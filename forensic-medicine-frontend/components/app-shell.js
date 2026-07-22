(function () {
  const body=document.body;
  const root=body.dataset.root||'..';
  if (body.dataset.public==='true') return;
  let session;
  try { session=JSON.parse(localStorage.getItem('fmd_session')); } catch {}
  if (!session) { location.replace(`${root}/index.html`); return; }

  const page=body.dataset.page||'';
  const items=[
    ['dashboard','Dashboard','dashboard.html',['Doctor','JMO','Lab Technician','Clerical Officer','Admin']],
    ['patients','Patient Management','patients.html',['Doctor','JMO','Clerical Officer','Admin']],
    ['cases','Case Management','cases.html',['Doctor','JMO','Clerical Officer','Admin']],
    ['clinical','Clinical Examination','clinical-examination.html',['Doctor','JMO']],
    ['postmortem','Postmortem','postmortem.html',['Doctor','JMO']],
    ['evidence','Evidence & Laboratory','evidence-lab.html',['Doctor','JMO','Lab Technician','Clerical Officer','Admin']],
    ['legal','Legal & Court Reports','legal-reports.html',['Doctor','JMO','Clerical Officer','Admin']],
    ['staff','Staff Management','staff.html',['Clerical Officer','Admin']],
    ['access','User & Access Control','access-control.html',['Admin']],
    ['reports','Reports & Statistics','reports.html',['Doctor','JMO','Lab Technician','Clerical Officer','Admin']],
    ['audit','Audit Trail','audit-trail.html',['Admin']]
  ].filter(x=>x[3].includes(session.role));

  const icons={
    dashboard:'<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="3" width="7" height="7" rx="2"/><rect x="14" y="3" width="7" height="7" rx="2"/><rect x="3" y="14" width="7" height="7" rx="2"/><rect x="14" y="14" width="7" height="7" rx="2"/></svg>',
    patients:'<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="3.5"/><path d="M5 20c.7-4 3-6 7-6s6.3 2 7 6"/></svg>',
    cases:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h6l2 2h8v10H4z"/><path d="M4 7V5h6l2 2"/></svg>',
    clinical:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 3h6v4h4v14H5V7h4z"/><path d="M9 12h6M12 9v6"/></svg>',
    postmortem:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M7 3h10v18H7z"/><path d="M10 7h4M10 11h4M10 15h4"/></svg>',
    evidence:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 3h6l1 5-4 3-4-3z"/><path d="M12 11v10M8 21h8"/></svg>',
    legal:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M6 3h9l3 3v15H6z"/><path d="M15 3v4h4M9 12h6M9 16h6"/></svg>',
    staff:'<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="9" cy="8" r="3"/><circle cx="17" cy="10" r="2.5"/><path d="M3 20c.5-4 2.5-6 6-6s5.5 2 6 6M14 15c3 0 5 1.7 5.5 5"/></svg>',
    access:'<svg viewBox="0 0 24 24" aria-hidden="true"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 018 0v3M12 14v3"/></svg>',
    reports:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 20V10M10 20V4M16 20v-7M22 20H2"/></svg>',
    audit:'<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3l8 4v5c0 5-3.4 8-8 9-4.6-1-8-4-8-9V7z"/><path d="M9 12l2 2 4-5"/></svg>'
  };
  const original=[...body.children].filter(n=>n.tagName!=='SCRIPT');
  original.forEach(n=>n.remove());

  const shell=document.createElement('div');
  shell.className='app-shell';
  shell.innerHTML=`
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-brand"><img src="${root}/assets/logo-mark.svg" class="brand-mark" alt=""><div><span class="brand-kicker">University Hospital</span><strong>Forensic Medicine</strong><small>Department Database</small></div></div>
      <div class="security-classification"><span class="security-dot"></span>Restricted records</div>
      <nav class="sidebar-nav">${items.map(x=>`<a class="nav-entry ${x[0]===page?'active':''}" href="${x[2]}"><span class="nav-icon">${icons[x[0]]}</span><span>${x[1]}</span></a>`).join('')}</nav>
      <div class="sidebar-footer"><div class="department-chip"><span>Department</span><strong>${UI.escapeHtml(session.department)}</strong></div><button class="sidebar-logout" id="logoutButton">Sign out securely</button></div>
    </aside>
    <div class="main-panel">
      <header class="topbar">
        <div class="topbar-left"><button class="mobile-menu-button" id="menuButton">☰</button><div><p class="eyebrow">${body.dataset.section||'Department Operations'}</p><h1>${body.dataset.title||document.title}</h1></div></div>
        <div class="topbar-actions">
          <div class="session-timer"><span class="session-pulse"></span><span>Session <strong id="sessionCountdown">14:59</strong></span></div>
          <div class="role-switcher"><label for="roleSwitcher">Demo role</label><select id="roleSwitcher" class="form-select form-select-sm">${['Doctor','JMO','Lab Technician','Clerical Officer','Admin'].map(r=>`<option ${r===session.role?'selected':''}>${r}</option>`).join('')}</select></div>
          <button class="profile-button" type="button" data-bs-toggle="dropdown"><span class="profile-avatar">${session.name.split(' ').map(x=>x[0]).slice(0,2).join('')}</span><span class="profile-copy"><strong>${UI.escapeHtml(session.name)}</strong><small>${UI.escapeHtml(session.role)}</small></span><span>⌄</span></button>
          <ul class="dropdown-menu dropdown-menu-end official-dropdown"><li><span class="dropdown-item-text">${UI.escapeHtml(session.department)}</span></li><li><hr class="dropdown-divider"></li><li><button class="dropdown-item" id="dropdownLogout">Sign out</button></li></ul>
        </div>
      </header>
      <main class="content-area" id="contentArea"></main>
    </div><div class="sidebar-scrim" id="sidebarScrim"></div>`;
  body.prepend(shell);
  original.forEach(n=>document.getElementById('contentArea').appendChild(n));

  const logout=()=>{localStorage.removeItem('fmd_session');location.replace(`${root}/index.html`);};
  document.getElementById('logoutButton').addEventListener('click',logout);
  document.getElementById('dropdownLogout').addEventListener('click',logout);

  document.getElementById('roleSwitcher').addEventListener('change',e=>{
    const names={'Doctor':'Dr. Nadeesha Perera','JMO':'Dr. Kavinda Jayasinghe','Lab Technician':'Ms. Ruwani Silva','Clerical Officer':'Mr. Dilan Fernando','Admin':'System Administrator'};
    session.role=e.target.value;session.name=names[session.role];
    localStorage.setItem('fmd_session',JSON.stringify(session));location.reload();
  });

  const sidebar=document.getElementById('sidebar'),scrim=document.getElementById('sidebarScrim');
  document.getElementById('menuButton').addEventListener('click',()=>{sidebar.classList.add('open');scrim.classList.add('show');});
  scrim.addEventListener('click',()=>{sidebar.classList.remove('open');scrim.classList.remove('show');});

  let seconds=899;
  const timer=setInterval(()=>{
    seconds--;
    if (seconds<0){clearInterval(timer);UI.toast('Demo session expired.','warning');setTimeout(logout,800);return;}
    document.getElementById('sessionCountdown').textContent=`${String(Math.floor(seconds/60)).padStart(2,'0')}:${String(seconds%60).padStart(2,'0')}`;
  },1000);
})();
