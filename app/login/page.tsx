import { AuthShell } from "@/components/auth/auth-shell";
import { LoginForm } from "@/components/auth/login-form";

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ role?: string }> }) {
  const params = await searchParams;
  return <AuthShell title="Choose your learning space" subtitle="Students continue their missions. Teachers open the class view and monitor progress."><LoginForm initialRole={params.role === "teacher" ? "teacher" : "student"}/></AuthShell>;
}
