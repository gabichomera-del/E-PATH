"use client";

import { motion } from "framer-motion";
import foxArt from "@/public/assets/mascot/e-path-fox-mentor.module.css";

type FoxMascotProps = { celebrating?: boolean; heroMentor?: boolean; compact?: boolean; hero?: boolean; mood?: "ready" | "thinking" | "progress" | "achievement" };

type FoxDisplayProps = FoxMascotProps & { mapGuide?: boolean };

export function FoxMascot({ celebrating = false, heroMentor = false, compact = false, hero = false, mapGuide = false, mood = "ready" }: FoxDisplayProps) {
  const joyful = celebrating || mood === "achievement";
  return <div data-fox-mood={joyful ? "achievement" : mood} className={`relative shrink-0 ${hero ? "h-[18rem] w-[18rem] sm:h-[22rem] sm:w-[22rem] lg:h-[27rem] lg:w-[27rem]" : mapGuide ? "h-16 w-16 sm:h-[4.5rem] sm:w-[4.5rem]" : compact ? "h-12 w-12 sm:h-14 sm:w-14" : "h-28 w-28 sm:h-36 sm:w-36"}`}>
    {heroMentor && <span className="pointer-events-none absolute inset-[12%] rounded-full bg-cyan-300/20 blur-xl" aria-hidden="true"/>}
    <motion.span role="img" aria-label={joyful ? "E-P.A.T.H. fox celebrating" : "E-P.A.T.H. fox explorer wearing goggles and a backpack"} initial={false} animate={mapGuide ? { scale: [1.18, 1.18, 1.22, 1.18], y: [0, 0, -2, 0] } : { scale: 1 }} transition={mapGuide ? { duration: 9, repeat: Infinity, ease: "easeInOut" } : { duration: 0 }} className={`${foxArt.art} relative drop-shadow-[0_14px_18px_rgba(2,16,42,.34)]`}/>
  </div>
}
