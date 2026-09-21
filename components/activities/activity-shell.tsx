import type { ReactNode } from "react";

export function ActivityShell({ eyebrow, instructions, children }: { eyebrow: string; instructions: string; children: ReactNode }) {
  return <section className="rounded-[2rem] border border-[#dce5f2] bg-white p-6 shadow-[0_22px_65px_rgba(13,48,91,.1)] sm:p-9"><p className="text-xs font-black uppercase tracking-[.18em] text-[#125cdb]">{eyebrow}</p><h2 className="font-adventure mt-2 text-2xl font-semibold text-[#10233f] sm:text-3xl">{instructions}</h2><div className="mt-7">{children}</div></section>;
}
