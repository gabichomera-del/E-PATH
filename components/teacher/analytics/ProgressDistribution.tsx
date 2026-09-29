import type { TeacherClassAnalytics } from "@/lib/database/teacher-analytics";

export function ProgressDistribution({ analytics, title = "Unit Progress Distribution" }: { analytics: TeacherClassAnalytics; title?: string }) {
  const total = Math.max(analytics.totalStudents, 1);
  const advanced = (analytics.distribution.Advanced / total) * 100;
  const onTrack = (analytics.distribution["On Track"] / total) * 100;
  const chart = analytics.totalStudents
    ? `conic-gradient(#21a46b 0 ${advanced}%, #3b82f6 ${advanced}% ${advanced + onTrack}%, #f59e0b ${advanced + onTrack}% 100%)`
    : "conic-gradient(#e5ebf3 0 100%)";
  const groups = [
    { label: "Advanced", range: "75–100%", count: analytics.distribution.Advanced, color: "bg-[#21a46b]" },
    { label: "On Track", range: "40–74%", count: analytics.distribution["On Track"], color: "bg-[#3b82f6]" },
    { label: "Needs Support", range: "0–39%", count: analytics.distribution["Needs Support"], color: "bg-[#f59e0b]" },
  ];

  return <section className="card p-6" aria-labelledby="distribution-title">
    <div><p className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Class progress</p><h2 id="distribution-title" className="mt-1 text-xl font-black">{title}</h2></div>
    <div className="mt-6 flex flex-col items-center gap-7 sm:flex-row sm:items-start">
      <div className="relative grid size-44 shrink-0 place-items-center rounded-full" style={{ background: chart }} role="img" aria-label="Student progress distribution chart">
        <div className="grid size-28 place-items-center rounded-full bg-white text-center shadow-inner"><div><p className="text-3xl font-black text-[#17243a]">{analytics.totalStudents}</p><p className="text-xs font-bold text-[#62708a]">students</p></div></div>
      </div>
      <div className="w-full space-y-3">
        {groups.map((group) => <div key={group.label} className="flex items-center justify-between gap-4 rounded-2xl bg-[#f7f9fc] p-4">
          <div className="flex items-center gap-3"><span className={`size-3 rounded-full ${group.color}`}/><div><p className="font-black text-[#17243a]">{group.label}</p><p className="text-xs font-semibold text-[#62708a]">{group.range}</p></div></div>
          <span className="text-lg font-black text-[#17243a]">{group.count}</span>
        </div>)}
      </div>
    </div>
  </section>;
}
