"use client";

import { useState } from "react";
import { Eye, EyeOff, KeyRound } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

const MIN_PASSWORD_LENGTH = 8;

type PasswordFieldProps = {
  id: string;
  label: string;
  autoComplete: "current-password" | "new-password";
  value: string;
  onChange: (value: string) => void;
  disabled: boolean;
};

export function ChangePasswordForm() {
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  async function submit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (loading) return;
    setError("");

    if (!currentPassword || !newPassword || !confirmPassword) {
      setError("Complete all password fields before continuing.");
      return;
    }
    if (newPassword.length < MIN_PASSWORD_LENGTH) {
      setError(`Your new password must be at least ${MIN_PASSWORD_LENGTH} characters.`);
      return;
    }
    if (newPassword === currentPassword) {
      setError("Choose a new password different from your current password.");
      return;
    }
    if (newPassword !== confirmPassword) {
      setError("The new passwords do not match.");
      return;
    }

    const supabase = createClient();
    if (!supabase) {
      setError("We couldn't update your password. Please try again.");
      return;
    }

    setLoading(true);
    try {
      const { data: userData, error: userError } = await supabase.auth.getUser();
      const email = userData.user?.email;
      if (userError || !email) {
        setError("Your session expired. Please sign in again.");
        return;
      }

      const { error: verificationError } = await supabase.auth.signInWithPassword({
        email,
        password: currentPassword,
      });
      if (verificationError) {
        setError(verificationError.status === 400 ? "Current password is incorrect." : "We couldn't verify your current password. Please try again.");
        return;
      }

      const { error: updateError } = await supabase.auth.updateUser({ password: newPassword });
      if (updateError) {
        const weakPassword = updateError.code === "weak_password" || /password|characters|weak/i.test(updateError.message);
        setError(weakPassword ? "Your new password does not meet the security requirements." : "We couldn't update your password. Please try again.");
        return;
      }

      setCurrentPassword("");
      setNewPassword("");
      setConfirmPassword("");
      const { error: globalSignOutError } = await supabase.auth.signOut({ scope: "global" });
      if (globalSignOutError) await supabase.auth.signOut({ scope: "local" });
      window.location.assign("/login?role=student&passwordChanged=true");
    } catch {
      setError("We couldn't update your password. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={submit} className="space-y-5" noValidate>
      <PasswordField id="current-password" label="Current password" autoComplete="current-password" value={currentPassword} onChange={setCurrentPassword} disabled={loading} />
      <PasswordField id="new-password" label="New password" autoComplete="new-password" value={newPassword} onChange={setNewPassword} disabled={loading} />
      <PasswordField id="confirm-password" label="Confirm new password" autoComplete="new-password" value={confirmPassword} onChange={setConfirmPassword} disabled={loading} />
      <p className="text-sm font-semibold text-[#62708a]">Use at least {MIN_PASSWORD_LENGTH} characters.</p>
      {error && <p role="alert" aria-live="polite" className="rounded-xl bg-red-50 p-3 text-sm font-bold text-red-700">{error}</p>}
      <button type="submit" className="btn-primary w-full" disabled={loading}>
        <KeyRound size={19} /> {loading ? "Updating password…" : "Save password"}
      </button>
    </form>
  );
}

function PasswordField({ id, label, autoComplete, value, onChange, disabled }: PasswordFieldProps) {
  const [visible, setVisible] = useState(false);
  return (
    <div>
      <label className="label" htmlFor={id}>{label}</label>
      <div className="relative">
        <input
          className="field pr-12"
          id={id}
          name={id}
          type={visible ? "text" : "password"}
          autoComplete={autoComplete}
          minLength={autoComplete === "new-password" ? MIN_PASSWORD_LENGTH : undefined}
          value={value}
          onChange={(event) => onChange(event.target.value)}
          required
          disabled={disabled}
        />
        <button type="button" aria-label={visible ? `Hide ${label.toLowerCase()}` : `Show ${label.toLowerCase()}`} onClick={() => setVisible((current) => !current)} disabled={disabled} className="focus-ring absolute right-3 top-3 rounded p-1 text-[#62708a]">
          {visible ? <EyeOff size={20} /> : <Eye size={20} />}
        </button>
      </div>
    </div>
  );
}
