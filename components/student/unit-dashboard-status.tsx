"use client";

import { CheckCircle2 } from "lucide-react";

export function UnitDashboardStatus({ variant, completed }: { variant: "badge" | "progress"; completed: number }) {
  const unitComplete=completed>=25;
  if(variant==="badge")return <span className={`inline-flex items-center gap-2 rounded-full border px-4 py-2 text-xs font-black uppercase tracking-[0.18em] backdrop-blur-md ${unitComplete?"border-emerald-200/60 bg-emerald-400/25 text-emerald-50":"border-emerald-300/35 bg-emerald-400/18 text-emerald-100"}`}>{unitComplete&&<CheckCircle2 size={15}/>} {unitComplete?"Completed":"Available now"}</span>;
  return <div className="mt-5 max-w-md rounded-2xl border border-white/15 bg-white/10 p-4 backdrop-blur-md"><div className="flex items-center justify-between text-sm font-black"><span>{completed} / 25 missions</span><span className={unitComplete?"text-emerald-200":"text-cyan-200"}>{unitComplete?"COMPLETED":`${Math.round(completed/25*100)}%`}</span></div><div className="mt-3 h-2.5 overflow-hidden rounded-full bg-[#03132d]/70"><div className="h-full rounded-full bg-gradient-to-r from-cyan-400 to-emerald-400 transition-all" style={{width:`${completed/25*100}%`}}/></div></div>;
}
