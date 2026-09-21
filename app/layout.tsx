import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: { default: "E-P.A.T.H. | English Learning", template: "%s | E-P.A.T.H." },
  description: "A gamified English learning platform for students and teachers.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
