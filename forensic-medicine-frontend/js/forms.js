(function(){
  const nicPattern=/^(?:\d{9}[VvXx]|\d{12})$/;
  window.FormValidation={
    validateNic(input){const v=input.value.trim(),ok=!v||nicPattern.test(v);input.setCustomValidity(ok?'':'Enter 9 digits + V/X, or a 12-digit NIC.');return ok;},
    validateNotFuture(input){const ok=!input.value||new Date(input.value)<=new Date();input.setCustomValidity(ok?'':'Date cannot be in the future.');return ok;},
    validateDateOrder(a,b){const ok=!a.value||!b.value||new Date(b.value)>=new Date(a.value);b.setCustomValidity(ok?'':'End date must be on or after start date.');return ok;},
    bindBootstrapValidation(form,onValid){form.addEventListener('submit',async e=>{e.preventDefault();e.stopPropagation();form.classList.add('was-validated');if(!form.checkValidity())return;try{await onValid(new FormData(form),form);}catch(err){console.error(err);UI.toast(err.message||'Unable to save record.','danger');}});}
  };
  document.addEventListener('input',e=>{if(e.target.matches('[data-validate="nic"]'))FormValidation.validateNic(e.target);if(e.target.matches('[data-not-future]'))FormValidation.validateNotFuture(e.target);});
})();
