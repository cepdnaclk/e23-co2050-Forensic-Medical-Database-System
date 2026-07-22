SET search_path TO fmds, public;

-- Table count
SELECT COUNT(*) AS total_tables
FROM information_schema.tables
WHERE table_schema='fmds' AND table_type='BASE TABLE';

-- Row counts
SELECT 'department' table_name, COUNT(*) row_count FROM department
UNION ALL SELECT 'case_type', COUNT(*) FROM case_type
UNION ALL SELECT 'evidence_type', COUNT(*) FROM evidence_type
UNION ALL SELECT 'access_role', COUNT(*) FROM access_role
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'patient', COUNT(*) FROM patient
UNION ALL SELECT 'forensic_case', COUNT(*) FROM forensic_case
UNION ALL SELECT 'clinical_examination', COUNT(*) FROM clinical_examination
UNION ALL SELECT 'postmortem', COUNT(*) FROM postmortem
UNION ALL SELECT 'evidence', COUNT(*) FROM evidence
UNION ALL SELECT 'laboratory_test', COUNT(*) FROM laboratory_test
UNION ALL SELECT 'legal_report', COUNT(*) FROM legal_report
UNION ALL SELECT 'court_submission', COUNT(*) FROM court_submission
ORDER BY table_name;

-- Staff with departments
SELECT s.staff_id,s.name,s.role,d.department_name
FROM staff s JOIN department d ON s.department_id=d.department_id
ORDER BY s.staff_id;

-- Cases with patients and types
SELECT fc.case_id,fc.police_reference_no,p.name patient_name,ct.type_name,fc.status
FROM forensic_case fc
JOIN patient p ON fc.patient_id=p.patient_id
JOIN case_type ct ON fc.case_type_id=ct.case_type_id
ORDER BY fc.case_id;

-- Clinical case details
SELECT fc.police_reference_no,p.name patient_name,s.name doctor_name,
       ce.examination_date,ce.referral_type,ce.doctor_notes
FROM clinical_examination ce
JOIN forensic_case fc ON ce.case_id=fc.case_id
JOIN patient p ON fc.patient_id=p.patient_id
JOIN staff s ON ce.doctor_id=s.staff_id
ORDER BY ce.examination_date;

-- Postmortem summary
SELECT fc.police_reference_no,p.name deceased_name,s.name doctor_name,
       pm.postmortem_date,pm.cause_of_death
FROM postmortem pm
JOIN forensic_case fc ON pm.case_id=fc.case_id
JOIN patient p ON fc.patient_id=p.patient_id
JOIN staff s ON pm.doctor_id=s.staff_id
ORDER BY pm.postmortem_date;

-- Evidence and tests
SELECT fc.police_reference_no,et.type_name,e.location,ls.sample_type,
       lt.test_type,lt.status,lt.result
FROM evidence e
JOIN forensic_case fc ON e.case_id=fc.case_id
JOIN evidence_type et ON e.evidence_type_id=et.evidence_type_id
LEFT JOIN lab_sample ls ON e.evidence_id=ls.evidence_id
LEFT JOIN laboratory_test lt ON ls.sample_id=lt.sample_id
ORDER BY fc.police_reference_no,e.evidence_id;

-- Chain of custody
SELECT fc.police_reference_no,e.evidence_id,c.transfer_date,s.name,
       c.from_location,c.to_location,c.remarks
FROM chain_of_custody_log c
JOIN evidence e ON c.evidence_id=e.evidence_id
JOIN forensic_case fc ON e.case_id=fc.case_id
JOIN staff s ON c.staff_id=s.staff_id
ORDER BY e.evidence_id,c.transfer_date;

-- Pending work
SELECT police_reference_no,status
FROM forensic_case
WHERE status NOT IN ('Closed','Submitted to Court')
ORDER BY incident_date;

-- Integrity checks: all should return zero rows
SELECT fc.case_id FROM forensic_case fc LEFT JOIN patient p ON fc.patient_id=p.patient_id WHERE p.patient_id IS NULL;
SELECT e.evidence_id FROM evidence e LEFT JOIN forensic_case fc ON e.case_id=fc.case_id WHERE fc.case_id IS NULL;
SELECT lt.test_id FROM laboratory_test lt LEFT JOIN lab_sample ls ON lt.sample_id=ls.sample_id WHERE ls.sample_id IS NULL;
