import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
SP=OUT
stub=r"""window.__log=[];window.supabase={createClient:()=>({auth:{getSession:async()=>({data:{session:null}}),onAuthStateChange:()=>({})},
 rpc:(n,a)=>{window.__log.push([n,a]);return Promise.resolve({data:(window.__rpc||{})[n]??(n==='publish_week'?3:null),error:null})},
 from:t=>{let f=[],one=false;const b={select(){return b},order(){return b},range(){return b},limit(){return b},neq(){return b},eq(k,v){f.push(r=>String(r[k])===String(v));return b},gte(k,v){f.push(r=>String(r[k])>=v);return b},lte(k,v){f.push(r=>String(r[k])<=v);return b},in(k,v){f.push(r=>v.includes(r[k]));return b},
  maybeSingle(){one=true;return b},single(){one=true;return b},insert(x){window.__log.push(['ins',t,x]);return b},update(x){window.__log.push(['upd',t,x]);return b},delete(){return b},
  then(res){let d=(window.__tb[t]||[]).filter(r=>f.every(fn=>fn(r)));res({data:one?(d[0]||null):d,error:null})}};return b}})};"""

with sync_playwright() as p:
    br=launch(p);ctx=br.new_context(viewport={'width':1200,'height':900});pg=ctx.new_page()
    pg.on("pageerror",lambda e:print("ERR",e))
    def h(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif u.startswith("file:") or "cdnjs" in u: r.continue_()
        else: r.abort()
    pg.route("**/*",h);pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
    pg.evaluate("""()=>{window.__tb={schedule_sessions:[],absence_requests:[],availability_weeks:[],published_weeks:[],attendance_records:[],teacher_availability:[],
        faculties:[{id:1,code:'F',name:'Faculté X',short_name:'X'}],postes:[{id:1,name:'Professeur',roles:['professeur'],scope:'faculte',sort:1}]};
      S.sched={...SCHED_DEFAULT};S.roles=[{role:'professeur',faculty_id:1}];S.teacher={id:1,first_name:'Samba',last_name:'Ba'};S.user={id:'u',email:'p@x',user_metadata:{full_name:'Samba Ba'}};S.annonces=[];S.myPoste=1;S.postes=window.__tb.postes;S.year='2026-2027';
      return loadFacs().then(()=>{S.fac=1;S.tab='accueil';return renderShell()})}""")
    pg.wait_for_timeout(600)
    pg.click("details.menu summary");pg.wait_for_timeout(200)
    pg.screenshot(path=SP+"lg_menu.png")
    pg.click("#langBtn");pg.wait_for_timeout(300);pg.screenshot(path=SP+"lg_dlg.png")
    pg.click(".lgopt.cur");pg.wait_for_timeout(300);print("same lang closes:",pg.evaluate("document.getElementById('dlg').open"),pg.evaluate("localStorage.getItem('saytu_lang')"))
    pg.click("details.menu summary");pg.wait_for_timeout(200);pg.click("#langBtn");pg.wait_for_timeout(300)
    with pg.expect_navigation(): pg.click(".lgopt[value=ar]")
    pg.wait_for_timeout(800)
    print("LS:",pg.evaluate("localStorage.getItem('saytu_lang')"),"dir:",pg.evaluate("document.documentElement.dir"))
    # écran de connexion : choix arabe puis repasse en français
    pg.screenshot(path=SP+"lg_login_ar.png")
    pg.click(".authlang [data-langpick]");pg.wait_for_timeout(300);pg.screenshot(path=SP+"lg_dlg_ar.png")
    with pg.expect_navigation(): pg.click(".lgopt[value=fr]")
    pg.wait_for_timeout(800)
    print("after login-pick:",pg.evaluate("[localStorage.getItem('saytu_lang'),localStorage.getItem('saytu_lang_pick')]"))
    br.close()
