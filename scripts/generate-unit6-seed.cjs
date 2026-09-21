const fs = require("node:fs");
const path = require("node:path");
const ts = require(path.join(
  process.env.LOCALAPPDATA,
  "Temp/e-path-deps-current/node_modules/typescript/lib/typescript.js",
));

const root = path.resolve(__dirname, "..");
const sourcePath = path.join(root, "lib/learning/unit-6.ts");
const outputPath = process.env.EPATH_SEED_OUTPUT || path.join(root, "supabase/migrations/20260920_02_seed_unit6_curriculum.sql");
const source = fs.readFileSync(sourcePath, "utf8");
const compiled = ts.transpileModule(source, {
  compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText;
const moduleShim = { exports: {} };
new Function("exports", "module", "require", compiled)(moduleShim.exports, moduleShim, require);
const missions = moduleShim.exports.unit6Missions;

if (!Array.isArray(missions) || missions.length !== 25) {
  throw new Error(`Expected exactly 25 Unit 6 missions; found ${missions?.length ?? 0}.`);
}
const stableKeys = missions.flatMap((mission) => [mission.id, ...mission.activities.flatMap((activity) => [activity.id, ...activity.items.map((item) => item.id)])]);
const duplicateKeys = stableKeys.filter((key, index) => stableKeys.indexOf(key) !== index);
if (duplicateKeys.length) throw new Error(`Duplicate curriculum content_key values: ${[...new Set(duplicateKeys)].join(", ")}`);

const q = (value) => `'${String(value).replaceAll("'", "''")}'`;
const json = (value) => `${q(JSON.stringify(value))}::jsonb`;
const nullable = (value) => (value == null ? "null" : q(value));
const lines = [
  "-- Generated from lib/learning/unit-6.ts. Do not hand-edit curriculum content here.",
  "-- Forward-only and idempotent: stable content_key values drive every upsert.",
  "do $seed$",
  "declare",
  "  v_grade_id uuid;",
  "  v_unit_id uuid;",
  "  v_mission_id uuid;",
  "  v_activity_id uuid;",
  "begin",
  "  insert into public.grades(name, sort_order)",
  "  values ('Grade 6', 6)",
  "  on conflict (name) do update set sort_order = excluded.sort_order",
  "  returning id into v_grade_id;",
  "",
  "  insert into public.units(grade_id, title, description, sort_order, content_key)",
  "  values (v_grade_id, 'Superpowers', 'Enter Superpower Academy and develop English through a 25-mission hero journey.', 6, 'unit-6')",
  "  on conflict (content_key) do update set grade_id=excluded.grade_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order",
  "  returning id into v_unit_id;",
];

for (const mission of missions) {
  lines.push(
    "",
    `  -- Mission ${mission.order}: ${mission.title.replaceAll("\n", " ")}`,
    "  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)",
    `  values (v_unit_id, ${q(mission.title)}, ${q(mission.description)}, ${mission.order}, ${q(mission.difficulty)}, ${mission.xpReward}, ${nullable(mission.badgeReward)}, ${q(mission.location)}, ${mission.mapPosition.x}, ${mission.mapPosition.y}, ${q(mission.id)})`,
    "  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y",
    "  returning id into v_mission_id;",
  );
  mission.activities.forEach((activity, activityIndex) => {
    const metadata = {};
    for (const key of ["correctFeedback", "incorrectFeedback", "unlockLabel", "completionMessage", "sequential", "audioScript", "schedule"]) {
      if (activity[key] !== undefined) metadata[key] = activity[key];
    }
    lines.push(
      "",
      "  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)",
      `  values (v_mission_id, ${q(activity.type)}::public.activity_type, ${q(activity.instructions)}, ${activityIndex + 1}, ${q(activity.id)}, ${json(metadata)})`,
      "  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata",
      "  returning id into v_activity_id;",
    );
    activity.items.forEach((item, itemIndex) => {
      const { id, answer, ...content } = item;
      lines.push(
        "  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)",
        `  values (v_activity_id, ${json(content)}, ${json(answer)}, ${itemIndex + 1}, ${q(id)})`,
        "  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;",
      );
    });
  });
}

lines.push("end", "$seed$;", "", "-- Mission objectives are preserved separately from descriptions.");
for (const mission of missions) {
  lines.push(`update public.missions set objective=${q(mission.objective)} where content_key=${q(mission.id)};`);
}
lines.push("");
fs.writeFileSync(outputPath, lines.join("\n"), "utf8");
console.log(JSON.stringify({ missions: missions.length, activities: missions.reduce((n, m) => n + m.activities.length, 0), items: missions.reduce((n, m) => n + m.activities.reduce((x, a) => x + a.items.length, 0), 0) }));
