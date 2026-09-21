import { notFound, redirect } from "next/navigation";
import { ProgressHeader } from "@/components/student/ProgressHeader";
import { UnitMap } from "@/components/student/UnitMap";
import { getStudentEnrollment } from "@/lib/database/classes";
import { getUnit } from "@/lib/learning/repository";
import { getWorldTheme } from "@/lib/learning/world-themes";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";
export default async function UnitPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params; if (id !== "unit-6" && id !== "6") notFound(); const unit = await getUnit(id); if (!unit) notFound();
  const supabase = await createClient(); let name = "Explorer"; let context: string | undefined;
  if (supabase) {
    const { data: { user } } = await supabase.auth.getUser(); if (!user) redirect("/login?role=student");
    const { data: profile } = await supabase.from("users").select("first_name, role").eq("id", user.id).single();
    if (profile?.role !== "student") redirect("/teacher/dashboard"); name = profile.first_name;
    const enrollment = await getStudentEnrollment(supabase, user.id); const classroom = Array.isArray(enrollment?.classroom) ? enrollment.classroom[0] : enrollment?.classroom;
    if (enrollment) context = `Grade ${enrollment.student.grade} · ${classroom?.name ?? "No class"}`;
  }
  return <main className="min-h-screen bg-[#071b3d]"><ProgressHeader name={name} context={context}/><UnitMap unit={unit} theme={getWorldTheme(unit.number)}/></main>;
}
