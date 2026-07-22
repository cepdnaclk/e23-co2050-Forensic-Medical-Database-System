(function(){
  function ensure(){
    if(document.getElementById('qrModal')) return;
    document.body.insertAdjacentHTML('beforeend',`<div class="modal fade" id="qrModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content official-modal">
      <div class="modal-header"><div><p class="eyebrow mb-1">Secure trace label</p><h2 class="modal-title fs-5" id="qrModalTitle">Tracking QR</h2></div><button class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body text-center"><div class="qr-frame"><div id="qrCodeTarget"></div></div><p class="fw-semibold mt-3 mb-1" id="qrRecordLabel"></p><p class="text-muted small">Scanning opens a read-only trace page.</p><div class="input-group input-group-sm"><input class="form-control" id="qrUrlInput" readonly><button class="btn btn-outline-secondary" id="copyQrLink">Copy link</button></div></div>
      <div class="modal-footer justify-content-between"><small class="text-muted">Attach to the official file or evidence container.</small><button class="btn btn-primary" id="printQrButton">Print label</button></div>
    </div></div></div>`);
    document.getElementById('copyQrLink').onclick=async()=>{const v=document.getElementById('qrUrlInput').value;try{await navigator.clipboard.writeText(v);}catch{document.getElementById('qrUrlInput').select();document.execCommand('copy');}UI.toast('Trace link copied.');};
    document.getElementById('printQrButton').onclick=()=>window.print();
  }
  window.showTrackingQr=({kind,id,label})=>{
    ensure();
    const origin=location.origin&&location.origin!=='null'?location.origin:'http://localhost:5500';
    const url=`${origin}/pages/trace.html?type=${encodeURIComponent(kind)}&id=${encodeURIComponent(id)}`;
    document.getElementById('qrModalTitle').textContent=`${kind==='case'?'Case':'Evidence'} tracking QR`;
    document.getElementById('qrRecordLabel').textContent=label||id;
    document.getElementById('qrUrlInput').value=url;
    const t=document.getElementById('qrCodeTarget');t.innerHTML='';
    if(window.QRCode)new QRCode(t,{text:url,width:210,height:210,correctLevel:QRCode.CorrectLevel.H});
    else t.innerHTML='<p class="text-danger">QR library failed to load.</p>';
    bootstrap.Modal.getOrCreateInstance(document.getElementById('qrModal')).show();
  };
})();
