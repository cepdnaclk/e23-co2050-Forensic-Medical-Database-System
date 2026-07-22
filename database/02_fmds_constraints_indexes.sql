BEGIN;
SET search_path TO fmds, public;

ALTER TABLE next_of_kin
ADD CONSTRAINT uq_nok_patient_name_relationship
UNIQUE (patient_id, name, relationship);

ALTER TABLE injury_detail
ADD CONSTRAINT uq_injury_exam_body_type
UNIQUE (examination_id, body_part, injury_type);

ALTER TABLE postmortem_finding
ADD CONSTRAINT uq_pm_finding_organ_observation
UNIQUE (postmortem_id, organ, observation);

ALTER TABLE lab_sample
ADD CONSTRAINT uq_sample_evidence_type_date
UNIQUE (evidence_id, sample_type, collected_date);

ALTER TABLE laboratory_test
ADD CONSTRAINT uq_test_sample_type_date
UNIQUE (sample_id, test_type, test_date);

CREATE INDEX idx_staff_department ON staff(department_id);
CREATE INDEX idx_staff_role ON staff(role);
CREATE INDEX idx_patient_name_lower ON patient(LOWER(name));
CREATE INDEX idx_patient_deceased ON patient(is_deceased);
CREATE INDEX idx_case_patient ON forensic_case(patient_id);
CREATE INDEX idx_case_type ON forensic_case(case_type_id);
CREATE INDEX idx_case_status_date ON forensic_case(status, incident_date);
CREATE INDEX idx_exam_case ON clinical_examination(case_id);
CREATE INDEX idx_exam_doctor ON clinical_examination(doctor_id);
CREATE INDEX idx_injury_exam ON injury_detail(examination_id);
CREATE INDEX idx_pm_doctor ON postmortem(doctor_id);
CREATE INDEX idx_pm_date ON postmortem(postmortem_date);
CREATE INDEX idx_pm_finding ON postmortem_finding(postmortem_id);
CREATE INDEX idx_evidence_case ON evidence(case_id);
CREATE INDEX idx_evidence_type ON evidence(evidence_type_id);
CREATE INDEX idx_sample_evidence ON lab_sample(evidence_id);
CREATE INDEX idx_custody_evidence_date ON chain_of_custody_log(evidence_id, transfer_date);
CREATE INDEX idx_test_sample ON laboratory_test(sample_id);
CREATE INDEX idx_test_status_date ON laboratory_test(status, test_date);
CREATE INDEX idx_report_case ON legal_report(case_id);
CREATE INDEX idx_report_status_date ON legal_report(status, issue_date);
CREATE INDEX idx_submission_report ON court_submission(report_id);
CREATE INDEX idx_submission_hearing ON court_submission(hearing_date) WHERE hearing_date IS NOT NULL;
CREATE INDEX idx_audit_user_time ON audit_log(user_id, action_timestamp);
CREATE INDEX idx_audit_table_record ON audit_log(table_affected, record_id);

COMMIT;
