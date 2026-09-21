import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

export async function proxy(request: NextRequest) {
  const path = request.nextUrl.pathname;
  if (path === "/" || path === "/login" || path === "/register") {
    return NextResponse.next({ request });
  }
  let response = NextResponse.next({ request }); const url = process.env.NEXT_PUBLIC_SUPABASE_URL; const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) return response;
  const supabase = createServerClient(url, key, { cookies: { getAll: () => request.cookies.getAll(), setAll: (items: { name: string; value: string; options: CookieOptions }[]) => { items.forEach(({ name, value }) => request.cookies.set(name, value)); response = NextResponse.next({ request }); items.forEach(({ name, value, options }) => response.cookies.set(name, value, options)); } } });
  const { data: { user } } = await supabase.auth.getUser();
  if (path.startsWith("/student") || path.startsWith("/teacher")) {
    if (!user) return NextResponse.redirect(new URL(`/login?role=${path.startsWith("/teacher") ? "teacher" : "student"}`, request.url));
    const { data: profile } = await supabase.from("users").select("role").eq("id", user.id).maybeSingle();
    if (path.startsWith("/student") && profile?.role !== "student") return NextResponse.redirect(new URL("/teacher/dashboard", request.url));
    if (path.startsWith("/teacher") && profile?.role !== "teacher" && profile?.role !== "admin") return NextResponse.redirect(new URL("/student/dashboard", request.url));
  }
  return response;
}
export const config = { matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"] };
