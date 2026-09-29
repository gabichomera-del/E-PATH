import { AlertCircle, CheckCircle2, MousePointerClick } from "lucide-react";
import type { ClassAlert } from "@/lib/database/teacher-analytics";

const alertPresentation = {
  "low-progress": { icon: AlertCircle, color: "text-[#d97706]", background: "bg-amber-50" },
  "incorrect-attempts": { icon: AlertCircle, color: "text-[#dc4c4c]", background: "bg-red-50" },
  "limited-activity": { icon: MousePointerClick, color: "text-[#125cdb]", background: "bg-blue-50" },
} as const;

export function ClassAlerts({ alerts }: { alerts: ClassAlert[] }) {
  return <section className="card p-6" aria-labelledby="alerts-title">
    <div><p className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Actionable signals</p><h2 id="alerts-title" className="mt-1 text-xl font-black">Class Alerts</h2></div>
    {!alerts.length ? <div className="mt-6 flex items-center gap-3 rounded-2xl bg-emerald-50 p-4 text-[#16885a]"><CheckCircle2/><p className="font-bold">No support alerts from the recorded learning data.</p></div> : <div className="mt-6 max-h-[360px] space-y-3 overflow-y-auto pr-1">{alerts.map((alert) => {
      const presentation = alertPresentation[alert.kind]; const Icon = presentation.icon;
      return <article key={alert.id} className={`flex gap-3 rounded-2xl p-4 ${presentation.background}`}><Icon className={`mt-0.5 shrink-0 ${presentation.color}`} size={20}/><div><h3 className="font-black text-[#17243a]">{alert.title}</h3><p className="mt-1 text-sm font-semibold text-[#62708a]">{alert.description}</p></div></article>;
    })}</div>}
  </section>;
}
