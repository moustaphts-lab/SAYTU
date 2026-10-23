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

  // Seul un administrateur est autorisé.
  const caller = createClient(url, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: isAdmin, error: roleErr } = await caller.rpc("has_role", { r: "admin" });
  if (roleErr || isAdmin !== true) return json({ error: "Réservé à l'administrateur." }, 403);
  const { data: me } = await caller.auth.getUser();

  const admin = createClient(url, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return json({ error: "Requête invalide." }, 400); }
  const action = String(body.action ?? "");

  try {
    if (action === "create") {
      const email = String(body.email ?? "").trim().toLowerCase();
      const fullName = String(body.full_name ?? "").trim();
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json({ error: "Adresse e-mail invalide." }, 400);
      if (!fullName) return json({ error: "Le nom est obligatoire." }, 400);
      const password = tempPassword();
      const { data, error } = await admin.auth.admin.createUser({
        email, password, email_confirm: true, user_metadata: { full_name: fullName },
      });
      if (error) {
        const msg = /already|exists|registered/i.test(error.message) ? "Un compte existe déjà avec cette adresse." : error.message;
        return json({ error: msg }, 400);
      }
      return json({ user_id: data.user.id, email, temp_password: password });
    }

    if (action === "reset_password") {
      const userId = String(body.user_id ?? "");
      if (!userId) return json({ error: "Compte manquant." }, 400);
      const password = tempPassword();
      const { error } = await admin.auth.admin.updateUserById(userId, { password });
      if (error) return json({ error: error.message }, 400);
      return json({ temp_password: password });
    }

    if (action === "set_active") {
      const userId = String(body.user_id ?? "");
      const active = body.active === true;
      if (!userId) return json({ error: "Compte manquant." }, 400);
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
