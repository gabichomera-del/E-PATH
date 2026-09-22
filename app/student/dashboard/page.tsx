import { redirect } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import { ArrowRight, Map, Sparkles, Zap } from "lucide-react";
import { ProgressHeader } from "@/components/student/ProgressHeader";
import { getUnit } from "@/lib/learning/repository";
import { createClient } from "@/lib/supabase/server";
import { getStudentEnrollment } from "@/lib/database/classes";
import { UnitDashboardStatus } from "@/components/student/unit-dashboard-status";
import { FoxMascot } from "@/components/student/FoxMascot";

export const dynamic = "force-dynamic";

export default async function StudentDashboard() {
  const supabase = await createClient();
  let user = null;
  let profile: { first_name: string; role: string } | null = null;
  let enrollment: Awaited<ReturnType<typeof getStudentEnrollment>> = null;
  if (supabase) {
    const result = await supabase.auth.getUser();
    user = result.data.user;
    if (!user) redirect("/login?role=student");
    const profileResult = await supabase.from("users").select("first_name, role").eq("id", user.id).single(); profile = profileResult.data;
    if (profile?.role !== "student") redirect("/teacher/dashboard");
    enrollment = await getStudentEnrollment(supabase, user.id);
  }
  const unit = await getUnit("unit-6");
  if (!unit) return null;
  const completedMissions=unit.missions.filter((mission)=>mission.status==="completed").length;
  const name = profile?.first_name || "Explorer";
  const classroom = Array.isArray(enrollment?.classroom) ? enrollment?.classroom[0] : enrollment?.classroom;
  return <main className="min-h-screen bg-[#071b3d] text-white">
    <ProgressHeader name={name} context={enrollment ? `Grade ${enrollment.student.grade} · ${classroom?.name ?? "No class"}` : undefined}/>
    <section id="my-units" className="relative isolate overflow-hidden px-5 py-10 sm:px-8 lg:px-12 lg:py-14">
      <div className="pointer-events-none absolute inset-0 -z-10 bg-[radial-gradient(circle_at_75%_15%,rgba(46,208,255,0.17),transparent_32%),radial-gradient(circle_at_18%_78%,rgba(124,58,237,0.18),transparent_34%),linear-gradient(180deg,#061736_0%,#081f49_100%)]"/>
      <div className="mx-auto max-w-6xl">
        <div className="mb-7 max-w-2xl">
          <div className="mb-3 inline-flex items-center gap-2 rounded-full border border-cyan-300/25 bg-cyan-300/10 px-4 py-2 text-xs font-black uppercase tracking-[0.2em] text-cyan-100"><Sparkles className="h-4 w-4"/> My Units</div>
          <h1 className="font-adventure text-4xl leading-tight text-white sm:text-5xl">Choose your learning adventure</h1>
          <p className="mt-3 text-base font-semibold text-blue-100/75 sm:text-lg">Your available English world is ready. Enter the academy and begin your hero training.</p>
        </div>
        <Link href="/student/unit/unit-6" className="group relative block min-h-[430px] overflow-hidden rounded-[2rem] border border-cyan-200/25 bg-[#071b42] shadow-[0_28px_80px_rgba(0,0,0,0.35)] transition duration-300 hover:-translate-y-1 hover:border-cyan-200/50 hover:shadow-[0_34px_90px_rgba(24,164,255,0.25)] focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-cyan-300/60">
          <Image src="/assets/worlds/unit-6-superpowers.png" alt="Superpower Academy floating-island world" fill priority sizes="(max-width: 1200px) 100vw, 1152px" className="object-cover object-center transition duration-700 group-hover:scale-[1.025]"/>
          <div className="absolute inset-0 bg-gradient-to-r from-[#04132f]/95 via-[#061a3c]/72 to-[#061a3c]/15"/>
          <div className="absolute inset-0 bg-gradient-to-t from-[#04112c] via-transparent to-transparent"/>
          <div className="pointer-events-none absolute bottom-2 right-[8%] hidden md:block" aria-hidden="true"><span className="absolute inset-0 rounded-full bg-cyan-300/20 blur-3xl"/><FoxMascot heroMentor hero mood="progress"/></div>
          <div className="relative flex min-h-[430px] max-w-2xl flex-col justify-between p-7 sm:p-10">
            <div className="flex flex-wrap gap-3"><span className="rounded-full border border-white/25 bg-white/12 px-4 py-2 text-xs font-black uppercase tracking-[0.18em] backdrop-blur-md">Unit 6</span><UnitDashboardStatus variant="badge" completed={completedMissions}/></div>
            <div>
              <div className="mb-4 flex h-14 w-14 items-center justify-center rounded-2xl border border-cyan-200/30 bg-cyan-300/15 shadow-[0_0_35px_rgba(34,211,238,0.3)] backdrop-blur-md"><Zap className="h-7 w-7 fill-cyan-200 text-cyan-200"/></div>
              <p className="text-sm font-black uppercase tracking-[0.24em] text-cyan-200">Superpower Academy</p>
              <h2 className="font-adventure mt-2 text-4xl text-white sm:text-6xl">{unit.title}</h2>
              <p className="mt-3 max-w-xl text-base font-semibold leading-relaxed text-blue-50/80 sm:text-lg">Discover your abilities, train your English powers, and advance through 25 hero missions.</p>
              <UnitDashboardStatus variant="progress" completed={completedMissions}/>
              <div className="mt-7 flex flex-wrap items-center gap-4"><span className="inline-flex items-center gap-2 rounded-2xl bg-white/10 px-4 py-3 text-sm font-bold backdrop-blur-md"><Map className="h-5 w-5 text-cyan-200"/> 25 missions</span><span className="inline-flex items-center gap-2 rounded-2xl bg-gradient-to-r from-orange-500 to-amber-400 px-5 py-3 text-sm font-black text-white shadow-lg shadow-orange-950/30 transition group-hover:brightness-110">Enter Superpower Academy <ArrowRight className="h-5 w-5 transition-transform group-hover:translate-x-1"/></span></div>
            </div>
          </div>
        </Link>
      </div>
    </section>
  </main>;
}
