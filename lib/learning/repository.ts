import { createClient } from "@/lib/supabase/server";
import { getSampleMission, getSampleUnit } from "@/lib/learning/sample-curriculum";
import type { Activity, ActivityItem, Mission, MissionStatus, Unit } from "@/lib/learning/types";

type DbActivityItem = { id: string; content_key?: string; content: Record<string, unknown> | null; answer: unknown; sort_order?: number };
type DbActivity = { id: string; content_key?: string; mission_id: string; type: Activity["type"]; instructions: string; sort_order?: number; metadata?: Record<string, unknown>; activity_items: DbActivityItem[] };
type DbMission = { id: string; content_key?: string; unit_id: string; title: string; objective?: string; description: string; sort_order: number; difficulty: Mission["difficulty"]; xp_reward: number; badge_reward?: string; location?: string; map_x?: number; map_y?: number; activities: DbActivity[] };

export async function getUnit(id: string): Promise<Unit | undefined> {
  const supabase = await createClient();
  if (!supabase) return getSampleUnit(id);
  const query = supabase.from("units").select("*, missions(*, activities(*, activity_items(*)))");
  const { data, error } = await (/^[0-9a-f-]{36}$/i.test(id) ? query.eq("id", id) : query.eq("content_key", id)).maybeSingle();
  if (error || !data) return getSampleUnit(id);
  const ordered = [...(data.missions as DbMission[])].sort((a, b) => a.sort_order - b.sort_order);
  const { data: auth } = await supabase.auth.getUser();
  const missionIds = ordered.map((mission) => mission.id);
  const { data: student } = auth.user ? await supabase.from("students").select("id").eq("user_id", auth.user.id).maybeSingle() : { data: null };
  const progress = student && missionIds.length
    ? await supabase.from("student_mission_progress").select("mission_id, status").eq("student_id", student.id).in("mission_id", missionIds)
    : { data: [] };
  const savedStatuses = new Map((progress.data ?? []).map((entry) => [entry.mission_id, entry.status as MissionStatus]));
  const missions = ordered.map((mission, index) => {
    const saved = savedStatuses.get(mission.id);
    const priorCompleted = index === 0 || savedStatuses.get(ordered[index - 1].id) === "completed";
    return mapMission(mission, saved === "completed" ? "completed" : priorCompleted ? "available" : "locked");
  });
  return { id: data.content_key ?? id, databaseId: data.id, gradeId: data.grade_id, number: data.sort_order, title: data.title, description: data.description, order: data.sort_order, missions };
}

export async function getMission(id: string): Promise<Mission | undefined> {
  const supabase = await createClient();
  if (!supabase) return getSampleMission(id);
  const query = supabase.from("missions").select("*, activities(*, activity_items(*))");
  const { data, error } = /^\d+$/.test(id) ? await query.eq("sort_order", Number(id)).limit(1).maybeSingle() : /^[0-9a-f-]{36}$/i.test(id) ? await query.eq("id", id).maybeSingle() : await query.eq("content_key", id).maybeSingle();
  if (error || !data) return getSampleMission(id);
  const mapped=mapMission(data as DbMission,"available");
  const unit=await getUnit(mapped.unitId);
  return unit?.missions.find((mission)=>mission.id===mapped.id)??mapped;
}

function mapMission(mission: DbMission, status: MissionStatus): Mission {
  const activities = [...(mission.activities ?? [])]
    .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))
    .map((activity) => ({
      id: activity.content_key ?? activity.id,
      databaseId: activity.id,
      missionId: mission.content_key ?? mission.id,
      type: activity.type,
      instructions: activity.instructions,
      ...(activity.metadata ?? {}),
      items: [...(activity.activity_items ?? [])].sort((a,b)=>(a.sort_order??0)-(b.sort_order??0)).map((item): ActivityItem => {
        const content = item.content ?? {};
        return {
          id: item.content_key ?? item.id,
          databaseId: item.id,
          prompt: String(content.prompt ?? ""),
          answer: item.answer as string | string[],
          options: Array.isArray(content.options) ? content.options.map(String) : undefined,
          pairs: Array.isArray(content.pairs) ? content.pairs as ActivityItem["pairs"] : undefined,
          passage: typeof content.passage === "string" ? content.passage : undefined,
          minWords: typeof content.minWords === "number" ? content.minWords : undefined,
          minSentences: typeof content.minSentences === "number" ? content.minSentences : undefined,
          maxSentences: typeof content.maxSentences === "number" ? content.maxSentences : undefined,
          sentenceStarters: Array.isArray(content.sentenceStarters) ? content.sentenceStarters.map(String) : undefined,
          writingRequirements: Array.isArray(content.writingRequirements) ? content.writingRequirements as ActivityItem["writingRequirements"] : undefined,
          requireSecondConditional: typeof content.requireSecondConditional === "boolean" ? content.requireSecondConditional : undefined,
          explanation: typeof content.explanation === "string" ? content.explanation : undefined,
          incorrectExplanation: typeof content.incorrectExplanation === "string" ? content.incorrectExplanation : undefined,
          codePart: typeof content.codePart === "string" ? content.codePart : undefined,
        };
      }),
    }));
  const fallbackX = 10 + ((mission.sort_order - 1) % 7) * 13;
  const fallbackY = 84 - Math.floor((mission.sort_order - 1) / 7) * 20;
  return { id: mission.content_key ?? mission.id, databaseId: mission.id, unitId: "unit-6", title: mission.title, objective: mission.objective || mission.description, description: mission.description, order: mission.sort_order, difficulty: mission.difficulty, xpReward: mission.xp_reward, badgeReward: mission.badge_reward, status, location: mission.location ?? "Campus checkpoint", mapPosition: { x: mission.map_x ?? fallbackX, y: mission.map_y ?? fallbackY }, activities };
}
