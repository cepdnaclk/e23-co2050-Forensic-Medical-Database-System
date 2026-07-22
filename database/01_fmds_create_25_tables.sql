BEGIN;

DROP SCHEMA IF EXISTS fmds CASCADE;
CREATE SCHEMA fmds;
SET search_path TO fmds, public;

CREATE TABLE department (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(150) NOT NULL,
    contact_number VARCHAR(20)
);

CREATE TABLE case_type (
    case_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE evidence_type (
    evidence_type_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(60) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE access_role (
    access_role_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE staff (
    staff_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES department(department_id) ON DELETE RESTRICT,
    name VARCHAR(120) NOT NULL,
    role VARCHAR(40) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(120) UNIQUE,
    CONSTRAINT chk_staff_role CHECK (
        role IN (
            'Doctor','Judicial Medical Officer','Laboratory Technician',
            'Clerical Officer','System Administrator','Records Officer',
            'Court Liaison Officer'
        )
    )
);

CREATE TABLE doctor (
    staff_id INTEGER PRIMARY KEY REFERENCES staff(staff_id) ON DELETE CASCADE,
    specialization VARCHAR(100) NOT NULL,
    medical_license_no VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE judicial_medical_officer (
    staff_id INTEGER PRIMARY KEY REFERENCES staff(staff_id) ON DELETE CASCADE,
    jurisdiction VARCHAR(120) NOT NULL,
    appointment_date DATE NOT NULL
);

CREATE TABLE lab_technician (
    staff_id INTEGER PRIMARY KEY REFERENCES staff(staff_id) ON DELETE CASCADE,
    lab_section VARCHAR(100) NOT NULL,
    certification_no VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE clerical_officer (
    staff_id INTEGER PRIMARY KEY REFERENCES staff(staff_id) ON DELETE CASCADE,
    desk_section VARCHAR(100) NOT NULL
);

CREATE TABLE patient (
    patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    nic VARCHAR(15) UNIQUE,
    age INTEGER,
    gender CHAR(1) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    bht_number VARCHAR(30) UNIQUE,
    is_deceased BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT chk_patient_age CHECK (age IS NULL OR age BETWEEN 0 AND 120),
    CONSTRAINT chk_patient_gender CHECK (gender IN ('M','F','O','U'))
);

CREATE TABLE next_of_kin (
    next_of_kin_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patient(patient_id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255)
);

CREATE TABLE fmds_user (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id INTEGER NOT NULL UNIQUE REFERENCES staff(staff_id) ON DELETE RESTRICT,
    username VARCHAR(60) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    last_login TIMESTAMPTZ,
    account_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_account_status CHECK (
        account_status IN ('Active','Locked','Suspended','Disabled')
    )
);

CREATE TABLE user_role (
    user_id INTEGER NOT NULL REFERENCES fmds_user(user_id) ON DELETE CASCADE,
    access_role_id INTEGER NOT NULL REFERENCES access_role(access_role_id) ON DELETE RESTRICT,
    assigned_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (user_id, access_role_id)
);

CREATE TABLE forensic_case (
    case_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patient(patient_id) ON DELETE RESTRICT,
    case_type_id INTEGER NOT NULL REFERENCES case_type(case_type_id) ON DELETE RESTRICT,
    registered_by INTEGER NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,
    incident_date DATE NOT NULL,
    place VARCHAR(180) NOT NULL,
    police_reference_no VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(40) NOT NULL DEFAULT 'Registered',
    CONSTRAINT chk_case_status CHECK (
        status IN (
            'Registered','Under Examination','Awaiting Laboratory Results',
            'Pending Report','Report Prepared','Submitted to Court',
            'Closed','Suspended'
        )
    )
);

CREATE TABLE clinical_examination (
    examination_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id INTEGER NOT NULL REFERENCES forensic_case(case_id) ON DELETE RESTRICT,
    doctor_id INTEGER NOT NULL REFERENCES doctor(staff_id) ON DELETE RESTRICT,
    examination_date DATE NOT NULL,
    referral_type VARCHAR(80) NOT NULL,
    doctor_notes TEXT
);

CREATE TABLE injury_detail (
    injury_detail_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    examination_id INTEGER NOT NULL REFERENCES clinical_examination(examination_id) ON DELETE CASCADE,
    body_part VARCHAR(80) NOT NULL,
    injury_type VARCHAR(80) NOT NULL,
    severity VARCHAR(30) NOT NULL,
    description TEXT NOT NULL,
    CONSTRAINT chk_injury_severity CHECK (
        severity IN ('Minor','Moderate','Severe','Grievous','Fatal','Undetermined')
    )
);

CREATE TABLE postmortem (
    postmortem_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id INTEGER NOT NULL UNIQUE REFERENCES forensic_case(case_id) ON DELETE RESTRICT,
    doctor_id INTEGER NOT NULL REFERENCES doctor(staff_id) ON DELETE RESTRICT,
    postmortem_date DATE NOT NULL,
    cause_of_death VARCHAR(200),
    pmr_details TEXT,
    postmortem_type VARCHAR(40) NOT NULL,
    CONSTRAINT chk_postmortem_type CHECK (
        postmortem_type IN (
            'Hospital Death','Non-Hospital Death','Court Ordered',
            'Inquest Ordered','Exhumation','Partial Examination'
        )
    )
);

CREATE TABLE postmortem_finding (
    finding_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    postmortem_id INTEGER NOT NULL REFERENCES postmortem(postmortem_id) ON DELETE CASCADE,
    organ VARCHAR(100) NOT NULL,
    observation TEXT NOT NULL,
    significance VARCHAR(150)
);

CREATE TABLE evidence (
    evidence_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id INTEGER NOT NULL REFERENCES forensic_case(case_id) ON DELETE RESTRICT,
    evidence_type_id INTEGER NOT NULL REFERENCES evidence_type(evidence_type_id) ON DELETE RESTRICT,
    collection_date DATE NOT NULL,
    location VARCHAR(180) NOT NULL,
    lab_name VARCHAR(150),
    storage_location VARCHAR(150) NOT NULL
);

CREATE TABLE lab_sample (
    sample_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    evidence_id INTEGER NOT NULL REFERENCES evidence(evidence_id) ON DELETE CASCADE,
    collected_by INTEGER NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,
    sample_type VARCHAR(100) NOT NULL,
    collected_date DATE NOT NULL
);

CREATE TABLE chain_of_custody_log (
    custody_log_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    evidence_id INTEGER NOT NULL REFERENCES evidence(evidence_id) ON DELETE RESTRICT,
    staff_id INTEGER NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,
    transfer_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    from_location VARCHAR(150) NOT NULL,
    to_location VARCHAR(150) NOT NULL,
    remarks VARCHAR(255),
    CONSTRAINT chk_custody_locations CHECK (
        LOWER(TRIM(from_location)) <> LOWER(TRIM(to_location))
    )
);

CREATE TABLE laboratory_test (
    test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sample_id INTEGER NOT NULL REFERENCES lab_sample(sample_id) ON DELETE RESTRICT,
    technician_id INTEGER NOT NULL REFERENCES lab_technician(staff_id) ON DELETE RESTRICT,
    test_type VARCHAR(150) NOT NULL,
    test_date DATE NOT NULL,
    result TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'Requested',
    CONSTRAINT chk_lab_status CHECK (
        status IN ('Requested','Sample Received','In Progress','Completed','Verified','Rejected','Inconclusive')
    )
);

CREATE TABLE legal_report (
    report_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id INTEGER NOT NULL REFERENCES forensic_case(case_id) ON DELETE RESTRICT,
    prepared_by INTEGER NOT NULL REFERENCES staff(staff_id) ON DELETE RESTRICT,
    report_type VARCHAR(60) NOT NULL,
    issue_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'Draft'
);

CREATE TABLE court_submission (
    submission_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    report_id INTEGER NOT NULL REFERENCES legal_report(report_id) ON DELETE RESTRICT,
    court_name VARCHAR(150) NOT NULL,
    submission_date DATE NOT NULL,
    hearing_date DATE,
    judge_name VARCHAR(120),
    submission_status VARCHAR(40) NOT NULL DEFAULT 'Submitted'
);

CREATE TABLE audit_log (
    audit_log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER REFERENCES fmds_user(user_id) ON DELETE SET NULL,
    action_type VARCHAR(30) NOT NULL,
    table_affected VARCHAR(80) NOT NULL,
    record_id BIGINT,
    action_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45)
);

COMMIT;
