import { NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth/current-user";

export async function DELETE(
  _: Request,
  { params }: { params: Promise<{ classId: string; studentId: string }> },
) {
  const { classId, studentId } = await params;
  const { supabase, authUser, profile } = await getCurrentUser();

  if (!supabase || !authUser) {
    return NextResponse.json({ error: "Authentication required." }, { status: 401 });
  }
  if (profile?.role !== "teacher") {
    return NextResponse.json({ error: "Teacher access required." }, { status: 403 });
  }

  const { data, error } = await supabase.rpc("remove_student_from_class", {
    p_class_id: classId,
    p_student_id: studentId,
  });

  if (error) {
    if (error.message === "Class not found or access denied.") {
      return NextResponse.json({ error: error.message }, { status: 403 });
    }
    if (error.message === "Student is not enrolled in this class.") {
      return NextResponse.json({ error: error.message }, { status: 404 });
    }
    if (error.message === "Authentication required." || error.message === "Teacher access required.") {
      return NextResponse.json({ error: error.message }, { status: 403 });
    }
    console.error("Could not remove student from class.", {
      code: error.code,
      message: error.message,
    });
    return NextResponse.json({ error: "We couldn't remove this student from the class. Please try again." }, { status: 500 });
  }

  if (data !== true) {
    return NextResponse.json({ error: "The class membership was not removed." }, { status: 500 });
  }

  return NextResponse.json({ message: "Student removed from this class. Their account and progress were preserved." });
}
