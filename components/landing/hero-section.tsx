import { Compass, Sparkles } from "lucide-react";
import { AdventureBackground } from "@/components/landing/adventure-background";
import { LoginButtons } from "@/components/landing/login-buttons";
import { BrandLogo } from "@/components/brand/brand-logo";

export function HeroSection() {
  return (
    <section className="relative isolate min-h-[100svh] overflow-hidden bg-[#020d22] text-white">
      <AdventureBackground />
      <header className="container-shell relative z-20 pt-3 sm:pt-5"><BrandLogo variant="hero" tone="light" priority className="!w-72 sm:!w-[25rem] lg:!w-[32rem]"/></header>
      <div className="container-shell relative z-10 flex min-h-[100svh] items-end pb-12 pt-[49svh] lg:items-center lg:py-16">
        <div className="w-full max-w-[42rem] lg:w-[49%]">
          <div className="font-adventure mb-5 inline-flex items-center gap-2 rounded-full border border-[#83edba]/25 bg-[#0a5149]/55 px-4 py-2 text-sm font-semibold tracking-wide text-[#a6f3ce] backdrop-blur-md sm:mb-8"><Compass size={17}/><span>Your English adventure</span><Sparkles size={15} className="text-[#ffae68]"/></div>
          <h1 className="font-adventure text-[clamp(2.8rem,11vw,3.5rem)] font-bold leading-[1.03] tracking-[-.025em] sm:text-[clamp(3.5rem,5vw,5.2rem)]"><span className="block text-white drop-shadow-[0_5px_18px_rgba(0,0,0,.28)]">Explore English.</span><span className="mt-2 block bg-gradient-to-r from-[#ffc07d] via-[#ff8a2b] to-[#ff9e48] bg-clip-text pb-2 text-transparent">Unlock your potential.</span></h1>
          <p className="mt-5 text-lg font-medium text-blue-100 sm:text-xl">Choose your path and let&apos;s begin!</p>
          <LoginButtons />
        </div>
      </div>
    </section>
  );
}
