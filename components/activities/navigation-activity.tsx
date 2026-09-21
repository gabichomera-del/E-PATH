"use client";

import { useState } from "react";
import Image from "next/image";
import { motion } from "framer-motion";
import { MapPin } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { FoxMascot } from "@/components/student/FoxMascot";
import { shuffleOptions } from "@/lib/learning/shuffle";

export function NavigationActivity({activity,onAnswer,onProgress}:ActivityProps){
  const [selected,setSelected]=useState<Record<string,string>>({});
  const [statuses,setStatuses]=useState<Record<string,boolean>>({});
  const correct=Object.values(statuses).filter(Boolean).length;
  const complete=correct===activity.items.length;
  function choose(id:string,value:string){if(statuses[id])return;const next={...selected,[id]:value};setSelected(next);setStatuses((current)=>{const copy={...current};delete copy[id];return copy});onProgress?.(next)}
  function check(){const itemsToCheck=activity.sequential?activity.items.filter((_,index)=>index<=correct):activity.items;const next={...statuses,...Object.fromEntries(itemsToCheck.map((item)=>[item.id,selected[item.id]===item.answer]))};const count=Object.values(next).filter(Boolean).length;setStatuses(next);if(activity.sequential&&next[activity.items[correct]?.id]&&count<activity.items.length)return;onAnswer({correct:count===activity.items.length,score:Math.round(count/activity.items.length*100),response:selected})}
  return <ActivityShell eyebrow="School Mission Map" instructions={activity.instructions}>
    <div className="relative mb-6 h-56 overflow-hidden rounded-3xl border border-blue-200"><Image src="/assets/worlds/unit-6-superpowers.png" alt="Superpower Academy navigation map" fill sizes="800px" className="object-cover"/><div className="absolute inset-0 bg-[#061832]/25"/><motion.div animate={{left:`${18+correct*55}%`}} transition={{type:"spring",stiffness:85,damping:15}} className="absolute bottom-3 -translate-x-1/2 scale-[.55]"><FoxMascot celebrating={complete}/></motion.div><MapPin className="absolute bottom-8 right-[12%] text-[#ff8426] drop-shadow" size={34} fill="white"/></div>
    {activity.sequential&&<p className="mb-4 text-center font-extrabold text-[#125cdb]">{Math.min(correct+1,activity.items.length)}/{activity.items.length} destinations</p>}
    <div className="grid gap-5">{activity.items.map((item,index)=>{const locked=Boolean(activity.sequential&&index>correct);return <fieldset key={item.id} disabled={locked} className={`rounded-2xl border border-[#dce5f2] p-4 ${locked?"opacity-45":""}`}><legend className="px-2 font-bold text-[#10233f]">Route {index+1}: {item.prompt}</legend><div className="mt-3 grid gap-2 sm:grid-cols-2">{shuffleOptions(item.options??[],`${activity.id}:${item.id}`).map((option)=><button type="button" key={option} disabled={locked||statuses[item.id]===true} onClick={()=>choose(item.id,option)} className={`focus-ring rounded-xl border-2 p-3 text-left font-semibold ${selected[item.id]===option?statuses[item.id]===true?"border-emerald-400 bg-emerald-50":"border-[#125cdb] bg-blue-50":"border-[#dce5f2]"}`}>{option}</button>)}</div>{statuses[item.id]===true&&<p className="mt-2 font-bold text-emerald-700">✓ Route found! The fox moves forward.</p>}{statuses[item.id]===false&&<p className="mt-2 font-bold text-red-700">✗ Check the directions and try again.</p>}{locked&&<p className="mt-2 font-semibold text-slate-500">Complete the previous destination to unlock this step.</p>}</fieldset>})}</div>
    {!complete&&<Submit disabled={activity.sequential?!selected[activity.items[correct]?.id]:!activity.items.every((item)=>selected[item.id])} label={activity.sequential?"Check destination":"Check routes"} onClick={check}/>} 
  </ActivityShell>
}
