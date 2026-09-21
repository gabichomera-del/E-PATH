import { notFound, redirect } from "next/navigation";
import Link from "next/link";
import { Gauge, Heart, Star } from "lucide-react";
import { getMission, getUnit } from "@/lib/learning/repository";
import { MissionEngine } from "@/components/learning/mission-engine";
import { MissionExitLink } from "@/components/learning/mission-exit-link";

export const dynamic = "force-dynamic";
export default async function MissionPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const mission = await getMission(id);
  if (!mission || mission.unitId !== "unit-6") notFound();
  if (mission.status === "locked") redirect(`/student/unit/${mission.unitId}`);
  const unit = await getUnit(mission.unitId);
  const nextMissionTitle = unit?.missions.find((item) => item.order === mission.order + 1)?.title;

  return <main className="min-h-screen bg-[radial-gradient(circle_at_top,#e4f2ff,#f6f9fd_48%)]"><header className="border-b border-[#dce5f2] bg-white/90 backdrop-blur"><div className="container-shell flex min-h-20 flex-wrap items-center justify-between gap-3 py-3"><MissionExitLink href={`/student/unit/${mission.unitId}`}/><div className="flex items-center gap-3"><span className="inline-flex items-center gap-1.5 rounded-full bg-orange-100 px-3 py-2 text-sm font-black text-[#b54d04]"><Star size={16} fill="currentColor"/> +{mission.xpReward} XP</span><span className="inline-flex items-center gap-1 rounded-full bg-red-50 px-3 py-2 text-[#e34848]" aria-label="Three lives"><Heart size={17} fill="currentColor"/><Heart size={17} fill="currentColor"/><Heart size={17} fill="currentColor"/></span></div></div></header><section className="container-shell py-8"><div className="mx-auto mb-7 max-w-4xl"><div className="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-[#125cdb]"><Gauge size={16}/> Mission {mission.order} · {mission.difficulty}</div><h1 className="font-adventure mt-2 text-3xl font-semibold sm:text-4xl">{mission.title}</h1><p className="mt-2 font-medium text-[#62708a]"><span className="font-bold text-[#31445f]">Objective:</span> {mission.objective}</p></div><div className="mx-auto max-w-4xl">{mission.activities.length ? <MissionEngine mission={mission} nextMissionTitle={nextMissionTitle}/> : <div className="card p-8 text-center"><p className="font-adventure text-2xl font-semibold">This checkpoint is still being prepared.</p><Link href={`/student/unit/${mission.unitId}`} className="btn-primary mt-6">Return to Unit World Map</Link></div>}</div></section></main>;
}
