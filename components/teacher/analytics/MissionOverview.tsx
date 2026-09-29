import { BookOpenCheck, CheckCircle2, Gauge, Users } from "lucide-react";
import type { TeacherMissionAnalytics } from "@/lib/database/teacher-analytics";

export function MissionOverview({ analytics }: { analytics: TeacherMissionAnalytics }) {
  const items = [
    { label: "Students working", value: analytics.studentsWorking, icon: Users },
    { label: "Average Mission Progress", value: `${analytics.averageProgress}%`, icon: Gauge },
    { label: "Activities", value: analytics.totalActivities, icon: BookOpenCheck },
    { label: "Class completions", value: analytics.completedActivityRecords, icon: CheckCircle2 },
  ];
  return <section className="card p-6"><div className="flex flex-wrap items-end justify-between gap-4"><div><p className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">{analytics.selectedMission.unitTitle} · Mission {analytics.selectedMission.order}</p><h2 className="mt-1 text-2xl font-black text-[#17243a]">{analytics.selectedMission.title}</h2></div><p className="text-sm font-bold text-[#62708a]">Progress is based on completed activities</p></div><div className="mt-6 grid gap-3 sm:grid-cols-2 xl:grid-cols-4">{items.map(({ label, value, icon: Icon }) => <div key={label} className="rounded-2xl bg-[#f5f8fc] p-4"><Icon className="text-[#125cdb]" size={20}/><p className="mt-3 text-2xl font-black">{value}</p><p className="text-xs font-bold text-[#62708a]">{label}</p></div>)}</div></section>;
}
