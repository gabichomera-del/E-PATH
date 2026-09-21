import { NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth/current-user";
import { createAdminClient } from "@/lib/supabase/admin";

function temporaryPassword() {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$";
  const bytes = crypto.getRandomValues(new Uint8Array(14));
  return Array.from(bytes, (byte) => chars[byte % chars.length]).join("");
}

async function hashPassword(password: string) {
  const salt = crypto.randomUUID();
  const bytes = new TextEncoder().encode(`${salt}:${password}`);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return `${salt}:${Buffer.from(digest).toString("hex")}`;
}

export async function POST(_: Request, { params }: { params: Promise<{ studentId: string }> }) {
  const { studentId } = await params; const { supabase, authUser, profile } = await getCurrentUser();
  if (!supabase || !authUser || profile?.role !== "teacher") return NextResponse.json({ error: "Teacher access required." }, { status: 403 });
  const { data: teacher } = await supabase.from("teachers").select("id").eq("user_id", authUser.id).single();
  if (!teacher) return NextResponse.json({ error: "Teacher profile not found." }, { status: 404 });
  const { data: membership } = await supabase.from("class_members").select("id, classes!inner(teacher_id)").eq("student_id", studentId).eq("classes.teacher_id", teacher.id).limit(1).maybeSingle();
  if (!membership) return NextResponse.json({ error: "This student is not enrolled in one of your classes." }, { status: 403 });
  const admin = createAdminClient();
  if (!admin) return NextResponse.json({ error: "Password administration is not configured." }, { status: 503 });
  const { data: student } = await admin.from("students").select("user_id").eq("id", studentId).single();
  if (!student) return NextResponse.json({ error: "Student not found." }, { status: 404 });
  const password = temporaryPassword();
  const { error: updateError } = await admin.auth.admin.updateUserById(student.user_id, { password });
  if (updateError) return NextResponse.json({ error: updateError.message }, { status: 400 });
  await admin.from("password_reset_requests").insert({ student_id: studentId, teacher_id: teacher.id, temporary_password: await hashPassword(password), status: "completed" });
  return NextResponse.json({ temporaryPassword: password });
}
