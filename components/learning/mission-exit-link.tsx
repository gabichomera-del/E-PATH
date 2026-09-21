"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft } from "lucide-react";

export function MissionExitLink({ href }: { href: string }) {
  const router = useRouter();
  const [saving, setSaving] = useState(false);

  return <div className="relative">
    <button type="button" disabled={saving} onClick={() => { setSaving(true); window.setTimeout(() => router.push(href), 850); }} className="focus-ring inline-flex items-center gap-2 rounded-xl font-bold text-[#31445f] disabled:cursor-wait">
      <ArrowLeft size={18}/> Exit to Unit World Map
    </button>
    {saving && <p role="status" className="absolute left-0 top-full z-20 mt-2 whitespace-nowrap rounded-xl bg-[#15365d] px-4 py-2 text-sm font-bold text-white shadow-lg">Your progress has been saved, Explorer!</p>}
  </div>;
}
