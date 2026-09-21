"use client";

import { motion } from "framer-motion";
import Image from "next/image";

export function FoxMascot({celebrating=false,heroMentor=false,compact=false}:{celebrating?:boolean;heroMentor?:boolean;compact?:boolean}){
  return <motion.div initial={{opacity:0,scale:.75,y:12}} animate={{opacity:1,scale:1,y:celebrating?[0,-12,0]:[0,-4,0]}} transition={celebrating?{duration:.7,repeat:2}:{duration:2.4,repeat:Infinity,ease:"easeInOut"}} className={compact?"relative h-12 w-11 sm:h-14 sm:w-12":"relative h-28 w-24 sm:h-36 sm:w-32"}>
    {heroMentor&&<><motion.div animate={{scale:[.9,1.08,.9],opacity:[.28,.62,.28]}} transition={{duration:2.2,repeat:Infinity}} className={`absolute inset-0 rounded-full border-cyan-200 ${compact?"border-2 shadow-[0_0_12px_4px_rgba(76,222,255,.42)]":"border-4 shadow-[0_0_28px_10px_rgba(76,222,255,.48)]"}`}/><div className="absolute left-[18%] top-[34%] h-[58%] w-[64%] rotate-[-7deg] bg-gradient-to-b from-[#ff9b37] to-[#d84916] shadow-lg" style={{clipPath:"polygon(8% 0,92% 0,72% 100%,50% 82%,27% 100%)"}}/><div className={`absolute right-[5%] top-[22%] z-20 grid place-items-center rounded-full border-white bg-gradient-to-br from-[#19d89a] to-[#087fc3] font-black text-white ${compact?"size-3.5 border text-[6px] shadow-[0_0_7px_rgba(55,233,187,.75)]":"size-8 border-2 shadow-[0_0_18px_rgba(55,233,187,.8)]"}`}>P</div></>}
    <div className="absolute inset-x-4 bottom-1 h-4 rounded-full bg-[#06172d]/40 blur-md"/><Image src="/assets/mascot/e-path-fox-explorer.svg" alt={heroMentor?"Friendly 3D Power Mentor Fox guiding the hero academy adventure":"Friendly E-P.A.T.H. fox explorer wearing a backpack"} fill sizes="128px" className="object-contain drop-shadow-[0_9px_9px_rgba(3,21,44,.45)]"/>
  </motion.div>
}
