import { Heart, Home, LogOut, Mail, Map, Medal, Star } from "lucide-react";
import { BrandLogo } from "@/components/brand/brand-logo";

const navigation = [
  { label: "Home", icon: Home, href: "/student/dashboard" },
  { label: "My Learning", icon: Map, href: "/student/dashboard#my-units" },
  { label: "Rewards", icon: Medal, href: "#rewards" },
  { label: "Messages", icon: Mail, href: "#messages" },
];

export function ProgressHUD({ name, xp = 0, context }: { name: string; xp?: number; context?: string }) {
  return <header className="relative z-30 border-b border-white/10 bg-[#061832]/95 text-white backdrop-blur-xl"><div className="container-shell flex min-h-24 items-center gap-4 py-3"><BrandLogo/><nav aria-label="Student navigation" className="ml-2 hidden items-center gap-1 lg:flex">{navigation.map(({ label, icon: Icon, href }, index) => <a key={label} href={href} aria-current={index === 0 ? "page" : undefined} className={`focus-ring inline-flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-semibold transition ${index === 0 ? "bg-white/12 text-white" : "text-blue-200 hover:bg-white/8 hover:text-white"}`}><Icon size={17}/>{label}</a>)}</nav><div className="ml-auto flex items-center gap-2"><HudStat icon={<Star fill="currentColor"/>} value={String(xp)} label="XP" color="text-[#ffd166]"/><HudStat icon={<Heart fill="currentColor"/>} value="3" label="Lives" color="text-[#ff806e]"/><div className="ml-1 hidden items-center gap-2 sm:flex"><span className="grid size-10 place-items-center rounded-full bg-gradient-to-br from-[#35ce91] to-[#13875a] font-bold">{name.slice(0, 1).toUpperCase()}</span><span className="hidden max-w-36 xl:block"><b className="block truncate text-sm">{name}</b>{context && <small className="block truncate text-xs font-medium text-blue-200">{context}</small>}</span></div><form action="/auth/signout" method="post"><button className="focus-ring grid size-10 place-items-center rounded-full text-blue-200 transition hover:bg-white/10 hover:text-white" aria-label="Sign out"><LogOut size={18}/></button></form></div></div></header>;
}

function HudStat({ icon, value, label, color }: { icon: React.ReactNode; value: string; label: string; color: string }) { return <div className="flex items-center gap-2 rounded-full border border-white/10 bg-white/[.08] px-3 py-2"><span className={`${color} [&>svg]:size-5`}>{icon}</span><span><b className="block text-sm leading-none">{value}</b><span className="hidden text-xs text-blue-200 sm:block">{label}</span></span></div>; }
