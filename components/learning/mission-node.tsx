"use client";

import type { Mission } from "@/lib/learning/types";
import { MissionNode as WorldMissionNode } from "@/components/student/MissionNode";

/**
 * Compatibility entry point for older imports.
 * The student world-map implementation remains the single visual source of truth.
 */
export function MissionNode({ mission, active }: { mission: Mission; active?: boolean; index?: number }) {
  return <WorldMissionNode mission={mission} active={active ?? mission.status === "available"}/>;
}
