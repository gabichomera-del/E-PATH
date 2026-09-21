"use client";

import { motion } from "framer-motion";
import { Award, BookOpen, CheckCircle2, Feather, Languages, Sparkles, Star, Zap } from "lucide-react";
import Link from "next/link";
import type { SavedUnitCompletion } from "@/lib/learning/pilot-progress";
import { FoxMascot } from "@/components/student/FoxMascot";

export function UnitComplete({ completion }: { completion: SavedUnitCompletion }) {
  const skills = [
    { label: "Vocabulary", Icon: Languages },
    { label: "Grammar", Icon: Sparkles },
    { label: "Reading", Icon: BookOpen },
    { label: "Writing", Icon: Feather },
  ];
  return <motion.section initial={{opacity:0,scale:.94,y:18}} animate={{opacity:1,scale:1,y:0}} className="relative mx-auto max-w-4xl overflow-hidden rounded-[2.5rem] border border-cyan-200/35 bg-[#071b42] p-6 text-center text-white shadow-[0_32px_100px_rgba(4,36,83,.38)] sm:p-10">
    <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_15%_18%,rgba(33,164,107,.3),transparent_28%),radial-gradient(circle_at_82%_14%,rgba(21,156,255,.34),transparent_32%),linear-gradient(145deg,rgba(15,61,128,.82),rgba(4,18,48,.96))]"/>
    <div className="relative">
      <div className="mx-auto flex w-fit items-end gap-2"><FoxMascot celebrating heroMentor/><motion.div animate={{rotate:[-8,8,-8],scale:[1,1.12,1]}} transition={{duration:1.6,repeat:Infinity}} className="mb-7 grid size-12 place-items-center rounded-full bg-gradient-to-br from-amber-300 to-orange-500 text-[#071b42] shadow-[0_0_28px_rgba(255,176,45,.7)]"><Zap fill="currentColor"/></motion.div></div>
      <p className="mt-2 text-xs font-black uppercase tracking-[.28em] text-cyan-200">Superpowers</p>
      <h1 className="font-adventure mt-2 text-4xl font-semibold sm:text-6xl">UNIT 6 COMPLETE! ⚡</h1>
      <h2 className="font-adventure mt-5 text-3xl font-semibold text-amber-300">Congratulations, Hero!</h2>
      <p className="mx-auto mt-3 max-w-2xl text-lg font-semibold text-blue-100">You completed all 25 missions of Unit 6: Superpowers.</p>

      <div className="mx-auto mt-8 max-w-2xl rounded-3xl border border-white/15 bg-white/10 p-5 text-left backdrop-blur-md">
        <div className="flex items-end justify-between gap-4"><div><p className="text-xs font-black uppercase tracking-[.2em] text-cyan-200">Unit 6</p><p className="font-adventure mt-1 text-2xl font-semibold">25 / 25 missions completed</p></div><CheckCircle2 className="text-emerald-300" size={38}/></div>
        <div className="mt-4 h-4 overflow-hidden rounded-full bg-[#03132d]/70"><motion.div initial={{width:0}} animate={{width:"100%"}} transition={{duration:1.2,ease:"easeOut"}} className="h-full rounded-full bg-gradient-to-r from-emerald-400 via-cyan-300 to-amber-300 shadow-[0_0_18px_rgba(73,238,185,.7)]"/></div>
        <div className="mt-4 flex items-center justify-between"><span className="font-bold text-blue-100">100% complete</span><span className="inline-flex items-center gap-2 rounded-full bg-orange-400/20 px-4 py-2 font-black text-amber-200"><Star size={18} fill="currentColor"/> Unit XP +{completion.totalXp}</span></div>
      </div>

      <div className="mt-7 grid gap-5 lg:grid-cols-2">
        <div className="rounded-3xl border border-white/15 bg-white/10 p-5 text-left backdrop-blur-md"><div className="flex items-center gap-2 text-amber-200"><Award/><h3 className="font-adventure text-2xl font-semibold">Badges earned</h3></div><div className="mt-4 flex max-h-44 flex-wrap gap-2 overflow-y-auto pr-1">{completion.badges.map((badge)=><span key={badge} className="rounded-full border border-amber-200/30 bg-amber-300/15 px-3 py-2 text-sm font-bold text-amber-50">{badge}</span>)}</div></div>
        <div className="rounded-3xl border border-white/15 bg-white/10 p-5 text-left backdrop-blur-md"><div className="flex items-center gap-2 text-emerald-200"><Sparkles/><h3 className="font-adventure text-2xl font-semibold">Skills completed</h3></div><div className="mt-4 grid grid-cols-2 gap-3">{skills.map(({label,Icon})=><div key={label} className="flex items-center gap-2 rounded-2xl bg-[#06152f]/55 p-3 font-black uppercase tracking-wider text-blue-50"><Icon size={18} className="text-cyan-200"/>{label}</div>)}</div></div>
      </div>

      <div className="mt-7 rounded-3xl bg-gradient-to-r from-emerald-400/20 via-cyan-400/15 to-orange-400/20 p-5"><p className="font-adventure text-3xl font-semibold text-amber-200">Mission accomplished!</p><p className="mt-2 font-semibold text-blue-100">You are ready for the next stage of your learning journey.</p></div>
      <Link href="/student/dashboard" className="btn-primary mt-7 w-full sm:w-auto">Back to Unit Dashboard</Link>
    </div>
  </motion.section>;
}
