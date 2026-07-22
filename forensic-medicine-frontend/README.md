# Forensic Medicine Department Database — Front-End

A complete responsive front-end for the university mini-project using plain HTML5, CSS3, vanilla JavaScript, Bootstrap 5, Chart.js, and QRCode.js.

## Visual design

- Frosted-glass cards, top bar, filters, modals, and navigation
- Soft navy, teal, blue-grey, and white palette suitable for official medical software
- Compact page descriptions and cleaner labels to avoid text-heavy screens
- Responsive card and chart layouts inspired by modern clinical dashboards
- Custom line icons in the sidebar without adding another icon dependency

## Run locally

Use an HTTP server so QR trace links and REST calls work correctly.

```bash
cd forensic-medicine-frontend
python -m http.server 5500
```

Open `http://localhost:5500`.

VS Code Live Server also works.

## Demo login

Choose any role. Demo credentials are prefilled. The selected role controls which sidebar modules are visible.

## Folder structure

```text
forensic-medicine-frontend/
├── index.html
├── README.md
├── assets/
│   └── logo-mark.svg
├── components/
│   ├── app-shell.js
│   ├── qr-modal.js
│   ├── ui.js
│   └── README.md
├── css/
│   ├── styles.css
│   └── print.css
├── docs/
│   └── api-endpoint-map.md
├── js/
│   ├── access.js
│   ├── api.js
│   ├── audit.js
│   ├── auth.js
│   ├── cases.js
│   ├── clinical.js
│   ├── config.js
│   ├── dashboard.js
│   ├── evidence.js
│   ├── forms.js
│   ├── legal.js
│   ├── mock-data.js
│   ├── patients.js
│   ├── postmortem.js
│   ├── reports.js
│   ├── staff.js
│   └── trace.js
└── pages/
    ├── access-control.html
    ├── audit-trail.html
    ├── cases.html
    ├── clinical-examination.html
    ├── dashboard.html
    ├── evidence-lab.html
    ├── legal-reports.html
    ├── patients.html
    ├── postmortem.html
    ├── reports.html
    ├── staff.html
    └── trace.html
```

## Implemented modules

- Role-based secure login demo and session timeout indicator
- Analytics dashboard with four interactive Chart.js charts and date filtering
- Patient registry, next-of-kin, search, and multiple-case history
- Case creation, filtering, status tracker, and working case QR
- MLEF-style clinical form with clickable body-region injury selector
- Postmortem registry, cause-of-death fields, and dynamic organ findings
- Evidence register, working evidence QR, custody timeline, samples, and laboratory tests
- Official medico-legal report preview, print layout, court tracker, and receipt logging
- Staff management with role-specific fields
- User accounts and permission matrix
- Daily, monthly, and pending-case reports with CSV export
- Admin audit trail with filters, before/after values, and suspicious-activity flags
- Public read-only case/evidence trace page

## Backend integration

Set `API_BASE_URL` in `js/config.js`. Each screen calls `apiRequest()` in `js/api.js`. Failed requests automatically use mock data so the viva demo stays functional.

See `docs/api-endpoint-map.md`.

## Production security notes

- Client-side role hiding is not security. Verify JWT claims in Express middleware.
- QR trace links must use signed, expiring tokens.
- Store forensic attachments in authenticated object storage and audit every access.
- Replace sample report text with approved departmental templates.
- Never use the mock personal data in production.
