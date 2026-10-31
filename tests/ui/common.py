"""Réglages communs des tests d'interface (Playwright + Chromium).
Les tests ouvrent index.html du dépôt avec un faux Supabase (aucune connexion réelle) et écrivent leurs captures dans tests/ui/out/."""
import os, glob
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
INDEX_URL = "file://" + os.path.join(ROOT, "index.html")
OUT = os.path.join(HERE, "out") + os.sep
LIB = os.path.join(HERE, "lib") + os.sep
os.makedirs(OUT, exist_ok=True)
def _chromium():
    if os.environ.get("CHROMIUM"): return os.environ["CHROMIUM"]
    for c in ("/opt/pw-browsers/chromium",):
        if os.path.exists(c): return c
    return None  # Playwright utilisera son Chromium installé
CHROMIUM = _chromium()
def launch(p, **kw):
    return p.chromium.launch(**({"executable_path": CHROMIUM} if CHROMIUM else {}), **kw)
