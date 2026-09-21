"use server";

import { createClient } from "@/lib/supabase/server";
import type { UserRole } from "@/lib/types";

type LoginResult =
  | { ok: true }
  | { ok: false; error: string };

export async function signIn(email: string, password: string, expectedRole: UserRole): Promise<LoginResult> {
  const supabase = await createClient();
  if (!supabase) {
    return { ok: false, error: "Supabase is not configured yet." };
  }

  const { data, error: authError } = await supabase.auth.signInWithPassword({ email, password });
  if (authError) {
    return { ok: false, error: `Unable to sign in: ${authError.message}` };
  }
  if (!data.user) {
    return { ok: false, error: "Authentication succeeded without returning a user. Please try again." };
  }

  const { data: profile, error: profileError } = await supabase
    .from("users")
    .select("role")
    .eq("id", data.user.id)
    .maybeSingle();

  if (profileError) {
    return { ok: false, error: `Unable to load your account profile: ${profileError.message}` };
  }
  if (!profile) {
    await supabase.auth.signOut();
    return { ok: false, error: "Your account profile could not be found. Please contact your administrator." };
  }
  if (profile.role !== expectedRole) {
    await supabase.auth.signOut();
    return { ok: false, error: `This account is not registered as a ${expectedRole}.` };
  }

  return { ok: true };
}
