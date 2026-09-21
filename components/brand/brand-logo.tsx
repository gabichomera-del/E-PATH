import Image from "next/image";
import Link from "next/link";

type BrandLogoProps = {
  variant?: "header" | "hero" | "guide";
  className?: string;
  priority?: boolean;
};

const styles = {
  header: "size-14 rounded-2xl shadow-[0_8px_24px_rgba(7,27,61,.16)] sm:size-16",
  hero: "aspect-square w-full max-w-[31rem] rounded-[3.5rem] shadow-[0_40px_90px_rgba(2,14,38,.5)]",
  guide: "size-16 rounded-2xl shadow-lg",
};

export function BrandLogo({ variant = "header", className = "", priority = false }: BrandLogoProps) {
  const image = <Image src="/assets/brand/e-path-logo-playful.svg" alt="E-P.A.T.H. — English learning adventure" width={1254} height={1254} priority={priority} sizes={variant === "hero" ? "(max-width: 1024px) 88vw, 496px" : variant === "header" ? "64px" : "64px"} className={`object-cover ${styles[variant]} ${className}`} />;
  if (variant === "guide") return image;
  return <Link href="/" aria-label="E-P.A.T.H. home" className="focus-ring inline-flex rounded-[3.5rem]">{image}</Link>;
}
