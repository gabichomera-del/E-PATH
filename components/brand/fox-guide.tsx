import { BrandLogo } from "@/components/brand/brand-logo";

export function FoxGuide({ message, compact = false }: { message: string; compact?: boolean }) {
  return <div className={`flex items-center gap-3 ${compact ? "" : "rounded-2xl bg-[#edf9f3] p-4"}`}>
    <BrandLogo variant="guide" className={compact ? "!size-12" : ""} />
    <p className="text-sm font-bold leading-5 text-[#24513f]">{message}</p>
  </div>;
}
