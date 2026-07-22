SET search_path TO fmds, public;

-- Application may set the current user before write operations:
-- SELECT set_config('fmds.current_user_id','1',false);

CREATE OR REPLACE FUNCTION fn_current_fmds_user_id()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_value TEXT;
BEGIN
    v_value := current_setting('fmds.current_user_id', true);
    IF v_value IS NULL OR v_value = '' THEN
        RETURN NULL;
    END IF;
    RETURN v_value::INTEGER;
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION fn_audit_table_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_record_id BIGINT;
BEGIN
    IF TG_OP='DELETE' THEN
        v_record_id := COALESCE(
            to_jsonb(OLD)->>'case_id',
            to_jsonb(OLD)->>'evidence_id',
            to_jsonb(OLD)->>'postmortem_id',
            to_jsonb(OLD)->>'examination_id',
            to_jsonb(OLD)->>'report_id',
            to_jsonb(OLD)->>'test_id',
            to_jsonb(OLD)->>'patient_id'
        )::BIGINT;
    ELSE
        v_record_id := COALESCE(
            to_jsonb(NEW)->>'case_id',
            to_jsonb(NEW)->>'evidence_id',
            to_jsonb(NEW)->>'postmortem_id',
            to_jsonb(NEW)->>'examination_id',
            to_jsonb(NEW)->>'report_id',
            to_jsonb(NEW)->>'test_id',
            to_jsonb(NEW)->>'patient_id'
        )::BIGINT;
    END IF;

    INSERT INTO audit_log(
        user_id,action_type,table_affected,record_id,ip_address
    )
    VALUES(
        fn_current_fmds_user_id(),
        TG_OP,
        TG_TABLE_NAME,
        v_record_id,
        inet_client_addr()::TEXT
    );

    RETURN COALESCE(NEW,OLD);
END;
$$;

CREATE TRIGGER trg_audit_patient
AFTER INSERT OR UPDATE OR DELETE ON patient
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_forensic_case
AFTER INSERT OR UPDATE OR DELETE ON forensic_case
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_clinical_examination
AFTER INSERT OR UPDATE OR DELETE ON clinical_examination
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_postmortem
AFTER INSERT OR UPDATE OR DELETE ON postmortem
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_evidence
AFTER INSERT OR UPDATE OR DELETE ON evidence
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_laboratory_test
AFTER INSERT OR UPDATE OR DELETE ON laboratory_test
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE TRIGGER trg_audit_legal_report
AFTER INSERT OR UPDATE OR DELETE ON legal_report
FOR EACH ROW EXECUTE FUNCTION fn_audit_table_change();

CREATE OR REPLACE FUNCTION fn_validate_postmortem_case()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_deceased BOOLEAN;
BEGIN
    SELECT p.is_deceased
    INTO v_is_deceased
    FROM forensic_case fc
    JOIN patient p ON fc.patient_id=p.patient_id
    WHERE fc.case_id=NEW.case_id;

    IF v_is_deceased IS NOT TRUE THEN
        RAISE EXCEPTION 'Postmortem cannot be created for a living patient.';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_postmortem_case
BEFORE INSERT OR UPDATE ON postmortem
FOR EACH ROW EXECUTE FUNCTION fn_validate_postmortem_case();

CREATE OR REPLACE FUNCTION fn_require_result_for_completed_test()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.status IN ('Completed','Verified')
       AND (NEW.result IS NULL OR BTRIM(NEW.result)='') THEN
        RAISE EXCEPTION 'Completed or verified laboratory tests require a result.';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_require_lab_result
BEFORE INSERT OR UPDATE ON laboratory_test
FOR EACH ROW EXECUTE FUNCTION fn_require_result_for_completed_test();
