import Image from "next/image";
import type { WorldTheme } from "@/lib/learning/world-themes";

export function WorldEnvironment({ theme }: { theme: WorldTheme }) {
  if(theme.world==="hero-skies")return <><Image src="/assets/worlds/unit-6-superpowers.png" alt="Superpower Academy with floating islands, futuristic buildings, training areas, laboratories, and the central academy tower" fill priority sizes="(max-width: 1536px) 100vw, 1536px" className="object-cover"/><div className="absolute inset-0 bg-gradient-to-t from-[#031a3d]/45 via-transparent to-[#0872c2]/10"/><div className="absolute inset-0 shadow-[inset_0_0_110px_rgba(2,19,52,.48)]"/><div className="absolute left-[44%] top-[28%] size-32 rounded-full bg-cyan-300/15 blur-3xl"/><div className="absolute bottom-[14%] right-[12%] size-28 rounded-full bg-emerald-300/15 blur-3xl"/></>;
  return <>{theme.environmentImage&&<Image src={theme.environmentImage} alt={`${theme.worldName}, an illustrated English learning world`} fill priority sizes="(max-width: 1536px) 100vw, 1536px" className="object-cover"/>}<div className="absolute inset-0 bg-gradient-to-t from-[#03142d]/45 via-transparent to-[#052b61]/15"/><div className="absolute inset-x-0 top-0 h-24 bg-gradient-to-b from-[#071b3d]/30 to-transparent"/></>;
}
