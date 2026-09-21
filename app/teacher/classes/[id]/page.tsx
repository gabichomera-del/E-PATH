import { notFound, redirect } from "next/navigation";
import Link from "next/link";
import { ArrowLeft, Users } from "lucide-react";
import { DashboardShell } from "@/components/dashboard/shell";
import { ResetPasswordButton } from "@/components/teacher/ResetPasswordButton";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";
export default async function TeacherClassPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params; const supabase = await createClient(); if (!supabase) return null;
  const { data: { user } } = await supabase.auth.getUser(); if (!user) redirect("/login?role=teacher");
  const { data: profile } = await supabase.from("users").select("first_name, role").eq("id", user.id).single(); if (profile?.role !== "teacher") redirect("/student/dashboard");
  const { data: teacher } = await supabase.from("teachers").select("id").eq("user_id", user.id).single();
  const { data: classroom } = await supabase.from("classes").select("id, name, grade, section, academic_year, class_code").eq("id", id).eq("teacher_id", teacher?.id).maybeSingle(); if (!classroom) notFound();
  const { data: members } = await supabase.from("class_members").select("student_id, joined_at, students(id, grade, section, users(first_name, last_name, email))").eq("class_id", id).order("joined_at");
  return <DashboardShell role="Teacher" name={profile.first_name}><Link href="/teacher/dashboard" className="inline-flex items-center gap-2 font-bold text-[#125cdb]"><ArrowLeft size={18}/> My classes</Link><div className="mt-6 flex flex-wrap items-end justify-between gap-4"><div><h1 className="text-3xl font-black">{classroom.name}</h1><p className="mt-1 font-semibold text-[#62708a]">Grade {classroom.grade} · Section {classroom.section} · {classroom.academic_year}</p></div><div className="rounded-2xl bg-[#eaf2ff] px-5 py-3"><p className="text-xs font-bold uppercase text-[#62708a]">Enrollment code</p><p className="font-mono text-lg font-black text-[#125cdb]">{classroom.class_code}</p></div></div><section className="card mt-7 overflow-hidden"><div className="flex items-center gap-3 border-b border-[#dce5f2] p-5"><Users className="text-[#21a46b]"/><h2 className="text-xl font-black">Enrolled students</h2></div>{!members?.length ? <p className="p-8 text-center font-semibold text-[#62708a]">No students have joined this class yet.</p> : <div className="divide-y divide-[#e8eef6]">{members.map((member) => { const student = Array.isArray(member.students) ? member.students[0] : member.students; const account = student && (Array.isArray(student.users) ? student.users[0] : student.users); return <div key={member.student_id} className="flex flex-wrap items-center justify-between gap-4 p-5"><div><p className="font-black">{account?.first_name} {account?.last_name}</p><p className="text-sm font-semibold text-[#62708a]">{account?.email}</p></div><ResetPasswordButton studentId={member.student_id}/></div>; })}</div>}</section></DashboardShell>;
}
