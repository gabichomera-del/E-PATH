alter table public.missions
  add column if not exists location text,
  add column if not exists map_x numeric(5,2),
  add column if not exists map_y numeric(5,2);

comment on column public.missions.location is 'World landmark associated with the mission.';
comment on column public.missions.map_x is 'Horizontal map position as a percentage from 0 to 100.';
comment on column public.missions.map_y is 'Vertical map position as a percentage from 0 to 100.';
