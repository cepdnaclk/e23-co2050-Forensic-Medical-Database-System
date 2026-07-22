window.apiRequest=async function(endpoint,options={}){
  const c=window.APP_CONFIG||{},controller=new AbortController(),timer=setTimeout(()=>controller.abort(),c.REQUEST_TIMEOUT_MS||4500);
  const request={headers:{'Content-Type':'application/json',...(options.headers||{})},...options,signal:controller.signal};
  if(request.body&&typeof request.body!=='string')request.body=JSON.stringify(request.body);
  try{
    const response=await fetch(`${c.API_BASE_URL||''}${endpoint}`,request);clearTimeout(timer);
    if(!response.ok)throw new Error(`API request failed (${response.status})`);
    return (response.headers.get('content-type')||'').includes('application/json')?response.json():response.text();
  }catch(error){
    clearTimeout(timer);
    if(c.USE_MOCK_FALLBACK&&window.MockDB){console.info(`[Mock fallback] ${endpoint}`);return MockDB.handle(endpoint,request);}
    throw error;
  }
};
