document.addEventListener('DOMContentLoaded',()=>{
  const css=getComputedStyle(document.documentElement);
  const teal=css.getPropertyValue('--teal-600').trim();
  const navy=css.getPropertyValue('--navy-900').trim();
  const amber=css.getPropertyValue('--amber-600').trim();
  const red=css.getPropertyValue('--red-600').trim();

  Chart.defaults.font.family='Inter, sans-serif';
  Chart.defaults.color='#627d98';
  Chart.defaults.plugins.legend.labels.usePointStyle=true;
  Chart.defaults.plugins.legend.labels.boxWidth=8;
  Chart.defaults.plugins.legend.labels.boxHeight=8;
  Chart.defaults.plugins.legend.labels.padding=16;

  const shared={
    responsive:true,
    maintainAspectRatio:false,
    animation:{duration:650},
    plugins:{
      legend:{position:'bottom',labels:{font:{size:11}}},
      tooltip:{backgroundColor:'rgba(7,22,37,.92)',padding:10,cornerRadius:10,titleFont:{size:11},bodyFont:{size:11}}
    }
  };

  const monthly=new Chart(document.getElementById('monthlyCasesChart'),{
    type:'bar',
    data:{
      labels:['Jan','Feb','Mar','Apr','May','Jun','Jul'],
      datasets:[
        {label:'Clinical',data:[31,34,29,42,38,41,32],backgroundColor:'rgba(21,153,139,.72)',hoverBackgroundColor:teal,borderRadius:10,borderSkipped:false,maxBarThickness:28},
        {label:'Postmortem',data:[15,13,17,14,18,16,16],backgroundColor:'rgba(19,50,77,.72)',hoverBackgroundColor:navy,borderRadius:10,borderSkipped:false,maxBarThickness:28}
      ]
    },
    options:{...shared,scales:{y:{beginAtZero:true,border:{display:false},grid:{color:'rgba(98,125,152,.10)'},ticks:{font:{size:10},padding:8}},x:{border:{display:false},grid:{display:false},ticks:{font:{size:10}}}}}
  });

  new Chart(document.getElementById('caseTypeChart'),{
    type:'doughnut',
    data:{labels:['Road traffic','Assault','Domestic abuse','Postmortem','Other'],datasets:[{data:[28,22,14,26,10],backgroundColor:['rgba(21,153,139,.78)','rgba(19,50,77,.78)','rgba(217,119,6,.68)','rgba(91,140,184,.72)','rgba(159,179,200,.75)'],hoverOffset:7,borderWidth:4,borderColor:'rgba(255,255,255,.68)'}]},
    options:{...shared,cutout:'63%'}
  });

  new Chart(document.getElementById('reportStatusChart'),{
    type:'doughnut',
    data:{labels:['Completed','Pending','Draft','Overdue'],datasets:[{data:[64,18,11,7],backgroundColor:['rgba(21,153,139,.78)','rgba(217,119,6,.72)','rgba(98,125,152,.62)','rgba(180,35,24,.72)'],hoverOffset:6,borderWidth:4,borderColor:'rgba(255,255,255,.68)'}]},
    options:{...shared,cutout:'68%'}
  });

  new Chart(document.getElementById('turnaroundChart'),{
    type:'line',
    data:{
      labels:['Jan','Feb','Mar','Apr','May','Jun','Jul'],
      datasets:[
        {label:'MLR',data:[8.1,7.8,7.2,6.9,6.3,6.1,5.8],borderColor:teal,backgroundColor:'rgba(21,153,139,.10)',pointBackgroundColor:'#fff',pointBorderColor:teal,pointRadius:3,pointHoverRadius:5,borderWidth:2.2,fill:true,tension:.4},
        {label:'PMR',data:[12.2,11.7,11.1,10.5,9.9,9.4,8.9],borderColor:navy,backgroundColor:'rgba(19,50,77,.07)',pointBackgroundColor:'#fff',pointBorderColor:navy,pointRadius:3,pointHoverRadius:5,borderWidth:2.2,fill:true,tension:.4}
      ]
    },
    options:{...shared,scales:{y:{beginAtZero:true,border:{display:false},grid:{color:'rgba(98,125,152,.10)'},ticks:{font:{size:10},padding:8}},x:{border:{display:false},grid:{display:false},ticks:{font:{size:10}}}}}
  });

  document.getElementById('applyDashboardFilter').onclick=()=>{
    const from=document.getElementById('dashboardFrom');
    const to=document.getElementById('dashboardTo');
    if(!FormValidation.validateDateOrder(from,to)){to.reportValidity();return;}
    const factor=document.getElementById('dashboardDepartment').selectedIndex?0.64:1;
    document.getElementById('metricCases').textContent=Math.round(48*factor);
    document.getElementById('metricMlef').textContent=Math.round(12*factor);
    monthly.data.datasets.forEach(dataset=>dataset.data=dataset.data.map(value=>Math.max(2,Math.round(value*factor))));
    monthly.update();
    UI.toast('Dashboard updated.');
  };

  document.getElementById('refreshDashboard').onclick=()=>UI.toast('Dashboard synced with demo data.');
});
