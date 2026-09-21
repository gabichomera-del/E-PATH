import type { SupabaseClient } from "@supabase/supabase-js";
import type { ClassRecord } from "@/lib/types/database";

export async function getTeacherClasses(supabase: SupabaseClient, userId: string): Promise<ClassRecord[]> {
  const { data: teacher } = await supabase.from("teachers").select("id").eq("user_id", userId).maybeSingle();
  if (!teacher) return [];
  const { data } = await supabase.from("classes").select("*, class_members(count)").eq("teacher_id", teacher.id).order("created_at", { ascending: false });
  return (data ?? []).map((item) => ({ ...item, student_count: item.class_members?.[0]?.count ?? 0 })) as ClassRecord[];
}

export async function getStudentEnrollment(supabase: SupabaseClient, userId: string) {
  const { data: student } = await supabase.from("students").select("id, grade, section").eq("user_id", userId).maybeSingle();
  if (!student) return null;
  const { data: membership } = await supabase.from("class_members").select("classes(id, name, grade, section, class_code)").eq("student_id", student.id).maybeSingle();
  return { student, classroom: membership?.classes ?? null };
}
