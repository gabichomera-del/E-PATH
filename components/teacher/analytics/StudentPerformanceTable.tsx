"use client";

import { useMemo, useState } from "react";
import { ArrowDownUp } from "lucide-react";
import type { StudentPerformance, StudentAnalyticsStatus } from "@/lib/database/teacher-analytics";

type SortKey = "name" | "progress" | "completedMissions" | "xp" | "badges" | "status";

const statusStyle: Record<StudentAnalyticsStatus, string> = {
  Advanced: "bg-emerald-50 text-[#16885a]",
  "On Track": "bg-blue-50 text-[#125cdb]",
  "Needs Support": "bg-amber-50 text-[#a45f00]",
};

export function StudentPerformanceTable({ students, totalMissions }: { students: StudentPerformance[]; totalMissions: number }) {
  const [sort, setSort] = useState<SortKey>("progress");
  const [descending, setDescending] = useState(true);
  const sorted = useMemo(() => [...students].sort((a, b) => {
    const left = a[sort]; const right = b[sort];
    const comparison = typeof left === "string" ? left.localeCompare(String(right)) : left - Number(right);
    return descending ? -comparison : comparison;
  }), [students, sort, descending]);

  function changeSort(next: SortKey) {
    if (sort === next) setDescending((value) => !value);
    else { setSort(next); setDescending(next !== "name"); }
  }

  const HeaderButton = ({ column, children }: { column: SortKey; children: React.ReactNode }) => <button onClick={() => changeSort(column)} className="inline-flex items-center gap-1.5 whitespace-nowrap font-black text-[#4b5f7a]" aria-label={`Sort by ${String(children)}`}><span>{children}</span><ArrowDownUp size={13}/></button>;

  return <section className="card overflow-hidden" aria-labelledby="performance-title">
    <div className="border-b border-[#dce5f2] p-6"><p className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Learner insights</p><h2 id="performance-title" className="mt-1 text-xl font-black">Student Performance</h2></div>
    {!students.length ? <p className="p-8 text-center font-semibold text-[#62708a]">No students have joined this class yet.</p> : <div className="overflow-x-auto"><table className="w-full min-w-[780px] text-left">
      <thead className="bg-[#f7f9fc] text-xs uppercase tracking-wide"><tr><th className="px-5 py-4"><HeaderButton column="name">Student</HeaderButton></th><th className="px-5 py-4"><HeaderButton column="progress">Unit Progress</HeaderButton></th><th className="px-5 py-4"><HeaderButton column="completedMissions">Missions</HeaderButton></th><th className="px-5 py-4"><HeaderButton column="xp">XP</HeaderButton></th><th className="px-5 py-4"><HeaderButton column="badges">Badges</HeaderButton></th><th className="px-5 py-4"><HeaderButton column="status">Status</HeaderButton></th></tr></thead>
      <tbody className="divide-y divide-[#e8eef6]">{sorted.map((student) => <tr key={student.id} className="transition hover:bg-[#f9fbfe]"><td className="px-5 py-4"><p className="font-black text-[#17243a]">{student.name}</p><p className="text-xs font-semibold text-[#7a879b]">{student.email}</p></td><td className="px-5 py-4"><div className="flex items-center gap-3"><div className="h-2 w-24 overflow-hidden rounded-full bg-[#e5ebf3]"><div className="h-full rounded-full bg-[#21a46b]" style={{ width: `${student.progress}%` }}/></div><span className="font-black">{student.progress}%</span></div></td><td className="px-5 py-4 font-bold">{student.completedMissions}/{totalMissions}</td><td className="px-5 py-4 font-bold">{student.xp.toLocaleString()}</td><td className="px-5 py-4 font-bold">{student.badges}</td><td className="px-5 py-4"><span className={`inline-flex rounded-full px-3 py-1 text-xs font-black ${statusStyle[student.status]}`}>{student.status}</span></td></tr>)}</tbody>
    </table></div>}
  </section>;
}
