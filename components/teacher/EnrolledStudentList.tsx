"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { UserMinus } from "lucide-react";
import { ResetPasswordButton } from "@/components/teacher/ResetPasswordButton";

export type EnrolledStudent = {
  id: string;
  name: string;
  email: string;
};

export function EnrolledStudentList({ classId, initialStudents }: { classId: string; initialStudents: EnrolledStudent[] }) {
  const [students, setStudents] = useState(initialStudents);
  const [confirmingId, setConfirmingId] = useState<string | null>(null);
  const [removingId, setRemovingId] = useState<string | null>(null);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const router = useRouter();

  async function removeStudent(student: EnrolledStudent) {
    if (removingId) return;
    setRemovingId(student.id);
    setError("");
    setSuccess("");

    try {
      const response = await fetch(`/api/teacher/classes/${classId}/students/${student.id}`, { method: "DELETE" });
      const result = await response.json().catch(() => ({}));
      if (!response.ok) {
        setError(result.error ?? "We couldn't remove this student from the class. Please try again.");
        return;
      }

      setStudents((current) => current.filter((item) => item.id !== student.id));
      setConfirmingId(null);
      setSuccess(`${student.name} was removed from this class. Their account and learning progress were preserved.`);
      router.refresh();
    } catch {
      setError("We couldn't remove this student from the class. Please check your connection and try again.");
    } finally {
      setRemovingId(null);
    }
  }

  return <>
    {success && <p role="status" className="border-b border-emerald-200 bg-emerald-50 px-5 py-4 text-sm font-bold text-emerald-800">{success}</p>}
    {error && <p role="alert" className="border-b border-red-200 bg-red-50 px-5 py-4 text-sm font-bold text-red-700">{error}</p>}
    {!students.length ? <p className="p-8 text-center font-semibold text-[#62708a]">No students have joined this class yet.</p> : <div className="divide-y divide-[#e8eef6]">
      {students.map((student) => <div key={student.id} className="p-5">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div><p className="font-black">{student.name}</p><p className="text-sm font-semibold text-[#62708a]">{student.email}</p></div>
          <div className="flex flex-wrap items-start justify-end gap-2">
            <ResetPasswordButton studentId={student.id}/>
            <button type="button" onClick={() => { setConfirmingId(student.id); setError(""); setSuccess(""); }} disabled={Boolean(removingId)} className="inline-flex items-center gap-2 rounded-xl border border-red-200 px-3 py-2 text-sm font-bold text-red-700 transition hover:bg-red-50 disabled:cursor-not-allowed disabled:opacity-60"><UserMinus size={16}/> Remove from class</button>
          </div>
        </div>
        {confirmingId === student.id && <div role="alertdialog" aria-labelledby={`remove-${student.id}-title`} aria-describedby={`remove-${student.id}-description`} className="mt-4 rounded-2xl border border-red-200 bg-red-50 p-4">
          <h3 id={`remove-${student.id}-title`} className="font-black text-red-900">Remove {student.name} from this class?</h3>
          <div id={`remove-${student.id}-description`} className="mt-2 space-y-1 text-sm font-semibold text-red-800">
            <p>This removes the student from this class only.</p>
            <p>Their account and learning progress will not be deleted.</p>
            <p>They will no longer appear in this class or its statistics.</p>
          </div>
          <div className="mt-4 flex flex-wrap gap-3">
            <button type="button" onClick={() => void removeStudent(student)} disabled={removingId === student.id} className="rounded-xl bg-red-700 px-4 py-2 text-sm font-black text-white disabled:cursor-wait disabled:opacity-60">{removingId === student.id ? "Removing…" : "Yes, remove from class"}</button>
            <button type="button" onClick={() => setConfirmingId(null)} disabled={removingId === student.id} className="rounded-xl px-4 py-2 text-sm font-black text-[#62708a] disabled:opacity-60">Cancel</button>
          </div>
        </div>}
      </div>)}
    </div>}
  </>;
}
