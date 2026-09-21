import type { Unit } from "@/lib/learning/types";
import { unit6Missions } from "@/lib/learning/unit-6";

export const sampleUnits: Unit[] = [
  { id: "unit-6", gradeId: "grade-6", number: 6, title: "Superpowers", description: "Special abilities, can for ability, responsible choices, reading inference, and guided hero writing.", order: 6, missions: unit6Missions },
];

export function getSampleUnit(id: string) { return sampleUnits.find((unit) => unit.id === id || String(unit.number) === id); }
export function getSampleMission(id: string) {
  const numericOrder = /^\d+$/.test(id) ? Number(id) : null;
  return sampleUnits.flatMap((unit) => unit.missions).find((mission) => mission.id === id || mission.id === `mission-${id}` || (numericOrder !== null && mission.order === numericOrder));
}
