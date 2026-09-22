import { BrandLogo } from "@/components/brand/brand-logo";

export function AuthShell({ title, subtitle, children }: { title: string; subtitle: string; children: React.ReactNode }) {
  return <main className="min-h-screen bg-[linear-gradient(135deg,#eef5ff_0%,#f9fbff_55%,#fff4ea_100%)]">
    <div className="container-shell py-5"><BrandLogo tone="dark" className="!w-64 sm:!w-80"/></div>
    <div className="container-shell grid items-start gap-10 pb-16 pt-6 lg:grid-cols-[.75fr_1.25fr] lg:pt-16">
      <aside className="max-w-md lg:sticky lg:top-12"><p className="text-sm font-black uppercase tracking-[.18em] text-[#125cdb]">Welcome to E.P.A.T.H.</p><h1 className="mt-4 text-4xl font-black tracking-tight text-[#071b3d] sm:text-5xl">{title}</h1><p className="mt-5 text-lg font-semibold leading-8 text-[#62708a]">{subtitle}</p><div className="mt-8 rounded-3xl border border-[#5cccf1]/25 bg-[linear-gradient(120deg,#102d59,#0b2449)] px-6 py-5 text-blue-50 shadow-[0_16px_34px_rgba(9,31,69,.14)]"><p className="text-xs font-black uppercase tracking-[.15em] text-[#8bd9ed]">Your adventure guide</p><p className="mt-2 max-w-sm text-sm font-semibold leading-6">Use your institutional email so I can guide you to the right learning space.</p></div></aside>
      <section className="card p-6 sm:p-9">{children}</section>
    </div>
  </main>;
}
