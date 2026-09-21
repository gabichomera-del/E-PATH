"use client";
import { useState } from "react";
import { BookOpen, CheckCircle2, XCircle } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

export function ReadingActivity({ activity, onAnswer }: ActivityProps) {
  const [selected, setSelected] = useState<Record<string, string>>({});
  const [statuses, setStatuses] = useState<Record<string, boolean>>({});
  const items = activity.items;
  const correctCount = Object.values(statuses).filter(Boolean).length;
  const checked = Object.keys(statuses).length > 0;
  const allCorrect = items.length > 0 && correctCount === items.length;
  const allAnswered = items.every((item) => selected[item.id]);
  const passageOnly = items.length === 1 && !(items[0].options?.length);

  function checkAnswers() {
    const next = Object.fromEntries(items.map((item) => [item.id, selected[item.id] === item.answer]));
    const count = Object.values(next).filter(Boolean).length;
    setStatuses(next);
    onAnswer({ correct: count === items.length, score: Math.round((count / items.length) * 100), response: selected });
  }

  if (passageOnly) return <ActivityShell eyebrow="Reading Passage" instructions={activity.instructions}><article className="rounded-3xl bg-[#f4f8ff] p-5 sm:p-7"><div className="mb-4 flex items-center gap-2 font-bold text-[#125cdb]"><BookOpen size={19}/> Read carefully</div><p className="text-lg font-medium leading-8 text-[#263d5c]">{items[0].passage}</p></article><Submit disabled={false} label="Continue to the questions" onClick={()=>onAnswer({correct:true,score:100,response:"read"})}/></ActivityShell>;

  return <ActivityShell eyebrow="Reading Adventure" instructions={activity.instructions}>
    {items[0]?.passage&&<article className="rounded-3xl bg-[#f4f8ff] p-5 sm:p-7"><div className="mb-4 flex items-center gap-2 font-bold text-[#125cdb]"><BookOpen size={19}/> Read carefully</div><p className="text-lg font-medium leading-8 text-[#263d5c]">{items[0].passage}</p></article>}
    <div className="mt-6 grid gap-6">{items.map((item, index) => <fieldset key={item.id} className="rounded-2xl border border-[#dce5f2] p-4"><legend className="px-2 text-lg font-bold text-[#10233f]">{index + 1}. {item.prompt}</legend><div className="mt-3 grid gap-2">{shuffleOptions(item.options??[],`${activity.id}:${item.id}`).map((option) => <button type="button" key={option} disabled={statuses[item.id] === true} onClick={() => { setSelected((current) => ({ ...current, [item.id]: option })); setStatuses((current) => { const next={...current}; delete next[item.id]; return next; }); }} className={`focus-ring rounded-xl border-2 p-3 text-left font-semibold disabled:cursor-not-allowed ${selected[item.id]===option ? statuses[item.id]===true ? "border-emerald-400 bg-emerald-50" : "border-[#125cdb] bg-blue-50" : "border-[#dce5f2]"}`}>{option}</button>)}</div>{statuses[item.id]===true&&<div className="mt-2"><p className="flex items-center gap-2 text-sm font-bold text-emerald-700"><CheckCircle2 size={17}/> Correct! Great reading.</p>{item.explanation&&<p className="mt-1 text-sm font-semibold text-[#31445f]">{item.explanation}</p>}</div>}{statuses[item.id]===false&&<div className="mt-2"><p className="flex items-center gap-2 text-sm font-bold text-red-700"><XCircle size={17}/> Look at the story clues and try again.</p>{item.incorrectExplanation&&<p className="mt-1 text-sm font-semibold text-[#66310e]">{item.incorrectExplanation}</p>}</div>}</fieldset>)}</div>
    {checked&&<p aria-live="polite" className="mt-5 rounded-2xl bg-blue-50 p-4 font-bold text-[#15365d]">Reading score: {correctCount}/{items.length}</p>}
    {!allCorrect&&<Submit disabled={!allAnswered} onClick={checkAnswers}/>} 
  </ActivityShell>;
}
