import type { SupabaseClient } from "@supabase/supabase-js";

export type StudentAnalyticsStatus = "Advanced" | "On Track" | "Needs Support";

export interface AnalyticsClass {
  id: string;
  name: string;
  grade: string;
  section: string;
  academicYear: number;
  classCode: string;
}

export interface StudentPerformance {
  id: string;
  name: string;
  email: string;
  progress: number;
  completedMissions: number;
  xp: number;
  badges: number;
  incorrectAttempts: number;
  recordedActivities: number;
  status: StudentAnalyticsStatus;
}

export interface ClassAlert {
  id: string;
  kind: "low-progress" | "incorrect-attempts" | "limited-activity";
  title: string;
  description: string;
  studentId: string;
}

export interface TeacherClassAnalytics {
  classroom: AnalyticsClass;
  students: StudentPerformance[];
  totalStudents: number;
  averageProgress: number;
  totalXp: number;
  totalBadges: number;
  totalMissions: number;
  distribution: Record<StudentAnalyticsStatus, number>;
  alerts: ClassAlert[];
}

export interface MissionOption {
  id: string;
  unitId: string;
  contentKey: string;
  title: string;
  order: number;
  unitTitle: string;
  unitKey: string;
}

export type ActivityDifficulty = "Low" | "Moderate" | "High" | "Not enough data";

export interface MissionActivityAnalytics {
  id: string;
  title: string;
  type: string;
  order: number;
  completedStudents: number;
  completionRate: number;
  averageScore: number | null;
  attempts: number;
  incorrectAttempts: number;
  difficulty: ActivityDifficulty;
}

export interface MissionStudentActivityDetail {
  id: string;
  title: string;
  status: "not_started" | "in_progress" | "completed";
  score: number | null;
  attempts: number;
  incorrectAttempts: number;
}

export interface MissionStudentPerformance {
  id: string;
  name: string;
  email: string;
  progress: number;
  unitProgress: number;
  completedActivities: number;
  averageScore: number | null;
  attempts: number;
  errors: number;
  missionCompleted: boolean;
  status: StudentAnalyticsStatus;
  activities: MissionStudentActivityDetail[];
}

export interface MissionAnalyticsAlert {
  id: string;
  kind: "low-completion" | "incorrect-attempts" | "stalled-student";
  title: string;
  description: string;
}

export interface TeacherMissionAnalytics {
  missions: MissionOption[];
  selectedMission: MissionOption;
  totalStudents: number;
  studentsWorking: number;
  averageProgress: number;
  totalActivities: number;
  completedActivityRecords: number;
  distribution: Record<StudentAnalyticsStatus, number>;
  activities: MissionActivityAnalytics[];
  students: MissionStudentPerformance[];
  alerts: MissionAnalyticsAlert[];
}

type MemberRow = {
  student_id: string;
  students: {
    users: { first_name: string; last_name: string; email: string } | { first_name: string; last_name: string; email: string }[] | null;
  } | { users: { first_name: string; last_name: string; email: string } | { first_name: string; last_name: string; email: string }[] | null }[] | null;
};

function first<T>(value: T | T[] | null): T | null {
  return Array.isArray(value) ? value[0] ?? null : value;
}

export function getStudentAnalyticsStatus(progress: number): StudentAnalyticsStatus {
  if (progress >= 75) return "Advanced";
  if (progress >= 40) return "On Track";
  return "Needs Support";
}

