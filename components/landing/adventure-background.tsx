"use client";

import Image from "next/image";
import { motion, useReducedMotion } from "framer-motion";

export function AdventureBackground() {
  const reduceMotion = useReducedMotion();

  return (
    <div className="absolute inset-0 overflow-hidden" aria-hidden="true">
      <motion.div initial={{ opacity: 0, scale: reduceMotion ? 1 : 1.035 }} animate={{ opacity: 1, scale: 1 }} transition={{ duration: 1.25, ease: "easeOut" }} className="absolute inset-0">
        <Image src="/assets/brand/e-path-adventure-hero.svg" alt="" fill priority sizes="100vw" className="object-cover object-[67%_center] sm:object-[64%_center] lg:object-center" />
      </motion.div>
      <div className="absolute inset-0 bg-[linear-gradient(90deg,rgba(2,12,31,.96)_0%,rgba(3,18,44,.82)_31%,rgba(3,19,47,.18)_58%,rgba(2,12,31,.04)_100%)]" />
      <div className="absolute inset-0 bg-[linear-gradient(0deg,rgba(2,10,25,.96)_0%,transparent_42%)] sm:bg-[linear-gradient(0deg,rgba(2,10,25,.74)_0%,transparent_44%)]" />
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_79%_39%,rgba(50,160,255,.12),transparent_25%)]" />
      <motion.span animate={reduceMotion ? {} : { opacity: [.35, .9, .35], scale: [.8, 1.2, .8] }} transition={{ duration: 4.5, repeat: Infinity }} className="absolute right-[16%] top-[12%] size-1.5 rounded-full bg-white shadow-[0_0_18px_6px_rgba(118,198,255,.45)]" />
      <motion.span animate={reduceMotion ? {} : { y: [0, -8, 0], opacity: [.45, 1, .45] }} transition={{ duration: 5.8, repeat: Infinity }} className="absolute right-[8%] top-[27%] size-2 rounded-full bg-[#76e5ad] shadow-[0_0_20px_7px_rgba(74,218,148,.35)]" />
    </div>
  );
}
