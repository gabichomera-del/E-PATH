"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Check, Footprints } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { FoxMascot } from "@/components/student/FoxMascot";
import { shuffleOptions } from "@/lib/learning/shuffle";

export function ProblemPathActivity({activity,onAnswer,onProgress}:ActivityProps){
  const [step,setStep]=useState(0);const [selected,setSelected]=useState("");const [wrong,setWrong]=useState(false);const [answers,setAnswers]=useState<Record<string,string>>({});
  const item=activity.items[step];const finished=step>=activity.items.length;
  function check(){if(!item)return;if(selected!==item.answer){setWrong(true);return}const next={...answers,[item.id]:selected};setAnswers(next);onProgress?.(next);setWrong(false);setSelected("");if(step===activity.items.length-1){setStep(activity.items.length);onAnswer({correct:true,score:100,response:next})}else setStep((current)=>current+1)}
  return <ActivityShell eyebrow="Mission Path" instructions={activity.instructions}>
    <div className="relative mb-7 h-36 rounded-3xl bg-gradient-to-r from-blue-100 via-emerald-50 to-orange-100"><div className="absolute left-[10%] right-[10%] top-[62%] border-t-4 border-dashed border-white"/>{activity.items.map((entry,index)=><span key={entry.id} className={`absolute top-[55%] grid size-8 -translate-x-1/2 place-items-center rounded-full border-2 border-white font-bold ${index<step||finished?"bg-emerald-500 text-white":"bg-[#8d9bad] text-white"}`} style={{left:`${15+index*35}%`}}>{index<step||finished?<Check size={17}/>:index+1}</span>)}<motion.div animate={{left:`${12+Math.min(step,activity.items.length-1)*35}%`}} transition={{type:"spring",stiffness:90,damping:16}} className="absolute -top-6 -translate-x-1/2 scale-[.48]"><FoxMascot celebrating={finished}/></motion.div><Footprints className="absolute bottom-2 left-1/2 text-[#125cdb]/50"/></div>
    {!finished&&item&&<div className="rounded-2xl border border-[#dce5f2] p-5"><p className="text-xs font-black uppercase tracking-widest text-[#125cdb]">Problem {step+1} of {activity.items.length}</p><h3 className="mt-2 text-lg font-bold text-[#10233f]">{item.prompt}</h3><div className="mt-4 grid gap-3">{shuffleOptions(item.options??[],`${activity.id}:${item.id}`).map((option)=><button type="button" key={option} onClick={()=>{setSelected(option);setWrong(false)}} className={`focus-ring rounded-xl border-2 p-3 text-left font-semibold ${selected===option?"border-[#125cdb] bg-blue-50":"border-[#dce5f2]"}`}>{option}</button>)}</div>{wrong&&<div className="mt-3"><p className="font-bold text-red-700">✗ That route does not solve the problem yet. Try again.</p>{item.incorrectExplanation&&<p className="mt-1 text-sm font-semibold text-[#31445f]">{item.incorrectExplanation}</p>}</div>}<Submit disabled={!selected} label="Solve and move" onClick={check}/></div>}
    {finished&&<div className="rounded-2xl bg-emerald-100 p-5 text-center font-adventure text-2xl font-semibold text-emerald-700">Path cleared! All three problems solved.</div>}
  </ActivityShell>
}
