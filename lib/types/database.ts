export type AppRole = "student" | "teacher" | "admin";
export type ResetStatus = "pending" | "completed" | "expired";

export interface AppUser { id: string; first_name: string; last_name: string; email: string; role: AppRole; created_at: string }
export interface Student { id: string; user_id: string; grade: string; section: string; student_code: string; created_at: string }
export interface Teacher { id: string; user_id: string; created_at: string }
export interface ClassRecord { id: string; teacher_id: string; name: string; grade: string; section: string; academic_year: number; class_code: string; created_at: string; student_count?: number }
export interface ClassMember { id: string; class_id: string; student_id: string; joined_at: string }
export interface PasswordResetRequest { id: string; student_id: string; teacher_id: string; temporary_password: string; created_at: string; status: ResetStatus }

export type LearningProgressStatus = "not_started" | "in_progress" | "completed";
export interface StudentActivityProgress { id: string; student_id: string; activity_id: string; status: LearningProgressStatus; response: unknown; score: number | null; attempt_count: number; completed_at: string | null; updated_at: string }
export interface StudentUnitProgress { id: string; student_id: string; unit_id: string; status: LearningProgressStatus; completed_missions: number; total_xp: number; started_at: string | null; completed_at: string | null; updated_at: string }
export interface StudentXpLedger { id: string; student_id: string; mission_id: string; xp_amount: number; awarded_at: string }
export interface StudentBadge { id: string; student_id: string; mission_id: string; badge_key: string; badge_name: string; earned_at: string }
