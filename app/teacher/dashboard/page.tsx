import { redirect } from "next/navigation";
import { DashboardShell } from "@/components/dashboard/shell";
import { ClassList } from "@/components/teacher/ClassList";
import { CreateClassForm } from "@/components/teacher/CreateClassForm";
import { getTeacherClasses } from "@/lib/database/classes";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";
export default async function TeacherDashboard() {
  const supabase = await createClient();
  if (!supabase) return <DashboardShell role="Teacher" name="Teacher"><Header/><ClassList classes={[]}/></DashboardShell>;
  const { data: { user } } = await supabase.auth.getUser(); if (!user) redirect("/login?role=teacher");
  const { data: profile } = await supabase.from("users").select("first_name, role").eq("id", user.id).single();
  if (profile?.role !== "teacher") redirect("/student/dashboard");
  const classes = await getTeacherClasses(supabase, user.id);
  return <DashboardShell role="Teacher" name={profile.first_name}><Header/><ClassList classes={classes}/></DashboardShell>;
}

function Header() { return <div className="mb-7"><div className="flex flex-wrap items-end justify-between gap-4"><div><p className="text-sm font-black uppercase tracking-widest text-[#125cdb]">Teacher workspace</p><h1 className="mt-1 text-3xl font-black">My Classes</h1><p className="mt-2 font-semibold text-[#62708a]">Create classes, share enrollment codes, and support your students.</p></div><CreateClassForm/></div></div>; }
