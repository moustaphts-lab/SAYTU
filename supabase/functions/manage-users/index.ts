import { createClient } from "npm:@supabase/supabase-js@2";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });

function tempPassword(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(12));
  return Array.from(bytes, (b) => chars[b % chars.length]).join("") + "!7";
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "Méthode non autorisée." }, 405);

  const url = Deno.env.get("SUPABASE_URL")!;
  const authHeader = req.headers.get("Authorization") ?? "";

  // 1. Qui appelle ? Un administrateur (central, ou d'une faculté).
  const caller = createClient(url, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: isAdmin, error: roleErr } = await caller.rpc("has_role", { r: "admin" });
  if (roleErr || isAdmin !== true) return json({ error: "Réservé à l'administrateur." }, 403);
  const { data: me } = await caller.auth.getUser();
  const { data: central } = await caller.rpc("is_central_admin");

  const admin = createClient(url, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return json({ error: "Requête invalide." }, 400); }
  const action = String(body.action ?? "");

  // 2. Un administrateur de faculté n'agit que sur les comptes de sa faculté.
  const canManage = async (userId: string) => {
    const { data } = await caller.rpc("can_manage_user", { u: userId });
    return data === true;
  };

  try {
    if (action === "create") {
      const email = String(body.email ?? "").trim().toLowerCase();
      const fullName = String(body.full_name ?? "").trim();
      const facultyId = body.faculty_id == null || body.faculty_id === "" ? null : Number(body.faculty_id);
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json({ error: "Adresse e-mail invalide." }, 400);
      if (!fullName) return json({ error: "Le nom est obligatoire." }, 400);
      if (central !== true) {
        if (facultyId == null) return json({ error: "Choisissez la faculté du compte." }, 400);
        const { data: ok } = await caller.rpc("admin_for", { fac: facultyId });
        if (ok !== true) return json({ error: "Vous ne pouvez créer des comptes que dans votre faculté." }, 403);
      }
      const password = tempPassword();
      const { data, error } = await admin.auth.admin.createUser({
        email, password, email_confirm: true, user_metadata: { full_name: fullName },
      });
      if (error) {
        const msg = /already|exists|registered/i.test(error.message) ? "Un compte existe déjà avec cette adresse." : error.message;
        return json({ error: msg }, 400);
      }
      if (facultyId != null) await admin.from("profiles").update({ faculty_id: facultyId }).eq("id", data.user.id);
      return json({ user_id: data.user.id, email, temp_password: password });
    }

    if (action === "reset_password") {
      const userId = String(body.user_id ?? "");
      if (!userId) return json({ error: "Compte manquant." }, 400);
      if (!(await canManage(userId))) return json({ error: "Ce compte ne dépend pas de votre faculté." }, 403);
      const password = tempPassword();
      const { error } = await admin.auth.admin.updateUserById(userId, { password });
      if (error) return json({ error: error.message }, 400);
      return json({ temp_password: password });
    }

    if (action === "set_active") {
      const userId = String(body.user_id ?? "");
      const active = body.active === true;
      if (!userId) return json({ error: "Compte manquant." }, 400);
      if (!(await canManage(userId))) return json({ error: "Ce compte ne dépend pas de votre faculté." }, 403);
      if (userId === me.user?.id && !active) return json({ error: "Vous ne pouvez pas désactiver votre propre compte." }, 400);
      const { error } = await admin.auth.admin.updateUserById(userId, { ban_duration: active ? "none" : "876000h" });
      if (error) return json({ error: error.message }, 400);
      const { error: e2 } = await admin.from("profiles").update({ active }).eq("id", userId);
      if (e2) return json({ error: e2.message }, 400);
      return json({ ok: true });
    }

    return json({ error: "Action inconnue." }, 400);
  } catch (e) {
    return json({ error: (e as Error).message }, 500);
  }
});
