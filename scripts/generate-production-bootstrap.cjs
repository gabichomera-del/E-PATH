const fs=require("node:fs");
const path=require("node:path");

const root=path.resolve(__dirname,"..");
const migrations=path.join(root,"supabase","migrations");
const output=process.env.EPATH_BOOTSTRAP_OUTPUT||path.join(root,"supabase","production-bootstrap.sql");
const read=(name)=>fs.readFileSync(path.join(migrations,name),"utf8").replace(/^\uFEFF/,"").trim();
const section=(number,name,file)=>`\n-- ============================================================================\n-- ${number}. ${name}\n-- Source: supabase/migrations/${file}\n-- ============================================================================\n${read(file)}\n`;

const historical=[
  ["1","CORE IDENTITY","20260905_core_identity.sql"],
  ["2","LEARNING ENGINE","20260906_sprint_2b_learning_engine.sql"],
  ["3","WORLD MAP","20260906_unit_world_map.sql"],
  ["4","USER AND CLASS MANAGEMENT","20260907_sprint_3_user_management.sql"],
  ["5","MISSION SCORE PERSISTENCE","20260910_mission_score_persistence.sql"],
];

const compatibility=`
-- The core migration creates identity tables before Sprint 3's CREATE TABLE IF
-- NOT EXISTS statements. Add the intended Sprint 3 checks explicitly so the
-- resulting empty-database schema is equivalent to the production definition.
do $$ begin alter table public.users add constraint users_first_name_not_blank check(length(trim(first_name))>0); exception when duplicate_object then null; end $$;
do $$ begin alter table public.users add constraint users_last_name_not_blank check(length(trim(last_name))>0); exception when duplicate_object then null; end $$;
do $$ begin alter table public.classes add constraint classes_academic_year_range check(academic_year between 2020 and 2100); exception when duplicate_object then null; end $$;
do $$ begin alter table public.classes add constraint classes_code_format check(class_code ~ '^EPATH-[A-Z0-9]{5}$'); exception when duplicate_object then null; end $$;
`;

let sql=`-- E-P.A.T.H. production bootstrap for a BRAND-NEW, EMPTY Supabase database.
-- Generated from the nine ordered migrations on 2026-09-20.
-- This file intentionally contains no teacher, class, or fictitious user data.
-- Execute only after reviewing the complete file. It has not been run remotely.

begin;
`;
for(const entry of historical)sql+=section(...entry);
sql+=`\n-- Empty-database compatibility normalization\n${compatibility}\ncommit;\n`;

sql+=`\n-- Commit before the seed: PostgreSQL requires newly added enum values to be\n-- committed before a later transaction can use them.\nbegin;\n`;
sql+=section("6","CURRICULUM KEYS AND TYPES","20260920_01_curriculum_keys_and_types.sql");
sql+="\ncommit;\n\nbegin;\n";
sql+=section("7","UNIT 6 CURRICULUM SEED","20260920_02_seed_unit6_curriculum.sql");
sql+="\ncommit;\n\nbegin;\n";
sql+=section("8","STUDENT LEARNING STATE","20260920_03_student_learning_state.sql");
sql+="\ncommit;\n\nbegin;\n";
sql+=section("9","LEARNING PROGRESS RLS AND RPC","20260920_04_learning_progress_rls_and_rpc.sql");
sql+="\ncommit;\n";

fs.writeFileSync(output,sql,"utf8");
console.log(JSON.stringify({output,bytes:Buffer.byteLength(sql),sections:9}));
