BEGIN;
SET search_path TO fmds, public;

INSERT INTO department (department_name, location, contact_number) VALUES
('Forensic Clinical Review Unit','Meridian Teaching Hospital, East Diagnostic Wing, Level 03','+94-70-810-2401'),
('Medicolegal Autopsy and Identification Unit','Meridian Teaching Hospital, North Mortuary Complex, Level 01','+94-71-820-3512'),
('Trace Evidence and Instrumental Analysis Unit','Asteron Science Annex, Laboratory Block C','+94-72-830-4623'),
('Records Integrity and Court Liaison Unit','Meridian Teaching Hospital, Legal Services Building, Level 02','+94-74-840-5734'),
('Forensic Molecular Identity Unit','Asteron Science Annex, Secure Laboratory Block D','+94-75-850-6845'),
('Digital Histology and Imaging Repository','Meridian Teaching Hospital, Pathology Archive Wing','+94-76-860-7956');

INSERT INTO case_type (type_name, description) VALUES
('Workplace Chemical Exposure','Clinical forensic investigation following exposure to an industrial chemical.'),
('Forensic Age Estimation','Medical and radiological assessment of probable age.'),
('Unexplained Hospital Death','Hospital death requiring medico-legal clarification.'),
('Environmental Exposure Death','Death associated with toxic gas or environmental contamination.'),
('Custodial Injury Assessment','Examination of a detained person for injury documentation.'),
('Suspected Drug-Facilitated Assault','Clinical and toxicological investigation of suspected incapacitating substances.'),
('Child Safeguarding Examination','Specialist examination of a child referred for suspected abuse or neglect.'),
('Human Identification Investigation','Identification using DNA, dental or related scientific methods.'),
('Road Traffic Fatality','Postmortem and evidence investigation after a fatal road incident.'),
('Court-Ordered Exhumation','Examination conducted after lawful exhumation.'),
('Domestic Violence Examination','Clinical forensic examination following alleged domestic violence.'),
('Suspicious Thermal Injury','Clinical or postmortem investigation of suspicious burns.');

INSERT INTO evidence_type (type_name, description) VALUES
('Preserved Garment Section','Sealed clothing section collected for residue or biological analysis.'),
('Vitreous Humour Specimen','Postmortem ocular fluid for biochemical or toxicological analysis.'),
('Subungual Debris Collection','Material recovered from beneath fingernails.'),
('Adhesive Fibre Lift','Trace fibres collected using forensic adhesive material.'),
('Femoral Venous Blood','Postmortem peripheral blood for toxicology.'),
('Myocardial Tissue Cassette','Preserved heart tissue for histopathology.'),
('Buccal Reference Swab','Reference oral-cell sample for identity comparison.'),
('Air-Filter Particulate Residue','Particulate matter recovered from an enclosed environment.'),
('Surface Chemical Swab','Swab used to collect suspected chemical residue.'),
('Hair Root Collection','Hair strands with roots for microscopic or DNA examination.'),
('Bone Marrow Reference Sample','Internal biological material for identification.'),
('Dental Imaging Record','Dental radiographic information for age estimation or identification.'),
('Histology Slide Set','Prepared tissue slides retained for pathological review.'),
('Volatile Substance Container','Airtight container for headspace gas chromatography.'),
('Electronic Imaging Record','Secure X-ray, CT, MRI or forensic photographic record.');

INSERT INTO access_role (role_name, description) VALUES
('System Administrator','Full system and database administration.'),
('Judicial Medical Officer','Performs postmortems and authorizes medico-legal reports.'),
('Clinical Forensic Doctor','Records examinations and medical opinions.'),
('Forensic Laboratory Technician','Performs tests and updates verified results.'),
('Clerical Registration Officer','Registers patients and cases.'),
('Court Liaison Officer','Tracks reports, submissions and hearings.'),
('Evidence Custodian','Maintains evidence storage and custody records.'),
('Records Auditor','Reviews logs and record changes.'),
('Research Data Reviewer','Accesses approved de-identified data.'),
('Department Supervisor','Reviews operational workload and pending work.');

