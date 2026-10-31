import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
SP=OUT
src=open(HERE+"/test_langue.py").read();stub=src[src.index('stub=r"""')+9:src.index('"""',src.index('stub=r"""')+9)]
L="""[{id:1,code:'UCAB',name:'Université Cheikh Ahmadou Bamba',active:true,created_at:'2026-10-30',comptes:36,facultes:3,administrateurs:1,derniere_connexion:'2026-10-30'},
  {id:2,code:'UCMB',name:'Université Cheikh Mokhtar Ba de Nouakchott',active:false,created_at:'2026-10-30',comptes:1,facultes:0,administrateurs:1,derniere_connexion:'2026-10-30'}]"""
with sync_playwright() as p:
  br=launch(p)
  for name,w,h,lang in [('ipad',1366,1024,'fr'),('phone',390,844,'fr'),('ipad_ar',1366,1024,'ar')]:
    ctx=br.new_context(viewport={'width':w,'height':h});pg=ctx.new_page();pg.on("pageerror",lambda e:print("ERR",e))
    def hd(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif u.startswith("file:") or "cdnjs" in u: r.continue_()
        else: r.abort()
    pg.route("**/*",hd)
    if lang=='ar': pg.add_init_script("localStorage.setItem('saytu_lang','ar')")
    pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
    pg.evaluate("()=>{window.__tb={};window.__rpc={platform_establishments:"+L+",platform_establishment_admins:[{user_id:'u',full_name:'Admin UCMB',email:'admin@ucmb.sn',last_sign_in_at:'2026-10-30'}]};S.user={id:'u',email:'saytul@test.com',user_metadata:{full_name:'Admin Saytu'}};S.roles=[];S.platform=true;S.etab=null;S.etabs=[];S.facs=[];S.tab='plateforme';return renderShell()}")
    pg.wait_for_timeout(800)
    print(name,pg.evaluate("()=>{const t=document.querySelector('.tbl');return t?[t.scrollWidth,t.clientWidth]:null}"))
    pg.screenshot(path=SP+f"pf_{name}.png")
    if name in('ipad','ipad_ar'):
      pg.click("[data-pfg='2']");pg.wait_for_timeout(500);pg.screenshot(path=SP+f"pf_{name}_dlg.png");pg.click("#pfDel");pg.wait_for_timeout(400);pg.screenshot(path=SP+f"pf_{name}_del.png")
    ctx.close()
