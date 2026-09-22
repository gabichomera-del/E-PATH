import scene from "@/public/assets/brand/e-path-home-hero.module.css";

export function AdventureBackground() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden" aria-hidden="true">
      <div className={`${scene.scene} absolute inset-x-0 top-16 h-[51svh] bg-[#06162f] bg-[position:63%_center] lg:inset-0 lg:h-full lg:bg-center`} />
      <div className="absolute inset-x-0 top-16 h-[51svh] bg-gradient-to-b from-[#020d22]/25 via-transparent to-[#020d22] lg:inset-0 lg:h-full lg:bg-[linear-gradient(90deg,rgba(2,11,28,.94)_0%,rgba(2,11,28,.78)_30%,rgba(2,11,28,.1)_55%,transparent_78%)]" />
      <div className="absolute inset-0 hidden bg-gradient-to-t from-[#020d22]/35 via-transparent to-[#020d22]/10 lg:block" />
    </div>
  );
}
