import os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
from playwright.sync_api import sync_playwright
W=OUT
src=open(HERE+"/test_langue.py").read();stub=src[src.index('stub=r"""')+9:src.index('"""',src.index('stub=r"""')+9)]
with sync_playwright() as p:
  br=launch(p);pg=br.new_page()
  pg.on("pageerror",lambda e:print("ERR",e))
  def h(r,req):
    u=req.url
    if "supabase-js" in u: r.fulfill(body=stub,content_type="application/javascript")
    elif "jspdf.umd" in u: r.fulfill(path=LIB+"jspdf.umd.min.js",content_type="application/javascript")
    elif "autotable" in u: r.fulfill(path=LIB+"jspdf.plugin.autotable.min.js",content_type="application/javascript")
    elif u.startswith("file:") or "cdnjs" in u: r.continue_()
    else: r.abort()
  pg.route("**/*",h);pg.goto(INDEX_URL);pg.wait_for_timeout(1500)
  print(pg.evaluate("""()=>{setVocab('institut');const d=new jspdf.jsPDF();d.text('Visa du doyen · la faculté',10,10);d.text(['Nouvelle faculté'],10,20);
    if(d.autoTable)d.autoTable({head:[['Faculté','Nom']],body:[['A','B']]});const o=d.output();return [/institut/.test(o),/Directeur|directeur/.test(o),/facult/i.test(o),!!d.autoTable]}"""))
  br.close()
