"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { Eye, EyeOff, LogIn } from "lucide-react";
import { signIn } from "@/app/login/actions";
import { domainForRole, isValidInstitutionalEmail } from "@/lib/validation/auth";
import type { UserRole } from "@/lib/types";

const LOGIN_TIMEOUT_MS = 15_000;

function withTimeout<T>(operation: PromiseLike<T>, message: string): Promise<T> {
  let timeoutId: ReturnType<typeof setTimeout>;
  const timeout = new Promise<never>((_, reject) => {
    timeoutId = setTimeout(() => reject(new Error(message)), LOGIN_TIMEOUT_MS);
  });

  return Promise.race([Promise.resolve(operation), timeout]).finally(() => clearTimeout(timeoutId));
}

export function LoginForm({ initialRole }: { initialRole: UserRole }) {
  const [role, setRole] = useState<UserRole>(initialRole);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const router = useRouter();

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault(); setError("");
    const form = new FormData(event.currentTarget); const email = String(form.get("email")); const password = String(form.get("password"));
    if (!isValidInstitutionalEmail(email, role)) return setError(`Use your @${domainForRole(role)} email.`);
    setLoading(true);
    try {
      const result = await withTimeout(
        signIn(email, password, role),
        "Sign in took too long. Please check your connection and try again.",
      );
      if (!result.ok) return setError(result.error);
      router.replace(`/${role}/dashboard`);
    } catch (caughtError) {
      setError(caughtError instanceof Error ? caughtError.message : "Unable to sign in. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return <div><div className="mb-8 grid grid-cols-2 rounded-xl bg-[#edf2f8] p-1" role="tablist">{(["student", "teacher"] as UserRole[]).map(item => <button key={item} type="button" onClick={() => { setRole(item); setError(""); }} className={`focus-ring rounded-lg px-4 py-3 text-sm font-black capitalize transition ${role === item ? "bg-white text-[#125cdb] shadow-sm" : "text-[#62708a]"}`}>{item}</button>)}</div>
    <form onSubmit={submit} className="space-y-5"><div><label className="label" htmlFor="email">Institutional email</label><input className="field" id="email" name="email" type="email" autoComplete="email" placeholder={`name@${domainForRole(role)}`} required /></div><div><label className="label" htmlFor="password">Password</label><div className="relative"><input className="field pr-12" id="password" name="password" type={showPassword ? "text" : "password"} autoComplete="current-password" required/><button type="button" aria-label={showPassword ? "Hide password" : "Show password"} onClick={() => setShowPassword(v => !v)} className="focus-ring absolute right-3 top-3 rounded p-1 text-[#62708a]">{showPassword ? <EyeOff size={20}/> : <Eye size={20}/>}</button></div></div>{error && <p role="alert" className="rounded-xl bg-red-50 p-3 text-sm font-bold text-red-700">{error}</p>}<button className="btn-primary w-full" disabled={loading}>{loading ? "Signing in…" : <><LogIn size={19}/> Continue as {role}</>}</button></form>
    <p className="mt-7 text-center text-sm font-semibold text-[#62708a]">New student? <a className="font-black text-[#125cdb] hover:underline" href="/register">Create your account</a></p></div>;
}
