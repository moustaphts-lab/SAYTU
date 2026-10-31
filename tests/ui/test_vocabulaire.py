import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
import sys
from playwright.sync_api import sync_playwright
W=OUT
src=open(HERE+"/test_langue.py").read();stub=src[src.index('stub=r"""')+9:src.index('"""',src.index('stub=r"""')+9)]
def run(voc,lang,shot):
  with sync_playwright() as p:
    br=launch(p);ctx=br.new_context(viewport={'width':1280,'height':1800});pg=ctx.new_page()
    pg.on("pageerror",lambda e:print("ERR",e))
    def h(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif u.startswith("file:") or "cdnjs" in u: r.continue_()
        else: r.abort()
    pg.route("**/*",h)
    if lang=='ar': pg.add_init_script("localStorage.setItem('saytu_lang','ar')")
    pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
    pg.evaluate("""(voc)=>{window.__tb={app_settings:[{establishment_id:2,name:'Institut Test',subtitle:'Enseignements',pdf_header:'',pdf_footer:'',logo:null,payroll_visa:true,show_demo:false,enabled_rights:['chef_departement'],unit_word:voc}],
      academic_years:[{id:1,label:'2026-2027',is_current:true,start_date:'2026-10-01',end_date:'2027-07-31'}],semesters:[{id:1,academic_year_id:1,label:'S1',faculty_id:1}],
      faculties:[{id:1,code:'IA',name:'Institut A',timetable_mode:'hebdomadaire',payroll_visa:true},{id:2,code:'IB',name:'Institut B',timetable_mode:'fixe',payroll_visa:false}],
      postes:[{id:1,name:'Professeur',roles:['professeur'],scope:'faculte',sort:1},{id:2,name:'Doyen',roles:['direction'],scope:'faculte',sort:2},{id:3,name:'Administrateur de faculté',roles:['admin'],scope:'faculte',sort:3},{id:4,name:'Administrateur central',roles:['admin'],scope:'universite',sort:4}],
      accounts:[],departments:[]};
      S.roles=[{role:'admin',faculty_id:null}];S.user={id:'u',email:'a@x',user_metadata:{full_name:'Admin'}};S.year='2026-2027';S.annonces=[];S.myPoste=4;
      return loadSettings().then(()=>loadFacs()).then(()=>loadPostes()).then(()=>{S.fac=null;S.tab='etab';return renderShell()})}""",voc)
    pg.wait_for_timeout(1200)
    txt=pg.evaluate("document.body.innerText")
    import re
    left=sorted(set(re.findall(r"[^\n]{0,30}(?:[Ff]acult|[Dd]oyen|كلي|العميد)[^\n]{0,30}",txt)))
    print(voc,lang,"restes:",left)
    pg.screenshot(path=W+shot,full_page=False)
    br.close()
for voc,lang in [(a,b) for a in sys.argv[1].split(",") for b in sys.argv[2].split(",")]:
    run(voc,lang,f"voc_{voc}_{lang}.png")
