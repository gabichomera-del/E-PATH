import Link from "next/link";
import logoArt from "@/public/assets/brand/e-path-3d-logo.module.css";

type BrandLogoProps = {
  variant?: "header" | "hero" | "guide";
  tone?: "light" | "dark";
  className?: string;
  priority?: boolean;
};

const styles = {
  header: "w-52 sm:w-64",
  hero: "w-full max-w-[32rem]",
  guide: "w-36",
};

export function BrandLogo({ variant = "header", className = "" }: BrandLogoProps) {
  const logo = <span role="img" aria-label="E.P.A.T.H. fox explorer logo" className={`${logoArt.art} ${styles[variant]} ${className}`} />;
  if (variant === "guide") return logo;
  return <Link href="/" aria-label="E.P.A.T.H. home" className="focus-ring inline-flex rounded-xl">{logo}</Link>;
}
