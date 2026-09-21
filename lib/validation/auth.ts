import type { UserRole } from "@/lib/types";

const ROLE_DOMAINS: Record<UserRole, string> = {
  student: "alumnos.innovaschools.edu.pe",
  teacher: "innovaschools.edu.pe",
};

export function isValidInstitutionalEmail(email: string, role: UserRole) {
  const normalized = email.trim().toLowerCase();
  return normalized.endsWith(`@${ROLE_DOMAINS[role]}`) && normalized.split("@").length === 2;
}

export function domainForRole(role: UserRole) { return ROLE_DOMAINS[role]; }
