import { BrandLogo } from "@/components/brand/brand-logo";
import { Bell, LogOut } from "lucide-react";

export function DashboardShell({ role, name, children }: { role: "Student" | "Teacher"; name: string; children: React.ReactNode }) {
  return <main className="min-h-screen bg-[#f5f8fc]"><header className="border-b border-[#dce5f2] bg-white"><div className="container-shell flex min-h-24 items-center justify-between py-3"><BrandLogo/><div className="flex items-center gap-3"><button className="focus-ring grid size-10 place-items-center rounded-xl bg-[#edf3fb] text-[#31445f]" aria-label="Notifications"><Bell size={19}/></button><div className="hidden text-right sm:block"><p className="text-sm font-black">{name}</p><p className="text-xs font-bold text-[#62708a]">{role}</p></div><form action="/auth/signout" method="post"><button className="focus-ring grid size-10 place-items-center rounded-xl text-[#62708a] hover:bg-red-50 hover:text-red-600" aria-label="Sign out"><LogOut size={19}/></button></form></div></div></header><div className="container-shell py-8">{children}</div></main>;
}
