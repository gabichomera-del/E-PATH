"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowRight, CheckCircle2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { domainForRole, isValidInstitutionalEmail } from "@/lib/validation/auth";
import type { UserRole } from "@/lib/types";

export function RegisterForm() {
  const [role, setRole] = useState<UserRole>("student"); const [loading, setLoading] = useState(false); const [error, setError] = useState(""); const [sent, setSent] = useState(false); const router = useRouter();
  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault(); setError(""); const f = new FormData(event.currentTarget); const email = String(f.get("email"));
    if (!isValidInstitutionalEmail(email, role)) return setError(`Use your @${domainForRole(role)} email.`);
    const supabase = createClient(); if (!supabase) return setError("Supabase is not configured yet. Add the environment variables to connect registration.");
    setLoading(true);
    if (role === "student") {
      const classCode = String(f.get("classCode") ?? "").trim().toUpperCase();
      const { data: validCode, error: codeError } = await supabase.rpc("validate_class_code", { requested_code: classCode });
      if (codeError || !validCode) { setError("That class code is not valid. Ask your teacher to check it."); setLoading(false); return; }
    }
    const { data, error: signUpError } = await supabase.auth.signUp({ email, password: String(f.get("password")), options: { data: { first_name: f.get("firstName"), last_name: f.get("lastName"), role, grade: role === "student" ? f.get("grade") : null, section: role === "student" ? f.get("section") : null, class_code: role === "student" ? f.get("classCode") : null } } });
    if (signUpError) { setError(signUpError.message); setLoading(false); return; }
    if (data.session) { router.push(`/${role}/dashboard`); router.refresh(); } else { setSent(true); setLoading(false); }
  }
  if (sent) return <div className="py-12 text-center"><CheckCircle2 className="mx-auto text-[#21a46b]" size={54}/><h2 className="mt-5 text-2xl font-black">Check your inbox</h2><p className="mx-auto mt-3 max-w-md font-semibold text-[#62708a]">We sent a confirmation link to your institutional email. Confirm it to begin your E-P.A.T.H.</p></div>;
  return <div><div className="mb-7 grid grid-cols-2 rounded-xl bg-[#edf2f8] p-1">{(["student", "teacher"] as UserRole[]).map(item => <button key={item} type="button" onClick={() => { setRole(item); setError(""); }} className={`focus-ring rounded-lg px-4 py-3 text-sm font-black capitalize ${role === item ? "bg-white text-[#125cdb] shadow-sm" : "text-[#62708a]"}`}>{item}</button>)}</div><form onSubmit={submit} className="grid gap-5 sm:grid-cols-2"><div><label className="label" htmlFor="firstName">First name</label><input className="field" id="firstName" name="firstName" autoComplete="given-name" required/></div><div><label className="label" htmlFor="lastName">Last name</label><input className="field" id="lastName" name="lastName" autoComplete="family-name" required/></div><div className="sm:col-span-2"><label className="label" htmlFor="email">Institutional email</label><input className="field" id="email" name="email" type="email" autoComplete="email" placeholder={`name@${domainForRole(role)}`} required/></div><div className="sm:col-span-2"><label className="label" htmlFor="password">Password</label><input className="field" id="password" name="password" type="password" minLength={8} autoComplete="new-password" placeholder="At least 8 characters" required/></div>{role === "student" && <><div><label className="label" htmlFor="grade">Grade</label><select className="field" id="grade" name="grade" defaultValue="6" required><option value="6">6th Grade</option></select></div><div><label className="label" htmlFor="section">Section</label><input className="field" id="section" name="section" placeholder="e.g. A" maxLength={10} required/></div><div className="sm:col-span-2"><label className="label" htmlFor="classCode">Class code</label><input className="field uppercase" id="classCode" name="classCode" placeholder="Enter the code from your teacher" required/></div></>}{error && <p role="alert" className="rounded-xl bg-red-50 p-3 text-sm font-bold text-red-700 sm:col-span-2">{error}</p>}<button className="btn-primary sm:col-span-2" disabled={loading}>{loading ? "Creating account…" : <>Create {role} account <ArrowRight size={19}/></>}</button></form><p className="mt-7 text-center text-sm font-semibold text-[#62708a]">Already registered? <a href="/login" className="font-black text-[#125cdb] hover:underline">Sign in</a></p></div>;
}