INSERT INTO staff (department_id, name, role, phone_number, email) VALUES
((SELECT department_id FROM department WHERE department_name='Medicolegal Autopsy and Identification Unit'),'Dr. Inovya Tharindri Welikumbura','Judicial Medical Officer','+94-70-914-2863','inovya.welikumbura@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Forensic Clinical Review Unit'),'Dr. Revan Akith Dissanayake','Judicial Medical Officer','+94-71-935-4072','revan.dissanayake@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Forensic Clinical Review Unit'),'Dr. Sadeesha Nethmini Karunatilaka','Doctor','+94-72-846-5194','sadeesha.karunatilaka@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Digital Histology and Imaging Repository'),'Dr. Maheesha Omalka Vithanage','Doctor','+94-74-857-6205','maheesha.vithanage@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Trace Evidence and Instrumental Analysis Unit'),'Yuhansa Manel Vinduranga','Laboratory Technician','+94-75-768-4316','yuhansa.vinduranga@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Forensic Molecular Identity Unit'),'Thevindu Lasal Ranasinghe','Laboratory Technician','+94-76-879-5427','thevindu.ranasinghe@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Digital Histology and Imaging Repository'),'Isuri Navodya Ekanayake','Laboratory Technician','+94-77-981-6538','isuri.ekanayake@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Records Integrity and Court Liaison Unit'),'Sewmini Arundathi Jayalath','Clerical Officer','+94-78-692-7149','sewmini.jayalath@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Forensic Clinical Review Unit'),'Kavishka Dulan Seneviratne','Clerical Officer','+94-70-583-8261','kavishka.seneviratne@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Records Integrity and Court Liaison Unit'),'Nethumli Arosha Goonetilleke','System Administrator','+94-71-604-9372','nethumli.goonetilleke@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Records Integrity and Court Liaison Unit'),'Dineth Aravinda Ilangakoon','Court Liaison Officer','+94-72-715-0483','dineth.ilangakoon@fmds.demo'),
((SELECT department_id FROM department WHERE department_name='Medicolegal Autopsy and Identification Unit'),'Rasara Minoli Abeywickrama','Records Officer','+94-74-826-1594','rasara.abeywickrama@fmds.demo');

