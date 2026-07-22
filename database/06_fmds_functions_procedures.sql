SET search_path TO fmds, public;

CREATE OR REPLACE FUNCTION fn_count_cases_by_status(p_status VARCHAR)
RETURNS INTEGER
LANGUAGE sql
AS $$
    SELECT COUNT(*)::INTEGER
    FROM forensic_case
    WHERE status = p_status;
$$;

CREATE OR REPLACE FUNCTION fn_patient_case_history(p_nic VARCHAR)
RETURNS TABLE (
    police_reference_no VARCHAR,
    case_type VARCHAR,
    incident_date DATE,
    case_status VARCHAR
)
LANGUAGE sql
AS $$
    SELECT fc.police_reference_no,ct.type_name,fc.incident_date,fc.status
    FROM patient p
    JOIN forensic_case fc ON p.patient_id=fc.patient_id
    JOIN case_type ct ON fc.case_type_id=ct.case_type_id
    WHERE p.nic=p_nic
    ORDER BY fc.incident_date;
$$;

CREATE OR REPLACE FUNCTION fn_case_evidence_count(p_case_id INTEGER)
RETURNS INTEGER
LANGUAGE sql
AS $$
    SELECT COUNT(*)::INTEGER
    FROM evidence
    WHERE case_id=p_case_id;
$$;

CREATE OR REPLACE PROCEDURE sp_update_case_status(
    p_case_id INTEGER,
    p_new_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE forensic_case
    SET status=p_new_status
    WHERE case_id=p_case_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Case ID % was not found.', p_case_id;
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE sp_mark_report_issued(
    p_report_id INTEGER,
    p_issue_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE legal_report
    SET status='Issued',
        issue_date=p_issue_date
    WHERE report_id=p_report_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Report ID % was not found.', p_report_id;
    END IF;
END;
$$;

-- Examples
-- SELECT fn_count_cases_by_status('Pending Report');
-- SELECT * FROM fn_patient_case_history('199835601284');
-- CALL sp_update_case_status(1,'Report Prepared');
