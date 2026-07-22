(function(){
  const seed={
    patients:[
      {PatientID:1001,Name:'Nimal Perera',NIC:'861234567V',Age:39,Gender:'M',Address:'Kandy',PhoneNumber:'0712345678',BHTNumber:'BHT-20541',IsDeceased:false,NextOfKin:[{Name:'Samanthi Perera',Relationship:'Spouse',PhoneNumber:'0772233445',Address:'Kandy'}]},
      {PatientID:1002,Name:'Fathima Nazeer',NIC:'200145600812',Age:25,Gender:'F',Address:'Akurana',PhoneNumber:'0767788990',BHTNumber:'BHT-20566',IsDeceased:false,NextOfKin:[{Name:'M. Nazeer',Relationship:'Father',PhoneNumber:'0753344556',Address:'Akurana'}]},
      {PatientID:1003,Name:'Unknown Male 07/26',NIC:'',Age:52,Gender:'M',Address:'Not available',PhoneNumber:'',BHTNumber:'BHT-20498',IsDeceased:true,NextOfKin:[]},
      {PatientID:1004,Name:'S. Jayawardena',NIC:'197955602345',Age:47,Gender:'F',Address:'Peradeniya',PhoneNumber:'0704455667',BHTNumber:'BHT-20610',IsDeceased:false,NextOfKin:[{Name:'K. Jayawardena',Relationship:'Sibling',PhoneNumber:'0725566778',Address:'Peradeniya'}]}
    ],
    cases:[
      {CaseID:24071,PatientID:1001,CaseTypeID:1,CaseType:'Road Traffic Accident',RegisteredBy:12,IncidentDate:'2026-07-12',Place:'Peradeniya Road',PoliceReferenceNo:'PDN/CR/442/26',Status:'MLEF Pending',AssignedDoctor:'Dr. Nadeesha Perera'},
      {CaseID:24072,PatientID:1002,CaseTypeID:2,CaseType:'Clinical Assault',RegisteredBy:14,IncidentDate:'2026-07-14',Place:'Akurana',PoliceReferenceNo:'AKR/CR/180/26',Status:'Under Examination',AssignedDoctor:'Dr. Kavinda Jayasinghe'},
      {CaseID:24073,PatientID:1003,CaseTypeID:4,CaseType:'Postmortem',RegisteredBy:12,IncidentDate:'2026-07-15',Place:'Kandy Municipal Area',PoliceReferenceNo:'KDY/UD/091/26',Status:'PM Report Pending',AssignedDoctor:'Dr. Kavinda Jayasinghe'},
      {CaseID:24074,PatientID:1004,CaseTypeID:3,CaseType:'Domestic Abuse',RegisteredBy:16,IncidentDate:'2026-06-29',Place:'Peradeniya',PoliceReferenceNo:'PDN/CR/390/26',Status:'Completed',AssignedDoctor:'Dr. Nadeesha Perera'}
    ],
    examinations:[{ExaminationID:501,CaseID:24071,DoctorID:12,Date:'2026-07-12',ReferralType:'Hospital Police / MLEF',DoctorNotes:'Clinical examination recorded.',Status:'Draft'}],
    postmortems:[
      {PostmortemID:310,CaseID:24073,DoctorID:17,Date:'2026-07-16',CauseOfDeath:'Pending laboratory confirmation',PMRDetails:'Draft findings recorded in PMR.',Type:'Natural',Status:'PM Report Pending'},
      {PostmortemID:309,CaseID:23996,DoctorID:17,Date:'2026-07-08',CauseOfDeath:'Cardiorespiratory failure due to natural disease',PMRDetails:'Finalized',Type:'Natural',Status:'Completed'}
    ],
    evidence:[
      {EvidenceID:7001,CaseID:24071,EvidenceTypeID:1,EvidenceType:'Blood Sample',CollectionDate:'2026-07-12',Location:'Ward 11',LabName:'Toxicology Laboratory',StorageLocation:'Cold Store A-12',Status:'In Laboratory'},
      {EvidenceID:7002,CaseID:24072,EvidenceTypeID:3,EvidenceType:'Clothing Item',CollectionDate:'2026-07-14',Location:'Examination Room 2',LabName:'Forensic Laboratory',StorageLocation:'Evidence Locker E-08',Status:'Stored'},
      {EvidenceID:7003,CaseID:24073,EvidenceTypeID:2,EvidenceType:'Tissue Sample',CollectionDate:'2026-07-16',Location:'Postmortem Room',LabName:'Histopathology',StorageLocation:'Histology Rack H-03',Status:'Testing'}
    ],
    custody:[
      {CustodyLogID:8801,EvidenceID:7001,StaffID:12,StaffName:'Dr. Nadeesha Perera',TransferDate:'2026-07-12T10:20:00',FromLocation:'Ward 11',ToLocation:'Evidence Reception',Remarks:'Collected and sealed'},
      {CustodyLogID:8802,EvidenceID:7001,StaffID:31,StaffName:'Ms. Ruwani Silva',TransferDate:'2026-07-12T11:05:00',FromLocation:'Evidence Reception',ToLocation:'Toxicology Laboratory',Remarks:'Seal verified; sample accepted'},
      {CustodyLogID:8803,EvidenceID:7001,StaffID:31,StaffName:'Ms. Ruwani Silva',TransferDate:'2026-07-13T15:15:00',FromLocation:'Toxicology Laboratory',ToLocation:'Cold Store A-12',Remarks:'Stored after initial processing'},
      {CustodyLogID:8810,EvidenceID:7002,StaffID:17,StaffName:'Dr. Kavinda Jayasinghe',TransferDate:'2026-07-14T13:40:00',FromLocation:'Examination Room 2',ToLocation:'Evidence Locker E-08',Remarks:'Item bagged, labeled, and sealed'}
    ],
    labSamples:[{SampleID:9101,EvidenceID:7001,CollectedBy:12,SampleType:'Peripheral blood',CollectedDate:'2026-07-12'},{SampleID:9102,EvidenceID:7003,CollectedBy:17,SampleType:'Tissue block',CollectedDate:'2026-07-16'}],
    labTests:[{TestID:9201,SampleID:9101,TechnicianID:31,TestType:'Toxicology Screen',TestDate:'2026-07-13',Result:'Pending confirmation',Status:'Processing'},{TestID:9202,SampleID:9102,TechnicianID:31,TestType:'Histology',TestDate:'2026-07-17',Result:'Report not yet issued',Status:'Pending'}],
    legalReports:[{ReportID:6101,CaseID:24071,PreparedBy:12,Type:'Medico-Legal Report',IssueDate:'',Status:'Draft'},{ReportID:6102,CaseID:24074,PreparedBy:12,Type:'Medico-Legal Report',IssueDate:'2026-07-02',Status:'Issued'},{ReportID:6103,CaseID:24073,PreparedBy:17,Type:'Postmortem Report',IssueDate:'',Status:'Pending'}],
    courtSubmissions:[{SubmissionID:6201,ReportID:6102,CourtName:'Magistrate Court of Kandy',SubmissionDate:'2026-07-03',HearingDate:'2026-07-24',JudgeName:'Hon. A. Wijesinghe',SubmissionStatus:'Received'},{SubmissionID:6202,ReportID:6101,CourtName:'District Court of Kandy',SubmissionDate:'',HearingDate:'2026-07-22',JudgeName:'Hon. R. Senanayake',SubmissionStatus:'Report Pending'}],
    staff:[
      {StaffID:12,DepartmentID:1,Name:'Dr. Nadeesha Perera',Role:'Doctor',PhoneNumber:'0711112233',Email:'nadeesha.perera@hospital.lk',Specialization:'Forensic Medicine',MedicalLicenseNo:'SLMC-18221',AccountStatus:'Active'},
      {StaffID:17,DepartmentID:1,Name:'Dr. Kavinda Jayasinghe',Role:'JMO',PhoneNumber:'0723334455',Email:'kavinda.j@hospital.lk',Jurisdiction:'Kandy District',AppointmentDate:'2024-01-10',AccountStatus:'Active'},
      {StaffID:31,DepartmentID:1,Name:'Ms. Ruwani Silva',Role:'Lab Technician',PhoneNumber:'0774445566',Email:'ruwani.s@hospital.lk',LabSection:'Toxicology',CertificationNo:'MLT-8821',AccountStatus:'Active'},
      {StaffID:42,DepartmentID:1,Name:'Mr. Dilan Fernando',Role:'Clerical Officer',PhoneNumber:'0765556677',Email:'dilan.f@hospital.lk',DeskSection:'Court Reports',AccountStatus:'Active'},
      {StaffID:50,DepartmentID:1,Name:'Ms. Anushka Ramanayake',Role:'Clerical Officer',PhoneNumber:'0756667788',Email:'anushka.r@hospital.lk',DeskSection:'Registry',AccountStatus:'Suspended'}
    ],
    users:[{UserID:1,StaffID:12,Username:'nperera',LastLogin:'2026-07-19T17:54:00',AccountStatus:'Active',AccessRole:'Doctor'},{UserID:2,StaffID:17,Username:'kjayasinghe',LastLogin:'2026-07-19T18:12:00',AccountStatus:'Active',AccessRole:'JMO'},{UserID:3,StaffID:31,Username:'rsilva',LastLogin:'2026-07-19T16:40:00',AccountStatus:'Active',AccessRole:'Lab Technician'},{UserID:4,StaffID:42,Username:'dfernando',LastLogin:'2026-07-19T17:08:00',AccountStatus:'Active',AccessRole:'Clerical Officer'},{UserID:5,StaffID:null,Username:'sysadmin',LastLogin:'2026-07-19T19:02:00',AccountStatus:'Active',AccessRole:'Admin'}],
    auditLogs:[
      {AuditLogID:9901,UserID:1,User:'nperera',ActionType:'LOGIN',TableAffected:'User',RecordID:1,Timestamp:'2026-07-19T17:54:10',IPAddress:'10.20.4.18',Before:null,After:{LastLogin:'2026-07-19T17:54:10'}},
      {AuditLogID:9902,UserID:1,User:'nperera',ActionType:'UPDATE',TableAffected:'ClinicalExamination',RecordID:501,Timestamp:'2026-07-19T18:02:18',IPAddress:'10.20.4.18',Before:{Status:'Draft',DoctorNotes:'Initial note'},After:{Status:'Under Review',DoctorNotes:'Clinical examination recorded.'}},
      {AuditLogID:9903,UserID:2,User:'kjayasinghe',ActionType:'CREATE',TableAffected:'PostmortemFinding',RecordID:4201,Timestamp:'2026-07-19T18:16:33',IPAddress:'10.20.4.21',Before:null,After:{Organ:'Heart',Significance:'Relevant'}},
      {AuditLogID:9904,UserID:4,User:'dfernando',ActionType:'REPORT_ISSUED',TableAffected:'LegalReport',RecordID:6102,Timestamp:'2026-07-19T18:40:20',IPAddress:'10.20.4.33',Before:{Status:'Approved'},After:{Status:'Issued',IssueDate:'2026-07-19'}},
      {AuditLogID:9905,UserID:88,User:'unknown',ActionType:'FAILED_LOGIN',TableAffected:'User',RecordID:0,Timestamp:'2026-07-19T23:51:02',IPAddress:'172.18.5.99',Before:null,After:{Attempts:5,Username:'admin'}},
      {AuditLogID:9906,UserID:5,User:'sysadmin',ActionType:'ROLE_CHANGED',TableAffected:'UserRole',RecordID:4,Timestamp:'2026-07-19T21:35:07',IPAddress:'10.20.4.5',Before:{Role:'Clerical Officer'},After:{Role:'Clerical Officer',CanExport:true}},
      {AuditLogID:9907,UserID:3,User:'rsilva',ActionType:'UPDATE',TableAffected:'LaboratoryTest',RecordID:9201,Timestamp:'2026-07-18T02:22:55',IPAddress:'10.20.4.29',Before:{Status:'Pending'},After:{Status:'Processing'}}
    ]
  };
  const key='fmd_mock_db';let db;try{db=JSON.parse(localStorage.getItem(key))||seed;}catch{db=seed}
  const save=()=>localStorage.setItem(key,JSON.stringify(db));
  const map={'/api/patients':'patients','/api/cases':'cases','/api/examinations':'examinations','/api/postmortems':'postmortems','/api/evidence':'evidence','/api/custody':'custody','/api/lab-samples':'labSamples','/api/lab-tests':'labTests','/api/legal-reports':'legalReports','/api/court-submissions':'courtSubmissions','/api/staff':'staff','/api/users':'users','/api/audit-logs':'auditLogs'};
  const idMap={patients:'PatientID',cases:'CaseID',examinations:'ExaminationID',postmortems:'PostmortemID',evidence:'EvidenceID',custody:'CustodyLogID',labSamples:'SampleID',labTests:'TestID',legalReports:'ReportID',courtSubmissions:'SubmissionID',staff:'StaffID',users:'UserID',auditLogs:'AuditLogID'};
  window.MockDB={data:db,async handle(endpoint,options={}){
    const clean=endpoint.split('?')[0].replace(/\/$/,''),collection=map[clean],method=(options.method||'GET').toUpperCase();
    if(!collection)throw new Error(`No mock route for ${endpoint}`);
    if(method==='GET')return structuredClone(db[collection]);
    const payload=typeof options.body==='string'?JSON.parse(options.body):(options.body||{});
    if(method==='POST'){const idField=idMap[collection],max=Math.max(0,...db[collection].map(x=>Number(x[idField])||0)),record={...payload,[idField]:payload[idField]||max+1};db[collection].unshift(record);save();return structuredClone(record);}
    throw new Error(`Mock method ${method} not implemented`);
  }};
})();
