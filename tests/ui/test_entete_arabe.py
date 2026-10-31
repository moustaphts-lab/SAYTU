import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# Barre du haut : le profil et le bouton de langue sont au bord de la ligne de fin (à gauche en arabe, à droite en français), pas au milieu.
src=open(os.path.join(HERE,"test_langue.py"),encoding="utf-8").read()
stub=src.split('stub=r"""')[1].split('"""')[0]
shell=src.split('pg.evaluate("""')[1].split('""")')[0]
res={}
with sync_playwright() as p:
    br=launch(p)
    for lang in ("ar","fr"):
        pg=br.new_context(viewport={'width':1180,'height':820}).new_page()
        pg.on("pageerror",lambda e:print("ERR",e))
        def h(r,req):
            u=req.url
            if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
            elif u.startswith("file:") or "cdnjs" in u: r.continue_()
            else: r.abort()
        pg.route("**/*",h);pg.add_init_script("localStorage.setItem('saytu_lang','%s');localStorage.setItem('saytu_lang_pick','1')"%lang)
        pg.goto(INDEX_URL);pg.wait_for_timeout(1000)
        pg.evaluate("""%s"""%shell);pg.wait_for_timeout(700)
        pg.screenshot(path=OUT+"entete_%s.png"%lang)
        res[lang]=pg.evaluate("""()=>{const b=document.querySelector('header.top .bar').getBoundingClientRect(),e=document.querySelector('.hdrend').getBoundingClientRect();return {barL:b.left,barR:b.right,endL:e.left,endR:e.right}}""")
    br.close()
a,f=res["ar"],res["fr"]
print(res)
ok_ar=abs(a["endL"]-a["barL"])<40; ok_fr=abs(f["barR"]-f["endR"])<40
print("arabe : à gauche",ok_ar,"· français : à droite",ok_fr)
print("OK" if ok_ar and ok_fr else "FAIL")
