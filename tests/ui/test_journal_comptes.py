import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
# Audit F4 : le journal affiche en français les actions sur les comptes (créé, mot de passe réinitialisé, désactivé...).
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
    pg.route("**/*",h);pg.goto(INDEX_URL);pg.wait_for_timeout(1200)
    r=pg.evaluate("""()=>{const {say}=auditText([]);const m=(a,d)=>say({table_name:'comptes',action:a,new_data:d});
      return [m('COMPTE_CREE',{email:'a@b.co'}),m('MOT_DE_PASSE_REINITIALISE',{email:'a@b.co'}),m('COMPTE_DESACTIVE',{email:'a@b.co'}),m('ETABLISSEMENT_SUPPRIME',{code:'X'}),m('INCONNU',{})]}""")
    for x in r:print(" -",x)
    ok=r[0]=="a créé le compte a@b.co" and "réinitialisé le mot de passe de a@b.co" in r[1] and "désactivé" in r[2] and "X" in r[3] and r[4]=="INCONNU"
    print("OK" if ok else "FAIL")
    br.close()
