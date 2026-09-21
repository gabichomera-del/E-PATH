"use client";

import { motion } from "framer-motion";
import { Check, CloudLightning, Crown, FlaskConical, Footprints, LockKeyhole, Shield, Star, Zap } from "lucide-react";
import Link from "next/link";
import type { Mission } from "@/lib/learning/types";
import { FoxMascot } from "@/components/student/FoxMascot";

const heroStationIcons=[Zap,FlaskConical,Shield,CloudLightning,Crown];
export function MissionNode({mission,active,variant}:{mission:Mission;active:boolean;variant?:string}) {
  const completed = mission.status === "completed"; const available = mission.status === "available";
  const heroWorld=variant==="hero-skies";const StationIcon=heroStationIcons[(mission.order-1)%heroStationIcons.length];
  const heroStart=heroWorld&&mission.order===1;
  const node = <motion.div initial={{ opacity: 0, scale: .5 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: Math.min(mission.order * .035, .8), type: "spring" }} whileHover={{ scale: 1.12, y: -3 }} className="group relative -translate-x-1/2 -translate-y-1/2">
    {active && !heroWorld && <div className="pointer-events-none absolute -left-10 -top-28 z-20 sm:-left-12 sm:-top-36"><FoxMascot/></div>}
    {active && !heroWorld && <motion.span initial={{ opacity: 0 }} animate={{ opacity: [.2, .9, .35] }} transition={{ duration: 1.6, repeat: Infinity }} className="absolute -left-8 top-7 rotate-[35deg] text-white"><Footprints size={21}/></motion.span>}
    {heroWorld&&<motion.span animate={available?{scale:[1,1.32,1],opacity:[.5,1,.5]}:{}} transition={{duration:1.7,repeat:Infinity}} className={`absolute rounded-[1.4rem] border-2 ${heroStart?"-inset-7 border-cyan-100 shadow-[0_0_32px_12px_rgba(67,229,255,.62)]":"-inset-5"} ${completed?"border-emerald-300/70":available?"border-cyan-200/90":"border-blue-200/25"}`}/>} 
    {heroStart&&<span className="absolute bottom-full left-1/2 mb-5 -translate-x-1/2 whitespace-nowrap rounded-full border-2 border-white bg-gradient-to-r from-[#ff8a2b] to-[#ffb13b] px-3 py-1 text-[9px] font-black uppercase tracking-[.18em] text-[#092b5b] shadow-[0_0_20px_rgba(255,164,54,.65)] sm:text-[10px]">Start · Mission 1</span>}
    <span className={`relative grid place-items-center border-[3px] border-white text-xs font-black shadow-[0_5px_0_rgba(3,21,45,.48),0_8px_16px_rgba(2,18,39,.38)] ${heroStart?"size-14 rounded-[1.1rem] sm:size-16":heroWorld?"size-12 rounded-[1rem] sm:size-14":"size-9 rounded-xl sm:size-11"} ${completed ? "bg-[#20b876] text-white" : available ? heroWorld?"bg-gradient-to-br from-[#39eff0] via-[#1687e8] to-[#1748b8] text-white ring-[10px] ring-[#58e4ff]/45":"bg-[#ff8426] text-white ring-8 ring-[#58e4ff]/40" : heroWorld?"bg-gradient-to-br from-[#284f83] to-[#13294e] text-blue-100":"bg-[#6f7c8e] text-[#e7ecf2]"}`}>{completed?<Check size={19} strokeWidth={3}/>:available?<><StationIcon size={heroStart?24:20}/><span className="absolute -right-1 -top-2 grid size-5 place-items-center rounded-full bg-white text-[10px] text-[#125cdb]">{mission.order}</span></>:heroWorld?<><StationIcon size={20}/><LockKeyhole size={12} className="absolute -bottom-1 -right-1 rounded-full bg-[#13294e]"/></>:<LockKeyhole size={16}/>} {completed&&<Star size={13} fill="currentColor" className="absolute -right-2 -top-2 text-[#ffd166]"/>}</span>
    <span className={`pointer-events-none absolute left-1/2 top-full mt-2 hidden -translate-x-1/2 whitespace-nowrap rounded-lg px-2.5 py-1.5 text-xs font-bold text-white shadow-lg group-hover:block ${available ? "bg-[#d95405]" : completed ? "bg-[#08784f]" : "bg-[#26364b]"}`}>{mission.title}</span>
  </motion.div>;
  const style = { left: `${mission.mapPosition.x}%`, top: `${mission.mapPosition.y}%` };
  return completed || available ? <Link href={`/student/mission/${mission.id}`} style={style} className="focus-ring absolute z-10 rounded-xl" aria-label={`${completed ? "Completed" : "Available"} Mission ${mission.order}: ${mission.title}`}>{node}</Link> : <div style={style} className="absolute z-10" aria-label={`Locked Mission ${mission.order}: ${mission.title}`}>{node}</div>;
}