INSERT INTO doctor VALUES
((SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'Forensic Pathology and Complex Death Investigation','SLMC-FMD-84217'),
((SELECT staff_id FROM staff WHERE email='revan.dissanayake@fmds.demo'),'Clinical Forensic Medicine and Custodial Assessment','SLMC-FMD-91746'),
((SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'Clinical Injury Interpretation and Safeguarding Medicine','SLMC-CFM-76328'),
((SELECT staff_id FROM staff WHERE email='maheesha.vithanage@fmds.demo'),'Forensic Histopathology and Postmortem Imaging','SLMC-FHP-68539');

INSERT INTO judicial_medical_officer VALUES
((SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'North Meridian Judicial Medical Division','2018-03-12'),
((SELECT staff_id FROM staff WHERE email='revan.dissanayake@fmds.demo'),'Riverstone Clinical Medico-Legal Jurisdiction','2020-08-24');

INSERT INTO lab_technician VALUES
((SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Spectral Residue and Volatile Compound Analysis','FTC-SRVC-26184'),
((SELECT staff_id FROM staff WHERE email='thevindu.ranasinghe@fmds.demo'),'Forensic DNA Profiling and Identity Comparison','FMI-DNA-37495'),
((SELECT staff_id FROM staff WHERE email='isuri.ekanayake@fmds.demo'),'Histomorphology and Digital Slide Preparation','DHI-HSP-48607');

INSERT INTO clerical_officer VALUES
((SELECT staff_id FROM staff WHERE email='sewmini.jayalath@fmds.demo'),'Court Document Dispatch and Receipt Verification Desk'),
((SELECT staff_id FROM staff WHERE email='kavishka.seneviratne@fmds.demo'),'Clinical Case Registration and MLEF Tracking Desk');

INSERT INTO patient (name,nic,age,gender,address,phone_number,bht_number,is_deceased) VALUES
('Senuri Dahampriya Alwis','199835601284',26,'F','18 Lake Crescent, Narangoda','+94-71-614-2875','BHT-240011',FALSE),
('Viduneth Saviru Kandegedara','200618703912',19,'M','74 Temple Reservoir Road, Mahakanadarawa','+94-72-904-5831','BHT-240012',FALSE),
('Thusari Vihangana Madugalle','197442801736',52,'F','91 Woodland Terrace, Galmuruwa',NULL,'BHT-240013',TRUE),
('Oshen Miral Senadheera','198912304578',37,'M','11 Quarry Hill Estate, Uduwila',NULL,'BHT-240014',TRUE),
('Nethuli Yasasmi Dahanayake','201025104981',15,'F','47 Sunrise Garden, Kaluwanchikudy','+94-70-527-1963','BHT-240015',FALSE),
('Rivinu Chenuka Illangasuriya','199129803146',33,'M','62 Orchid Ridge, Mirigama','+94-74-618-9520','BHT-240016',FALSE),
('Tharushi Imesha Ranasinghe','198667904153',39,'F','8 Sapphire Avenue, Diyatalawa','+94-76-713-4852','BHT-240017',FALSE),
('Kavindya Sesandi Weerasekara','197855402397',47,'F','22 Pine Meadow Road, Ambepussa',NULL,'BHT-240018',TRUE);

INSERT INTO next_of_kin (patient_id,name,relationship,phone_number,address) VALUES
((SELECT patient_id FROM patient WHERE nic='199835601284'),'Ravindu Chanaka Alwis','Brother','+94-70-610-4815','18 Lake Crescent, Narangoda'),
((SELECT patient_id FROM patient WHERE nic='200618703912'),'Anushika Devmini Kandegedara','Mother','+94-71-620-3954','74 Temple Reservoir Road, Mahakanadarawa'),
((SELECT patient_id FROM patient WHERE nic='197442801736'),'Malinda Priyantha Madugalle','Husband','+94-72-731-8206','91 Woodland Terrace, Galmuruwa'),
((SELECT patient_id FROM patient WHERE nic='198912304578'),'Imalka Nethmini Senadheera','Wife','+94-75-842-5160','11 Quarry Hill Estate, Uduwila'),
((SELECT patient_id FROM patient WHERE nic='201025104981'),'Ashen Dilruk Jayasinghe','Father','+94-77-483-7152','47 Sunrise Garden, Kaluwanchikudy'),
((SELECT patient_id FROM patient WHERE nic='199129803146'),'Pabasara Vinuri Illangasuriya','Sister','+94-71-902-3145','62 Orchid Ridge, Mirigama'),
((SELECT patient_id FROM patient WHERE nic='198667904153'),'Rukshan Malith Ranasinghe','Husband','+94-76-520-6134','8 Sapphire Avenue, Diyatalawa'),
((SELECT patient_id FROM patient WHERE nic='197855402397'),'Nisala Charith Weerasekara','Son','+94-74-310-2485','22 Pine Meadow Road, Ambepussa');

INSERT INTO fmds_user (staff_id,username,password_hash,account_status) VALUES
((SELECT staff_id FROM staff WHERE email='nethumli.goonetilleke@fmds.demo'),'admin.nethumli','$2b$12$demoHashAdminNethumli000000000000000000000000000000','Active'),
((SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'jmo.inovya','$2b$12$demoHashJmoInovya0000000000000000000000000000000','Active'),
((SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'doctor.sadeesha','$2b$12$demoHashDoctorSadeesha00000000000000000000000000000','Active'),
((SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'lab.yuhansa','$2b$12$demoHashLabYuhansa000000000000000000000000000000','Active'),
((SELECT staff_id FROM staff WHERE email='kavishka.seneviratne@fmds.demo'),'clerk.kavishka','$2b$12$demoHashClerkKavishka0000000000000000000000000000','Active'),
((SELECT staff_id FROM staff WHERE email='dineth.ilangakoon@fmds.demo'),'court.dineth','$2b$12$demoHashCourtDineth000000000000000000000000000000','Active');

INSERT INTO user_role (user_id,access_role_id) VALUES
((SELECT user_id FROM fmds_user WHERE username='admin.nethumli'),(SELECT access_role_id FROM access_role WHERE role_name='System Administrator')),
((SELECT user_id FROM fmds_user WHERE username='jmo.inovya'),(SELECT access_role_id FROM access_role WHERE role_name='Judicial Medical Officer')),
((SELECT user_id FROM fmds_user WHERE username='doctor.sadeesha'),(SELECT access_role_id FROM access_role WHERE role_name='Clinical Forensic Doctor')),
((SELECT user_id FROM fmds_user WHERE username='lab.yuhansa'),(SELECT access_role_id FROM access_role WHERE role_name='Forensic Laboratory Technician')),
((SELECT user_id FROM fmds_user WHERE username='clerk.kavishka'),(SELECT access_role_id FROM access_role WHERE role_name='Clerical Registration Officer')),
((SELECT user_id FROM fmds_user WHERE username='court.dineth'),(SELECT access_role_id FROM access_role WHERE role_name='Court Liaison Officer'));

INSERT INTO forensic_case (patient_id,case_type_id,registered_by,incident_date,place,police_reference_no,status) VALUES
((SELECT patient_id FROM patient WHERE nic='199835601284'),(SELECT case_type_id FROM case_type WHERE type_name='Workplace Chemical Exposure'),(SELECT staff_id FROM staff WHERE email='kavishka.seneviratne@fmds.demo'),'2026-05-04','Lunara Manuscript Conservation Workshop, Solace Industrial Lane','CRF/LUN/26/0417','Awaiting Laboratory Results'),
((SELECT patient_id FROM patient WHERE nic='200618703912'),(SELECT case_type_id FROM case_type WHERE type_name='Forensic Age Estimation'),(SELECT staff_id FROM staff WHERE email='kavishka.seneviratne@fmds.demo'),'2026-05-11','Northvale Immigration Assessment Centre, Interview Chamber 06','AGE/NVA/26/0094','Under Examination'),
((SELECT patient_id FROM patient WHERE nic='197442801736'),(SELECT case_type_id FROM case_type WHERE type_name='Unexplained Hospital Death'),(SELECT staff_id FROM staff WHERE email='rasara.abeywickrama@fmds.demo'),'2026-05-18','Meridian Teaching Hospital, Cardiac Observation Ward 7B','PMH/MER/26/0138','Pending Report'),
((SELECT patient_id FROM patient WHERE nic='198912304578'),(SELECT case_type_id FROM case_type WHERE type_name='Environmental Exposure Death'),(SELECT staff_id FROM staff WHERE email='rasara.abeywickrama@fmds.demo'),'2026-05-23','Rivermist Spice-Drying Complex, Enclosed Chamber E-4','ENV/RVM/26/0226','Awaiting Laboratory Results');

INSERT INTO clinical_examination (case_id,doctor_id,examination_date,referral_type,doctor_notes) VALUES
((SELECT case_id FROM forensic_case WHERE police_reference_no='CRF/LUN/26/0417'),(SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'2026-05-04','Hospital Ward','Observed sharply demarcated erythema on both forearms with mild blistering; findings are compatible with recent contact exposure to an irritant chemical.'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='AGE/NVA/26/0094'),(SELECT staff_id FROM staff WHERE email='revan.dissanayake@fmds.demo'),'2026-05-12','Immigration Authority','Physical maturity assessment completed; dental and left-wrist imaging were requested before final opinion.');

INSERT INTO injury_detail (examination_id,body_part,injury_type,severity,description) VALUES
((SELECT examination_id FROM clinical_examination ce JOIN forensic_case fc ON ce.case_id=fc.case_id WHERE fc.police_reference_no='CRF/LUN/26/0417'),'Left forearm','Chemical irritation','Moderate','Irregular erythematous area with small superficial vesicles over the volar forearm.'),
((SELECT examination_id FROM clinical_examination ce JOIN forensic_case fc ON ce.case_id=fc.case_id WHERE fc.police_reference_no='CRF/LUN/26/0417'),'Right wrist','Contact dermatitis pattern','Minor','Localized redness corresponding to the edge of a protective garment cuff.');

INSERT INTO postmortem (case_id,doctor_id,postmortem_date,cause_of_death,pmr_details,postmortem_type) VALUES
((SELECT case_id FROM forensic_case WHERE police_reference_no='PMH/MER/26/0138'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'2026-05-19','Ischaemic heart disease associated with acute myocardial infarction','Hospital identity records and next-of-kin confirmation were reviewed before examination. Internal examination demonstrated severe coronary atherosclerosis and recent myocardial injury.','Hospital Death'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='ENV/RVM/26/0226'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'2026-05-24','Suspected carbon monoxide toxicity pending laboratory confirmation','The deceased was recovered from an enclosed drying chamber. External findings were non-specific; femoral blood and chamber residue were retained for toxicological analysis.','Non-Hospital Death');

INSERT INTO postmortem_finding (postmortem_id,organ,observation,significance) VALUES
((SELECT postmortem_id FROM postmortem pm JOIN forensic_case fc ON pm.case_id=fc.case_id WHERE fc.police_reference_no='PMH/MER/26/0138'),'Heart','Severe narrowing of the left anterior descending coronary artery with focal pale myocardial change.','Supports recent ischaemic myocardial injury.'),
((SELECT postmortem_id FROM postmortem pm JOIN forensic_case fc ON pm.case_id=fc.case_id WHERE fc.police_reference_no='PMH/MER/26/0138'),'Lungs','Moderate bilateral pulmonary congestion with fine frothy fluid in major airways.','Consistent with acute cardiac failure.'),
((SELECT postmortem_id FROM postmortem pm JOIN forensic_case fc ON pm.case_id=fc.case_id WHERE fc.police_reference_no='ENV/RVM/26/0226'),'Blood and tissues','Unusually bright red coloration observed in blood and dependent tissues.','Raises suspicion of carboxyhaemoglobin elevation.');

INSERT INTO evidence (case_id,evidence_type_id,collection_date,location,lab_name,storage_location) VALUES
((SELECT case_id FROM forensic_case WHERE police_reference_no='CRF/LUN/26/0417'),(SELECT evidence_type_id FROM evidence_type WHERE type_name='Preserved Garment Section'),'2026-05-04','Left protective sleeve cuff','Aurelia Trace Chemistry Laboratory','Trace Store T1 - Cabinet 07 - Shelf B'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='CRF/LUN/26/0417'),(SELECT evidence_type_id FROM evidence_type WHERE type_name='Surface Chemical Swab'),'2026-05-04','Volar surface of left forearm','Aurelia Trace Chemistry Laboratory','Cold Vault C2 - Rack 04 - Slot 11'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='ENV/RVM/26/0226'),(SELECT evidence_type_id FROM evidence_type WHERE type_name='Femoral Venous Blood'),'2026-05-24','Right femoral vein','Cedar Vault Toxicology Centre','Secure Freezer F2 - Basket 09'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='ENV/RVM/26/0226'),(SELECT evidence_type_id FROM evidence_type WHERE type_name='Air-Filter Particulate Residue'),'2026-05-24','Drying chamber exhaust filter E-4','Lattice Spectral Evidence Unit','Trace Store T1 - Cabinet 11 - Shelf D');

INSERT INTO lab_sample (evidence_id,collected_by,sample_type,collected_date) VALUES
((SELECT evidence_id FROM evidence WHERE location='Left protective sleeve cuff'),(SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'Preserved garment cuff section','2026-05-04'),
((SELECT evidence_id FROM evidence WHERE location='Volar surface of left forearm'),(SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'Sterile surface residue swab','2026-05-04'),
((SELECT evidence_id FROM evidence WHERE location='Right femoral vein'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'Fluoride-preserved femoral blood aliquot','2026-05-24'),
((SELECT evidence_id FROM evidence WHERE location='Drying chamber exhaust filter E-4'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Air-filter particulate residue','2026-05-24');

INSERT INTO chain_of_custody_log (evidence_id,staff_id,transfer_date,from_location,to_location,remarks) VALUES
((SELECT evidence_id FROM evidence WHERE location='Left protective sleeve cuff'),(SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'2026-05-04 14:20+05:30','Clinical Examination Room 03','Trace Evidence Reception','Item sealed in tamper-evident pouch TE-260504-17.'),
((SELECT evidence_id FROM evidence WHERE location='Left protective sleeve cuff'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'2026-05-04 15:05+05:30','Trace Evidence Reception','Trace Store T1 - Cabinet 07 - Shelf B','Seal verified intact before refrigerated storage.'),
((SELECT evidence_id FROM evidence WHERE location='Right femoral vein'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'2026-05-24 11:45+05:30','Postmortem Suite 02','Toxicology Dispatch Refrigerator','Tube labelled FB-ENV-0226 and sealed.'),
((SELECT evidence_id FROM evidence WHERE location='Right femoral vein'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'2026-05-24 16:10+05:30','Toxicology Dispatch Refrigerator','Secure Freezer F2 - Basket 09','Specimen received at controlled temperature.');

INSERT INTO laboratory_test (sample_id,technician_id,test_type,test_date,result,status) VALUES
((SELECT sample_id FROM lab_sample WHERE sample_type='Preserved garment cuff section'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Fourier-transform infrared residue comparison','2026-05-05','Spectrum showed strong similarity to an alkaline silicate cleaning compound used at the incident location.','Verified'),
((SELECT sample_id FROM lab_sample WHERE sample_type='Sterile surface residue swab'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Ion chromatography screening','2026-05-05','Elevated silicate and carbonate ions were detected on the submitted swab.','Completed'),
((SELECT sample_id FROM lab_sample WHERE sample_type='Fluoride-preserved femoral blood aliquot'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Carboxyhaemoglobin quantification','2026-05-25','Carboxyhaemoglobin concentration measured at 58 percent saturation.','Verified'),
((SELECT sample_id FROM lab_sample WHERE sample_type='Air-filter particulate residue'),(SELECT staff_id FROM staff WHERE email='yuhansa.vinduranga@fmds.demo'),'Headspace gas chromatography screening','2026-05-25','Combustion-derived volatile profile detected; no petroleum accelerant pattern identified.','Completed');

INSERT INTO legal_report (case_id,prepared_by,report_type,issue_date,status) VALUES
((SELECT case_id FROM forensic_case WHERE police_reference_no='CRF/LUN/26/0417'),(SELECT staff_id FROM staff WHERE email='sadeesha.karunatilaka@fmds.demo'),'Medico-Legal Examination Report','2026-05-08','Issued'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='PMH/MER/26/0138'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'Postmortem Examination Report','2026-05-27','Signed'),
((SELECT case_id FROM forensic_case WHERE police_reference_no='ENV/RVM/26/0226'),(SELECT staff_id FROM staff WHERE email='inovya.welikumbura@fmds.demo'),'Cause of Death Notification','2026-05-28','Submitted');

INSERT INTO court_submission (report_id,court_name,submission_date,hearing_date,judge_name,submission_status) VALUES
((SELECT report_id FROM legal_report lr JOIN forensic_case fc ON lr.case_id=fc.case_id WHERE fc.police_reference_no='ENV/RVM/26/0226' AND lr.report_type='Cause of Death Notification'),'Hillcrest Magistrate''s Court','2026-05-29','2026-06-18','Magistrate A. M. Virel','Hearing Scheduled');

COMMIT;
