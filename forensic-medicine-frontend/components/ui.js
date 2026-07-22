(function () {
  const statusClass = (status = '') => {
    const v = String(status).toLowerCase();
    if (['completed','issued','active','received','approved','closed','living','stored'].some(x => v.includes(x))) return 'status-success';
    if (['pending','awaiting','draft','scheduled','processing','under'].some(x => v.includes(x))) return 'status-warning';
    if (['urgent','overdue','failed','suspended','deceased','missing'].some(x => v.includes(x))) return 'status-danger';
    return 'status-neutral';
  };
  window.UI = {
    escapeHtml(value='') {
      return String(value).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));
    },
    statusBadge(status) {
      return `<span class="case-seal ${statusClass(status)}">${this.escapeHtml(status)}</span>`;
    },
    formatDate(value) {
      if (!value) return '—';
      const d = new Date(value);
      return Number.isNaN(d.getTime()) ? value : new Intl.DateTimeFormat('en-GB',{day:'2-digit',month:'short',year:'numeric'}).format(d);
    },
    toast(message, type='success') {
      let c = document.getElementById('toastContainer');
      if (!c) {
        c = document.createElement('div');
        c.id='toastContainer';
        c.className='toast-container position-fixed top-0 end-0 p-3';
        c.style.zIndex='2000';
        document.body.appendChild(c);
      }
      const id=`toast-${Date.now()}`;
      c.insertAdjacentHTML('beforeend',`<div id="${id}" class="toast border-0 shadow" role="status">
        <div class="toast-header"><span class="toast-dot toast-${type}"></span><strong class="me-auto">Forensic DB</strong><small>now</small><button class="btn-close" data-bs-dismiss="toast"></button></div>
        <div class="toast-body">${this.escapeHtml(message)}</div></div>`);
      const el=document.getElementById(id);
      bootstrap.Toast.getOrCreateInstance(el,{delay:3200}).show();
      el.addEventListener('hidden.bs.toast',()=>el.remove());
    },
    emptyRow(colspan, message='No records found.') {
      return `<tr><td colspan="${colspan}" class="empty-state">${this.escapeHtml(message)}</td></tr>`;
    },
    downloadCsv(filename, rows) {
      if (!rows?.length) return this.toast('No rows available for export.','warning');
      const headers=Object.keys(rows[0]);
      const csv=[headers.join(','),...rows.map(r=>headers.map(h=>`"${String(r[h]??'').replace(/"/g,'""')}"`).join(','))].join('\n');
      const blob=new Blob([csv],{type:'text/csv;charset=utf-8'});
      const url=URL.createObjectURL(blob);
      const a=document.createElement('a');
      a.href=url;a.download=filename;a.click();URL.revokeObjectURL(url);
    }
  };
})();
