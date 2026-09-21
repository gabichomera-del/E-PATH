# E-P.A.T.H.

Scalable, gamified English learning platform foundation built with Next.js, React, TypeScript, Tailwind CSS, Framer Motion, and Supabase.

## Architecture

- `app/` — route-first presentation layer for public, student, and teacher experiences.
- `components/` — reusable brand, authentication, landing, dashboard, and UI components.
- `lib/` — domain types, email validation, and browser/server Supabase adapters.
- `supabase/schema.sql` — relational schema, signup trigger, indexes, and Row Level Security policies.

Supabase Auth owns credentials and password hashes; passwords are intentionally never copied into `public.profiles`.

## Local setup

1. Create a Supabase project.
2. Run every file in `supabase/migrations/` in filename order using the Supabase SQL Editor or Supabase CLI.
3. Copy `.env.example` to `.env.local` and add the project URL, anon key, and server-only service-role key from Project Settings → API.
4. In Supabase Auth settings, configure the local Site URL as `http://localhost:3000` and add the production Vercel URL later.
5. Run `pnpm install`, then `pnpm dev`.

Without environment variables, all pages render in preview mode; authentication actions explain that Supabase must be configured.

## Deployment

Import the repository into Vercel and add the same three environment variables. Keep `SUPABASE_SERVICE_ROLE_KEY` server-only. Apply all migrations before enabling registrations.

## Next sprint

Add curriculum entities (units, missions, activities), XP transaction history and lives, teacher class creation, assignment workflows, and analytics derived from immutable attempt records.

## Sprint 2B learning engine

- `/student/unit/[id]` renders a data-driven, stateful mission path.
- `/student/mission/[id]` renders matching, fill-blank, multiple-choice, unscramble, reading, and writing activities through a shared registry.
- `lib/learning/` contains the curriculum domain model, repository boundary, and preview curriculum.
- `supabase/migrations/20260906_sprint_2b_learning_engine.sql` adds grades, units, missions, activities, items, progress, attempts, indexes, and Row Level Security.

The migration sequence includes the identity dependency foundation before curriculum tables. PostgreSQL-safe `sort_order` columns implement ordering fields.

## Sprint 3 accounts and classes

- Supabase Auth owns credentials; `public.users` owns authorization roles.
- Student registration pre-validates the class code, and the database trigger atomically creates the student profile and membership.
- Teachers can create classes with generated `EPATH-XXXXX` codes and inspect enrolled students.
- Password resets run through a server-only Admin API route after class ownership is verified. The temporary password is returned once; only a salted, non-reversible audit hash is stored.
- Protected student and teacher routes resolve roles from the database and are reinforced by Row Level Security.
