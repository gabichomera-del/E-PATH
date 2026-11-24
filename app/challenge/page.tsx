import type { Metadata } from "next";
import { ChallengeExperience } from "@/components/challenge/ChallengeExperience";

export const metadata: Metadata = {
  title: "Challenge",
  description: "Discover what keeps the E-P.A.T.H. learning journey moving beyond the classroom.",
};

export default function ChallengePage() {
  return <ChallengeExperience/>;
}
