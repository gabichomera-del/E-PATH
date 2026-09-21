import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import type { AppRole, AppUser } from "@/lib/types/database";

export async function getCurrentUser() {
  const supabase = await createClient();
  if (!supabase) return { supabase: null, authUser: null, profile: null };
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return { supabase, authUser: null, profile: null };
  const { data: profile } = await supabase.from("users").select("id, first_name, last_name, email, role, created_at").eq("id", user.id).maybeSingle();
  return { supabase, authUser: user, profile: profile as AppUser | null };
}

export async function requireRole(role: AppRole) {
  const context = await getCurrentUser();
  if (!context.authUser) redirect(`/login?role=${role}`);
  if (!context.profile || context.profile.role !== role) redirect(context.profile?.role === "teacher" ? "/teacher/dashboard" : "/student/dashboard");
  return { ...context, authUser: context.authUser, profile: context.profile };
}
