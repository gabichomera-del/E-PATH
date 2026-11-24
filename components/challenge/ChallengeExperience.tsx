"use client";

import { useState } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { CheckCircle2, Compass, Lightbulb, Sparkles } from "lucide-react";
import { BrandLogo } from "@/components/brand/brand-logo";
import { FoxMascot } from "@/components/student/FoxMascot";

const options = [
  { key: "A", text: "It replaces the teacher after class." },
  { key: "B", text: "It allows students to continue practicing what they learned through purposeful, gamified activities." },
  { key: "C", text: "It gives students more homework." },
  { key: "D", text: "It only tracks their grades." },
] as const;

type OptionKey = typeof options[number]["key"];
type Result = "idle" | "incorrect" | "correct";

export function ChallengeExperience() {
  const [selected, setSelected] = useState<OptionKey | null>(null);
  const [result, setResult] = useState<Result>("idle");

  function selectAnswer(key: OptionKey) {
    if (result === "correct") return;
    setSelected(key);
    setResult("idle");
  }

  function checkAnswer(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selected || result === "correct") return;
    setResult(selected === "B" ? "correct" : "incorrect");
  }

  return <main className="relative isolate min-h-[100svh] overflow-hidden bg-[#061a3a] px-4 py-5 text-white sm:px-6 sm:py-8">
    <div className="pointer-events-none absolute inset-0" aria-hidden="true">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_5%,rgba(33,164,107,.22),transparent_30%),radial-gradient(circle_at_88%_14%,rgba(18,92,219,.36),transparent_34%),linear-gradient(155deg,#061a3a_0%,#092855_55%,#071830_100%)]"/>
      <div className="absolute -left-24 top-[42%] h-72 w-72 rounded-full border border-cyan-300/10"/>
      <div className="absolute -right-28 -top-20 h-80 w-80 rounded-full border border-orange-300/10"/>
      <div className="absolute inset-x-0 bottom-0 h-52 bg-gradient-to-t from-[#031127] to-transparent"/>
    </div>

    <div className="relative mx-auto flex w-full max-w-5xl flex-col">
      <header className="flex items-center justify-between gap-4">
        <BrandLogo variant="header" className="!w-44 sm:!w-56"/>
        <div className="hidden items-center gap-2 rounded-full border border-white/15 bg-white/10 px-4 py-2 text-sm font-bold text-blue-100 backdrop-blur sm:flex"><Compass size={17}/> Keep exploring</div>
      </header>

      <section className="mt-5 grid items-center gap-5 lg:mt-8 lg:grid-cols-[minmax(0,1fr)_15rem] lg:gap-8">
        <div className="rounded-[1.75rem] border border-white/15 bg-white/[.08] p-5 shadow-[0_28px_80px_rgba(0,0,0,.28)] backdrop-blur-md sm:p-8">
          <div className="flex items-center gap-4">
            <div className="grid size-12 shrink-0 place-items-center rounded-2xl bg-gradient-to-br from-[#ff9a42] to-[#f2680b] shadow-[0_8px_22px_rgba(242,104,11,.32)]"><Sparkles size={25}/></div>
            <div><p className="text-xs font-black uppercase tracking-[.2em] text-[#86e7c2]">Scan · Think · Discover</p><h1 className="font-adventure mt-1 text-2xl font-bold sm:text-3xl">E-P.A.T.H. CHALLENGE</h1></div>
          </div>

          <form className="mt-6" onSubmit={checkAnswer}>
            <fieldset disabled={result === "correct"}>
              <legend className="text-xl font-bold leading-8 text-white sm:text-2xl sm:leading-9">Imagine you are an E-P.A.T.H. student. Your English class has ended. What makes E-P.A.T.H. valuable at that moment?</legend>
              <div className="mt-5 grid gap-3">
                {options.map((option) => {
                  const isSelected = selected === option.key;
                  const isCorrect = result === "correct" && option.key === "B";
                  const isIncorrect = result === "incorrect" && isSelected;
                  return <label key={option.key} className={`focus-within:ring-4 focus-within:ring-[#8eb8ff]/60 flex min-h-16 cursor-pointer items-center gap-4 rounded-2xl border p-4 text-left transition sm:p-5 ${isCorrect ? "border-emerald-300 bg-emerald-400/20 shadow-[0_0_0_1px_rgba(110,231,183,.2)]" : isIncorrect ? "border-orange-300 bg-orange-400/15" : isSelected ? "border-[#69a8ff] bg-[#125cdb]/35 shadow-[0_0_0_1px_rgba(105,168,255,.25)]" : "border-white/15 bg-[#071d40]/70 hover:border-white/30 hover:bg-[#0b2b59]"}`}>
                    <input type="radio" name="challenge-answer" value={option.key} checked={isSelected} onChange={() => selectAnswer(option.key)} className="sr-only"/>
                    <span className={`grid size-10 shrink-0 place-items-center rounded-xl text-base font-black ${isCorrect ? "bg-emerald-400 text-[#052b20]" : isIncorrect ? "bg-orange-400 text-[#3b1900]" : isSelected ? "bg-[#5ca4ff] text-[#061a3a]" : "bg-white/10 text-blue-100"}`}>{isCorrect ? <CheckCircle2 size={22}/> : option.key}</span>
                    <span className="text-base font-semibold leading-6 text-blue-50 sm:text-lg">{option.text}</span>
                  </label>;
                })}
              </div>
            </fieldset>

            <button type="submit" disabled={!selected || result === "correct"} className="btn-primary mt-6 w-full text-lg disabled:cursor-not-allowed disabled:translate-y-0 disabled:opacity-50 disabled:shadow-none">{result === "correct" ? "Challenge complete" : "Check answer"}</button>
          </form>

          <div className="mt-5 min-h-[8.5rem]" aria-live="polite">
            <AnimatePresence mode="wait">
              {result === "incorrect" && <motion.div key="incorrect" initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} className="rounded-2xl border border-amber-300/30 bg-amber-300/10 p-4 text-amber-50">
                <div className="flex items-start gap-3"><Lightbulb className="mt-0.5 shrink-0 text-amber-300" size={24}/><div><p className="font-adventure text-xl font-bold text-amber-200">💡 THINK AGAIN!</p><p className="mt-1 font-semibold leading-6">Think about what happens to learning after the class ends.</p></div></div>
              </motion.div>}
              {result === "correct" && <motion.div key="correct" initial={{ opacity: 0, scale: .97, y: 10 }} animate={{ opacity: 1, scale: 1, y: 0 }} className="relative overflow-hidden rounded-2xl border border-emerald-300/35 bg-emerald-300/15 p-5 text-emerald-50">
                <Sparkles className="absolute right-4 top-4 text-orange-300" size={24} aria-hidden="true"/>
                <p className="font-adventure text-2xl font-bold text-[#8ff0c8]">🎉 EXCELLENT!</p>
                <p className="mt-2 text-lg font-bold text-white">You discovered the heart of E-P.A.T.H.</p>
                <p className="mt-1 font-semibold leading-6">Connecting classroom learning with autonomous practice.</p>
                <p className="mt-3 font-bold text-orange-200">The learning continues. 🦊</p>
              </motion.div>}
            </AnimatePresence>
          </div>
        </div>

        <aside className="relative mx-auto hidden w-full max-w-60 lg:block" aria-label="E.P.A.T.H. adventure guide">
          <div className="absolute inset-x-3 bottom-2 h-20 rounded-full bg-cyan-300/15 blur-2xl" aria-hidden="true"/>
          <FoxMascot mood={result === "correct" ? "achievement" : result === "incorrect" ? "thinking" : "ready"}/>
          <div className="relative -mt-3 rounded-2xl border border-white/15 bg-[#0b2b59]/90 p-4 text-center shadow-xl backdrop-blur">
            <p className="text-xs font-black uppercase tracking-[.16em] text-[#86e7c2]">Fox challenge</p>
            <p className="mt-1 text-sm font-semibold text-blue-100">Learning does not stop when class ends.</p>
          </div>
        </aside>
      </section>

      <div className="mx-auto mt-4 flex items-center gap-3 rounded-2xl border border-white/10 bg-white/[.06] px-4 py-3 lg:hidden">
        <FoxMascot compact mood={result === "correct" ? "achievement" : result === "incorrect" ? "thinking" : "ready"}/>
        <p className="text-sm font-semibold text-blue-100">Choose the idea that keeps learning moving forward.</p>
      </div>
    </div>
  </main>;
}
