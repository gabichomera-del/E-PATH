export function ProgressBar({ value, label }: { value: number; label?: string }) {
  return <div>
    {label && <div className="mb-2 flex justify-between text-sm font-bold"><span>{label}</span><span>{value}%</span></div>}
    <div className="h-3 overflow-hidden rounded-full bg-[#dce8e2]" role="progressbar" aria-valuenow={value} aria-valuemin={0} aria-valuemax={100}>
      <div className="h-full rounded-full bg-[#21a46b]" style={{ width: `${value}%` }} />
    </div>
  </div>;
}
