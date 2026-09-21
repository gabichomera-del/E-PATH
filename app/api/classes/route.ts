import { NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth/current-user";

function createClassCode() {
  const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  const bytes = crypto.getRandomValues(new Uint8Array(5));
  return `EPATH-${Array.from(bytes, (byte) => alphabet[byte % alphabet.length]).join("")}`;
}

export async function POST(request: Request) {
  const { supabase, authUser, profile } = await getCurrentUser();
  if (!supabase || !authUser || profile?.role !== "teacher") return NextResponse.json({ error: "Teacher access required." }, { status: 403 });
  const body = await request.json();
  const name = String(body.name ?? "").trim(); const grade = String(body.grade ?? "").trim(); const section = String(body.section ?? "").trim().toUpperCase(); const academicYear = Number(body.academicYear);
  if (!name || !grade || !section || !Number.isInteger(academicYear)) return NextResponse.json({ error: "Complete every class field." }, { status: 400 });
  const { data: teacher } = await supabase.from("teachers").select("id").eq("user_id", authUser.id).single();
  if (!teacher) return NextResponse.json({ error: "Teacher profile not found." }, { status: 404 });
  for (let attempt = 0; attempt < 5; attempt++) {
    const classCode = createClassCode();
    const { data, error } = await supabase.from("classes").insert({ teacher_id: teacher.id, name, grade, section, academic_year: academicYear, class_code: classCode }).select().single();
    if (!error) return NextResponse.json({ classroom: data }, { status: 201 });
    if (error.code !== "23505") return NextResponse.json({ error: error.message }, { status: 400 });
  }
  return NextResponse.json({ error: "Could not generate a unique class code." }, { status: 503 });
}
