import { ProgressHUD } from "@/components/student/ProgressHUD";

export function ProgressHeader({ name, xp, context }: { name: string; xp?: number; context?: string }) { return <ProgressHUD name={name} xp={xp} context={context}/>; }
