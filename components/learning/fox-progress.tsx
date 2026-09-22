"use client";

import foxArt from "@/public/assets/mascot/e-path-fox-mentor.module.css";

export function FoxProgress({ label = "You are here", compact = false }: { label?: string; compact?: boolean }) {
  return <div className="flex items-center gap-3"><div className={`${compact ? "size-12" : "size-16"} relative overflow-hidden rounded-full border-4 border-white bg-gradient-to-br from-[#164e91] to-[#0a2149] shadow-[0_8px_24px_rgba(7,27,61,.25)]`}><span role="img" aria-label="E-P.A.T.H. fox explorer" className={`${foxArt.art} scale-[2.2] translate-y-[19%]`}/></div>{!compact && <span className="rounded-full bg-white px-3 py-1.5 text-xs font-bold text-[#125cdb] shadow-sm">{label}</span>}</div>;
}
