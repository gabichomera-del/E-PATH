"use client";

import { motion } from "framer-motion";
import Image from "next/image";

export function FoxProgress({ label = "You are here", compact = false }: { label?: string; compact?: boolean }) {
  return <motion.div initial={{ scale: .8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} transition={{ type: "spring", stiffness: 180, damping: 16 }} className="flex items-center gap-3"><div className={`${compact ? "size-12" : "size-16"} relative overflow-hidden rounded-full border-4 border-white bg-[#0c3472] shadow-[0_8px_24px_rgba(7,27,61,.25)]`}><Image src="/assets/mascot/e-path-fox-explorer.svg" alt="E-P.A.T.H. fox" fill sizes={compact ? "48px" : "64px"} className="scale-[1.9] object-cover object-[50%_24%]" /></div>{!compact && <span className="rounded-full bg-white px-3 py-1.5 text-xs font-bold text-[#125cdb] shadow-sm">{label}</span>}</motion.div>;
}
