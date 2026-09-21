"use client";

import { createClient } from "@/lib/supabase/client";
import type { AttemptRecord } from "@/lib/learning/types";
import type { MissionResume, SavedUnitCompletion } from "@/lib/learning/pilot-progress";

async function context() {
  const supabase=createClient(); if(!supabase)return null;
  const {data:{user}}=await supabase.auth.getUser(); if(!user)return null;
  const {data:student}=await supabase.from("students").select("id").eq("user_id",user.id).maybeSingle();
  return student?{supabase,studentId:student.id as string}:null;
}

export async function startRemoteMission(missionKey:string){const ctx=await context();if(!ctx)return false;const {error}=await ctx.supabase.rpc("start_learning_mission",{p_mission_key:missionKey});return !error}

export async function loadRemoteMissionResume(missionKey:string):Promise<MissionResume|null>{
  const ctx=await context();if(!ctx)return null;
  const {data:mission}=await ctx.supabase.from("missions").select("id, activities(id,content_key,sort_order)").eq("content_key",missionKey).maybeSingle();if(!mission)return null;
  const activities=[...((mission.activities??[]) as {id:string;content_key:string;sort_order:number}[])].sort((a,b)=>a.sort_order-b.sort_order);
  const {data:progress}=await ctx.supabase.from("student_mission_progress").select("status,current_activity_id,lives_remaining,score,xp_earned,completed_at,updated_at").eq("student_id",ctx.studentId).eq("mission_id",mission.id).maybeSingle();if(!progress)return null;
  const ids=activities.map(a=>a.id);const keyById=new Map(activities.map(a=>[a.id,a.content_key]));
  const {data:activityRows}=ids.length?await ctx.supabase.from("student_activity_progress").select("activity_id,status,response,score,attempt_count").eq("student_id",ctx.studentId).in("activity_id",ids):{data:[]};
  const {data:attemptRows}=ids.length?await ctx.supabase.from("student_attempts").select("activity_id,attempt_number,score,lives_remaining,response,is_correct").eq("student_id",ctx.studentId).in("activity_id",ids).order("attempted_at"):{data:[]};
  const saved=Object.fromEntries((activityRows??[]).map(row=>[keyById.get(row.activity_id)??row.activity_id,{status:row.status==="completed"?"COMPLETED":"IN_PROGRESS",answer:row.response,score:Number(row.score??0)}]));
  const attempts:AttemptRecord[]=(attemptRows??[]).map(row=>({activityId:keyById.get(row.activity_id)??row.activity_id,attemptNumber:row.attempt_number,score:Number(row.score),livesRemaining:row.lives_remaining,response:row.response,correct:row.is_correct}));
  const current=Math.max(0,activities.findIndex(a=>a.id===progress.current_activity_id));
  return {missionId:missionKey,status:progress.status==="completed"?"COMPLETED":"IN_PROGRESS",currentActivityIndex:current,activities:saved,attempts,updatedAt:progress.updated_at,livesRemaining:progress.lives_remaining,finalScore:progress.score==null?undefined:Number(progress.score),xpEarned:progress.xp_earned,completedAt:progress.completed_at??undefined};
}

export async function saveRemoteActivity(input:{activityKey:string;response:unknown;score:number;correct:boolean;livesRemaining:number;attemptNumber:number}){const ctx=await context();if(!ctx)return false;const {error}=await ctx.supabase.rpc("save_learning_activity",{p_activity_key:input.activityKey,p_response:input.response,p_score:input.score,p_is_correct:input.correct,p_lives_remaining:input.livesRemaining,p_attempt_number:input.attemptNumber});return !error}

export async function saveRemoteActivityDraft(activityKey:string,response:unknown,livesRemaining:number){const ctx=await context();if(!ctx)return false;const {error}=await ctx.supabase.rpc("save_learning_activity_draft",{p_activity_key:activityKey,p_response:response,p_lives_remaining:livesRemaining});return !error}

export async function completeRemoteMission(missionKey:string){const ctx=await context();if(!ctx)return null;const {data,error}=await ctx.supabase.rpc("complete_learning_mission",{p_mission_key:missionKey});if(error)return null;return Array.isArray(data)?data[0]:data}

export async function loadRemoteUnitCompletion(unitKey:string):Promise<SavedUnitCompletion|null>{const ctx=await context();if(!ctx)return null;const {data:unit}=await ctx.supabase.from("units").select("id").eq("content_key",unitKey).maybeSingle();if(!unit)return null;const {data:progress}=await ctx.supabase.from("student_unit_progress").select("status,completed_missions,total_xp,completed_at").eq("student_id",ctx.studentId).eq("unit_id",unit.id).maybeSingle();if(progress?.status!=="completed")return null;const {data:badges}=await ctx.supabase.from("student_badges").select("badge_name,missions!inner(unit_id)").eq("student_id",ctx.studentId).eq("missions.unit_id",unit.id);return {unitId:unitKey,status:"COMPLETED",completedMissionCount:progress.completed_missions,totalMissions:25,totalXp:progress.total_xp,badges:(badges??[]).map(row=>row.badge_name),completedAt:progress.completed_at};}
