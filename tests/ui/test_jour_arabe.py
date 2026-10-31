import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# En arabe, le jour abrégé (fdate) doit s'écrire « الخميس » (avec l'article), comme le jour complet.
src=open(os.path.join(HERE,"test_langue.py"),encoding="utf-8").read()
stub=src.split('stub=r"""')[1].split('"""')[0]
with sync_playwright() as p:
    br=launch(p);pg=br.new_context().new_page()
    pg.on("pageerror",lambda e:print("ERR",e))
    def h(r,req):
        u=req.url
        if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
        elif u.startswith("file:") or "cdnjs" in u: r.continue_()
        else: r.abort()
    pg.route("**/*",h);pg.add_init_script("localStorage.setItem('saytu_lang','ar');localStorage.setItem('saytu_lang_pick','1');window.__wd=[];const o=Date.prototype.toLocaleDateString;Date.prototype.toLocaleDateString=function(l,op){window.__wd.push(op&&op.weekday);return o.call(this,l,op)}")
    pg.goto(INDEX_URL);pg.wait_for_timeout(1500)
    print("langue:",pg.evaluate("LANG"),"lang key:",pg.evaluate("LANG_KEY"))
    r=pg.evaluate("()=>[fdate('2026-10-29'),fdate('2026-11-02'),fdate('2026-11-06'),new Date(2026,9,29).toLocaleDateString('fr-FR',{weekday:'short'})]")
    print(r)
    ok=r[0].startswith("الخميس") and r[1].startswith("الاثنين") and r[2].startswith("الجمعة") and r[3]=="الخميس"
    wd=pg.evaluate("window.__wd");print("options weekday transmises au navigateur :",sorted(set(map(str,wd))))
    ok=ok and "short" not in wd  # Safari écrit « خميس » pour short : on ne doit jamais le demander
    print("OK" if ok else "FAIL")
    br.close()
