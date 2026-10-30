/* Saytu — PDF en arabe.
   Quand l'interface est en arabe, chaque document PDF est produit en arabe :
   - police arabe intégrée (Noto Kufi Arabic, choisie pour les documents, réduite au latin et à l'arabe, licence OFL), chargée seulement à ce moment-là ;
   - textes traduits avec le même dictionnaire que l'écran ;
   - mise en page en miroir (la page se lit de droite à gauche, tableaux compris) ;
   - lettres arabes liées (formes contextuelles) et ordre d'affichage calculé ici, nombres et mots latins gardés de gauche à droite. */
(function(){
const FONT_FILES={normal:"fonts/SaytuArabic.ttf",bold:"fonts/SaytuArabic-Bold.ttf"};
let fontData=null;
const b64=buf=>{let s="";const a=new Uint8Array(buf);for(let i=0;i<a.length;i+=0x8000)s+=String.fromCharCode.apply(null,a.subarray(i,i+0x8000));return btoa(s)};
async function loadFonts(){if(fontData)return fontData;
  const [n,b]=await Promise.all([FONT_FILES.normal,FONT_FILES.bold].map(u=>fetch(u).then(r=>{if(!r.ok)throw new Error("Police arabe introuvable.");return r.arrayBuffer()})));
  return fontData={normal:b64(n),bold:b64(b)}}

const AR=/[؀-ۿﭐ-﷿ﹰ-﻿]/;
const MIRROR={"(":")",")":"(","[":"]","]":"[","{":"}","}":"{","«":"»","»":"«","<":">",">":"<","‹":"›","›":"‹"};
/* ordre visuel d'une ligne dont le sens de base est de droite à gauche */
function visual(s){
  const re=/(\d{1,3}(?:[   ]\d{3})+(?!\d)|\d+(?:[:\/.,\-–]\d+)*%?)|([A-Za-zÀ-ɏ@][A-Za-z0-9À-ɏ_'’@.\-]*)|([؀-ۿﭐ-﷿ﹰ-﻿]+)|([\s\S])/g;
  const T=[];let m;while((m=re.exec(s))){T.push({t:m[0],k:m[1]||m[2]?"L":m[3]?"R":"N"})}
  const strong=(i,step)=>{for(let j=i+step;j>=0&&j<T.length;j+=step)if(T[j].k!=="N")return T[j].k;return "R"};
  T.forEach((x,i)=>{if(x.k==="N")x.d=strong(i,-1)==="L"&&strong(i,1)==="L"?"L":"R";else x.d=x.k});
  const runs=[];T.forEach(x=>{const r=runs[runs.length-1];if(r&&r.d===x.d)r.items.push(x);else runs.push({d:x.d,items:[x]})});
  return runs.reverse().map(r=>r.d==="L"?r.items.map(x=>x.t).join(""):r.items.slice().reverse().map(x=>x.k==="R"?[...x.t].reverse().join(""):(MIRROR[x.t]||x.t)).join("")).join("")}

const clean=s=>String(s).replace(/[⁦-⁩‎‏]/g,"").replace(/⁠/g,"").replace(/\u202f/g,"\u00a0").replace(/\u2248/g,"~").replace(/\u2713\s?/g,"").replace(/(\d)\s*–\s*(\d)/g,"$1-$2");
function arLine(doc,s){
  s=clean(typeof tr==="function"?tr(String(s)):String(s));
  s=s.replace(/\b(\d+) h (\d{2})\b/g,"$1 س $2 د").replace(/\b(\d+) h\b/g,"$1 س");
  if(!AR.test(s))return s;
  const shaped=doc.processArabic?doc.processArabic(s):s;
  return visual(shaped)}

/* rend un document jsPDF « arabe » : police, traduction, miroir */
function arabize(doc){
  if(doc.__ar)return doc;doc.__ar=true;
  doc.addFileToVFS("SaytuArabic.ttf",fontData.normal);doc.addFont("SaytuArabic.ttf","SaytuAR","normal");
  doc.addFileToVFS("SaytuArabic-Bold.ttf",fontData.bold);doc.addFont("SaytuArabic-Bold.ttf","SaytuAR","bold");
  const W=()=>doc.internal.pageSize.getWidth();
  const o={text:doc.text,setFont:doc.setFont,rect:doc.rect,roundedRect:doc.roundedRect,line:doc.line,addImage:doc.addImage,circle:doc.circle,ellipse:doc.ellipse,getTextWidth:doc.getTextWidth,splitTextToSize:doc.splitTextToSize};
  doc.setFont=function(f,st){return o.setFont.call(doc,"SaytuAR",/bold/i.test(st||"")?"bold":"normal")};
  doc.setFont("SaytuAR","normal");
  doc.splitTextToSize=function(t,w,opt){const tt=Array.isArray(t)?t.map(x=>clean(typeof tr==="function"?tr(String(x)):String(x))):clean(typeof tr==="function"?tr(String(t)):String(t));return o.splitTextToSize.call(doc,tt,w,opt)};
  doc.text=function(t,x,y,opt,trans){
    opt=Object.assign({},opt||{});
    const conv=v=>Array.isArray(v)?v.map(conv):arLine(doc,v);
    let lines=conv(t);
    if(opt.maxWidth&&!Array.isArray(lines)){const raw=clean(typeof tr==="function"?tr(String(t)):String(t));lines=o.splitTextToSize.call(doc,raw,opt.maxWidth).map(l=>arLine(doc,l));delete opt.maxWidth}
    const a=opt.align||"left";opt.align=a==="left"?"right":a==="right"?"left":a;
    opt.isInputVisual=true;opt.isOutputVisual=true;opt.isInputRtl=false;opt.isOutputRtl=false;
    return o.text.call(doc,lines,W()-x,y,opt,trans)};
  doc.rect=function(x,y,w,h,st){return o.rect.call(doc,W()-x-w,y,w,h,st)};
  if(o.roundedRect)doc.roundedRect=function(x,y,w,h,rx,ry,st){return o.roundedRect.call(doc,W()-x-w,y,w,h,rx,ry,st)};
  doc.line=function(x1,y1,x2,y2,st){return o.line.call(doc,W()-x1,y1,W()-x2,y2,st)};
  doc.circle=function(x,y,r,st){return o.circle.call(doc,W()-x,y,r,st)};
  if(o.ellipse)doc.ellipse=function(x,y,rx,ry,st){return o.ellipse.call(doc,W()-x,y,rx,ry,st)};
  doc.addImage=function(img,fmt,x,y,w,h,...r){return o.addImage.call(doc,img,fmt,W()-x-w,y,w,h,...r)};
  /* tableaux : textes traduits avant la mesure des colonnes, police arabe */
  const at=doc.autoTable;
  if(at)doc.autoTable=function(opts){opts=Object.assign({},opts);
    const fix=s=>Object.assign({},s||{},{font:"SaytuAR"});
    opts.styles=fix(opts.styles);opts.headStyles=Object.assign({},opts.headStyles||{},{font:"SaytuAR"});
    const prev=opts.didParseCell;
    opts.didParseCell=function(d){d.cell.text=(d.cell.text||[]).map(x=>clean(typeof tr==="function"?tr(String(x)):String(x)));if(prev)prev(d)};
    return at.call(doc,opts)};
  return doc}

/* en arabe, chaque « new jsPDF(...) » de l'application rend un document déjà arabisé */
function hook(){const J=window.jspdf;if(!J||J.__arHook)return;J.__arHook=true;const Orig=J.jsPDF;
  const Wrapped=function(...a){const d=new Orig(...a);return (typeof LANG!=="undefined"&&LANG==="ar")?(fontData?arabize(d):(()=>{throw new Error("جارٍ تحميل الخط العربي، أعد المحاولة بعد لحظة.")})()):d};
  Wrapped.API=Orig.API;Wrapped.version=Orig.version;Object.setPrototypeOf(Wrapped,Orig);J.jsPDF=Wrapped}
window.SAYTU_PDF={hook,loadFonts,arabize,visual,
  /* à appeler juste après « new jsPDF(...) » : ne fait rien en français */
  prep:doc=>(typeof LANG!=="undefined"&&LANG==="ar"&&fontData)?arabize(doc):doc,
  ready:()=>(typeof LANG!=="undefined"&&LANG==="ar")?loadFonts():Promise.resolve()};
})();
