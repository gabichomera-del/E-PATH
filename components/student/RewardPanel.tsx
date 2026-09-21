import { Star, Trophy } from "lucide-react";

export function RewardPanel({ completed, total }: { completed: number; total: number }) {
  return <div className="absolute bottom-4 left-4 z-20 hidden items-center gap-3 rounded-2xl border border-white/20 bg-[#061832]/85 px-4 py-3 text-white shadow-xl backdrop-blur-md lg:flex"><span className="grid size-10 place-items-center rounded-xl bg-[#ffd166] text-[#7b5100]"><Trophy size={21}/></span><div><p className="text-xs font-semibold text-blue-200">World rewards</p><p className="flex items-center gap-1 text-sm font-bold">{completed}/{total} places explored <Star size={13} fill="currentColor" className="text-[#ffd166]"/></p></div></div>;
}
