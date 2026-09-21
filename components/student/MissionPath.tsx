"use client";

import { motion } from "framer-motion";
import type { Mission } from "@/lib/learning/types";

function buildPath(missions: Mission[]) {
  if (!missions.length) return "";
  return missions.slice(1).reduce((path, mission, index) => {
    const previous = missions[index].mapPosition; const current = mission.mapPosition;
    return `${path} Q ${(previous.x + current.x) / 2} ${previous.y}, ${current.x} ${current.y}`;
  }, `M ${missions[0].mapPosition.x} ${missions[0].mapPosition.y}`);
}

export function MissionPath({missions,variant}:{missions:Mission[];variant?:string}) {
  const path = buildPath(missions);
  const hero=variant==="hero-skies";
  if(hero)return <svg aria-hidden="true" viewBox="0 0 100 100" preserveAspectRatio="none" className="pointer-events-none absolute inset-0 z-[2] size-full"><defs><filter id="hero-energy-glow" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="2.4" result="blur"/><feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs><motion.path initial={{pathLength:0}} animate={{pathLength:1,strokeDashoffset:[0,-24]}} transition={{pathLength:{duration:2,ease:"easeOut"},strokeDashoffset:{duration:2,repeat:Infinity,ease:"linear"}}} d={path} fill="none" stroke="rgba(151,246,255,.92)" strokeWidth="4" strokeDasharray="3 8" strokeLinecap="round" strokeLinejoin="round" vectorEffect="non-scaling-stroke" filter="url(#hero-energy-glow)"/></svg>;
  return <svg aria-hidden="true" viewBox="0 0 100 100" preserveAspectRatio="none" className="pointer-events-none absolute inset-0 z-[2] size-full"><path d={path} fill="none" stroke="rgba(6,25,48,.42)" strokeWidth="8" strokeLinecap="round" strokeLinejoin="round" vectorEffect="non-scaling-stroke"/><motion.path initial={{ pathLength: 0 }} animate={{ pathLength: 1 }} transition={{ duration: 2, ease: "easeOut" }} d={path} fill="none" stroke="rgba(255,244,210,.92)" strokeWidth="3" strokeDasharray="4 6" strokeLinecap="round" vectorEffect="non-scaling-stroke"/></svg>;
}
