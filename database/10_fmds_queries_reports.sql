-- =====================================================================
-- FORENSIC MEDICAL DEPARTMENT DATABASE SYSTEM
-- File: 10_fmds_queries_reports.sql
-- Database: forensic_db
-- Schema: fmds
-- DBMS: PostgreSQL
--
-- Purpose
-- ---------------------------------------------------------------------
-- This script contains meaningful data-retrieval and reporting queries
-- for the Forensic Medical Department Database System.
--
-- The queries demonstrate SELECT, filtering, sorting, joins, aggregate
-- functions, GROUP BY, HAVING, subqueries, and date-based reporting.
--
-- This file does not modify the database and is safe to run repeatedly.
-- =====================================================================

SET search_path TO fmds, public;

-- =====================================================================
-- QUERY 01: SEARCH FOR A PATIENT USING NIC
-- =====================================================================
SELECT
    patient_id,
    name,
    nic,
    age,
    gender,
    address,
    phone_number,
    bht_number,
    is_deceased
FROM patient
WHERE nic = '199835601284';

-- =====================================================================
-- QUERY 02: PATIENTS WITH NEXT-OF-KIN INFORMATION
-- =====================================================================
SELECT
    p.patient_id,
    p.name AS patient_name,
    p.nic,
    p.is_deceased,
    nk.name AS next_of_kin_name,
    nk.relationship,
    nk.phone_number AS next_of_kin_phone,
    nk.address AS next_of_kin_address
FROM patient p
LEFT JOIN next_of_kin nk
    ON p.patient_id = nk.patient_id
ORDER BY p.patient_id;

-- =====================================================================
-- QUERY 03: COMPLETE CASE HISTORY OF ONE PATIENT
-- =====================================================================
SELECT
    p.name AS patient_name,
    p.nic,
    fc.case_id,
    fc.police_reference_no,
    ct.type_name AS case_type,
    fc.incident_date,
    fc.place,
    fc.status
FROM patient p
JOIN forensic_case fc
    ON p.patient_id = fc.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
WHERE p.nic = '199835601284'
ORDER BY fc.incident_date;

-- =====================================================================
-- QUERY 04: GENERAL FORENSIC CASE REGISTER
-- =====================================================================
SELECT
    fc.case_id,
    fc.police_reference_no,
    p.name AS patient_name,
    ct.type_name AS case_type,
    fc.incident_date,
    fc.place,
    fc.status,
    s.name AS registered_by
FROM forensic_case fc
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
JOIN staff s
    ON fc.registered_by = s.staff_id
ORDER BY fc.incident_date, fc.case_id;

-- =====================================================================
-- QUERY 05: FILTER CASES BY STATUS
-- =====================================================================
SELECT
    fc.case_id,
    fc.police_reference_no,
    p.name AS patient_name,
    ct.type_name AS case_type,
    fc.incident_date,
    fc.status
FROM forensic_case fc
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
WHERE fc.status = 'Awaiting Laboratory Results'
ORDER BY fc.incident_date;

-- =====================================================================
-- QUERY 06: COUNT CASES BY STATUS
-- =====================================================================
SELECT
    status,
    COUNT(*) AS number_of_cases
FROM forensic_case
GROUP BY status
ORDER BY number_of_cases DESC, status;

-- =====================================================================
-- QUERY 07: COUNT CASES BY CASE TYPE
-- =====================================================================
SELECT
    ct.type_name AS case_type,
    COUNT(fc.case_id) AS number_of_cases
FROM case_type ct
LEFT JOIN forensic_case fc
    ON ct.case_type_id = fc.case_type_id
GROUP BY ct.case_type_id, ct.type_name
ORDER BY number_of_cases DESC, ct.type_name;

-- =====================================================================
-- QUERY 08: DAILY CASE REPORT
-- =====================================================================
SELECT
    fc.police_reference_no,
    p.name AS patient_name,
    ct.type_name AS case_type,
    fc.place,
    fc.status,
    s.name AS registered_by
FROM forensic_case fc
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
JOIN staff s
    ON fc.registered_by = s.staff_id
WHERE fc.incident_date = DATE '2026-05-04'
ORDER BY fc.police_reference_no;

-- =====================================================================
-- QUERY 09: MONTHLY CASE STATISTICS
-- =====================================================================
SELECT
    TO_CHAR(DATE_TRUNC('month', incident_date), 'YYYY-MM') AS case_month,
    COUNT(*) AS number_of_cases
