import { FoxMascot } from "@/components/student/FoxMascot";

export function FoxGuide({ message, compact = false }: { message: string; compact?: boolean }) {
  return <div className={`relative isolate overflow-hidden ${compact ? "min-h-20 rounded-2xl" : "min-h-44 rounded-[1.5rem]"} border border-[#285280] bg-[radial-gradient(circle_at_85%_25%,rgba(63,159,222,.35),transparent_38%),linear-gradient(135deg,#0a2449,#102f57)] shadow-[0_18px_38px_rgba(12,42,82,.17)]`}>
    <div className="absolute inset-x-0 bottom-0 h-12 bg-gradient-to-t from-[#071a36]/90 to-transparent" aria-hidden="true"/>
    <div className="absolute -bottom-5 -right-2" aria-hidden="true"><FoxMascot compact={compact} mood="ready"/></div>
    <div className="relative z-10 max-w-[63%] p-5"><p className="text-[10px] font-black uppercase tracking-[.16em] text-[#8de1e8]">Your adventure guide</p><p className="mt-2 text-sm font-semibold leading-6 text-white">{message}</p></div>
  </div>;
}
