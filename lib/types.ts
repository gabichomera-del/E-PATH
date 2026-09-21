export type UserRole = "student" | "teacher";

export interface RegistrationData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  role: UserRole;
  grade?: string;
  section?: string;
  classCode?: string;
}
