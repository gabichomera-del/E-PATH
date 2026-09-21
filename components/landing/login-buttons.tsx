"use client";

import { motion } from "framer-motion";
import { ArrowRight, BookOpen, GraduationCap } from "lucide-react";
import Link from "next/link";

const actions = [
  { href: "/login?role=student", label: "Student Login", icon: GraduationCap, className: "btn-primary" },
  { href: "/login?role=teacher", label: "Teacher Login", icon: BookOpen, className: "btn-teacher" },
];

export function LoginButtons() {
  return <div className="mt-10 flex flex-col gap-5 sm:flex-row">{actions.map(({ href, label, icon: Icon, className }) => <motion.div key={label} whileHover={{ y: -3 }} whileTap={{ y: 2 }} transition={{ duration: .18 }} className="sm:flex-1"><Link href={href} className={`${className} font-adventure min-h-14 w-full min-w-56 rounded-2xl text-base font-semibold tracking-wide`}><Icon size={22}/>{label}<ArrowRight size={18}/></Link></motion.div>)}</div>;
}
