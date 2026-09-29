import "server-only";
import { createClient } from "@supabase/supabase-js";

export function getAdminEnvironmentStatus() {
  return {
    hasSupabaseUrl: Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL?.trim()),
    hasServiceRoleKey: Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()),
  };
}

export function createAdminClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim();
  const environment = getAdminEnvironmentStatus();

  if (!url || !key) {
    console.error("Supabase admin configuration is unavailable.", environment);
    return null;
  }

  try {
    return createClient(url, key, {
      auth: { autoRefreshToken: false, persistSession: false },
    });
  } catch (error) {
    const initializationError = error instanceof Error
      ? { name: error.name, message: error.message }
      : { name: "UnknownError", message: "Unknown Supabase admin initialization error." };
    console.error("Supabase admin client initialization failed.", {
      ...environment,
      error: initializationError,
    });
    return null;
  }
}
