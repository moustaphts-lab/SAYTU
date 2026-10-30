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
  const admin = createClient(url, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return json({ error: "Requête invalide." }, 400); }
  const action = String(body.action ?? "");

  // 0. Administrateur de la plateforme : premier administrateur central d'un établissement
  if (action === "platform_create_admin") {
    const { data: isPlatform } = await caller.rpc("is_platform_admin");
    if (isPlatform !== true) return json({ error: "Réservé à l'administrateur de la plateforme." }, 403);
    const etabId = Number(body.establishment_id);
    const email = String(body.email ?? "").trim().toLowerCase();
    const fullName = String(body.full_name ?? "").trim();
    if (!etabId) return json({ error: "Établissement manquant." }, 400);
    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json({ error: "Adresse e-mail invalide." }, 400);
    if (!fullName) return json({ error: "Le nom est obligatoire." }, 400);
    const { data: prev } = await admin.from("profiles").select("id").ilike("email", email).maybeSingle();
    let userId: string, password: string | null = null;
    if (prev) {
      userId = prev.id;
      await admin.auth.admin.updateUserById(userId, { ban_duration: "none" });
    } else {
      password = tempPassword();
      const { data, error } = await admin.auth.admin.createUser({ email, password, email_confirm: true, user_metadata: { full_name: fullName } });
      if (error) return json({ error: error.message }, 400);
      userId = data.user.id;
      await admin.from("profiles").update({ establishment_id: etabId, must_change_password: true }).eq("id", userId);
    }
    const { error: eA } = await caller.rpc("platform_attach_admin", { p_etab: etabId, p_user: userId });
    if (eA) return json({ error: eA.message }, 400);
    return password ? json({ user_id: userId, email, temp_password: password }) : json({ user_id: userId, email, existing: true });
  }

  // 0 bis. Administrateur de la plateforme : nouveau mot de passe provisoire pour un administrateur central
  if (action === "platform_reset_admin") {
    const etabId = Number(body.establishment_id);
    const userId = String(body.user_id ?? "");
    const { data: ok } = await caller.rpc("platform_can_reset", { p_etab: etabId, p_user: userId });
    if (ok !== true) return json({ error: "Réservé à l'administrateur de la plateforme, pour un administrateur central." }, 403);
    const password = tempPassword();
    const { error } = await admin.auth.admin.updateUserById(userId, { password, ban_duration: "none" });
    if (error) return json({ error: error.message }, 400);
    await admin.from("profiles").update({ must_change_password: true }).eq("id", userId);
    await admin.from("memberships").update({ active: true }).eq("user_id", userId).eq("establishment_id", etabId);
    return json({ temp_password: password });
  }

  // 0 ter. Administrateur de la plateforme : suppression définitive d'un établissement vide (essai, erreur)
  if (action === "platform_remove_establishment") {
    const { data: users, error: eR } = await caller.rpc("platform_remove_establishment", {
      p_id: Number(body.establishment_id), p_code: String(body.code ?? ""),
    });
    if (eR) return json({ error: eR.message }, 400);
    // comptes qui n'existaient que pour cet établissement
    let failed = 0;
    for (const id of (users ?? []) as string[]) {
      const { error } = await admin.auth.admin.deleteUser(id);
      if (error) failed++;
    }
    return json({ ok: true, accounts: (users ?? []).length, failed });
  }

  const { data: isAdmin, error: roleErr } = await caller.rpc("has_role", { r: "admin" });
  if (roleErr || isAdmin !== true) return json({ error: "Réservé à l'administrateur." }, 403);
  const { data: me } = await caller.auth.getUser();
  const { data: central } = await caller.rpc("is_central_admin");
  // établissement de travail de l'administrateur qui appelle
  const { data: etab } = await caller.rpc("current_establishment");
  if (!etab) return json({ error: "Établissement introuvable." }, 403);

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
      // un compte par personne : si l'adresse sert déjà dans un autre établissement, on y ajoute seulement l'appartenance
      const { data: prev } = await admin.from("profiles").select("id").ilike("email", email).maybeSingle();
      if (prev) {
        const { data: mem } = await admin.from("memberships").select("user_id").eq("user_id", prev.id).eq("establishment_id", etab).maybeSingle();
        if (mem) return json({ error: "Un compte existe déjà avec cette adresse dans votre établissement." }, 400);
        const { error: eM } = await admin.from("memberships").insert({ user_id: prev.id, establishment_id: etab, faculty_id: facultyId });
        if (eM) return json({ error: eM.message }, 400);
        await admin.auth.admin.updateUserById(prev.id, { ban_duration: "none" });
        return json({ user_id: prev.id, email, existing: true });
      }
      const password = tempPassword();
      const { data, error } = await admin.auth.admin.createUser({
        email, password, email_confirm: true, user_metadata: { full_name: fullName },
      });
      if (error) {
        const msg = /already|exists|registered/i.test(error.message) ? "Un compte existe déjà avec cette adresse." : error.message;
        return json({ error: msg }, 400);
      }
      await admin.from("profiles").update({ establishment_id: etab }).eq("id", data.user.id);
      const { error: eM } = await admin.from("memberships").upsert({ user_id: data.user.id, establishment_id: etab, faculty_id: facultyId });
      if (eM) return json({ error: eM.message }, 400);
      return json({ user_id: data.user.id, email, temp_password: password });
    }

    if (action === "reset_password") {
      const userId = String(body.user_id ?? "");
      if (!userId) return json({ error: "Compte manquant." }, 400);
      if (!(await canManage(userId))) return json({ error: "Ce compte ne dépend pas de votre faculté." }, 403);
      const { data: shared } = await caller.rpc("is_shared_account", { u: userId });
      if (shared === true) return json({ error: "Ce compte sert aussi dans un autre établissement : la personne gère elle-même son mot de passe." }, 403);
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
      // l'accès est retiré dans cet établissement seulement ; le compte n'est bloqué que s'il n'a plus aucun établissement actif
      const { error: e2 } = await admin.from("memberships").update({ active }).eq("user_id", userId).eq("establishment_id", etab);
      if (e2) return json({ error: e2.message }, 400);
      const { data: still } = await admin.from("memberships").select("establishment_id").eq("user_id", userId).eq("active", true);
      const { error } = await admin.auth.admin.updateUserById(userId, { ban_duration: (still ?? []).length ? "none" : "876000h" });
      if (error) return json({ error: error.message }, 400);
      return json({ ok: true });
    }

    return json({ error: "Action inconnue." }, 400);
  } catch (e) {
    return json({ error: (e as Error).message }, 500);
  }
});
