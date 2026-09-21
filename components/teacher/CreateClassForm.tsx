"use client";

import { useState } from "react";
import { Plus } from "lucide-react";
import { useRouter } from "next/navigation";

export function CreateClassForm() {
  const [open, setOpen] = useState(false); const [error, setError] = useState(""); const [loading, setLoading] = useState(false); const router = useRouter();
  async function submit(event: React.FormEvent<HTMLFormElement>) { event.preventDefault(); setLoading(true); setError(""); const form = new FormData(event.currentTarget); const response = await fetch("/api/classes", { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ name: form.get("name"), grade: form.get("grade"), section: form.get("section"), academicYear: Number(form.get("academicYear")) }) }); const result = await response.json(); if (!response.ok) { setError(result.error ?? "Could not create class."); setLoading(false); return; } setOpen(false); router.refresh(); }
  if (!open) return <button onClick={() => setOpen(true)} className="btn-primary"><Plus size={18}/> Create class</button>;
  return <form onSubmit={submit} className="card grid gap-4 p-5 sm:grid-cols-2"><div><label className="label" htmlFor="class-name">Class name</label><input className="field" id="class-name" name="name" placeholder="6A English" required/></div><div><label className="label" htmlFor="class-grade">Grade</label><input className="field" id="class-grade" name="grade" placeholder="6" required/></div><div><label className="label" htmlFor="class-section">Section</label><input className="field uppercase" id="class-section" name="section" placeholder="A" required/></div><div><label className="label" htmlFor="academic-year">Academic year</label><input className="field" id="academic-year" name="academicYear" type="number" defaultValue={new Date().getFullYear()} required/></div>{error && <p className="text-sm font-bold text-red-600 sm:col-span-2">{error}</p>}<div className="flex gap-3 sm:col-span-2"><button className="btn-primary" disabled={loading}>{loading ? "Creating…" : "Create and generate code"}</button><button type="button" onClick={() => setOpen(false)} className="rounded-xl px-4 font-bold text-[#62708a]">Cancel</button></div></form>;
}
