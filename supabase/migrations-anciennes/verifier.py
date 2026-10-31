"""Compare chaque fichier .sql de ce dossier à l'empreinte (md5) enregistrée dans MANIFEST.tsv.
Usage : python3 verifier.py   (affiche les fichiers absents ou différents)"""
import hashlib, os
here = os.path.dirname(os.path.abspath(__file__))
ok = bad = missing = 0
for line in open(os.path.join(here, "MANIFEST.tsv"), encoding="utf-8"):
    v, name, ln, md = line.rstrip("\n").split("\t")
    p = os.path.join(here, f"{v}_{name}.sql")
    if not os.path.exists(p): missing += 1; continue
    t = open(p, encoding="utf-8").read()
    cands = [t] + ([t[:-1]] if t.endswith("\n") else [])  # le texte d'origine finit avec ou sans retour à la ligne
    if any(hashlib.md5(c.encode("utf-8")).hexdigest() == md for c in cands): ok += 1
    else: bad += 1; print("DIFFÉRENT:", v, name, "longueur", len(t), "attendu", ln)
print(f"conformes {ok}, différents {bad}, absents {missing}")
