import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# Audit F1 : un texte piégé (balise <img onerror>) passé à la fenêtre « Prévenir les professeurs »
# (introduction, titre, nom, téléphone, message) ne doit jamais devenir du code.
src=open(os.path.join(HERE,"test_langue.py"),encoding="utf-8").read()
stub=src.split('stub=r"""')[1].split('"""')[0]
PIEGE='<img src=x onerror="window.__pwn=1"><script>window.__pwn=1</script>'
with sync_playwright() as p:
    br=launch(p);pg=br.new_context().new_page()
    pg.on("pageerror",lambda e:print("ERR",e))
    def h(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif u.startswith("file:") or "cdnjs" in u: r.continue_()
        else: r.abort()
    pg.route("**/*",h);pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
    pg.evaluate("""p=>{notifyDialog({title:p,intro:p,common:p,items:[{t:{id:1,first_name:p,last_name:p,phone:p},msg:p},{t:{id:2,first_name:'Aïcha',last_name:'Ndiaye',phone:''},msg:p}]})}""",PIEGE)
    pg.wait_for_timeout(600)
    res=pg.evaluate("""()=>{const d=document.querySelector('dialog[open]')||document.body;
      return {pwn:window.__pwn||0, img:d.querySelectorAll('img[onerror]').length, script:d.querySelectorAll('script').length, texte:d.textContent.includes('<img src=x')}}""")
    print(res)
    ok=res["pwn"]==0 and res["img"]==0 and res["script"]==0 and res["texte"]
    print("OK" if ok else "FAIL")
    br.close()
