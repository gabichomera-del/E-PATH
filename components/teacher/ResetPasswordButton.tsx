"use client";

import { useState } from "react";

export function ResetPasswordButton({ studentId }: { studentId: string }) {
  const [result, setResult] = useState(""); const [loading, setLoading] = useState(false);
  async function reset() { setLoading(true); setResult(""); const response = await fetch(`/api/teacher/students/${studentId}/reset-password`, { method: "POST" }); const data = await response.json(); setResult(response.ok ? `Temporary password: ${data.temporaryPassword}` : data.error); setLoading(false); }
  return <div className="text-right"><button onClick={reset} disabled={loading} className="rounded-xl border border-[#dce5f2] px-3 py-2 text-sm font-bold text-[#125cdb] hover:bg-blue-50">{loading ? "Resetting…" : "Reset password"}</button>{result && <p className="mt-2 max-w-xs text-xs font-bold text-[#62708a]" role="status">{result}</p>}</div>;
}