export async function getTeacherClassAnalytics(
  supabase: SupabaseClient,
  userId: string,
  classId: string,
): Promise<TeacherClassAnalytics | null> {
  const { data: teacher, error: teacherError } = await supabase
    .from("teachers")
    .select("id")
    .eq("user_id", userId)
    .maybeSingle();

  if (teacherError) throw teacherError;
  if (!teacher) return null;

  const { data: classroom, error: classError } = await supabase
    .from("classes")
    .select("id, name, grade, section, academic_year, class_code")
    .eq("id", classId)
    .eq("teacher_id", teacher.id)
    .maybeSingle();

  if (classError) throw classError;
  if (!classroom) return null;

  const [{ data: rawMembers, error: membersError }, { data: rawMissionCatalog, error: missionCatalogError }] = await Promise.all([
    supabase
      .from("class_members")
      .select("student_id, students(users(first_name, last_name, email))")
      .eq("class_id", classId)
      .order("joined_at"),
    supabase.from("missions").select("id, activities(id)"),
  ]);

  if (membersError) throw membersError;
  if (missionCatalogError) throw missionCatalogError;

  const members = (rawMembers ?? []) as unknown as MemberRow[];
  const studentIds = members.map((member) => member.student_id);
  const missionCatalog = (rawMissionCatalog ?? []).map((mission) => ({
    id: mission.id,
    activityIds: ((mission.activities ?? []) as { id: string }[]).map((activity) => activity.id),
  }));
  const totalMissions = missionCatalog.length;
  const totalActivities = missionCatalog.reduce((total, mission) => total + mission.activityIds.length, 0);
  const allActivityIds = missionCatalog.flatMap((mission) => mission.activityIds);

  if (!studentIds.length) {
    return {
      classroom: {
        id: classroom.id,
        name: classroom.name,
        grade: classroom.grade,
        section: classroom.section,
        academicYear: classroom.academic_year,
        classCode: classroom.class_code,
      },
      students: [],
      totalStudents: 0,
      averageProgress: 0,
      totalXp: 0,
      totalBadges: 0,
      totalMissions,
      distribution: { Advanced: 0, "On Track": 0, "Needs Support": 0 },
      alerts: [],
    };
  }

  const [xpResult, badgeResult, attemptResult, activityResult] = await Promise.all([
    supabase.from("student_xp_ledger").select("student_id, xp_amount").in("student_id", studentIds),
    supabase.from("student_badges").select("student_id").in("student_id", studentIds),
    supabase.from("student_attempts").select("student_id, is_correct").in("student_id", studentIds),
    allActivityIds.length
      ? supabase.from("student_activity_progress").select("student_id, activity_id, status").in("student_id", studentIds).in("activity_id", allActivityIds)
      : Promise.resolve({ data: [], error: null }),
  ]);

  for (const result of [xpResult, badgeResult, attemptResult, activityResult]) {
    if (result.error) throw result.error;
  }

  const xpByStudent = new Map<string, number>();
  const badgesByStudent = new Map<string, number>();
  const incorrectByStudent = new Map<string, number>();
  const activitiesByStudent = new Map<string, number>();

  xpResult.data?.forEach(({ student_id, xp_amount }) => xpByStudent.set(student_id, (xpByStudent.get(student_id) ?? 0) + xp_amount));
  badgeResult.data?.forEach(({ student_id }) => badgesByStudent.set(student_id, (badgesByStudent.get(student_id) ?? 0) + 1));
  attemptResult.data?.forEach(({ student_id, is_correct }) => {
    if (!is_correct) incorrectByStudent.set(student_id, (incorrectByStudent.get(student_id) ?? 0) + 1);
  });
  activityResult.data?.forEach(({ student_id }) => activitiesByStudent.set(student_id, (activitiesByStudent.get(student_id) ?? 0) + 1));

  const students = members.map((member): StudentPerformance => {
    const student = first(member.students);
    const account = student ? first(student.users) : null;
    const completedActivityIds = new Set((activityResult.data ?? []).filter((row) => row.student_id === member.student_id && row.status === "completed").map((row) => row.activity_id));
    const completedActivities = completedActivityIds.size;
    const completedMissions = missionCatalog.filter((mission) => mission.activityIds.length > 0 && mission.activityIds.every((activityId) => completedActivityIds.has(activityId))).length;
    const progress = totalActivities ? Math.round((completedActivities / totalActivities) * 100) : 0;
    return {
      id: member.student_id,
      name: account ? `${account.first_name} ${account.last_name}`.trim() : "Student",
      email: account?.email ?? "",
      progress,
      completedMissions,
      xp: xpByStudent.get(member.student_id) ?? 0,
      badges: badgesByStudent.get(member.student_id) ?? 0,
      incorrectAttempts: incorrectByStudent.get(member.student_id) ?? 0,
      recordedActivities: activitiesByStudent.get(member.student_id) ?? 0,
      status: getStudentAnalyticsStatus(progress),
    };
  });

  const distribution: TeacherClassAnalytics["distribution"] = { Advanced: 0, "On Track": 0, "Needs Support": 0 };
  students.forEach((student) => { distribution[student.status] += 1; });

  const alerts: ClassAlert[] = [];
  students.forEach((student) => {
    if (student.progress < 40) alerts.push({
      id: `${student.id}-progress`, kind: "low-progress", studentId: student.id,
      title: `${student.name} needs progress support`,
      description: `${student.progress}% of available learning activities completed (${student.completedMissions}/${totalMissions} missions fully completed).`,
    });
    if (student.incorrectAttempts >= 5) alerts.push({
      id: `${student.id}-attempts`, kind: "incorrect-attempts", studentId: student.id,
      title: `${student.name} has repeated incorrect attempts`,
      description: `${student.incorrectAttempts} incorrect attempts have been recorded.`,
    });
    if (student.recordedActivities <= 2 && student.progress < 40) alerts.push({
      id: `${student.id}-activity`, kind: "limited-activity", studentId: student.id,
      title: `${student.name} has limited recorded activity`,
      description: `${student.recordedActivities} learning activities are currently recorded.`,
    });
  });

  return {
    classroom: {
      id: classroom.id,
      name: classroom.name,
      grade: classroom.grade,
      section: classroom.section,
      academicYear: classroom.academic_year,
      classCode: classroom.class_code,
    },
    students,
    totalStudents: students.length,
    averageProgress: students.length ? Math.round(students.reduce((sum, student) => sum + student.progress, 0) / students.length) : 0,
    totalXp: students.reduce((sum, student) => sum + student.xp, 0),
    totalBadges: students.reduce((sum, student) => sum + student.badges, 0),
    totalMissions,
    distribution,
    alerts,
  };
}

