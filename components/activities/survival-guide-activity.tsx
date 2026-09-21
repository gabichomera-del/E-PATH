"use client";
import { useMemo, useState } from "react";
import { Compass, Sparkles } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

export function SurvivalGuideActivity({activity,onAnswer,onProgress}:ActivityProps){
  const [choices,setChoices]=useState<Record<string,string>>({});
  const options=useMemo(()=>Object.fromEntries(activity.items.map(item=>[item.id,shuffleOptions(item.options??[],`${activity.id}:${item.id}`)])),[activity]);
  const complete=activity.items.every(item=>choices[item.id]);
  function choose(id:string,value:string){const next={...choices,[id]:value};setChoices(next);onProgress?.(next)}
  return <ActivityShell eyebrow="Build the Survival Guide" instructions={activity.instructions}><div className="grid gap-4 sm:grid-cols-2">{activity.items.map(item=><label key={item.id} className="rounded-2xl border border-[#dce5f2] bg-white p-4 font-bold text-[#31445f]"><span className="flex items-center gap-2 text-[#125cdb]"><Compass size={18}/>{item.prompt}</span><select value={choices[item.id]??""} onChange={event=>choose(item.id,event.target.value)} className="field mt-3"><option value="">Choose a recommendation</option>{options[item.id].map(option=><option key={option}>{option}</option>)}</select></label>)}</div>{complete&&<div className="mt-6 rounded-3xl border border-emerald-200 bg-gradient-to-br from-emerald-50 to-blue-50 p-5"><Sparkles className="text-[#ff8426]"/><p className="mt-2 text-xs font-black uppercase tracking-widest text-[#21a46b]">My School Survival Guide</p>{activity.items.map(item=><p key={item.id} className="mt-2 font-semibold text-[#31445f]"><strong>{item.prompt}:</strong> {choices[item.id]}</p>)}</div>}<Submit disabled={!complete} label="Save my survival guide" onClick={()=>onAnswer({correct:true,score:100,response:choices})}/></ActivityShell>
}
