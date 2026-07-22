-- Run this file as a PostgreSQL administrator.
SET search_path TO fmds, public;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='fmds_admin') THEN
        CREATE ROLE fmds_admin NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='fmds_doctor') THEN
        CREATE ROLE fmds_doctor NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='fmds_lab_staff') THEN
        CREATE ROLE fmds_lab_staff NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='fmds_clerical') THEN
        CREATE ROLE fmds_clerical NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname='fmds_court_liaison') THEN
        CREATE ROLE fmds_court_liaison NOLOGIN;
    END IF;
END $$;

REVOKE ALL ON SCHEMA fmds FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA fmds FROM PUBLIC;

GRANT USAGE ON SCHEMA fmds TO
fmds_admin,fmds_doctor,fmds_lab_staff,fmds_clerical,fmds_court_liaison;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA fmds TO fmds_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA fmds TO fmds_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA fmds TO fmds_admin;

GRANT SELECT ON patient,forensic_case,clinical_examination,injury_detail,
postmortem,postmortem_finding,evidence,lab_sample,laboratory_test,
legal_report TO fmds_doctor;
GRANT INSERT,UPDATE ON clinical_examination,injury_detail,postmortem,
postmortem_finding,evidence,lab_sample,legal_report TO fmds_doctor;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA fmds TO fmds_doctor;

GRANT SELECT ON forensic_case,evidence,lab_sample,laboratory_test,
chain_of_custody_log TO fmds_lab_staff;
GRANT INSERT,UPDATE ON lab_sample,laboratory_test,chain_of_custody_log
TO fmds_lab_staff;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA fmds TO fmds_lab_staff;

GRANT SELECT,INSERT,UPDATE ON patient,next_of_kin,forensic_case,legal_report
TO fmds_clerical;
GRANT SELECT ON case_type,staff,department TO fmds_clerical;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA fmds TO fmds_clerical;

GRANT SELECT ON vw_case_summary,legal_report,court_submission TO fmds_court_liaison;
GRANT INSERT,UPDATE ON court_submission TO fmds_court_liaison;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA fmds TO fmds_court_liaison;

-- Example login creation:
-- CREATE ROLE teammate_name LOGIN PASSWORD 'Use-A-Strong-Password';
-- GRANT fmds_doctor TO teammate_name;
