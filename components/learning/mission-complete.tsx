"use client";
import { motion } from "framer-motion";
import { AlertTriangle, Award, CheckCircle2, RefreshCcw, Sparkles, Star } from "lucide-react";
import Link from "next/link";
import type { Mission } from "@/lib/learning/types";
import { FoxProgress } from "@/components/learning/fox-progress";

export function MissionComplete({ mission, accuracy, nextMissionTitle, completionConfirmed, completionError, retrying=false, onRetry, activityResults=[] }: { mission: Mission; accuracy: number; nextMissionTitle?: string; completionConfirmed: boolean; completionError?: string|null; retrying?: boolean; onRetry?: ()=>void|Promise<void>; activityResults?: number[]; activityResponses?: Record<string,unknown> }) {
  const checkpoint=mission.order===10||mission.order===20||mission.order===25;
  return <motion.section initial={{opacity:0,scale:.94}} animate={{opacity:1,scale:1}} className="mx-auto max-w-2xl rounded-[2.5rem] border border-emerald-200 bg-white p-7 text-center shadow-[0_28px_80px_rgba(20,120,77,.16)] sm:p-10">
    <div className="mx-auto w-fit"><FoxProgress label="Amazing work!"/></div>
    <div className="mx-auto mt-7 grid size-16 place-items-center rounded-full bg-emerald-100 text-[#21a46b]"><CheckCircle2 size={34}/></div>
    <p className="mt-5 text-sm font-black uppercase tracking-[.2em] text-[#21a46b]">{checkpoint?"Checkpoint complete":"Mission completed"}</p>
    <h1 className="font-adventure mt-2 text-4xl font-semibold text-[#10233f]">{checkpoint?`${mission.title.toUpperCase()} COMPLETE!`:`${mission.title} cleared!`}</h1>
    <p className="mt-3 font-bold text-[#21a46b]">{mission.activities.length} activities completed</p>
    <div className="mt-7 grid gap-3 sm:grid-cols-3"><Reward icon={<Sparkles/>} value={`${accuracy}%`} label="Score"/><Reward icon={<Star/>} value={`+${mission.xpReward}`} label="XP earned"/><Reward icon={<Award/>} value={mission.badgeReward??"Explorer"} label="Badge earned"/></div>
    {checkpoint&&<div className="mt-5 rounded-2xl bg-[#f5f8fc] p-4 text-left"><p className="font-bold text-[#15365d]">Activity results</p><div className="mt-2 grid grid-cols-2 gap-2 text-sm font-semibold text-[#62708a]">{mission.activities.map((activity,index)=><span key={activity.id}>✓ Challenge {index+1}: {activityResults[index]??100}%</span>)}</div></div>}
    {checkpoint&&<div className="mt-5 rounded-2xl bg-gradient-to-r from-orange-100 to-emerald-100 p-4 font-adventure text-xl font-semibold text-[#15365d]">{mission.order===10?"Stage 2 Unlocked":mission.order===20?"Stage 3 Unlocked":"Superpower Academy Complete!"}</div>}
    {completionConfirmed?(nextMissionTitle?<div className="mt-7 rounded-2xl bg-blue-50 p-4 text-[#125cdb]"><p className="text-xs font-black uppercase tracking-widest">Next mission unlocked</p><p className="font-adventure mt-1 text-xl font-semibold">Mission {mission.order+1}: {nextMissionTitle}</p></div>:<div className="mt-7 rounded-2xl bg-emerald-50 p-4 font-bold text-emerald-700">You completed the final mission in this unit!</div>):<div className="mt-7 rounded-2xl border border-amber-200 bg-amber-50 p-4 text-amber-900"><AlertTriangle className="mx-auto" size={24}/><p className="mt-2 font-black">Progress pending synchronization</p><p className="mt-1 text-sm font-medium">Your answers remain saved on this device, but the next mission is not unlocked yet. Please retry when your connection is available.</p>{completionError&&<p className="mt-2 text-xs" role="alert">{completionError}</p>}{onRetry&&<button type="button" onClick={()=>void onRetry()} disabled={retrying} className="mt-4 inline-flex items-center gap-2 rounded-xl bg-white px-4 py-2 font-bold shadow-sm disabled:opacity-60"><RefreshCcw size={17}/>{retrying?"Syncing…":"Retry sync"}</button>}</div>}
    <Link href={`/student/unit/${mission.unitId}`} className="btn-primary mt-7 w-full sm:w-auto">Continue Adventure</Link>
  </motion.section>;
}

function Reward({icon,value,label}:{icon:React.ReactNode;value:string;label:string}){return <div className="rounded-2xl bg-[#f5f8fc] p-4"><div className="mx-auto w-fit text-[#ff7a1a] [&>svg]:size-5">{icon}</div><p className="mt-2 font-adventure text-xl font-semibold text-[#10233f]">{value}</p><p className="mt-1 text-xs font-bold text-[#62708a]">{label}</p></div>}
