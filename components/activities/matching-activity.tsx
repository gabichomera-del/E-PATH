"use client";
import { useMemo, useState } from "react";
import { CheckCircle2, Eye, XCircle } from "lucide-react";
import type { ActivityProps } from "@/components/activities/multiple-choice-activity";
import { Submit } from "@/components/activities/multiple-choice-activity";
import { ActivityShell } from "@/components/activities/activity-shell";
import { shuffleOptions } from "@/lib/learning/shuffle";

type PairStatus = "correct" | "incorrect";

export function MatchingActivity({ activity, onAnswer }: ActivityProps) {
  const item = activity.items[0];
  const pairs = item.pairs ?? [];
  const meanings = useMemo(() => shuffleOptions([...new Set(pairs.map((pair) => pair.right))], activity.id), [activity.id, pairs]);
  const [matches, setMatches] = useState<Record<string, string>>({});
  const [statuses, setStatuses] = useState<Record<string, PairStatus>>({});
  const [attempts, setAttempts] = useState<Record<string, number>>({});
  const [revealed, setRevealed] = useState<Record<string, boolean>>({});
  const [score, setScore] = useState<number | null>(null);

  const correctCount = Object.values(statuses).filter((status) => status === "correct").length;
  const allCorrect = pairs.length > 0 && correctCount === pairs.length;
  const allAnswered = pairs.every((pair) => Boolean(matches[pair.left]));

  function updateMatch(word: string, value: string) {
    if (statuses[word] === "correct") return;
    setMatches((current) => ({ ...current, [word]: value }));
    setStatuses((current) => {
      const next = { ...current };
      delete next[word];
      return next;
    });
  }

  function checkAnswers() {
    const nextStatuses = { ...statuses };
    const nextAttempts = { ...attempts };

    for (const pair of pairs) {
      if (nextStatuses[pair.left] === "correct") continue;
      const correct = matches[pair.left] === pair.right;
      nextStatuses[pair.left] = correct ? "correct" : "incorrect";
      if (!correct) nextAttempts[pair.left] = (nextAttempts[pair.left] ?? 0) + 1;
    }

    const nextCorrectCount = pairs.filter((pair) => nextStatuses[pair.left] === "correct").length;
    const nextScore = pairs.length ? Math.round((nextCorrectCount / pairs.length) * 100) : 0;
    setStatuses(nextStatuses);
    setAttempts(nextAttempts);
    setScore(nextScore);
    onAnswer({ correct: nextCorrectCount === pairs.length, score: nextScore, response: matches });
  }

  return <ActivityShell eyebrow="Connect the pairs" instructions={activity.instructions}>
    <div className="grid gap-3">
      {pairs.map((pair) => {
        const status = statuses[pair.left];
        const isCorrect = status === "correct";
        const isIncorrect = status === "incorrect";
        return <div key={pair.left} className={`rounded-2xl border-2 p-3 transition-colors ${isCorrect ? "border-emerald-300 bg-emerald-50" : isIncorrect ? "border-red-300 bg-red-50" : "border-transparent bg-[#f5f8fc]"}`}>
          <div className="grid items-center gap-3 sm:grid-cols-[1fr_auto_1.35fr]">
            <span className="rounded-xl bg-white px-4 py-3 font-bold text-[#15365d] shadow-sm">{pair.left}</span>
            <span className="hidden text-[#9cabc0] sm:block">→</span>
            <select aria-label={`Meaning for ${pair.left}`} value={matches[pair.left] ?? ""} disabled={isCorrect} onChange={(event) => updateMatch(pair.left, event.target.value)} className={`field disabled:cursor-not-allowed disabled:opacity-80 ${isCorrect ? "border-emerald-400 bg-emerald-100" : isIncorrect ? "border-red-400 bg-white" : ""}`}>
              <option value="">Choose a meaning</option>
              {meanings.map((meaning) => <option key={meaning}>{meaning}</option>)}
            </select>
          </div>
          {isCorrect && <p className="mt-2 flex items-center gap-2 text-sm font-bold text-emerald-700"><CheckCircle2 size={17}/> ✓ {activity.correctFeedback??"Great job, Explorer!"}</p>}
          {isIncorrect && <div className="mt-2 flex flex-wrap items-center justify-between gap-2 text-sm font-bold text-red-700"><p className="flex items-center gap-2"><XCircle size={17}/> ✗ {activity.incorrectFeedback??"Almost there! Try again."}</p>{(attempts[pair.left] ?? 0) >= 2 && !revealed[pair.left] && <button type="button" onClick={() => setRevealed((current) => ({ ...current, [pair.left]: true }))} className="focus-ring inline-flex items-center gap-1 rounded-lg bg-white px-3 py-1.5 text-[#125cdb] shadow-sm"><Eye size={15}/> Show answer</button>}</div>}
          {revealed[pair.left] && !isCorrect && <p className="mt-2 rounded-xl bg-blue-50 px-3 py-2 text-sm font-semibold text-[#31445f]">Answer: <span className="font-bold text-[#125cdb]">{pair.right}</span> — choose this meaning, then check again.</p>}
        </div>;
      })}
    </div>

    {score !== null && <div aria-live="polite" className={`mt-5 rounded-2xl border p-4 ${allCorrect ? "border-emerald-300 bg-emerald-50" : "border-blue-200 bg-blue-50"}`}>
      <p className={`font-adventure text-xl font-semibold ${allCorrect ? "text-emerald-700" : "text-[#15365d]"}`}>{allCorrect ? "🎉 Excellent! You got them all!" : `Your score: ${correctCount}/${pairs.length}`}</p>
      {allCorrect ? <p className="mt-1 font-bold text-emerald-700">{correctCount}/{pairs.length} correct</p> : <div className="mt-2 flex flex-wrap gap-x-5 gap-y-1 text-sm font-bold"><span className="text-emerald-700">✓ {correctCount} correct</span><span className="text-red-700">🔴 {pairs.length - correctCount} to review</span></div>}
    </div>}

    {!allCorrect && <Submit disabled={!allAnswered} onClick={checkAnswers}/>} 
  </ActivityShell>;
}
