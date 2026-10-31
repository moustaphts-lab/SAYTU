import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# Cas testés : la lecture de app_settings renvoie vide ou une erreur de droits (visiteur) ; dans les deux cas login_demo décide.
# Écran de connexion : visiteur non connecté, plusieurs établissements (app_settings illisible) -> comptes démo selon login_demo()
stub=r"""window.__log=[];window.supabase={createClient:()=>({auth:{getSession:async()=>({data:{session:null}}),onAuthStateChange:()=>({})},
 rpc:(n,a)=>{window.__log.push([n,a]);return Promise.resolve({data:(window.__rpc||{})[n]??(n==='publish_week'?3:null),error:null})},
 from:t=>{let f=[],one=false;const b={select(){return b},order(){return b},range(){return b},limit(){return b},neq(){return b},eq(k,v){f.push(r=>String(r[k])===String(v));return b},gte(k,v){f.push(r=>String(r[k])>=v);return b},lte(k,v){f.push(r=>String(r[k])<=v);return b},in(k,v){f.push(r=>v.includes(r[k]));return b},
  maybeSingle(){one=true;return b},single(){one=true;return b},insert(x){window.__log.push(['ins',t,x]);return b},update(x){window.__log.push(['upd',t,x]);return b},delete(){return b},
  then(res){let d=(window.__tb[t]||[]).filter(r=>f.every(fn=>fn(r)));res({data:one?(d[0]||null):d,error:null})}};return b}})};"""
res=[]
with sync_playwright() as p:
    br=launch(p)
    for val,err in ((True,False),(False,False),(True,True),(False,True)):
        pg=br.new_context(viewport={'width':1000,'height':800}).new_page()
        pg.on("pageerror",lambda e:print("ERR",e))
        def h(r,req):
            u=req.url
            if "supabase-js" in u: r.fulfill(body=stub.replace("window.__log=[];","window.__log=[];window.__rpc={login_demo:%s};window.__tb={};"%("true" if val else "false")).replace("res({data:one?(d[0]||null):d,error:null})","res(%s)"%("{data:null,error:{message:'permission denied'}}" if err else "{data:one?(d[0]||null):d,error:null}")),content_type="application/javascript")
            elif u.startswith("file:") or "cdnjs" in u: r.continue_()
            else: r.abort()
        pg.route("**/*",h);pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
        res.append(pg.locator("details.demo").count()==(1 if val else 0))
    br.close()
print(res)
