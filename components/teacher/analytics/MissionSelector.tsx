"use client";

import { usePathname, useRouter, useSearchParams } from "next/navigation";
import type { MissionOption } from "@/lib/database/teacher-analytics";

export function MissionSelector({ missions, selectedKey }: { missions: MissionOption[]; selectedKey: string }) {
  const router = useRouter(); const pathname = usePathname(); const searchParams = useSearchParams();
  return <section className="card p-5" aria-labelledby="mission-selector-title">
    <label id="mission-selector-title" htmlFor="mission-selector" className="text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Explore mission analytics</label>
    <select id="mission-selector" value={selectedKey} onChange={(event) => { const params = new URLSearchParams(searchParams.toString()); params.set("mission", event.target.value); router.push(`${pathname}?${params.toString()}#mission-analytics`); }} className="focus-ring mt-3 w-full rounded-2xl border border-[#dce5f2] bg-white px-4 py-3 font-bold text-[#17243a]">
      {missions.map((mission, index) => {
        const showUnit = index === 0 || missions[index - 1]?.unitKey !== mission.unitKey;
        return showUnit ? <optgroup key={mission.unitKey} label={mission.unitTitle}>{missions.filter((item) => item.unitKey === mission.unitKey).map((item) => <option key={item.id} value={item.contentKey}>Mission {item.order} · {item.title}</option>)}</optgroup> : null;
      })}
    </select>
  </section>;
}
