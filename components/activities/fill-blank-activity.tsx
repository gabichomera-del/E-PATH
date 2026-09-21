"use client";
import { useState } from "react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";

export function FillBlankActivity({ activity, onAnswer, initialResponse, onProgress }: ActivityProps) { const item=activity.items[0]; const [value,setValue]=useState(typeof initialResponse==="string"?initialResponse:""); const correct=String(item.answer).toLowerCase().trim()===value.toLowerCase().trim(); return <ActivityShell eyebrow="Complete the clue" instructions={activity.instructions}><p className="rounded-2xl bg-blue-50 p-5 text-xl font-semibold leading-9 text-[#15365d]">{item.prompt}</p><label className="label mt-6" htmlFor="blank-answer">Your word</label><input id="blank-answer" value={value} onChange={(e)=>{setValue(e.target.value);onProgress?.(e.target.value)}} className="field max-w-md" placeholder="Type the missing word"/><Submit disabled={!value.trim()} onClick={()=>onAnswer({correct,score:correct?100:0,response:value})}/></ActivityShell>; }