FROM forensic_case
GROUP BY DATE_TRUNC('month', incident_date)
ORDER BY DATE_TRUNC('month', incident_date);

-- =====================================================================
-- QUERY 10: CLINICAL EXAMINATIONS WITH DOCTOR AND PATIENT
-- =====================================================================
SELECT
    ce.examination_id,
    fc.police_reference_no,
    p.name AS patient_name,
    s.name AS examining_doctor,
    ce.examination_date,
    ce.referral_type,
    ce.doctor_notes
FROM clinical_examination ce
JOIN forensic_case fc
    ON ce.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN staff s
    ON ce.doctor_id = s.staff_id
ORDER BY ce.examination_date;

-- =====================================================================
-- QUERY 11: CLINICAL EXAMINATIONS WITH INJURY DETAILS
-- =====================================================================
SELECT
    fc.police_reference_no,
    p.name AS patient_name,
    ce.examination_date,
    id.body_part,
    id.injury_type,
    id.severity,
    id.description
FROM injury_detail id
JOIN clinical_examination ce
    ON id.examination_id = ce.examination_id
JOIN forensic_case fc
    ON ce.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
ORDER BY fc.police_reference_no, id.injury_detail_id;

-- =====================================================================
-- QUERY 12: DOCTOR WORKLOAD SUMMARY
-- =====================================================================
SELECT
    s.staff_id,
    s.name AS doctor_name,
    d.specialization,
    COUNT(DISTINCT ce.examination_id) AS clinical_examinations,
    COUNT(DISTINCT pm.postmortem_id) AS postmortems
FROM doctor d
JOIN staff s
    ON d.staff_id = s.staff_id
LEFT JOIN clinical_examination ce
    ON d.staff_id = ce.doctor_id
LEFT JOIN postmortem pm
    ON d.staff_id = pm.doctor_id
GROUP BY s.staff_id, s.name, d.specialization
ORDER BY postmortems DESC, clinical_examinations DESC, s.name;

-- =====================================================================
-- QUERY 13: POSTMORTEM REPORT SUMMARY
-- =====================================================================
SELECT
    pm.postmortem_id,
    fc.police_reference_no,
    p.name AS deceased_name,
    pm.postmortem_date,
    pm.postmortem_type,
    s.name AS forensic_doctor,
    pm.cause_of_death
FROM postmortem pm
JOIN forensic_case fc
    ON pm.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN staff s
    ON pm.doctor_id = s.staff_id
ORDER BY pm.postmortem_date;

-- =====================================================================
-- QUERY 14: POSTMORTEM FINDINGS BY ORGAN
-- =====================================================================
SELECT
    fc.police_reference_no,
    p.name AS deceased_name,
    pf.organ,
    pf.observation,
    pf.significance
FROM postmortem_finding pf
JOIN postmortem pm
    ON pf.postmortem_id = pm.postmortem_id
JOIN forensic_case fc
    ON pm.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
ORDER BY fc.police_reference_no, pf.finding_id;

-- =====================================================================
-- QUERY 15: DECEASED PATIENTS WITHOUT POSTMORTEM RECORDS
-- =====================================================================
SELECT
    p.patient_id,
    p.name,
    p.nic,
    p.bht_number
FROM patient p
LEFT JOIN forensic_case fc
    ON p.patient_id = fc.patient_id
LEFT JOIN postmortem pm
    ON fc.case_id = pm.case_id
WHERE p.is_deceased = TRUE
GROUP BY p.patient_id, p.name, p.nic, p.bht_number
HAVING COUNT(pm.postmortem_id) = 0
ORDER BY p.name;

-- =====================================================================
-- QUERY 16: EVIDENCE ITEMS ASSOCIATED WITH EACH CASE
-- =====================================================================
SELECT
    fc.police_reference_no,
    e.evidence_id,
    et.type_name AS evidence_type,
    e.collection_date,
    e.location AS collection_location,
    e.lab_name,
    e.storage_location
FROM evidence e
JOIN forensic_case fc
    ON e.case_id = fc.case_id
JOIN evidence_type et
    ON e.evidence_type_id = et.evidence_type_id
ORDER BY fc.police_reference_no, e.evidence_id;

-- =====================================================================
-- QUERY 17: COMPLETE CHAIN-OF-CUSTODY HISTORY
-- =====================================================================
SELECT
    fc.police_reference_no,
    e.evidence_id,
    et.type_name AS evidence_type,
    c.transfer_date,
    s.name AS handled_by,
    c.from_location,
    c.to_location,
    c.remarks
