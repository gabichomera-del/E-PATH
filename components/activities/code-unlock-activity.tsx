"use client";

import { useState } from "react";
import { LockKeyhole, ShieldCheck } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

export function CodeUnlockActivity({activity,onAnswer,onProgress}:ActivityProps){
  const [selected,setSelected]=useState<Record<string,string>>({});const [statuses,setStatuses]=useState<Record<string,boolean>>({});
  const unlocked=activity.items.filter((item)=>statuses[item.id]).length;const complete=unlocked===activity.items.length;
  function choose(id:string,value:string){if(statuses[id])return;const next={...selected,[id]:value};setSelected(next);setStatuses((current)=>{const copy={...current};delete copy[id];return copy});onProgress?.(next)}
  function check(){const next=Object.fromEntries(activity.items.map((item)=>[item.id,selected[item.id]===item.answer]));const count=Object.values(next).filter(Boolean).length;setStatuses(next);onAnswer({correct:count===activity.items.length,score:Math.round(count/activity.items.length*100),response:selected})}
  return <ActivityShell eyebrow="School Rule Master" instructions={activity.instructions}><div className="mb-6 grid grid-cols-5 gap-2">{activity.items.map((item,index)=><div key={item.id} className={`rounded-xl p-3 text-center ${statuses[item.id]?"bg-emerald-100 text-emerald-700":"bg-[#edf1f6] text-[#8a98aa]"}`}>{statuses[item.id]?<ShieldCheck className="mx-auto"/>:<LockKeyhole className="mx-auto"/>}<span className="mt-1 block text-xs font-black">Code {index+1}</span></div>)}</div><div className="grid gap-5">{activity.items.map((item,index)=><fieldset key={item.id} className="rounded-2xl border border-[#dce5f2] p-4"><legend className="px-2 font-bold text-[#10233f]">{index+1}. {item.prompt}</legend><div className="mt-3 grid gap-2">{shuffleOptions(item.options??[],`${activity.id}:${item.id}`).map((option)=><button type="button" key={option} disabled={statuses[item.id]} onClick={()=>choose(item.id,option)} className={`focus-ring rounded-xl border-2 p-3 text-left font-semibold ${selected[item.id]===option?statuses[item.id]?"border-emerald-400 bg-emerald-50":"border-[#125cdb] bg-blue-50":"border-[#dce5f2]"}`}>{option}</button>)}</div>{statuses[item.id]===true&&<p className="mt-2 font-bold text-emerald-700">✓ Code part unlocked: {item.codePart}</p>}{statuses[item.id]===false&&<p className="mt-2 font-bold text-red-700">✗ Review the rule and try again.</p>}</fieldset>)}</div>{complete?<div className="mt-6 rounded-2xl bg-emerald-100 p-5 text-center font-adventure text-2xl font-semibold text-emerald-700">School Rules Code Unlocked!</div>:<Submit disabled={!activity.items.every((item)=>selected[item.id])} label="Unlock the code" onClick={check}/>}</ActivityShell>
}
