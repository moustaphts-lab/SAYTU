// faux client Supabase piloté par globalThis.__w (monde simulé)
const W:any = () => (globalThis as any).__w;
export function createClient(_u:string,key:string,opts?:any){
  const isAdmin = key==="SERVICE";
  const log=(x:any)=>W().log.push(x);
  const q=(table:string)=>{ const f:any={}; let upd:any=null, ins:any=null, ups:any=null;
    const b:any={ select(){return b}, eq(k:string,v:any){f[k]=v;return b}, ilike(k:string,v:any){f[k]=v;return b},
      update(x:any){upd=x;return b}, insert(x:any){ins=x;return b}, upsert(x:any){ups=x;return b},
      maybeSingle(){return Promise.resolve({data:(W().rows[table]||[]).find((r:any)=>Object.entries(f).every(([k,v])=>r[k]===v))??null,error:null})},
      then(res:any){ if(upd){log(["upd",table,f,upd]);} if(ins){log(["ins",table,ins]);} if(ups){log(["ups",table,ups]);} res({data:null,error:((ins||ups||upd)&&W().tableErr&&W().tableErr[table])||null}) } };
    return b };
  return { from:q,
    rpc:(n:string,a:any)=>W().rpcErr&&W().rpcErr[n]?Promise.resolve({data:null,error:W().rpcErr[n]}):Promise.resolve({data:(W().rpc[n]!==undefined?(typeof W().rpc[n]==="function"?W().rpc[n](a):W().rpc[n]):null),error:null}),
    auth:{ getUser:()=>Promise.resolve({data:{user:{id:"ME"}}}),
      admin:{ getUserById:(id:string)=>Promise.resolve({data:{user:{id,last_sign_in_at:W().lastSign[id]??null}}}),
              updateUserById:(id:string,x:any)=>{log(["updateUser",id,x]);return Promise.resolve({error:W().updErr||null})},
              createUser:(x:any)=>{log(["createUser",x.email]);return W().createErr?Promise.resolve({data:null,error:W().createErr}):Promise.resolve({data:{user:{id:"NEW"}},error:null})} } } };
}
