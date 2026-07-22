# REST API integration map

The UI calls these placeholder endpoints through `js/api.js`. If a request fails, it falls back to `js/mock-data.js`.

| UI module | Method | Endpoint | Main database entities |
|---|---:|---|---|
| Login | POST | `/api/auth/login` | User, UserRole, AccessRole |
| Patients | GET / POST | `/api/patients` | Patient, NextOfKin |
| Cases | GET / POST | `/api/cases` | Case, CaseType |
| Clinical examination | GET / POST | `/api/examinations` | ClinicalExamination, InjuryDetail |
| Postmortem | GET / POST | `/api/postmortems` | Postmortem, PostmortemFinding |
| Evidence | GET / POST | `/api/evidence` | Evidence, EvidenceType |
| Custody | GET / POST | `/api/custody` | ChainOfCustodyLog |
| Samples | GET / POST | `/api/lab-samples` | LabSample |
| Laboratory tests | GET / POST | `/api/lab-tests` | LaboratoryTest |
| Legal reports | GET / POST | `/api/legal-reports` | LegalReport |
| Court submissions | GET / POST | `/api/court-submissions` | CourtSubmission |
| Staff | GET / POST | `/api/staff` | Staff and role subtype tables |
| Users | GET / PATCH | `/api/users` | User, UserRole |
| Audit trail | GET | `/api/audit-logs` | AuditLog |

## JWT integration

1. Replace the demo login handler with `POST /api/auth/login`.
2. Prefer an HTTP-only, secure, same-site cookie for the token.
3. If the backend returns a bearer token, add the `Authorization` header inside `js/api.js`.
4. Redirect to `index.html` when the backend returns `401`.
5. Enforce role permissions in Express middleware. The client role toggle is only a demo.
6. Use a signed, expiring token in QR trace URLs.
