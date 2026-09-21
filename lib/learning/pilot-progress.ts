import type { AttemptRecord, MissionStatus } from "@/lib/learning/types";

export type SavedMissionProgress = {
  missionId: string;
  status: MissionStatus;
  score: number;
  xpEarned: number;
  completedAt: string;
};

export type SavedUnitCompletion = {
  unitId: string;
  status: "COMPLETED";
  completedMissionCount: number;
  totalMissions: number;
  totalXp: number;
  badges: string[];
  completedAt: string;
};

const progressKey = "epath:unit-6:mission-progress";
const legacyProgressKey = "epath:unit-1:mission-progress";
const unitCompletionKey = "epath:unit-6:completion";

export type LearningStatus = "NOT_STARTED" | "IN_PROGRESS" | "COMPLETED";
export type SavedActivityProgress = { status: LearningStatus; answer: unknown; score: number };
export type MissionResume = { missionId: string; status: LearningStatus; currentActivityIndex: number; activities: Record<string, SavedActivityProgress>; attempts?: AttemptRecord[]; updatedAt: string; livesRemaining?: number; finalScore?: number; xpEarned?: number; completedAt?: string };
function resumeKey(missionId: string) { return `epath:mission:${missionId}:resume`; }
export function readMissionResume(missionId: string): MissionResume | null { if(typeof window==="undefined")return null;try{return JSON.parse(window.localStorage.getItem(resumeKey(missionId))??"null")}catch{return null} }
export function saveMissionResume(progress: MissionResume) { if(typeof window!=="undefined")window.localStorage.setItem(resumeKey(progress.missionId),JSON.stringify(progress)); }

export function readPilotProgress(): SavedMissionProgress[] {
  if (typeof window === "undefined") return [];
  try {
    const saved = window.localStorage.getItem(progressKey);
    if (saved) {
      const value = JSON.parse(saved);
      return Array.isArray(value) ? value.filter(isUnit6Progress) : [];
    }

    const legacy = JSON.parse(window.localStorage.getItem(legacyProgressKey) ?? "[]");
    const migrated = Array.isArray(legacy) ? legacy.filter(isUnit6Progress) : [];
    if (migrated.length) window.localStorage.setItem(progressKey, JSON.stringify(migrated));
    return migrated;
  } catch {
    return [];
  }
}

export function savePilotProgress(progress: SavedMissionProgress) {
  if (typeof window === "undefined") return;
  const current = readPilotProgress().filter((item) => item.missionId !== progress.missionId);
  window.localStorage.setItem(progressKey, JSON.stringify([...current, progress]));
}

export function readUnit6Completion(): SavedUnitCompletion | null {
  if (typeof window === "undefined") return null;
  try {
    const value = JSON.parse(window.localStorage.getItem(unitCompletionKey) ?? "null");
    return value?.unitId === "unit-6" && value?.status === "COMPLETED" ? value : null;
  } catch {
    return null;
  }
}

export function finalizeUnit6Completion(missions: { id: string; xpReward: number; badgeReward?: string }[]): SavedUnitCompletion | null {
  if (typeof window === "undefined") return null;
  const progress = readPilotProgress();
  const completedById = new Map(progress.filter((item) => item.status === "completed").map((item) => [item.missionId, item]));
  const completed = missions.filter((mission) => completedById.has(mission.id));
  if (completed.length !== missions.length || missions.length !== 25) return null;
  const badges = [...new Set(completed.map((mission) => mission.badgeReward).filter((badge): badge is string => Boolean(badge)))];
  const record: SavedUnitCompletion = {
    unitId: "unit-6",
    status: "COMPLETED",
    completedMissionCount: completed.length,
    totalMissions: missions.length,
    totalXp: completed.reduce((total, mission) => total + (completedById.get(mission.id)?.xpEarned ?? 0), 0),
    badges,
    completedAt: new Date().toISOString(),
  };
  window.localStorage.setItem(unitCompletionKey, JSON.stringify(record));
  return record;
}

function isUnit6Progress(value: unknown): value is SavedMissionProgress {
  return typeof value === "object" && value !== null && "missionId" in value && String(value.missionId).startsWith("unit-6-");
}
