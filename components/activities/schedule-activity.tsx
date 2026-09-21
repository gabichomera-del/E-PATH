"use client";

import { useState } from "react";
import { CalendarDays } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

const days=["Monday","Tuesday","Wednesday","Thursday","Friday"];

export function ScheduleActivity({activity,onAnswer,onProgress}:ActivityProps){
  const [selected,setSelected]=useState<Record<string,string>>({});
  const [statuses,setStatuses]=useState<Record<string,boolean>>({});
  const correct=Object.values(statuses).filter(Boolean).length;
  const complete=correct===activity.items.length;
  function choose(id:string,value:string){if(statuses[id])return;const next={...selected,[id]:value};setSelected(next);setStatuses((current)=>{const copy={...current};delete copy[id];return copy});onProgress?.(next)}
  function check(){const next=Object.fromEntries(activity.items.map((item)=>[item.id,selected[item.id]===item.answer]));const count=Object.values(next).filter(Boolean).length;setStatuses(next);onAnswer({correct:count===activity.items.length,score:Math.round(count/activity.items.length*100),response:selected})}
  return <ActivityShell eyebrow="Schedule Detective" instructions={activity.instructions}>
    <div className="overflow-x-auto rounded-2xl border border-blue-200"><table className="min-w-[680px] w-full border-collapse text-center text-sm"><caption className="bg-[#15365d] px-4 py-3 font-bold text-white"><CalendarDays className="mr-2 inline" size={18}/>Green Valley School Timetable</caption><thead><tr className="bg-blue-50"><th className="p-3 text-[#15365d]">Time</th>{days.map((day)=><th key={day} className="p-3 text-[#15365d]">{day}</th>)}</tr></thead><tbody>{activity.schedule?.map((row)=><tr key={row.time} className="border-t border-blue-100"><th className="bg-[#f5f8fc] p-3 text-[#31445f]">{row.time}</th>{days.map((day)=><td key={day} className="p-3 font-semibold text-[#31445f]">{row.subjects[day]}</td>)}</tr>)}</tbody></table></div>
    <div className="mt-6 grid gap-5">{activity.items.map((item,index)=><fieldset key={item.id} className="rounded-2xl border border-[#dce5f2] p-4"><legend className="px-2 font-bold text-[#10233f]">{index+1}. {item.prompt}</legend><div className="mt-3 grid gap-2 sm:grid-cols-2">{shuffleOptions(item.options??[],`${activity.id}:${item.id}`).map((option)=><button type="button" key={option} disabled={statuses[item.id]===true} onClick={()=>choose(item.id,option)} className={`focus-ring rounded-xl border-2 p-3 text-left font-semibold ${selected[item.id]===option?statuses[item.id]===true?"border-emerald-400 bg-emerald-50":"border-[#125cdb] bg-blue-50":"border-[#dce5f2]"}`}>{option}</button>)}</div>{statuses[item.id]===true&&<p className="mt-2 font-bold text-emerald-700">✓ Information found!</p>}{statuses[item.id]===false&&<p className="mt-2 font-bold text-red-700">✗ Look at the timetable again.</p>}</fieldset>)}</div>
    {!complete&&<Submit disabled={!activity.items.every((item)=>selected[item.id])} onClick={check}/>} 
  </ActivityShell>;
}
