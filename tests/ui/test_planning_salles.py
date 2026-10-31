import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
import sys
from playwright.sync_api import sync_playwright
W=OUT
src=open(HERE+"/test_langue.py").read();stub=src[src.index('stub=r"""')+9:src.index('"""',src.index('stub=r"""')+9)].replace('neq(){return b},','neq(){return b},is(k,v){f.push(r=>r[k]==v);return b},')
lang=sys.argv[1] if len(sys.argv)>1 else 'fr'
with sync_playwright() as p:
  br=launch(p);ctx=br.new_context(viewport={'width':1280,'height':1000});pg=ctx.new_page()
  pg.on("pageerror",lambda e:print("ERR",e))
  def h(r,req):
    u=req.url
    if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
    elif u.startswith("file:") or "cdnjs" in u: r.continue_()
    else: r.abort()
  pg.route("**/*",h)
  if lang=='ar': pg.add_init_script("localStorage.setItem('saytu_lang','ar')")
  pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
  pg.evaluate("""()=>{window.__tb={app_settings:[{establishment_id:1,name:'Université Test',subtitle:'Enseignements',unit_word:'faculte',shared_rooms:true,enabled_rights:[]}],
    faculties:[{id:1,code:'F1',name:'Faculté Une',timetable_mode:'hebdomadaire'},{id:2,code:'F2',name:'Faculté Deux',timetable_mode:'hebdomadaire'}],
    rooms:[{id:1,code:'AMPHI-A',name:'Grand amphi',capacity:400,room_type:'amphi',faculty_id:null},{id:2,code:'S1',name:'Salle 1',capacity:30,room_type:'standard',faculty_id:1},{id:3,code:'S9',name:'Salle autre',capacity:30,room_type:'standard',faculty_id:2}],
    timetable_slots:[],schedule_sessions:[],slot_conflicts:[],student_groups:[],teachers:[],teaching_assignments:[],semesters:[],teacher_availability:[],availability_weeks:[],published_weeks:[],
    departments:[],programs:[],academic_years:[],teacher_statuses:[],courses:[],postes:[]};
    window.__rpc={shared_room_busy:[{room_id:1,day_of_week:2,start_time:'08:00:00',end_time:'12:00:00'}]};
    S.sched={...SCHED_DEFAULT};S.roles=[{role:'planificateur',faculty_id:1}];S.user={id:'u',email:'p@x',user_metadata:{full_name:'Planif'}};S.year='2026-2027';S.annonces=[];
    return loadSettings().then(()=>loadFacs()).then(()=>{S.fac=1;S.tab='planning';S.ttTab='salles';return renderShell()})}""")
  pg.wait_for_timeout(1500)
  pg.screenshot(path=W+f"plan_salles_{lang}.png")
  pg.evaluate("()=>{S.tab='referentiel';S.refSec='salles';return renderShell()}");pg.wait_for_timeout(1500)
  pg.evaluate("()=>{const b=[...document.querySelectorAll('button')].find(x=>/^Salles|^القاعات/.test(x.textContent.trim()));if(b)b.click()}");pg.wait_for_timeout(1000)
  pg.screenshot(path=W+f"ref_salles_{lang}.png",full_page=True)
  br.close()
