import { AlertTriangle, CheckCircle2 } from "lucide-react";
import type { MissionAnalyticsAlert } from "@/lib/database/teacher-analytics";

export function MissionAlerts({ alerts }: { alerts: MissionAnalyticsAlert[] }) {
  return <section className="card p-6"><p className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Mission signals</p><h2 className="mt-1 text-xl font-black">Mission Alerts</h2>{!alerts.length ? <div className="mt-5 flex gap-3 rounded-2xl bg-emerald-50 p-4 text-[#16885a]"><CheckCircle2 className="shrink-0"/><p className="font-bold">No alerts from the recorded data for this mission.</p></div> : <div className="mt-5 space-y-3">{alerts.map((alert) => <article key={alert.id} className="flex gap-3 rounded-2xl bg-amber-50 p-4"><AlertTriangle className="shrink-0 text-[#d97706]" size={20}/><div><h3 className="font-black">{alert.title}</h3><p className="mt-1 text-sm font-semibold text-[#62708a]">{alert.description}</p></div></article>)}</div>}</section>;
}
