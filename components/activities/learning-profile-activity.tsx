"use client";

import { useMemo, useState } from "react";
import { Sparkles } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

type Profile = { subject: string; reason: string; preferredActivity: string };

export function LearningProfileActivity({ activity, onAnswer, initialResponse, onProgress }: ActivityProps) {
  const item = activity.items[0];
  const initial = typeof initialResponse === "object" && initialResponse ? initialResponse as Partial<Profile> : {};
  const [profile, setProfile] = useState<Profile>({ subject: initial.subject??"", reason: initial.reason??"", preferredActivity: initial.preferredActivity??"" });
  const subjects = useMemo(() => shuffleOptions(item.options??[], `${activity.id}:subjects`), [activity.id, item.options]);
  const reasons = useMemo(() => shuffleOptions(["It is interesting", "It is creative", "It is useful", "It is exciting", "I enjoy challenging myself"], `${activity.id}:reasons`), [activity.id]);
  const preferredActivities = useMemo(() => shuffleOptions(["reading and writing", "solving problems", "doing experiments", "creating projects", "practicing or performing"], `${activity.id}:activities`), [activity.id]);
  const complete = Boolean(profile.subject && profile.reason && profile.preferredActivity);
  function update(field: keyof Profile, value: string) { const next={...profile,[field]:value};setProfile(next);onProgress?.(next); }
  return <ActivityShell eyebrow="My Learning Profile" instructions={activity.instructions}>
    <div className="grid gap-4 sm:grid-cols-3"><Choice label="Favorite subject" value={profile.subject} options={subjects} onChange={(value)=>update("subject",value)}/><Choice label="Reason" value={profile.reason} options={reasons} onChange={(value)=>update("reason",value)}/><Choice label="Preferred activity" value={profile.preferredActivity} options={preferredActivities} onChange={(value)=>update("preferredActivity",value)}/></div>
    {complete&&<div className="mt-6 rounded-3xl border border-emerald-200 bg-gradient-to-br from-emerald-50 to-blue-50 p-5 text-center"><Sparkles className="mx-auto text-[#ff8426]"/><p className="mt-2 text-xs font-black uppercase tracking-widest text-[#21a46b]">My Learning Profile</p><h3 className="font-adventure mt-2 text-2xl font-semibold text-[#10233f]">{profile.subject} Explorer</h3><p className="mt-2 font-medium text-[#31445f]">I like {profile.subject} because {profile.reason.toLowerCase()}. I prefer {profile.preferredActivity}.</p></div>}
    <Submit disabled={!complete} label="Save my profile" onClick={()=>onAnswer({correct:true,score:100,response:profile})}/>
  </ActivityShell>;
}

function Choice({label,value,options,onChange}:{label:string;value:string;options:string[];onChange:(value:string)=>void}){return <label className="font-bold text-[#31445f]">{label}<select value={value} onChange={(event)=>onChange(event.target.value)} className="field mt-2"><option value="">Choose one</option>{options.map((option)=><option key={option}>{option}</option>)}</select></label>}
