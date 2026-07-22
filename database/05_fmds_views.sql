SET search_path TO fmds, public;

CREATE OR REPLACE VIEW vw_case_summary AS
SELECT
    fc.case_id,
    fc.police_reference_no,
    p.name AS patient_name,
    p.nic,
    p.is_deceased,
    ct.type_name AS case_type,
    fc.incident_date,
    fc.place,
    fc.status,
    s.name AS registered_by
FROM forensic_case fc
JOIN patient p ON fc.patient_id=p.patient_id
JOIN case_type ct ON fc.case_type_id=ct.case_type_id
JOIN staff s ON fc.registered_by=s.staff_id;

CREATE OR REPLACE VIEW vw_pending_reports AS
SELECT
    fc.police_reference_no,
    p.name AS patient_name,
    lr.report_id,
    lr.report_type,
    lr.status,
    lr.issue_date,
    s.name AS prepared_by
FROM legal_report lr
JOIN forensic_case fc ON lr.case_id=fc.case_id
JOIN patient p ON fc.patient_id=p.patient_id
JOIN staff s ON lr.prepared_by=s.staff_id
WHERE lr.status IN ('Draft','Under Review','Awaiting Signature');

CREATE OR REPLACE VIEW vw_evidence_custody_history AS
SELECT
    fc.police_reference_no,
    e.evidence_id,
    et.type_name AS evidence_type,
    c.transfer_date,
    c.from_location,
    c.to_location,
    s.name AS handled_by,
    c.remarks
FROM chain_of_custody_log c
JOIN evidence e ON c.evidence_id=e.evidence_id
JOIN evidence_type et ON e.evidence_type_id=et.evidence_type_id
JOIN forensic_case fc ON e.case_id=fc.case_id
JOIN staff s ON c.staff_id=s.staff_id;

CREATE OR REPLACE VIEW vw_laboratory_work_queue AS
SELECT
    lt.test_id,
    fc.police_reference_no,
    ls.sample_type,
    lt.test_type,
    lt.test_date,
    lt.status,
    s.name AS technician_name
FROM laboratory_test lt
JOIN lab_sample ls ON lt.sample_id=ls.sample_id
JOIN evidence e ON ls.evidence_id=e.evidence_id
JOIN forensic_case fc ON e.case_id=fc.case_id
JOIN staff s ON lt.technician_id=s.staff_id;

CREATE OR REPLACE VIEW vw_upcoming_court_hearings AS
SELECT
    cs.submission_id,
    fc.police_reference_no,
    lr.report_type,
    cs.court_name,
    cs.hearing_date,
    cs.judge_name,
    cs.submission_status
FROM court_submission cs
JOIN legal_report lr ON cs.report_id=lr.report_id
JOIN forensic_case fc ON lr.case_id=fc.case_id
WHERE cs.hearing_date IS NOT NULL
  AND cs.hearing_date >= CURRENT_DATE;
