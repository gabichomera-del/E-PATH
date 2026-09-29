import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft } from "lucide-react";
import { DashboardShell } from "@/components/dashboard/shell";
import { ClassAlerts } from "@/components/teacher/analytics/ClassAlerts";
import { ClassOverview } from "@/components/teacher/analytics/ClassOverview";
import { ProgressDistribution } from "@/components/teacher/analytics/ProgressDistribution";
import { StudentPerformanceTable } from "@/components/teacher/analytics/StudentPerformanceTable";
import { ActivityBreakdown } from "@/components/teacher/analytics/ActivityBreakdown";
import { MissionAlerts } from "@/components/teacher/analytics/MissionAlerts";
import { MissionOverview } from "@/components/teacher/analytics/MissionOverview";
import { MissionSelector } from "@/components/teacher/analytics/MissionSelector";
import { MissionStudentPerformance } from "@/components/teacher/analytics/MissionStudentPerformance";
import { requireRole } from "@/lib/auth/current-user";
import { getTeacherClassAnalytics, getTeacherMissionAnalytics } from "@/lib/database/teacher-analytics";

export const dynamic = "force-dynamic";

export default async function ManageClassPage({ params, searchParams }: { params: Promise<{ id: string }>; searchParams: Promise<{ mission?: string }> }) {
  const { id } = await params;
  const { mission } = await searchParams;
  const { supabase, authUser, profile } = await requireRole("teacher");
  if (!supabase) notFound();

  const analytics = await getTeacherClassAnalytics(supabase, authUser.id, id);
  if (!analytics) notFound();
  const missionAnalytics = await getTeacherMissionAnalytics(supabase, authUser.id, id, mission);
  if (!missionAnalytics) notFound();

  return <DashboardShell role="Teacher" name={profile.first_name}>
    <Link href="/teacher/dashboard" className="inline-flex items-center gap-2 font-bold text-[#125cdb]"><ArrowLeft size={18}/> My classes</Link>
    <header className="mt-6 flex flex-wrap items-end justify-between gap-4">
      <div><p className="text-sm font-black uppercase tracking-widest text-[#125cdb]">Teacher Analytics Center</p><h1 className="mt-1 text-3xl font-black text-[#17243a]">{analytics.classroom.name}</h1><p className="mt-2 font-semibold text-[#62708a]">Grade {analytics.classroom.grade} · Section {analytics.classroom.section} · {analytics.classroom.academicYear}</p></div>
      <div className="rounded-2xl bg-[#eaf2ff] px-5 py-3"><p className="text-xs font-bold uppercase text-[#62708a]">Class code</p><p className="font-mono text-lg font-black text-[#125cdb]">{analytics.classroom.classCode}</p></div>
    </header>
    <div className="mt-7"><ClassOverview analytics={analytics}/></div>
    <div className="mt-6 grid gap-6 xl:grid-cols-[1.08fr_.92fr]"><ProgressDistribution analytics={analytics}/><ClassAlerts alerts={analytics.alerts}/></div>
    <div className="mt-6"><StudentPerformanceTable students={analytics.students} totalMissions={analytics.totalMissions}/></div>
    <section id="mission-analytics" className="mt-10 scroll-mt-6 space-y-6">
      <div><p className="text-sm font-black uppercase tracking-widest text-[#125cdb]">Mission & Activity Analytics</p><h2 className="mt-1 text-3xl font-black text-[#17243a]">Explore learning performance</h2><p className="mt-2 font-semibold text-[#62708a]">Select a mission to inspect activity completion, scores, attempts, and observable errors.</p></div>
      <MissionSelector missions={missionAnalytics.missions} selectedKey={missionAnalytics.selectedMission.contentKey}/>
      <MissionOverview analytics={missionAnalytics}/>
      <div className="grid gap-6 xl:grid-cols-[1.08fr_.92fr]"><ProgressDistribution title="Mission Progress Distribution" analytics={{ ...analytics, totalStudents: missionAnalytics.totalStudents, distribution: missionAnalytics.distribution }}/><MissionAlerts alerts={missionAnalytics.alerts}/></div>
      <ActivityBreakdown activities={missionAnalytics.activities} totalStudents={missionAnalytics.totalStudents}/>
      <MissionStudentPerformance students={missionAnalytics.students} totalActivities={missionAnalytics.totalActivities}/>
    </section>
  </DashboardShell>;
}
