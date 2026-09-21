export type WorldLocation = { x: number; y: number; label: string };
export type WorldTheme = { unit: string; title: string; world: string; worldName: string; environmentImage: string; atmosphere: string; accent: string; success: string; foxAccessory: string; mapStyle: "campus" | "city" | "garden" | "future" | "mystery" | "sky"; locations: WorldLocation[] };

const superpowerLocations = [
  { x: 16, y: 75, label: "Academy Entrance" }, { x: 30, y: 60, label: "Power Discovery" },
  { x: 52, y: 42, label: "Hero Training" }, { x: 73, y: 27, label: "Sky Challenge" },
  { x: 88, y: 17, label: "Hero Hall" },
];

const superpowerTheme: WorldTheme = {
  unit: "Unit 6", title: "Superpowers", world: "hero-skies", worldName: "Superpower Academy",
  environmentImage: "/assets/worlds/unit-6-superpowers.png", atmosphere: "#083f77", accent: "#ff7d32",
  success: "#29cda0", foxAccessory: "cape", mapStyle: "sky", locations: superpowerLocations,
};

export function getWorldTheme(_unitNumber: number) { return superpowerTheme; }
