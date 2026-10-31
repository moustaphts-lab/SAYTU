import os,sys,re,hashlib,base64
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from common import *
# Les 4 bibliothèques externes de index.html portent une signature (SRI) ; celles dont on a une copie locale (tests/ui/lib) doivent correspondre.
s=open(os.path.join(ROOT,"index.html"),encoding="utf-8").read()
tags=re.findall(r'<script src="(https://[^"]+)"([^>]*)>',s)
sri=lambda f:"sha384-"+base64.b64encode(hashlib.sha384(open(f,"rb").read()).digest()).decode()
ok=len(tags)==4
for u,a in tags:
    m=re.search(r'integrity="(sha384-[A-Za-z0-9+/]{64})"',a);c='crossorigin="anonymous"' in a
    loc=os.path.join(LIB,os.path.basename(u))
    eg=(sri(loc)==m.group(1)) if (m and os.path.exists(loc)) else None
    print(os.path.basename(u),"signature" if m else "SANS SIGNATURE","crossorigin" if c else "SANS crossorigin","copie locale identique" if eg else ("copie locale DIFFERENTE" if eg is False else ""))
    ok=ok and bool(m) and c and eg is not False
print("OK" if ok else "FAIL")
