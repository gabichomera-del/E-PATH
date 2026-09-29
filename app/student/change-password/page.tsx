import Link from "next/link";
import { ArrowLeft, KeyRound, ShieldCheck } from "lucide-react";
import { ChangePasswordForm } from "@/components/student/change-password-form";
import { ProgressHeader } from "@/components/student/ProgressHeader";
import { requireRole } from "@/lib/auth/current-user";

export const dynamic = "force-dynamic";

export default async function ChangePasswordPage() {
  const { profile } = await requireRole("student");

  return (
    <main className="min-h-screen bg-[#071b3d] text-white">
      <ProgressHeader name={profile.first_name} />
      <section className="relative isolate overflow-hidden px-5 py-10 sm:px-8 lg:px-12 lg:py-14">
        <div className="pointer-events-none absolute inset-0 -z-10 bg-[radial-gradient(circle_at_75%_15%,rgba(46,208,255,0.17),transparent_32%),radial-gradient(circle_at_18%_78%,rgba(124,58,237,0.18),transparent_34%),linear-gradient(180deg,#061736_0%,#081f49_100%)]" />
        <div className="mx-auto max-w-xl">
          <Link href="/student/dashboard" className="focus-ring inline-flex items-center gap-2 rounded-xl px-2 py-2 font-bold text-cyan-100 transition hover:bg-white/10 hover:text-white">
            <ArrowLeft size={18} /> Back to dashboard
          </Link>
          <section className="mt-6 overflow-hidden rounded-[2rem] border border-cyan-200/20 bg-white text-[#10233f] shadow-[0_28px_80px_rgba(0,0,0,0.32)]">
            <div className="border-b border-[#dce5f2] bg-gradient-to-r from-[#edf7ff] to-[#fff7ed] p-6 sm:p-8">
              <div className="grid size-14 place-items-center rounded-2xl bg-[#125cdb] text-white shadow-lg shadow-blue-200">
                <KeyRound size={27} />
              </div>
              <p className="mt-5 text-xs font-black uppercase tracking-[0.18em] text-[#125cdb]">Account security</p>
              <h1 className="font-adventure mt-2 text-3xl font-semibold sm:text-4xl">Change Password</h1>
              <p className="mt-3 font-medium leading-7 text-[#62708a]">Confirm your current password, then choose a new password for your E.P.A.T.H. account.</p>
            </div>
            <div className="p-6 sm:p-8">
              <div className="mb-6 flex items-start gap-3 rounded-2xl border border-blue-100 bg-blue-50 p-4 text-sm font-semibold leading-6 text-[#31445f]">
                <ShieldCheck className="mt-0.5 shrink-0 text-[#21a46b]" size={21} />
                <p>After the password is updated, you will be signed out securely. Sign in again using your new password.</p>
              </div>
              <ChangePasswordForm />
            </div>
          </section>
        </div>
      </section>
    </main>
  );
}
