document.addEventListener('DOMContentLoaded',()=>{
  const form=document.getElementById('loginForm'),role=document.getElementById('loginRole'),user=document.getElementById('username'),pass=document.getElementById('password');
  const names={'Doctor':'Dr. Nadeesha Perera','JMO':'Dr. Kavinda Jayasinghe','Lab Technician':'Ms. Ruwani Silva','Clerical Officer':'Mr. Dilan Fernando','Admin':'System Administrator'};
  role.onchange=()=>{const u={'Doctor':'nperera','JMO':'kjayasinghe','Lab Technician':'rsilva','Clerical Officer':'dfernando','Admin':'sysadmin'};user.value=u[role.value];pass.value='demo1234';};
  role.onchange();
  form.addEventListener('submit',e=>{e.preventDefault();form.classList.add('was-validated');if(!form.checkValidity())return;localStorage.setItem('fmd_session',JSON.stringify({name:names[role.value],role:role.value,department:'Forensic Medicine — Teaching Hospital'}));const b=form.querySelector('button[type="submit"]');b.disabled=true;b.innerHTML='<span class="spinner-border spinner-border-sm me-2"></span>Verifying secure session…';setTimeout(()=>location.href='pages/dashboard.html',500);});
});
