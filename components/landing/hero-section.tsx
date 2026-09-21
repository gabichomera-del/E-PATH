"use client";

import { motion } from "framer-motion";
import { Compass, Sparkles } from "lucide-react";
import { AdventureBackground } from "@/components/landing/adventure-background";
import { LoginButtons } from "@/components/landing/login-buttons";

export function HeroSection() {
  return (
    <section className="relative isolate min-h-screen overflow-hidden bg-[#020d22] text-white">
      <AdventureBackground />
      <div className="container-shell relative z-10 flex min-h-screen items-end pb-12 pt-[52vh] sm:items-center sm:py-16">
        <motion.div initial={{ opacity: 0, x: -24, y: 12 }} animate={{ opacity: 1, x: 0, y: 0 }} transition={{ delay: .18, duration: .72, ease: "easeOut" }} className="max-w-[42rem] sm:w-[54%] lg:w-[48%]">
          <div className="font-adventure mb-8 inline-flex items-center gap-2 rounded-full border border-[#83edba]/25 bg-[#21a46b]/15 px-4 py-2.5 text-sm font-semibold tracking-wide text-[#91edbf] shadow-[inset_0_1px_rgba(255,255,255,.1)] backdrop-blur-md"><Compass size={17}/><span>Your English adventure</span><Sparkles size={15} className="text-[#ffae68]"/></div>
          <h1 className="font-adventure text-[3.2rem] font-bold leading-[.98] tracking-[-.025em] sm:text-[4rem] lg:text-[4.8rem]"><span className="block text-white drop-shadow-[0_5px_18px_rgba(0,0,0,.28)]">Explore English.</span><span className="mt-2 block bg-gradient-to-r from-[#ffc07d] via-[#ff8a2b] to-[#ff9e48] bg-clip-text pb-2 text-transparent drop-shadow-[0_6px_18px_rgba(185,70,0,.2)]">Unlock your potential.</span></h1>
          <p className="mt-5 text-lg font-medium text-blue-100 sm:text-xl">Choose your path and let&apos;s begin!</p>
          <LoginButtons />
        </motion.div>
      </div>
    </section>
  );
}
