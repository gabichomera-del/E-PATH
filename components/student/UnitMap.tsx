"use client";

import { useMemo } from "react";
import { motion } from "framer-motion";
import { Atom, CloudLightning, Compass, Crown, Dumbbell, Shield, Star } from "lucide-react";
import type { Unit } from "@/lib/learning/types";
import type { WorldTheme } from "@/lib/learning/world-themes";
import { MissionNode } from "@/components/student/MissionNode";
import { MissionPath } from "@/components/student/MissionPath";
import { FoxMascot } from "@/components/student/FoxMascot";
import { WorldEnvironment } from "@/components/student/WorldEnvironment";

export function UnitMap({unit,theme}:{unit:Unit;theme:WorldTheme}){
  const missions=useMemo(()=>unit.missions,[unit.missions]);
  const found=missions.findIndex(mission=>mission.status==="available");
  const lastCompleted=missions.reduce((last,mission,index)=>mission.status==="completed"?index:last,0);
  const activeIndex=found<0?lastCompleted:found;
  const current=missions[activeIndex];
  const completed=missions.filter(mission=>mission.status==="completed").length;
  const stage3Unlocked=unit.number===6&&missions.some(mission=>mission.order===20&&mission.status==="completed");
  return <section aria-labelledby="unit-map-title" className="relative overflow-hidden pb-7" style={{backgroundColor:theme.atmosphere}}>
    <div className="container-shell grid gap-4 py-4 text-white xl:grid-cols-[minmax(0,1fr)_minmax(20rem,.72fr)_auto] xl:items-center"><div><p className="text-sm font-bold uppercase tracking-[.18em] text-[#75d8ff]">{theme.unit}: {unit.title}</p><h1 id="unit-map-title" className="mt-1 font-adventure text-3xl font-semibold sm:text-4xl">{theme.worldName}</h1></div>{current&&<div className="rounded-2xl border border-cyan-200/30 bg-white/10 px-4 py-3 shadow-[0_10px_28px_rgba(2,20,48,.2)] backdrop-blur-sm"><div className="flex items-center justify-between gap-3"><p className="text-[10px] font-black uppercase tracking-[.18em] text-cyan-200">Current mission</p><span className="inline-flex items-center gap-1 rounded-full bg-orange-400/15 px-2 py-1 text-xs font-black text-[#ffd18c]"><Star size={13} fill="currentColor"/>+{current.xpReward} XP</span></div><p className="mt-1 font-adventure text-lg font-semibold">Mission {current.order} - {current.title}</p><p className="mt-1 text-xs font-medium text-blue-100">{theme.world==="hero-skies"?"Discover your abilities and begin your hero training.":current.description}</p></div>}<div className="text-left xl:text-right"><p className="text-2xl font-bold">{completed}<span className="text-base text-blue-200">/{missions.length}</span></p><p className="text-xs font-semibold uppercase tracking-widest text-[#5cdea7]">World explored</p></div></div>
    <div className="relative mx-auto aspect-[1.66/1] min-h-[660px] w-full max-w-[1536px] overflow-hidden border-y border-white/15 shadow-[0_25px_80px_rgba(0,0,0,.45)] sm:aspect-[1.78/1] sm:min-h-0 sm:rounded-[2.5rem] sm:border" data-map-layer="current-mission-system"><WorldEnvironment theme={theme}/>{theme.world==="hero-skies"&&<HeroAcademyZones/>}<MissionPath missions={missions} variant={theme.world}/>{stage3Unlocked&&<div className="absolute left-[76%] top-[12%] z-20 rounded-2xl border-2 border-white bg-gradient-to-r from-[#125cdb] to-[#21a46b] px-4 py-2 text-center text-white shadow-xl"><p className="text-[10px] font-black uppercase tracking-widest">New path opened</p><p className="font-adventure text-lg font-semibold">Stage 3 Unlocked</p></div>}{missions.map((mission,index)=><MissionNode key={mission.id} mission={mission} active={index===activeIndex} variant={theme.world}/>)}{theme.world==="hero-skies"&&current&&<HeroFoxGuide mission={current}/>}</div>
  </section>
}

const academyZones=[
  {label:"Power Discovery Zone",x:"10%",y:"88%",Icon:Compass,accent:"from-[#1ee2dc] to-[#1371cf]"},
  {label:"Hero Training Arena",x:"88%",y:"78%",Icon:Dumbbell,accent:"from-[#ff9b35] to-[#cf4e1c]"},
  {label:"Sky Challenge Zone",x:"8%",y:"34%",Icon:CloudLightning,accent:"from-[#a783ff] to-[#3c73dc]"},
  {label:"Energy Research Center",x:"91%",y:"20%",Icon:Atom,accent:"from-[#50e6ae] to-[#118d88]"},
  {label:"Hero Hall",x:"12%",y:"8%",Icon:Crown,accent:"from-[#ffd166] to-[#d68424]"},
];