FROM chain_of_custody_log c
JOIN evidence e
    ON c.evidence_id = e.evidence_id
JOIN evidence_type et
    ON e.evidence_type_id = et.evidence_type_id
JOIN forensic_case fc
    ON e.case_id = fc.case_id
JOIN staff s
    ON c.staff_id = s.staff_id
ORDER BY e.evidence_id, c.transfer_date;

-- =====================================================================
-- QUERY 18: LABORATORY SAMPLES WITH TEST RESULTS
-- =====================================================================
SELECT
    fc.police_reference_no,
    e.evidence_id,
    ls.sample_id,
    ls.sample_type,
    lt.test_id,
    lt.test_type,
    lt.test_date,
    lt.status,
    lt.result,
    s.name AS technician_name
FROM lab_sample ls
JOIN evidence e
    ON ls.evidence_id = e.evidence_id
JOIN forensic_case fc
    ON e.case_id = fc.case_id
LEFT JOIN laboratory_test lt
    ON ls.sample_id = lt.sample_id
LEFT JOIN staff s
    ON lt.technician_id = s.staff_id
ORDER BY fc.police_reference_no, ls.sample_id, lt.test_id;

-- =====================================================================
-- QUERY 19: LABORATORY TESTS AWAITING COMPLETION
-- =====================================================================
SELECT
    lt.test_id,
    fc.police_reference_no,
    ls.sample_type,
    lt.test_type,
    lt.test_date,
    lt.status,
    s.name AS technician_name
FROM laboratory_test lt
JOIN lab_sample ls
    ON lt.sample_id = ls.sample_id
JOIN evidence e
    ON ls.evidence_id = e.evidence_id
JOIN forensic_case fc
    ON e.case_id = fc.case_id
JOIN staff s
    ON lt.technician_id = s.staff_id
WHERE lt.status IN ('Requested', 'Sample Received', 'In Progress')
ORDER BY lt.test_date;

-- =====================================================================
-- QUERY 20: LABORATORY TECHNICIAN WORKLOAD
-- =====================================================================
SELECT
    s.staff_id,
    s.name AS technician_name,
    ltech.lab_section,
    COUNT(lt.test_id) AS number_of_tests,
    COUNT(*) FILTER (WHERE lt.status = 'Verified') AS verified_tests,
    COUNT(*) FILTER (WHERE lt.status = 'Completed') AS completed_tests
FROM lab_technician ltech
JOIN staff s
    ON ltech.staff_id = s.staff_id
LEFT JOIN laboratory_test lt
    ON ltech.staff_id = lt.technician_id
GROUP BY s.staff_id, s.name, ltech.lab_section
ORDER BY number_of_tests DESC, s.name;

-- =====================================================================
-- QUERY 21: EVIDENCE WITHOUT A LABORATORY TEST
-- =====================================================================
SELECT
    fc.police_reference_no,
    e.evidence_id,
    et.type_name AS evidence_type,
    e.collection_date,
    e.storage_location
FROM evidence e
JOIN evidence_type et
    ON e.evidence_type_id = et.evidence_type_id
JOIN forensic_case fc
    ON e.case_id = fc.case_id
LEFT JOIN lab_sample ls
    ON e.evidence_id = ls.evidence_id
LEFT JOIN laboratory_test lt
    ON ls.sample_id = lt.sample_id
GROUP BY
    fc.police_reference_no,
    e.evidence_id,
    et.type_name,
    e.collection_date,
    e.storage_location
HAVING COUNT(lt.test_id) = 0
ORDER BY e.evidence_id;

-- =====================================================================
-- QUERY 22: LEGAL REPORT REGISTER
-- =====================================================================
SELECT
    lr.report_id,
    fc.police_reference_no,
    p.name AS patient_name,
    lr.report_type,
    lr.issue_date,
    lr.status,
    s.name AS prepared_by
FROM legal_report lr
JOIN forensic_case fc
    ON lr.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN staff s
    ON lr.prepared_by = s.staff_id
ORDER BY lr.issue_date NULLS LAST, lr.report_id;

-- =====================================================================
-- QUERY 23: CASES WITHOUT LEGAL REPORTS
-- =====================================================================
SELECT
    fc.case_id,
    fc.police_reference_no,
    p.name AS patient_name,
    ct.type_name AS case_type,
    fc.status
FROM forensic_case fc
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
LEFT JOIN legal_report lr
    ON fc.case_id = lr.case_id
WHERE lr.report_id IS NULL
ORDER BY fc.incident_date;

