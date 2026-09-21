import type { Activity, ActivityResult } from "@/lib/learning/types";
import { MatchingActivity } from "@/components/activities/matching-activity";
import { FillBlankActivity } from "@/components/activities/fill-blank-activity";
import { MultipleChoiceActivity } from "@/components/activities/multiple-choice-activity";
import { UnscrambleActivity } from "@/components/activities/unscramble-activity";
import { ReadingActivity } from "@/components/activities/reading-activity";
import { WritingActivity } from "@/components/activities/writing-activity";
import { LearningProfileActivity } from "@/components/activities/learning-profile-activity";
import { NavigationActivity } from "@/components/activities/navigation-activity";
import { ScheduleActivity } from "@/components/activities/schedule-activity";
import { CodeUnlockActivity } from "@/components/activities/code-unlock-activity";
import { ProblemPathActivity } from "@/components/activities/problem-path-activity";
import { GrammarMachineActivity } from "@/components/activities/grammar-machine-activity";
import { SurvivalGuideActivity } from "@/components/activities/survival-guide-activity";
import { GuidedAdviceActivity } from "@/components/activities/guided-advice-activity";
import { MultiSelectActivity } from "@/components/activities/multi-select-activity";
import { SchoolBuilderActivity } from "@/components/activities/school-builder-activity";
import { SchoolScheduleActivity } from "@/components/activities/school-schedule-activity";
import { SchoolProfileActivity } from "@/components/activities/school-profile-activity";
import { CheckpointScheduleActivity } from "@/components/activities/checkpoint-schedule-activity";
import { EvaluatedWritingActivity } from "@/components/activities/evaluated-writing-activity";

const renderers = { matching: MatchingActivity, fill_blank: FillBlankActivity, multiple_choice: MultipleChoiceActivity, unscramble: UnscrambleActivity, reading: ReadingActivity, writing: WritingActivity, learning_profile: LearningProfileActivity, navigation: NavigationActivity, schedule: ScheduleActivity, code_unlock: CodeUnlockActivity, problem_path: ProblemPathActivity, grammar_machine: GrammarMachineActivity, survival_guide: SurvivalGuideActivity, guided_advice: GuidedAdviceActivity, multi_select: MultiSelectActivity, listening: MultipleChoiceActivity, school_builder: SchoolBuilderActivity, school_schedule: SchoolScheduleActivity, school_profile: SchoolProfileActivity, checkpoint_schedule: CheckpointScheduleActivity, evaluated_writing: EvaluatedWritingActivity };
export function ActivityRenderer({ activity, onAnswer, initialResponse, onProgress }: { activity: Activity; onAnswer: (result: ActivityResult) => void; initialResponse?: unknown; onProgress?: (response: unknown) => void }) { const Component=renderers[activity.type]; return <Component activity={activity} onAnswer={onAnswer} initialResponse={initialResponse} onProgress={onProgress}/>; }