function activityTitle(instructions: string, order: number): string {
  const heading = instructions.split(":")[0]?.trim();
  return heading && heading.length <= 70 ? heading : `Activity ${order}`;
}

function detectedDifficulty(completionRate: number, incorrect: number, attempts: number): ActivityDifficulty {
  if (!attempts && !completionRate) return "Not enough data";
  const errorRate = attempts ? (incorrect / attempts) * 100 : 0;
  if (errorRate >= 50 || completionRate < 40) return "High";
  if (errorRate >= 25 || completionRate < 75) return "Moderate";
  return "Low";
}

export async function getTeacherMissionAnalytics(
  supabase: SupabaseClient,
  userId: string,
  classId: string,
  requestedMissionKey?: string,
): Promise<TeacherMissionAnalytics | null> {
  const { data: teacher, error: teacherError } = await supabase.from("teachers").select("id").eq("user_id", userId).maybeSingle();
  if (teacherError) throw teacherError;
  if (!teacher) return null;

  const { data: classroom, error: classError } = await supabase.from("classes").select("id").eq("id", classId).eq("teacher_id", teacher.id).maybeSingle();
  if (classError) throw classError;
  if (!classroom) return null;

  const [{ data: rawMembers, error: membersError }, { data: rawMissions, error: missionsError }] = await Promise.all([
    supabase.from("class_members").select("student_id, students(users(first_name, last_name, email))").eq("class_id", classId).order("joined_at"),
    supabase.from("missions").select("id, unit_id, content_key, title, sort_order, units!inner(title, content_key, sort_order)").order("sort_order", { referencedTable: "units" }).order("sort_order"),
  ]);
  if (membersError) throw membersError;
  if (missionsError) throw missionsError;

  const members = (rawMembers ?? []) as unknown as MemberRow[];
  const missions = (rawMissions ?? []).map((row) => {
    const unit = first(row.units as { title: string; content_key: string; sort_order: number } | { title: string; content_key: string; sort_order: number }[] | null);
    return { id: row.id, unitId: row.unit_id, contentKey: row.content_key, title: row.title, order: row.sort_order, unitTitle: unit?.title ?? "Unit", unitKey: unit?.content_key ?? "unit" } satisfies MissionOption;
  });
  if (!missions.length) return null;
  const selectedMission = missions.find((mission) => mission.contentKey === requestedMissionKey) ?? missions[0];

  const [{ data: rawActivities, error: activitiesError }, { data: rawUnitMissions, error: unitActivitiesError }] = await Promise.all([
    supabase.from("activities").select("id, type, instructions, sort_order").eq("mission_id", selectedMission.id).order("sort_order"),
    supabase.from("missions").select("activities(id)").eq("unit_id", selectedMission.unitId),
  ]);
  if (activitiesError) throw activitiesError;
  if (unitActivitiesError) throw unitActivitiesError;

  const activityCatalog = (rawActivities ?? []).map((activity) => ({
    id: activity.id,
    title: activityTitle(activity.instructions, activity.sort_order),
    type: activity.type,
    order: activity.sort_order,
  }));
  const activityIds = activityCatalog.map((activity) => activity.id);
  const unitActivityIds = (rawUnitMissions ?? []).flatMap((mission) => ((mission.activities ?? []) as { id: string }[]).map((activity) => activity.id));
  const studentIds = members.map((member) => member.student_id);

  if (!studentIds.length || !activityIds.length) {
    return {
      missions, selectedMission, totalStudents: studentIds.length, studentsWorking: 0, averageProgress: 0,
      totalActivities: activityIds.length, completedActivityRecords: 0,
      distribution: { Advanced: 0, "On Track": 0, "Needs Support": studentIds.length },
      activities: activityCatalog.map((activity) => ({ ...activity, completedStudents: 0, completionRate: 0, averageScore: null, attempts: 0, incorrectAttempts: 0, difficulty: "Not enough data" })),
      students: members.map((member) => {
        const student = first(member.students); const account = student ? first(student.users) : null;
        return { id: member.student_id, name: account ? `${account.first_name} ${account.last_name}`.trim() : "Student", email: account?.email ?? "", progress: 0, unitProgress: 0, completedActivities: 0, averageScore: null, attempts: 0, errors: 0, missionCompleted: false, status: "Needs Support" as const, activities: [] };
      }),
      alerts: [],
    };
  }

  const [activityProgressResult, attemptsResult, missionProgressResult] = await Promise.all([
    supabase.from("student_activity_progress").select("student_id, activity_id, status, score, attempt_count, updated_at").in("student_id", studentIds).in("activity_id", unitActivityIds),
    supabase.from("student_attempts").select("student_id, activity_id, is_correct").in("student_id", studentIds).in("activity_id", activityIds),
    supabase.from("student_mission_progress").select("student_id, status, updated_at").in("student_id", studentIds).eq("mission_id", selectedMission.id),
  ]);
  for (const result of [activityProgressResult, attemptsResult, missionProgressResult]) if (result.error) throw result.error;

  const progressRows = activityProgressResult.data ?? [];
  const missionProgressRows = progressRows.filter((row) => activityIds.includes(row.activity_id));
  const attemptRows = attemptsResult.data ?? [];
  const missionRows = missionProgressResult.data ?? [];
  const studentsWorking = new Set([...missionProgressRows.map((row) => row.student_id), ...missionRows.filter((row) => row.status === "in_progress" || row.status === "completed").map((row) => row.student_id)]).size;

  const activities: MissionActivityAnalytics[] = activityCatalog.map((activity) => {
    const progress = missionProgressRows.filter((row) => row.activity_id === activity.id);
    const completed = progress.filter((row) => row.status === "completed");
    const attempts = attemptRows.filter((row) => row.activity_id === activity.id);
    const scores = progress.map((row) => row.score).filter((score): score is number => score !== null);
    const completionRate = Math.round((completed.length / studentIds.length) * 100);
    const incorrectAttempts = attempts.filter((attempt) => !attempt.is_correct).length;
    return {
      ...activity,
      completedStudents: completed.length,
      completionRate,
      averageScore: scores.length ? Math.round(scores.reduce((sum, score) => sum + score, 0) / scores.length) : null,
      attempts: attempts.length,
      incorrectAttempts,
      difficulty: detectedDifficulty(completionRate, incorrectAttempts, attempts.length),
    };
  });

  const students: MissionStudentPerformance[] = members.map((member) => {
    const student = first(member.students); const account = student ? first(student.users) : null;
    const studentProgress = missionProgressRows.filter((row) => row.student_id === member.student_id);
    const completedUnitActivities = progressRows.filter((row) => row.student_id === member.student_id && row.status === "completed").length;
    const studentAttempts = attemptRows.filter((row) => row.student_id === member.student_id);
    const completedActivities = studentProgress.filter((row) => row.status === "completed").length;
    const progress = Math.round((completedActivities / activityIds.length) * 100);
    const scores = studentProgress.map((row) => row.score).filter((score): score is number => score !== null);
    return {
      id: member.student_id,
      name: account ? `${account.first_name} ${account.last_name}`.trim() : "Student",
      email: account?.email ?? "",
      progress,
      unitProgress: unitActivityIds.length ? Math.round((completedUnitActivities / unitActivityIds.length) * 100) : 0,
      completedActivities,
      averageScore: scores.length ? Math.round(scores.reduce((sum, score) => sum + score, 0) / scores.length) : null,
      attempts: studentAttempts.length,
      errors: studentAttempts.filter((attempt) => !attempt.is_correct).length,
      missionCompleted: completedActivities === activityIds.length && activityIds.length > 0,
      status: getStudentAnalyticsStatus(progress),
      activities: activityCatalog.map((activity) => {
        const row = studentProgress.find((item) => item.activity_id === activity.id);
        const attempts = studentAttempts.filter((item) => item.activity_id === activity.id);
        return { id: activity.id, title: activity.title, status: row?.status ?? "not_started", score: row?.score ?? null, attempts: attempts.length, incorrectAttempts: attempts.filter((attempt) => !attempt.is_correct).length };
      }),
    };
  });

  const distribution: TeacherMissionAnalytics["distribution"] = { Advanced: 0, "On Track": 0, "Needs Support": 0 };
  students.forEach((student) => { distribution[student.status] += 1; });
  const alerts: MissionAnalyticsAlert[] = [];
  if (studentsWorking > 0) activities.filter((activity) => activity.completionRate < 40).forEach((activity) => alerts.push({ id: `${activity.id}-completion`, kind: "low-completion", title: `${activity.title} has low completion`, description: `${activity.completionRate}% of the class has completed this activity.` }));
  activities.filter((activity) => activity.incorrectAttempts >= 5).forEach((activity) => alerts.push({ id: `${activity.id}-attempts`, kind: "incorrect-attempts", title: `${activity.title} needs review`, description: `${activity.incorrectAttempts} incorrect attempts have been recorded.` }));
  const sevenDaysAgo = Date.now() - 7 * 24 * 60 * 60 * 1000;
  missionRows.filter((row) => row.status === "in_progress" && new Date(row.updated_at).getTime() < sevenDaysAgo).forEach((row) => {
    const student = students.find((item) => item.id === row.student_id);
    if (student) alerts.push({ id: `${student.id}-stalled`, kind: "stalled-student", title: `${student.name} may be stalled`, description: "This mission is in progress with no recorded progress update in the last 7 days." });
  });

  return {
    missions, selectedMission, totalStudents: studentIds.length, studentsWorking,
    averageProgress: students.length ? Math.round(students.reduce((sum, student) => sum + student.progress, 0) / students.length) : 0,
    totalActivities: activityIds.length,
    completedActivityRecords: missionProgressRows.filter((row) => row.status === "completed").length,
    distribution, activities, students, alerts,
  };
}