-- =====================================================================
-- QUERY 24: REPORTS PENDING COMPLETION OR SIGNATURE
-- =====================================================================
SELECT
    lr.report_id,
    fc.police_reference_no,
    p.name AS patient_name,
    lr.report_type,
    lr.status,
    s.name AS prepared_by
FROM legal_report lr
JOIN forensic_case fc
    ON lr.case_id = fc.case_id
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN staff s
    ON lr.prepared_by = s.staff_id
WHERE lr.status IN ('Draft', 'Under Review', 'Awaiting Signature')
ORDER BY lr.report_id;

-- =====================================================================
-- QUERY 25: COURT SUBMISSION REPORT
-- =====================================================================
SELECT
    cs.submission_id,
    fc.police_reference_no,
    lr.report_type,
    cs.court_name,
    cs.submission_date,
    cs.hearing_date,
    cs.judge_name,
    cs.submission_status
FROM court_submission cs
JOIN legal_report lr
    ON cs.report_id = lr.report_id
JOIN forensic_case fc
    ON lr.case_id = fc.case_id
ORDER BY cs.submission_date;

-- =====================================================================
-- QUERY 26: UPCOMING OR SCHEDULED COURT HEARINGS
-- =====================================================================
SELECT
    cs.submission_id,
    fc.police_reference_no,
    cs.court_name,
    cs.hearing_date,
    cs.judge_name,
    cs.submission_status
FROM court_submission cs
JOIN legal_report lr
    ON cs.report_id = lr.report_id
JOIN forensic_case fc
    ON lr.case_id = fc.case_id
WHERE cs.hearing_date IS NOT NULL
ORDER BY cs.hearing_date;

-- =====================================================================
-- QUERY 27: DEPARTMENT STAFF SUMMARY
-- =====================================================================
SELECT
    d.department_name,
    s.role,
    COUNT(*) AS number_of_staff
FROM staff s
JOIN department d
    ON s.department_id = d.department_id
GROUP BY d.department_name, s.role
ORDER BY d.department_name, s.role;

-- =====================================================================
-- QUERY 28: USER ACCOUNT AND ROLE REPORT
-- Password hashes are intentionally excluded.
-- =====================================================================
SELECT
    u.user_id,
    u.username,
    s.name AS staff_name,
    s.role AS staff_role,
    ar.role_name AS access_role,
    ur.assigned_date,
    u.account_status,
    u.last_login
FROM fmds_user u
JOIN staff s
    ON u.staff_id = s.staff_id
LEFT JOIN user_role ur
    ON u.user_id = ur.user_id
LEFT JOIN access_role ar
    ON ur.access_role_id = ar.access_role_id
ORDER BY u.username, ar.role_name;

-- =====================================================================
-- QUERY 29: AUDIT LOG REPORT
-- The table may be empty before monitored changes occur.
-- =====================================================================
SELECT
    al.audit_log_id,
    al.action_timestamp,
    u.username,
    al.action_type,
    al.table_affected,
    al.record_id,
    al.ip_address
FROM audit_log al
LEFT JOIN fmds_user u
    ON al.user_id = u.user_id
ORDER BY al.action_timestamp DESC;

-- =====================================================================
-- QUERY 30: CASE COMPLETENESS REPORT
-- =====================================================================
SELECT
    fc.case_id,
    fc.police_reference_no,
    p.name AS patient_name,
    ct.type_name AS case_type,
    CASE
        WHEN COUNT(DISTINCT ce.examination_id) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_clinical_examination,
    CASE
        WHEN COUNT(DISTINCT pm.postmortem_id) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_postmortem,
    CASE
        WHEN COUNT(DISTINCT e.evidence_id) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_evidence,
    CASE
        WHEN COUNT(DISTINCT lr.report_id) > 0 THEN 'Yes'
        ELSE 'No'
    END AS has_legal_report
FROM forensic_case fc
JOIN patient p
    ON fc.patient_id = p.patient_id
JOIN case_type ct
    ON fc.case_type_id = ct.case_type_id
LEFT JOIN clinical_examination ce
    ON fc.case_id = ce.case_id
LEFT JOIN postmortem pm
    ON fc.case_id = pm.case_id
LEFT JOIN evidence e
    ON fc.case_id = e.case_id
LEFT JOIN legal_report lr
    ON fc.case_id = lr.case_id
GROUP BY fc.case_id, fc.police_reference_no, p.name, ct.type_name
ORDER BY fc.case_id;

-- =====================================================================
-- END OF FILE
-- =====================================================================