function HeroAcademyZones(){return <div className="pointer-events-none absolute inset-0 z-[3]">
  {academyZones.map((zone,index)=><div key={zone.label} className="absolute -translate-x-1/2" style={{left:zone.x,top:zone.y}}><motion.div animate={{y:[0,-2,0]}} transition={{duration:4.2+index*.3,repeat:Infinity,ease:"easeInOut"}}>
    <span className="absolute left-1/2 top-2 h-8 w-24 -translate-x-1/2 rounded-full bg-cyan-200/15 blur-lg"/>
    <div className="relative w-24 rounded-md border-2 border-[#efc76f] bg-[linear-gradient(155deg,#213f69_0%,#0b2349_52%,#07172f_100%)] px-1.5 py-1.5 shadow-[0_3px_0_#412c1e,0_6px_10px_rgba(2,17,40,.5),inset_0_1px_0_rgba(255,255,255,.3)] sm:w-28">
      <span className="absolute left-1 top-1 size-1 rounded-full bg-[#ffe5a0] shadow-[0_0_4px_#fff1ad]"/><span className="absolute right-1 top-1 size-1 rounded-full bg-[#ffe5a0] shadow-[0_0_4px_#fff1ad]"/>
      <div className="flex items-center justify-center gap-1 rounded border border-cyan-100/20 bg-[#071a38]/75 px-1 py-1">
        <span className={`grid size-5 shrink-0 place-items-center rounded-full border border-white/60 bg-gradient-to-br ${zone.accent} text-white shadow-[0_1px_0_rgba(0,0,0,.4),0_0_7px_rgba(107,227,255,.35)]`}><zone.Icon size={11}/></span>
        <span className="text-center font-adventure text-[7px] font-semibold uppercase leading-[1.15] tracking-[.04em] text-[#fff6dd] drop-shadow sm:text-[8px]">{zone.label}</span>
      </div>
    </div>
    <div className="mx-auto h-5 w-2 border-x border-[#d9a956] bg-[linear-gradient(90deg,#412b23,#8a6039_48%,#35231d)] shadow-[2px_2px_4px_rgba(2,13,30,.45)] sm:h-6"/>
    <div className="mx-auto h-1.5 w-8 rounded-full bg-[#152844]/65 blur-[1px]"/>
  </motion.div></div>)}
  <div className="absolute left-1/2 top-[2%] -translate-x-1/2">
    <span className="absolute left-1/2 top-1/2 h-9 w-32 -translate-x-1/2 -translate-y-1/2 rounded-full bg-cyan-300/25 blur-xl"/>
    <div className="relative w-28 rounded-[.65rem] border border-[#d8f7ff] bg-[linear-gradient(145deg,#c4f3ff_0%,#4f91b9_8%,#163f73_18%,#071b3f_52%,#123b70_82%,#82d9ee_92%,#e7fbff_100%)] p-[2px] text-center shadow-[0_3px_0_#06152f,0_7px_14px_rgba(0,10,35,.48),0_0_15px_rgba(73,222,255,.38)] sm:w-32">
      <span className="absolute -left-2 top-1/2 h-4 w-3 -translate-y-1/2 -skew-y-[25deg] rounded-l border border-r-0 border-cyan-100/70 bg-[#163f73] shadow-md"/><span className="absolute -right-2 top-1/2 h-4 w-3 -translate-y-1/2 skew-y-[25deg] rounded-r border border-l-0 border-cyan-100/70 bg-[#163f73] shadow-md"/>
      <div className="relative rounded-[.5rem] border border-cyan-200/35 bg-[radial-gradient(circle_at_50%_0%,rgba(50,190,255,.32),transparent_52%),linear-gradient(180deg,#0c3568,#051a3b)] px-2 py-1.5 shadow-[inset_0_1px_0_rgba(255,255,255,.24)]">
        <Shield size={12} className="absolute left-1.5 top-1/2 -translate-y-1/2 fill-cyan-300/20 text-cyan-100/80"/>
        <span className="block font-adventure text-[8px] font-semibold uppercase leading-[1.05] tracking-[.11em] text-white drop-shadow-[0_1px_3px_rgba(65,220,255,.85)] sm:text-[9px]">Superpower<br/>Academy</span>
        <span className="mx-auto my-1 block h-px w-12 bg-gradient-to-r from-transparent via-cyan-200 to-transparent"/>
        <span className="block text-[6px] font-black uppercase tracking-[.28em] text-cyan-200 sm:text-[7px]">World Map</span>
      </div>
    </div>
    <div className="mx-auto flex w-20 justify-between px-2"><span className="h-3 w-1.5 border-x border-cyan-200/25 bg-[#183a61] shadow-sm"/><span className="h-3 w-1.5 border-x border-cyan-200/25 bg-[#183a61] shadow-sm"/></div>
  </div>
</div>}

function HeroFoxGuide({mission}:{mission:Unit["missions"][number]}){return <div className="pointer-events-none absolute z-20 h-10 w-10 -translate-x-1/2 -translate-y-[calc(100%+0.75rem)]" style={{left:`${mission.mapPosition.x}%`,top:`${mission.mapPosition.y}%`}} aria-hidden="true"><motion.div animate={{y:[0,-3,0]}} transition={{duration:2.8,repeat:Infinity,ease:"easeInOut"}} className="h-full w-full"><FoxMascot heroMentor compact/></motion.div></div>}
