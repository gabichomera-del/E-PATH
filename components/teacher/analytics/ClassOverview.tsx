import { Award, BookOpenCheck, Sparkles, Users } from "lucide-react";
import type { TeacherClassAnalytics } from "@/lib/database/teacher-analytics";

export function ClassOverview({ analytics }: { analytics: TeacherClassAnalytics }) {
  const metrics = [
    { label: "Students", value: analytics.totalStudents, icon: Users, color: "text-[#125cdb]", background: "bg-[#eaf2ff]" },
    { label: "Average unit progress", value: `${analytics.averageProgress}%`, icon: BookOpenCheck, color: "text-[#16885a]", background: "bg-emerald-50" },
    { label: "Total XP", value: analytics.totalXp.toLocaleString(), icon: Sparkles, color: "text-[#e8801b]", background: "bg-orange-50" },
    { label: "Badges earned", value: analytics.totalBadges, icon: Award, color: "text-[#7654c7]", background: "bg-violet-50" },
  ];

  return <section aria-labelledby="class-overview-title">
    <h2 id="class-overview-title" className="sr-only">Class overview</h2>
    <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      {metrics.map(({ label, value, icon: Icon, color, background }) => <article key={label} className="card p-5">
        <div className={`grid size-11 place-items-center rounded-2xl ${background} ${color}`}><Icon size={22}/></div>
        <p className="mt-4 text-2xl font-black text-[#17243a]">{value}</p>
        <p className="mt-1 text-sm font-bold text-[#62708a]">{label}</p>
      </article>)}
    </div>
  </section>;
}
