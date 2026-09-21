export type MissionStatus = "locked" | "available" | "completed";
export type ActivityType = "matching" | "fill_blank" | "multiple_choice" | "unscramble" | "reading" | "writing" | "learning_profile" | "navigation" | "schedule" | "code_unlock" | "problem_path" | "grammar_machine" | "survival_guide" | "guided_advice" | "multi_select" | "listening" | "school_builder" | "school_schedule" | "school_profile" | "checkpoint_schedule" | "evaluated_writing";
export type Difficulty = "starter" | "explorer" | "challenger";

export interface ActivityItem {
  id: string;
  databaseId?: string;
  prompt: string;
  answer: string | string[];
  options?: string[];
  pairs?: { left: string; right: string }[];
  passage?: string;
  minWords?: number;
  minSentences?: number;
  maxSentences?: number;
  sentenceStarters?: string[];
  writingRequirements?: { label: string; pattern: string; message: string }[];
  requireSecondConditional?: boolean;
  explanation?: string;
  incorrectExplanation?: string;
  codePart?: string;
}

export interface Activity {
  id: string;
  databaseId?: string;
  missionId: string;
  type: ActivityType;
  instructions: string;
  correctFeedback?: string;
  incorrectFeedback?: string;
  unlockLabel?: string;
  completionMessage?: string;
  sequential?: boolean;
  audioScript?: string;
  schedule?: { time: string; subjects: Record<string, string> }[];
  items: ActivityItem[];
}

export interface Mission {
  id: string;
  databaseId?: string;
  unitId: string;
  title: string;
  objective: string;
  description: string;
  order: number;
  difficulty: Difficulty;
  xpReward: number;
  badgeReward?: string;
  status: MissionStatus;
  location: string;
  mapPosition: { x: number; y: number };
  activities: Activity[];
}

export interface Unit {
  id: string;
  databaseId?: string;
  gradeId: string;
  number: number;
  title: string;
  description: string;
  order: number;
  missions: Mission[];
}

export interface ActivityResult {
  correct: boolean;
  score: number;
  response: unknown;
}

export interface AttemptRecord {
  activityId: string;
  attemptNumber: number;
  score: number;
  livesRemaining: number;
  response: unknown;
  correct: boolean;
}
