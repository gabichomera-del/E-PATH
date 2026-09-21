-- Generated from lib/learning/unit-6.ts. Do not hand-edit curriculum content here.
-- Forward-only and idempotent: stable content_key values drive every upsert.
do $seed$
declare
  v_grade_id uuid;
  v_unit_id uuid;
  v_mission_id uuid;
  v_activity_id uuid;
begin
  insert into public.grades(name, sort_order)
  values ('Grade 6', 6)
  on conflict (name) do update set sort_order = excluded.sort_order
  returning id into v_grade_id;

  insert into public.units(grade_id, title, description, sort_order, content_key)
  values (v_grade_id, 'Superpowers', 'Enter Superpower Academy and develop English through a 25-mission hero journey.', 6, 'unit-6')
  on conflict (content_key) do update set grade_id=excluded.grade_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order
  returning id into v_unit_id;

  -- Mission 1: Welcome to Superpower Academy
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Welcome to Superpower Academy', 'Welcome to Superpower Academy! Discover your first abilities and start your hero training journey.', 1, 'starter', 150, 'Power Explorer', 'Academy Arrival Plaza', 14, 84, 'unit-6-mission-1')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'matching'::public.activity_type, 'Power Scanner: match each superpower with its correct description.', 1, 'u6-m1-power-scanner', '{"correctFeedback":"Power identified! Great scanning!","incorrectFeedback":"Check the power description and try again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Scan all six powers.","pairs":[{"left":"Telepathy","right":"The ability to communicate with someone''s thoughts."},{"left":"Invisibility","right":"The ability to disappear and not be seen."},{"left":"Super speed","right":"The ability to move faster than normal people."},{"left":"Telekinesis","right":"The ability to move objects using your mind."},{"left":"Healing power","right":"The power to recover from injuries quickly."},{"left":"Flying ability","right":"The ability to travel through the air."}]}'::jsonb, '"all"'::jsonb, 1, 'u6-m1-power-pairs')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Grammar Lab: complete each Second Conditional challenge using If + past simple + would + base verb.', 2, 'u6-m1-hero-grammar-lab', '{"correctFeedback":"Grammar power activated!","incorrectFeedback":"Check the past form after if and use would + base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If I _____ invisibility, I _____ secret places.","options":["had / would explore","have / explored","would have / explore","had / explored"],"incorrectExplanation":"Use past simple after if: had. Then use would + base verb: would explore."}'::jsonb, '"had / would explore"'::jsonb, 1, 'u6-m1-grammar-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Maya _____ a flying hero, she _____ people from tall buildings.","options":["is / rescued","would be / rescue","were / would rescue","was / will rescue"],"incorrectExplanation":"In an imaginary situation, use If Maya were... and would rescue."}'::jsonb, '"were / would rescue"'::jsonb, 2, 'u6-m1-grammar-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Leo _____ telekinesis, he _____ objects with his mind.","options":["discovers / moved","discovered / would move","would discover / moves","discovered / moved"],"incorrectExplanation":"Use discovered in the if-clause and would move in the result."}'::jsonb, '"discovered / would move"'::jsonb, 3, 'u6-m1-grammar-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If we _____ our powers responsibly, we _____ more people.","options":["use / helped","would use / help","used / helped","used / would help"],"incorrectExplanation":"Use used after if and would help for the imaginary result."}'::jsonb, '"used / would help"'::jsonb, 4, 'u6-m1-grammar-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Noah _____ healing power, he _____ injured heroes.","options":["had / would heal","has / healed","would have / heals","had / will heal"],"incorrectExplanation":"The Second Conditional pattern is If + had, then would + heal."}'::jsonb, '"had / would heal"'::jsonb, 5, 'u6-m1-grammar-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'The First Day at Superpower Academy', 3, 'u6-m1-reading-mission', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Leo was an ordinary student until one day he discovered a strange ability. When he touched objects, they started moving without anyone touching them. At first, Leo was scared because he did not understand his power. He joined Superpower Academy to learn how to control his ability. His mentor explained that having a power was not only about being strong. Heroes needed responsibility, creativity, and kindness. Leo met other students with different abilities. Emma could become invisible, and Noah could run extremely fast. Together, they learned that every power could help people in different ways.","prompt":"What ability did Leo discover?","options":["Moving objects with his mind.","Becoming invisible.","Running extremely fast.","Healing injuries quickly."]}'::jsonb, '"Moving objects with his mind."'::jsonb, 1, 'u6-m1-read-literal-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why did Leo join Superpower Academy?","options":["To meet ordinary students.","To become the strongest hero.","To control his ability.","To hide his power forever."]}'::jsonb, '"To control his ability."'::jsonb, 2, 'u6-m1-read-literal-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why was Leo scared at the beginning?","options":["Because he did not understand his ability.","Because his mentor was unkind.","Because Emma could become invisible.","Because the academy had no students."]}'::jsonb, '"Because he did not understand his ability."'::jsonb, 3, 'u6-m1-read-infer-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about Superpower Academy?","options":["It only accepts students who can fly.","It teaches students to use powers responsibly.","It asks students to hide their abilities.","It believes strength is the only hero quality."]}'::jsonb, '"It teaches students to use powers responsibly."'::jsonb, 4, 'u6-m1-read-infer-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'evaluated_writing'::public.activity_type, 'My Hero Identity Card: write 5–6 sentences, review the feedback, and revise your hero profile before saving.', 4, 'u6-m1-hero-identity', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Create your hero identity. Include your hero name, special ability, personality, how you help people, and one Second Conditional sentence.","minSentences":5,"maxSentences":6,"sentenceStarters":["My hero name is...","My special ability is...","I am...","I help people by...","If I had..., I would..."]}'::jsonb, '"teacher-reviewed"'::jsonb, 1, 'u6-m1-identity-writing')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 2: The Ability Scanner
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Ability Scanner', 'Welcome back, Hero Explorer! The Ability Scanner has discovered new powers around the academy. Your mission is to identify abilities and learn how heroes use them.', 2, 'starter', 150, 'Ability Detective', 'Power Scanner Deck', 30, 72, 'unit-6-mission-2')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Detective: read each clue and select the correct ability.', 1, 'u6-m2-power-detective', '{"correctFeedback":"Ability detected!","incorrectFeedback":"Scan the clue again and try another power."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"I can disappear and people cannot see me.","options":["Telepathy","Invisibility","Super strength","Flying"]}'::jsonb, '"Invisibility"'::jsonb, 1, 'u6-m2-power-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"I can communicate with someone''s thoughts.","options":["Telepathy","Healing power","Super speed","Telekinesis"]}'::jsonb, '"Telepathy"'::jsonb, 2, 'u6-m2-power-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"I can move objects without touching them.","options":["Flying","Telekinesis","Water control","Invisibility"]}'::jsonb, '"Telekinesis"'::jsonb, 3, 'u6-m2-power-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"I can recover quickly after an injury.","options":["Healing power","Super speed","Fire control","Mind control"]}'::jsonb, '"Healing power"'::jsonb, 4, 'u6-m2-power-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"I can move faster than normal people.","options":["Telepathy","Super speed","Flying","Invisibility"]}'::jsonb, '"Super speed"'::jsonb, 5, 'u6-m2-power-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Ability Control: choose can or can''t to describe each hero''s abilities.', 2, 'u6-m2-ability-control', '{"correctFeedback":"Ability control confirmed!","incorrectFeedback":"Compare the sentence with the hero''s power."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Sky has a flying ability. Sky _____ travel through the air.","options":["can","can''t","doesn''t"],"explanation":"Sky has a flying ability, so Sky can travel through the air.","incorrectExplanation":"Use can for an ability a hero has."}'::jsonb, '"can"'::jsonb, 1, 'u6-m2-control-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Shadow has invisibility. Shadow _____ become invisible.","options":["can''t","can","does"],"explanation":"Invisibility means Shadow can disappear from view.","incorrectExplanation":"Use can because becoming invisible is Shadow''s ability."}'::jsonb, '"can"'::jsonb, 2, 'u6-m2-control-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua controls water, not fire. Aqua _____ control fire.","options":["can","doesn''t","can''t"],"explanation":"Aqua''s power is water control, so Aqua can''t control fire.","incorrectExplanation":"Use can''t for an ability the hero does not have."}'::jsonb, '"can''t"'::jsonb, 3, 'u6-m2-control-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Flash has super speed. Flash _____ move very quickly.","options":["can''t","can","is"],"explanation":"Super speed means Flash can move very quickly.","incorrectExplanation":"Use can to express Flash''s ability."}'::jsonb, '"can"'::jsonb, 4, 'u6-m2-control-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mind Master has telepathy. Mind Master _____ read people''s thoughts.","options":["doesn''t","can''t","can"],"explanation":"Telepathy means Mind Master can communicate with thoughts.","incorrectExplanation":"Use can because reading thoughts is Mind Master''s ability."}'::jsonb, '"can"'::jsonb, 5, 'u6-m2-control-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'The New Hero Team', 3, 'u6-m2-reading-mission', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Superpower Academy is creating a new hero team. Four students want to join the team because they want to help people. Sara can control water. She can create waves and help during emergencies. Max can run extremely fast. He can arrive quickly when someone needs help. Lily can become invisible. She uses her power carefully because she knows that every ability has responsibility. Tom can communicate with animals. He helps protect forests and understand nature. The teacher explains that a true hero is not only someone with a powerful ability. A true hero knows how and when to use their power.","prompt":"What ability does Sara have?","options":["She can control water.","She can become invisible.","She can run extremely fast.","She can communicate with animals."]}'::jsonb, '"She can control water."'::jsonb, 1, 'u6-m2-read-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why can Max arrive quickly?","options":["Because he can fly.","Because he can run extremely fast.","Because he can control water.","Because he can become invisible."]}'::jsonb, '"Because he can run extremely fast."'::jsonb, 2, 'u6-m2-read-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why does Lily use her power carefully?","options":["Because she dislikes her ability.","Because she understands that powers require responsibility.","Because she wants to leave the team.","Because her power does not work."]}'::jsonb, '"Because she understands that powers require responsibility."'::jsonb, 3, 'u6-m2-read-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What is the main message of the text?","options":["Only fast heroes can help people.","Every hero should have the same power.","Heroes need responsibility, not only abilities.","Powerful abilities are always safe."]}'::jsonb, '"Heroes need responsibility, not only abilities."'::jsonb, 4, 'u6-m2-read-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Create Your Ability Card: write exactly 6 sentences, review the feedback, revise, and submit again.', 4, 'u6-m2-ability-card', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Write about a superhero ability. Include the hero name, special ability, what the hero can and cannot do, and how the power helps people.","minSentences":6,"maxSentences":6,"sentenceStarters":["My hero name is...","My ability is...","I can...","I can''t...","I help people...","My power is useful because..."],"writingRequirements":[{"label":"the hero name","pattern":"\\b(my hero name is|my superhero name is)\\b","message":"My hero name is..."},{"label":"a special ability","pattern":"\\b(my (special )?(ability|power) is)\\b","message":"My ability is..."},{"label":"what the hero can do","pattern":"\\bcan\\s+[a-z]+","message":"I can..."},{"label":"what the hero cannot do","pattern":"\\b(can''t|cannot)\\s+[a-z]+","message":"I can''t..."},{"label":"how the power helps people","pattern":"\\b(help|helps|protect|protects|save|saves|rescue|rescues)\\b","message":"I help people by..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m2-ability-writing')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 3: The Missing Power Crystal
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Missing Power Crystal', 'The Ability Laboratory has lost the Power Crystal. It contains important information about superhero abilities. Investigate the clues and discover which hero can recover it.', 3, 'starter', 150, 'Power Investigator', 'Ability Laboratory', 43, 84, 'unit-6-mission-3')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Power Investigation Files: read the four hero files and infer the best answer for each clue.', 1, 'u6-m3-investigation-files', '{"correctFeedback":"Clue confirmed!","incorrectFeedback":"Review the hero file and investigate again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"FILE 1 — NOVA: Nova can create and control fire. She can produce light and heat, but she cannot control water. She usually helps people during dangerous situations. FILE 2 — AQUA: Aqua can control water. She can move waves and create water barriers. She uses her power to protect cities near the ocean. FILE 3 — SHADOW: Shadow can disappear and become invisible. He uses his ability to enter dangerous places without being detected. FILE 4 — TITAN: Titan has super strength. He can lift heavy objects and help people after accidents.","prompt":"Which situation is better for Nova?","options":["Helping people during a fire emergency.","Saving people underwater.","Finding lost objects in the ocean."]}'::jsonb, '"Helping people during a fire emergency."'::jsonb, 1, 'u6-m3-file-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Aqua useful during floods?","options":["Because she can control water.","Because she can fly.","Because she can become invisible."]}'::jsonb, '"Because she can control water."'::jsonb, 2, 'u6-m3-file-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about Shadow''s ability?","options":["It is useful for secret missions.","It is only useful for sports.","It helps him control nature."]}'::jsonb, '"It is useful for secret missions."'::jsonb, 3, 'u6-m3-file-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What makes Titan a good rescue hero?","options":["His physical strength.","His ability to disappear.","His ability to read minds."]}'::jsonb, '"His physical strength."'::jsonb, 4, 'u6-m3-file-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Match the Hero: choose the best hero for each emergency situation.', 2, 'u6-m3-match-hero', '{"correctFeedback":"Excellent investigation choice!","incorrectFeedback":"Compare the situation with each hero''s ability."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A city has a huge flood. Which hero should respond?","options":["Shadow","Aqua","Titan","Nova"],"explanation":"Aqua can control water and create barriers during a flood."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m3-logic-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A building collapsed and people need help. Which hero should respond?","options":["Nova","Titan","Aqua","Shadow"],"explanation":"Titan can lift heavy objects during a rescue."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m3-logic-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A secret place needs investigation. Which hero should respond?","options":["Shadow","Titan","Nova","Aqua"],"explanation":"Shadow can enter dangerous places without being detected."}'::jsonb, '"Shadow"'::jsonb, 3, 'u6-m3-logic-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"People need light in a dark area. Which hero should respond?","options":["Aqua","Titan","Nova","Shadow"],"explanation":"Nova can create fire, light, and heat."}'::jsonb, '"Nova"'::jsonb, 4, 'u6-m3-logic-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Crystal Recovery Report: write exactly 5 sentences, review the investigation feedback, revise, and resubmit.', 3, 'u6-m3-crystal-report', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Write about the hero who can recover the Power Crystal. Include the hero name, special ability, what the hero can do, why the ability is useful, and your opinion.","minSentences":5,"maxSentences":5,"sentenceStarters":["... can recover the Power Crystal.","The hero has...","The hero can...","This ability is useful because...","I think..."],"writingRequirements":[{"label":"the hero name","pattern":"\\b(Nova|Aqua|Shadow|Titan)\\b","message":"Choose Nova, Aqua, Shadow, or Titan."},{"label":"a special ability","pattern":"\\b(ability|power|fire|water|invisible|invisibility|strength)\\b","message":"The hero has..."},{"label":"what the hero can do","pattern":"\\bcan\\s+[a-z]+","message":"The hero can..."},{"label":"why the ability is useful","pattern":"\\b(useful|because|help|helps|rescue|protect)\\b","message":"This ability is useful because..."},{"label":"your opinion","pattern":"\\b(I think|In my opinion|I believe)\\b","message":"I think..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m3-report-writing')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 4: Hero Rescue Mission
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Hero Rescue Mission', 'A city needs help! Different emergencies are happening around Superpower Academy. Choose the right heroes and decide what they would do with their abilities.', 4, 'starter', 150, 'Hero Helper', 'Emergency Response Hub', 56, 72, 'unit-6-mission-4')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Emergency Alerts: analyze each emergency and choose the most useful ability.', 1, 'u6-m4-emergency-alerts', '{"correctFeedback":"Good choice! The rescue plan is ready.","incorrectFeedback":"Think about what the emergency requires and try again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A group of people are trapped inside a building after an accident. Which ability would be most useful?","options":["Invisibility","Super strength","Telepathy","Flying"],"explanation":"Super strength is useful because the hero can move heavy objects and clear a path.","incorrectExplanation":"Choose the ability that can move heavy objects after an accident."}'::jsonb, '"Super strength"'::jsonb, 1, 'u6-m4-alert-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A city has a dangerous flood. Which ability would be most useful?","options":["Control water","Super speed","Read minds","Become invisible"],"explanation":"Water control can redirect waves and create barriers during a flood.","incorrectExplanation":"Choose the power that directly affects flood water."}'::jsonb, '"Control water"'::jsonb, 2, 'u6-m4-alert-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A missing person needs to be found. Which ability would help?","options":["Control fire","Telepathy","Super strength","Flying"],"explanation":"Telepathy may help the hero communicate with or locate the missing person.","incorrectExplanation":"Choose the power connected to thoughts and communication."}'::jsonb, '"Telepathy"'::jsonb, 3, 'u6-m4-alert-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"People need help in a very high place. Which ability would help?","options":["Flying","Healing power","Water control","Invisibility"],"explanation":"Flying lets the hero safely reach people in a high place.","incorrectExplanation":"Choose the ability that helps a hero reach high locations."}'::jsonb, '"Flying"'::jsonb, 4, 'u6-m4-alert-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Decision Center: choose the response that correctly uses If + past simple + would + base verb.', 2, 'u6-m4-decision-center', '{"correctFeedback":"Second Conditional activated!","incorrectFeedback":"Check the verb after if and the base verb after would."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You have super speed. What would you do?","options":["If I had super speed, I would help people quickly.","If I have super speed, I help people quickly.","If I had super speed, I helped people quickly."],"explanation":"Use had after if and would help for the imaginary result.","incorrectExplanation":"Remember: If + past simple + would + base verb."}'::jsonb, '"If I had super speed, I would help people quickly."'::jsonb, 1, 'u6-m4-decision-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can become invisible. What would you do?","options":["If I were invisible, I would help during secret missions.","If I am invisible, I would help during secret missions.","If I was invisible, I help during secret missions."],"explanation":"If I were expresses the imaginary condition; would help expresses the result.","incorrectExplanation":"Use were after If I and would + help in the result."}'::jsonb, '"If I were invisible, I would help during secret missions."'::jsonb, 2, 'u6-m4-decision-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You have the ability to fly. What would you do?","options":["If I could fly, I would travel around the world.","If I can fly, I traveled around the world.","If I could fly, I travel around the world."],"explanation":"Could fly and would travel form a correct imaginary situation.","incorrectExplanation":"Use If I could fly, followed by I would + base verb."}'::jsonb, '"If I could fly, I would travel around the world."'::jsonb, 3, 'u6-m4-decision-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'My Rescue Plan: write 5–6 sentences, review the feedback, revise, and resubmit before completing the mission.', 3, 'u6-m4-rescue-plan', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Describe an emergency, the power you would use, what you would do, and why the power is useful.","minSentences":5,"maxSentences":6,"requireSecondConditional":true,"sentenceStarters":["The emergency is...","If I had..., I would...","I would...","This power would be useful because...","I would help..."],"writingRequirements":[{"label":"an emergency situation","pattern":"\\b(emergency|accident|flood|fire|danger|trapped|missing|rescue)\\b","message":"The emergency is..."},{"label":"the power you would use","pattern":"\\b(power|ability|strength|speed|telepathy|invisibility|fly|flying|water)\\b","message":"The power I would use is..."},{"label":"what you would do","pattern":"\\bwould\\s+[a-z]+","message":"I would..."},{"label":"why the power is useful","pattern":"\\b(useful|because|help|protect|save|rescue)\\b","message":"This power is useful because..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m4-rescue-writing')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 5: The Hero Signal
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Hero Signal', 'A strange signal has appeared on the Superpower Academy communication system. Analyze its emergency clues and determine which hero should respond.', 5, 'starter', 150, 'Signal Solver', 'Discovery Beacon', 69, 82, 'unit-6-mission-5')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Emergency Signal: read the report carefully and use evidence to answer each question.', 1, 'u6-m5-emergency-signal', '{"correctFeedback":"Signal detail confirmed!","incorrectFeedback":"Look back at the emergency message and find evidence."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Attention, Superpower Academy! A powerful storm is moving toward the coastal area. Several streets are already covered with water. Some families are trapped inside their homes, and the rescue team needs help. The academy must send a hero who can deal with water and reach people quickly. The situation may become more dangerous if the storm continues.","prompt":"What is happening in the coastal area?","options":["A powerful storm is causing flooding.","A fire is spreading through the city.","A building has lost electricity.","A hero training event is beginning."]}'::jsonb, '"A powerful storm is causing flooding."'::jsonb, 1, 'u6-m5-signal-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Where are some families trapped?","options":["Inside their homes.","At Superpower Academy.","On a training tower.","Inside a laboratory."]}'::jsonb, '"Inside their homes."'::jsonb, 2, 'u6-m5-signal-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why does the rescue team need help?","options":["Because families are trapped and the situation is dangerous.","Because the heroes are taking an exam.","Because the streets are completely dry.","Because the storm has already ended."]}'::jsonb, '"Because families are trapped and the situation is dangerous."'::jsonb, 3, 'u6-m5-signal-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about the weather?","options":["The storm may continue to make the situation worse.","The weather will become sunny immediately.","The storm cannot affect the streets.","The coastal area has no more rain."]}'::jsonb, '"The storm may continue to make the situation worse."'::jsonb, 4, 'u6-m5-signal-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What type of ability would be most useful in this emergency?","options":["An ability related to controlling water.","An ability related to creating fire.","An ability used only for hiding.","An ability used for reading thoughts."]}'::jsonb, '"An ability related to controlling water."'::jsonb, 5, 'u6-m5-signal-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why would a hero who can control fire not be the best choice?","options":["Because the main problem is flooding and water.","Because fire heroes cannot help anyone.","Because the emergency is inside the academy.","Because the city needs more heat."]}'::jsonb, '"Because the main problem is flooding and water."'::jsonb, 6, 'u6-m5-signal-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Hero Files: study the four profiles and select the best hero for each situation.', 2, 'u6-m5-hero-files', '{"correctFeedback":"Evidence matched to the right hero!","incorrectFeedback":"Compare the situation with each hero''s file."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"AQUA — Ability: control water. Aqua can move water, create water barriers, and help during floods. NOVA — Ability: control fire. Nova can create flames, produce heat, and create light. SHADOW — Ability: invisibility. Shadow can become invisible, move without being seen, and enter restricted areas. TITAN — Ability: super strength. Titan can lift heavy objects, move damaged objects, and help during rescue operations.","prompt":"Flooded streets need to be cleared. Who is the best hero?","options":["Shadow","Aqua","Nova","Titan"],"explanation":"Aqua can move water and help during floods."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m5-file-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dark building needs light. Who is the best hero?","options":["Titan","Shadow","Nova","Aqua"],"explanation":"Nova can create flames and produce light."}'::jsonb, '"Nova"'::jsonb, 2, 'u6-m5-file-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dangerous location needs to be investigated secretly. Who is the best hero?","options":["Aqua","Nova","Titan","Shadow"],"explanation":"Shadow can move without being seen and enter restricted areas."}'::jsonb, '"Shadow"'::jsonb, 3, 'u6-m5-file-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A heavy object is blocking a rescue route. Who is the best hero?","options":["Nova","Titan","Aqua","Shadow"],"explanation":"Titan''s super strength helps him move heavy or damaged objects."}'::jsonb, '"Titan"'::jsonb, 4, 'u6-m5-file-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The city needs a water barrier before more flooding occurs. Who is the best hero?","options":["Titan","Shadow","Aqua","Nova"],"explanation":"Aqua can create water barriers and control the flooding."}'::jsonb, '"Aqua"'::jsonb, 5, 'u6-m5-file-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Final Rescue Decision: analyze the complete emergency and choose the strongest evidence-based plan.', 3, 'u6-m5-final-decision', '{"correctFeedback":"Excellent rescue reasoning!","incorrectFeedback":"Consider every part of the emergency and the abilities required."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The storm is becoming stronger. Aqua is helping near the flooded streets, but a family is trapped inside a damaged building whose entrance is blocked by concrete. Which plan would be most effective?","options":["Send Aqua alone because she can control water.","Send Titan to remove the concrete and Aqua to help with the flooding.","Send Shadow because invisibility can remove the concrete.","Send Nova because fire is the best solution for every emergency."],"explanation":"Titan can clear the heavy concrete while Aqua continues controlling the flood."}'::jsonb, '"Send Titan to remove the concrete and Aqua to help with the flooding."'::jsonb, 1, 'u6-m5-final-plan')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Titan useful in this situation?","options":["He can move heavy objects.","He can control the flooding.","He can become invisible.","He can create light."],"explanation":"Titan''s strength lets him remove the concrete blocking the entrance."}'::jsonb, '"He can move heavy objects."'::jsonb, 2, 'u6-m5-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Aqua still important?","options":["She can help control the flooding.","She can lift the concrete.","She can investigate secretly.","She can create fire."],"explanation":"Aqua addresses the continuing water emergency while Titan handles the building."}'::jsonb, '"She can help control the flooding."'::jsonb, 3, 'u6-m5-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about solving emergencies?","options":["Different abilities can solve different parts of the same problem.","One hero should solve every emergency alone.","The strongest hero is always the only useful hero.","Every emergency needs exactly the same ability."],"explanation":"Complex emergencies often require heroes to combine different strengths."}'::jsonb, '"Different abilities can solve different parts of the same problem."'::jsonb, 4, 'u6-m5-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 6: Design Your Power
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Design Your Power', 'The academy is opening a new Hero Training Arena. Before entering, every hero must design and register a unique power that can help people.', 6, 'starter', 150, 'Power Designer', 'Hero Training Arena', 78, 68, 'unit-6-mission-6')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Generator: combine an action, an element, and a purpose. Choose the ability that makes logical sense.', 1, 'u6-m6-power-generator', '{"correctFeedback":"Power combination confirmed! Your ability has a clear purpose.","incorrectFeedback":"Check how the action and element work together, then try again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"CONTROL + WATER · Purpose: rescue people during floods. What can this hero do?","options":["Read people''s thoughts.","Move water and create waves.","Become invisible.","Talk to animals."],"explanation":"Controlling water lets the hero redirect water and create waves during a flood."}'::jsonb, '"Move water and create waves."'::jsonb, 1, 'u6-m6-power-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"COMMUNICATE WITH + ANIMALS · Purpose: protect nature. What can this hero do?","options":["Create fire and heat.","Travel through the air.","Talk to animals and understand them.","Move through shadows."],"explanation":"Animal communication helps the hero learn what animals need and protect their habitats."}'::jsonb, '"Talk to animals and understand them."'::jsonb, 2, 'u6-m6-power-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"BECOME + SHADOWS · Purpose: explore dangerous places. What is the most logical ability?","options":["Control oceans and rivers.","Move through shadows without being easily seen.","Read people''s minds.","Create strong winds."],"explanation":"Becoming part of the shadows helps the hero explore without attracting attention."}'::jsonb, '"Move through shadows without being easily seen."'::jsonb, 3, 'u6-m6-power-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"CREATE + FIRE · Purpose: solve problems in dark or cold places. What can this hero do?","options":["Produce flames, heat, and light.","Speak with animals.","Move water away.","Become invisible."],"explanation":"Creating fire can provide controlled heat and light when they are needed."}'::jsonb, '"Produce flames, heat, and light."'::jsonb, 4, 'u6-m6-power-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"TRAVEL THROUGH + AIR · Purpose: rescue people in high places. What can this hero do?","options":["Read hidden thoughts.","Create ocean waves.","Lift objects with the mind.","Fly to high or distant places."],"explanation":"Traveling through the air lets the hero reach roofs, towers, and distant places quickly."}'::jsonb, '"Fly to high or distant places."'::jsonb, 5, 'u6-m6-power-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"COMMUNICATE WITH + PEOPLE''S THOUGHTS · Purpose: find and help lost people. What can this hero do?","options":["Become a shadow.","Share and receive thoughts without speaking.","Control fire.","Run across water."],"explanation":"Communicating through thoughts can help locate someone and understand what help they need."}'::jsonb, '"Share and receive thoughts without speaking."'::jsonb, 6, 'u6-m6-power-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Upgrade Challenge: choose the power upgrade that best solves each hero''s problem.', 2, 'u6-m6-hero-upgrade', '{"correctFeedback":"Smart upgrade! That ability matches the hero''s mission.","incorrectFeedback":"Think about the exact problem the hero needs to solve."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero can fly, but cannot help people trapped inside damaged buildings. Which upgrade would be most useful?","options":["Animal communication","Super strength","Invisibility","Telepathy"],"explanation":"Super strength would help the hero move heavy debris and open a safe rescue route.","incorrectExplanation":"The hero needs an ability that can move the heavy parts of a damaged building."}'::jsonb, '"Super strength"'::jsonb, 1, 'u6-m6-upgrade-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero can run very fast but needs to find people who are lost. Which upgrade would help most?","options":["Water control","Fire control","Telepathy","Super strength"],"explanation":"Telepathy could help the hero detect or communicate with lost people.","incorrectExplanation":"The best upgrade should help locate people, not only travel faster."}'::jsonb, '"Telepathy"'::jsonb, 2, 'u6-m6-upgrade-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero protects forests. Which ability would be most useful?","options":["Flying","Invisibility","Super speed","Animal communication"],"explanation":"Animals can share clues about danger and changes in their habitat.","incorrectExplanation":"Choose the power that helps the hero understand the creatures living in the forest."}'::jsonb, '"Animal communication"'::jsonb, 3, 'u6-m6-upgrade-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero needs to enter dangerous places without being noticed. Which ability would be most useful?","options":["Invisibility","Healing","Water control","Super strength"],"explanation":"Invisibility lets the hero enter and investigate without attracting attention.","incorrectExplanation":"The mission requires the hero to remain unseen."}'::jsonb, '"Invisibility"'::jsonb, 4, 'u6-m6-upgrade-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero works near the ocean and often helps during floods. Which ability would be most useful?","options":["Super speed","Invisibility","Control water","Telepathy"],"explanation":"Water control directly helps manage ocean water and flooding.","incorrectExplanation":"Choose the power connected to the main danger: too much water."}'::jsonb, '"Control water"'::jsonb, 5, 'u6-m6-upgrade-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Mini Hero Profile: write exactly 6 sentences. Review the feedback, revise important errors, and resubmit to register your hero.', 3, 'u6-m6-mini-profile', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Create the superhero you designed. Include a hero name, special ability, what the hero can do, the purpose of the power, one thing the hero cannot do, and one Second Conditional sentence.","minSentences":6,"maxSentences":6,"requireSecondConditional":true,"sentenceStarters":["My hero is...","The hero''s special ability is...","The hero can...","The hero uses this power to...","The hero cannot...","If the hero had..., the hero would..."],"writingRequirements":[{"label":"a hero name","pattern":"\\b(my hero is|my hero name is|the hero is)\\b","message":"My hero is..."},{"label":"a special ability","pattern":"\\b(ability|power|control|create|move|communicate|become|travel|fly|invisibility|strength|speed|telepathy)\\b","message":"The hero''s special ability is..."},{"label":"what the hero can do","pattern":"\\bcan\\s+[a-z]+","message":"The hero can..."},{"label":"the purpose of the power","pattern":"\\b(help|protect|rescue|explore|solve|communicate|save)\\b","message":"The hero uses this power to..."},{"label":"something the hero cannot do","pattern":"\\b(can''t|cannot)\\s+[a-z]+","message":"The hero cannot..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m6-profile-writing')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 7: What Would You Do?
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'What Would You Do?', 'The Hero Training Arena is testing your decision-making skills. Every power creates different possibilities. What would you do if you were a superhero?', 7, 'starter', 150, 'Hero Decision Maker', 'Hero Training Arena', 64, 58, 'unit-6-mission-7')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Choices: identify the complete sentence that correctly expresses each imaginary situation.', 1, 'u6-m7-power-choices', '{"correctFeedback":"Great! The Second Conditional uses a past form after ''if'' and ''would + base verb'' in the result.","incorrectFeedback":"Check both parts: If + past form, then would + base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You have super speed. Which sentence is correct?","options":["If I have super speed, I would help people.","If I had super speed, I would help people.","If I had super speed, I helped people."],"explanation":"Had is the past form after if, and would help uses would + base verb."}'::jsonb, '"If I had super speed, I would help people."'::jsonb, 1, 'u6-m7-recognize-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You can fly. Which sentence is correct?","options":["If I could fly, I visited different countries.","If I can fly, I would visit different countries.","If I could fly, I would visit different countries."],"explanation":"Could expresses the imaginary ability, and would visit describes the imagined result."}'::jsonb, '"If I could fly, I would visit different countries."'::jsonb, 2, 'u6-m7-recognize-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You can become invisible. Which sentence is correct?","options":["If I were invisible, I entered the building.","If I were invisible, I would enter the building.","If I am invisible, I would enter the building."],"explanation":"Were belongs in the imaginary if-clause, followed by would enter in the result."}'::jsonb, '"If I were invisible, I would enter the building."'::jsonb, 3, 'u6-m7-recognize-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You can control water. Which sentence is correct?","options":["If I control water, I would help during floods.","If I controlled water, I helped during floods.","If I controlled water, I would help during floods."],"explanation":"Controlled is the past form, and would help follows the correct result pattern."}'::jsonb, '"If I controlled water, I would help during floods."'::jsonb, 4, 'u6-m7-recognize-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You can communicate with animals. Which sentence is correct?","options":["If I could communicate with animals, I would protect them.","If I could communicate with animals, I protected them.","If I can communicate with animals, I would protect them."],"explanation":"Could introduces the imaginary ability, while would protect gives the possible result."}'::jsonb, '"If I could communicate with animals, I would protect them."'::jsonb, 5, 'u6-m7-recognize-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'What Would You Do? Choose the most logical response using the Second Conditional.', 2, 'u6-m7-hero-decisions', '{"correctFeedback":"Strong hero decision—and the grammar pattern is correct!","incorrectFeedback":"Choose the response that is both logical and grammatically complete."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You discover that you can fly. What would you do?","options":["If I can fly, I helped people in difficult places.","If I could fly, I would help people in difficult places.","If I could fly, I help people in difficult places."],"explanation":"Flying would let the hero reach people in places that are difficult to access."}'::jsonb, '"If I could fly, I would help people in difficult places."'::jsonb, 1, 'u6-m7-decision-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Your city has a serious flood, and you can control water. What would you do?","options":["If I controlled water, I moved the water away.","If I control water, I would moved the water away.","If I controlled water, I would move the water away from people''s homes."],"explanation":"Moving floodwater away directly protects homes, and the sentence uses controlled + would move."}'::jsonb, '"If I controlled water, I would move the water away from people''s homes."'::jsonb, 2, 'u6-m7-decision-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can read people''s thoughts. What would you do?","options":["If I could read minds, I help people.","If I could read minds, I would help people who need help.","If I can read minds, I would helped people."],"explanation":"The hero uses the ability responsibly to identify people who need support."}'::jsonb, '"If I could read minds, I would help people who need help."'::jsonb, 3, 'u6-m7-decision-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can become invisible. What would you do during a rescue mission?","options":["If I am invisible, I entered the dangerous area.","If I were invisible, I would enter the dangerous area carefully.","If I were invisible, I enter the dangerous area."],"explanation":"Invisibility could help the hero enter safely, but acting carefully remains important."}'::jsonb, '"If I were invisible, I would enter the dangerous area carefully."'::jsonb, 4, 'u6-m7-decision-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You have super strength. What would you do after an earthquake?","options":["If I had super strength, I moved heavy objects.","If I have super strength, I would move heavy objects.","If I had super strength, I would move heavy objects."],"explanation":"Moving heavy debris is a useful rescue action, expressed with had + would move."}'::jsonb, '"If I had super strength, I would move heavy objects."'::jsonb, 5, 'u6-m7-decision-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Grammar Repair: inspect each incorrect sentence and select its repaired version.', 3, 'u6-m7-grammar-repair', '{"correctFeedback":"Grammar repaired! The training system is back online.","incorrectFeedback":"Inspect the verb after ''if'' and the verb that follows ''would''."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If I have super speed, I would help people.”","options":["If I have super speed, I help people.","If I had super speed, I helped people.","If I had super speed, I would help people."],"explanation":"Change have to had; would help is already correct."}'::jsonb, '"If I had super speed, I would help people."'::jsonb, 1, 'u6-m7-repair-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If she could fly, she would traveled around the world.”","options":["If she could fly, she traveled around the world.","If she could fly, she would travel around the world.","If she can fly, she would travel around the world."],"explanation":"After would, use the base verb travel—not traveled."}'::jsonb, '"If she could fly, she would travel around the world."'::jsonb, 2, 'u6-m7-repair-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If I were invisible, I would entered the building.”","options":["If I were invisible, I entered the building.","If I am invisible, I would enter the building.","If I were invisible, I would enter the building."],"explanation":"Would must be followed by the base verb enter."}'::jsonb, '"If I were invisible, I would enter the building."'::jsonb, 3, 'u6-m7-repair-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If he had super strength, he move heavy objects.”","options":["If he has super strength, he would move heavy objects.","If he had super strength, he would move heavy objects.","If he had super strength, he moved heavy objects."],"explanation":"The result clause needs would + move."}'::jsonb, '"If he had super strength, he would move heavy objects."'::jsonb, 4, 'u6-m7-repair-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If we could control water, we would helped the city.”","options":["If we could control water, we helped the city.","If we can control water, we would help the city.","If we could control water, we would help the city."],"explanation":"After would, use the base verb help."}'::jsonb, '"If we could control water, we would help the city."'::jsonb, 5, 'u6-m7-repair-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If I were a superhero, I would protects people.”","options":["If I were a superhero, I protected people.","If I were a superhero, I would protect people.","If I am a superhero, I would protect people."],"explanation":"After would, the verb stays in its base form: protect."}'::jsonb, '"If I were a superhero, I would protect people."'::jsonb, 6, 'u6-m7-repair-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 8: The Mystery Hero
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Mystery Hero', 'A mysterious hero has entered Superpower Academy. Several secret files contain clues. Read the evidence and discover who the mystery hero is.', 8, 'starter', 150, 'Mystery Solver', 'Hero Training Arena', 50, 66, 'unit-6-mission-8')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Secret File — The Mystery Hero: read carefully and investigate each clue. The file contains both direct information and evidence you must interpret.', 1, 'u6-m8-secret-file', '{"correctFeedback":"Evidence confirmed! You found the clue in the secret file.","incorrectFeedback":"Not quite. Return to the text and look for evidence that supports your answer."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Nobody knows exactly who the new student at Superpower Academy is. The academy records say that the student can move very quickly and can reach places before other people. The student is also very careful and prefers helping people without attracting attention. During a training exercise, the student helped a group of younger students leave a dangerous area. Nobody saw the hero enter the area. Later, the academy discovered that the student had also helped an injured animal near the forest. The teachers believe that the mystery hero has an ability that combines speed with another special skill. The identity of the student is still unknown.","prompt":"What can the mystery hero do very quickly?","options":["Control water during storms.","Move and reach places quickly.","Lift extremely heavy objects.","Create fire and light."],"explanation":"The academy records say the student moves quickly and reaches places before other people."}'::jsonb, '"Move and reach places quickly."'::jsonb, 1, 'u6-m8-read-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Who did the hero help during the training exercise?","options":["The academy teachers.","A rescue team.","A group of younger students.","A group of forest guards."],"explanation":"The text directly states that the hero helped younger students leave a dangerous area."}'::jsonb, '"A group of younger students."'::jsonb, 2, 'u6-m8-read-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Where did the hero help an injured animal?","options":["Inside the academy laboratory.","Near the forest.","At the training arena.","Beside the ocean."],"explanation":"The injured animal was found near the forest."}'::jsonb, '"Near the forest."'::jsonb, 3, 'u6-m8-read-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why do teachers think the hero has more than one special skill?","options":["Because the hero is stronger than every teacher.","Because the hero combines speed with another ability.","Because the hero can control every element.","Because the records reveal the hero''s full identity."],"explanation":"Speed explains arriving quickly, but the unseen rescue suggests another special skill."}'::jsonb, '"Because the hero combines speed with another ability."'::jsonb, 4, 'u6-m8-read-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about the hero''s personality?","options":["The hero is competitive and wants fame.","The hero is afraid to help others.","The hero is helpful and does not want attention.","The hero only cares about winning."],"explanation":"The hero repeatedly helps others and prefers doing so without attracting attention."}'::jsonb, '"The hero is helpful and does not want attention."'::jsonb, 5, 'u6-m8-read-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why was it difficult for other students to see the hero during the rescue?","options":["The rescue happened at night with no witnesses.","The teachers asked everyone to close their eyes.","The hero moved quickly and may have another ability that helped them remain unnoticed.","The hero used water to hide the entire area."],"explanation":"The text links fast movement with a second unknown skill and says nobody saw the hero enter."}'::jsonb, '"The hero moved quickly and may have another ability that helped them remain unnoticed."'::jsonb, 6, 'u6-m8-read-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Evidence: decide whether each statement is SUPPORTED BY THE TEXT or NOT SUPPORTED BY THE TEXT.', 2, 'u6-m8-hero-evidence', '{"correctFeedback":"Correct. Your decision matches the evidence in the file.","incorrectFeedback":"Check the secret file again. Decide whether the statement is actually stated or supported."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The mystery hero can move very quickly.","options":["NOT SUPPORTED BY THE TEXT","SUPPORTED BY THE TEXT"],"explanation":"The records say the student can move very quickly and arrive before other people."}'::jsonb, '"SUPPORTED BY THE TEXT"'::jsonb, 1, 'u6-m8-evidence-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The mystery hero enjoys being the center of attention.","options":["SUPPORTED BY THE TEXT","NOT SUPPORTED BY THE TEXT"],"explanation":"The text says the opposite: the hero prefers helping without attracting attention."}'::jsonb, '"NOT SUPPORTED BY THE TEXT"'::jsonb, 2, 'u6-m8-evidence-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The hero helped younger students during a dangerous situation.","options":["SUPPORTED BY THE TEXT","NOT SUPPORTED BY THE TEXT"],"explanation":"The training record says the hero helped younger students leave a dangerous area."}'::jsonb, '"SUPPORTED BY THE TEXT"'::jsonb, 3, 'u6-m8-evidence-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The hero helped an injured animal.","options":["NOT SUPPORTED BY THE TEXT","SUPPORTED BY THE TEXT"],"explanation":"The academy discovered that the student helped an injured animal near the forest."}'::jsonb, '"SUPPORTED BY THE TEXT"'::jsonb, 4, 'u6-m8-evidence-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The teachers already know the hero''s identity.","options":["NOT SUPPORTED BY THE TEXT","SUPPORTED BY THE TEXT"],"explanation":"The file clearly says the student''s identity is still unknown."}'::jsonb, '"NOT SUPPORTED BY THE TEXT"'::jsonb, 5, 'u6-m8-evidence-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The hero may have more than one ability.","options":["SUPPORTED BY THE TEXT","NOT SUPPORTED BY THE TEXT"],"explanation":"The teachers believe the hero combines speed with another special skill."}'::jsonb, '"SUPPORTED BY THE TEXT"'::jsonb, 6, 'u6-m8-evidence-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Solve the Mystery: connect the four clues and select conclusions supported by the evidence. Clue 1: fast movement. Clue 2: helps without attention. Clue 3: unseen entering danger. Clue 4: helped an animal near the forest.', 3, 'u6-m8-solve-mystery', '{"correctFeedback":"Excellent detective work! Your conclusion is supported by the evidence.","incorrectFeedback":"Compare every option with the clues. Choose the conclusion that explains the most evidence."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero is most likely to be the mystery hero?","options":["Aqua — control water","Titan — super strength","Shadow — invisibility and fast movement","Storm — control water"],"explanation":"Shadow''s two abilities explain both the hero''s speed and why nobody saw the rescue."}'::jsonb, '"Shadow — invisibility and fast movement"'::jsonb, 1, 'u6-m8-solve-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which TWO clues most strongly identify Shadow?","options":["Clue 2 and Clue 4","Clue 1 and Clue 3","Clue 1 and Clue 4","Clue 2 and Clue 3"],"explanation":"Clue 1 points to fast movement, while Clue 3 points to invisibility. Together they match both of Shadow''s powers."}'::jsonb, '"Clue 1 and Clue 3"'::jsonb, 2, 'u6-m8-solve-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about the mystery hero''s values?","options":["The hero wants to win every competition.","The hero does not care about other people.","The hero wants to become famous.","The hero wants to help others."],"explanation":"The hero rescues younger students and helps an injured animal without seeking attention."}'::jsonb, '"The hero wants to help others."'::jsonb, 3, 'u6-m8-solve-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Shadow a better match than Titan?","options":["Titan can become invisible.","Shadow has super strength.","Titan can control water.","Shadow''s abilities explain both the speed and the fact that nobody saw the hero."],"explanation":"Titan''s strength does not explain the two central clues: fast movement and remaining unseen."}'::jsonb, '"Shadow''s abilities explain both the speed and the fact that nobody saw the hero."'::jsonb, 4, 'u6-m8-solve-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 9: The Hero Ability Leaflet
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Hero Ability Leaflet', 'The Energy Research Center is preparing an exhibition about superhero abilities. Every hero needs an official ability leaflet. Create one for a hero of your choice.', 9, 'starter', 150, 'Hero Designer', 'Energy Research Center', 36, 55, 'unit-6-mission-9')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Build Your Ability: assemble each power from an action, an element, and a useful purpose. Choose the combination whose meaning is logical.', 1, 'u6-m9-power-builder', '{"correctFeedback":"Power built! The action, ability, and purpose work together logically.","incorrectFeedback":"Think about what the action can realistically do with that power and purpose."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could help people during a flood?","options":["Become fire to communicate with animals.","Control water to help people.","Travel through thoughts to create air.","Move shadows to control a city."],"explanation":"Controlling water could redirect dangerous floodwater and help people reach safety."}'::jsonb, '"Control water to help people."'::jsonb, 1, 'u6-m9-build-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could protect nature and its wildlife?","options":["Create shadows to move water.","Travel through fire to read thoughts.","Communicate with animals to protect nature.","Become air to create animals."],"explanation":"Talking with animals could help a hero understand dangers affecting wildlife and habitats."}'::jsonb, '"Communicate with animals to protect nature."'::jsonb, 2, 'u6-m9-build-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could help explore a dangerous place without being seen?","options":["Control animals to produce fire.","Move air to read water.","Become a shadow to explore dangerous places.","Create thoughts to protect nature."],"explanation":"A shadow ability would help a hero explore carefully without attracting attention."}'::jsonb, '"Become a shadow to explore dangerous places."'::jsonb, 3, 'u6-m9-build-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could provide light and warmth in an emergency?","options":["Communicate with air to rescue thoughts.","Create fire to solve problems.","Become water to protect flames.","Move animals to create shadows."],"explanation":"Controlled fire can provide useful heat and light when used responsibly."}'::jsonb, '"Create fire to solve problems."'::jsonb, 4, 'u6-m9-build-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could reach people trapped on a high tower?","options":["Control thoughts to become water.","Create animals to protect fire.","Travel through air to rescue others.","Become a shadow to move a city."],"explanation":"Traveling through the air allows a hero to reach high places safely."}'::jsonb, '"Travel through air to rescue others."'::jsonb, 5, 'u6-m9-build-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power design could locate people who cannot call for help?","options":["Move fire to become an animal.","Communicate with people''s thoughts to help people.","Control air to create water.","Travel through shadows to protect flames."],"explanation":"Thought communication could reveal where someone is and what assistance they need."}'::jsonb, '"Communicate with people''s thoughts to help people."'::jsonb, 6, 'u6-m9-build-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'school_profile'::public.activity_type, 'Choose Your Hero Details: personalize every part of the official leaflet. All listed choices are valid—build the hero you want to present.', 2, 'u6-m9-profile-builder', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Hero name","options":["Nova Guardian","Shadow Spark","Aqua Fox","Sky Sentinel"]}'::jsonb, '"student-choice"'::jsonb, 1, 'u6-m9-detail-name')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Personality","options":["Brave","Creative","Responsible","Intelligent","Helpful","Adventurous"]}'::jsonb, '"student-choice"'::jsonb, 2, 'u6-m9-detail-personality')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Special ability","options":["Control water","Create fire","Communicate with animals","Move objects","Become a shadow","Travel through air"]}'::jsonb, '"student-choice"'::jsonb, 3, 'u6-m9-detail-ability')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Main strength","options":["Speed","Strength","Intelligence","Courage","Creativity"]}'::jsonb, '"student-choice"'::jsonb, 4, 'u6-m9-detail-strength')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Main purpose","options":["Rescue people","Protect nature","Protect the city","Solve problems","Help other heroes"]}'::jsonb, '"student-choice"'::jsonb, 5, 'u6-m9-detail-purpose')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Hero symbol","options":["⚡ Energy bolt","🛡️ Hero shield","💧 Water drop","🌟 Academy star","🪽 Flight wings"]}'::jsonb, '"student-choice"'::jsonb, 6, 'u6-m9-detail-symbol')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Create Your Hero Ability Leaflet: write 7–8 original sentences. Review specific feedback, revise important errors, and resubmit before publishing the leaflet.', 3, 'u6-m9-leaflet-writing', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Write your digital hero leaflet. Include the hero''s name, personality, special ability, what the hero can do, how the power helps people, why it is useful, the main purpose, and one Second Conditional sentence.","minSentences":7,"maxSentences":8,"requireSecondConditional":true,"sentenceStarters":["My hero is...","My hero is... and...","The special ability is...","The hero can...","This power helps people by...","This power is useful because...","If my hero had another power, he/she would...","My hero''s main purpose is to..."],"writingRequirements":[{"label":"a hero name","pattern":"\\b(my hero is|my hero name is|the hero is)\\b","message":"My hero is..."},{"label":"the hero''s personality","pattern":"\\b(brave|creative|responsible|intelligent|helpful|adventurous)\\b","message":"My hero is brave, creative, responsible, intelligent, helpful, or adventurous."},{"label":"a special ability","pattern":"\\b(ability|power|control|create|communicate|move|become|travel|water|fire|animals|shadows|air|thoughts)\\b","message":"The special ability is..."},{"label":"what the hero can do","pattern":"\\bcan\\s+[a-z]+","message":"The hero can..."},{"label":"how the power helps people","pattern":"\\b(help|helps|rescue|rescues|protect|protects|save|saves)\\b","message":"This power helps people by..."},{"label":"why the ability is useful","pattern":"\\b(useful|because)\\b","message":"This power is useful because..."},{"label":"the hero''s main purpose","pattern":"\\b(main purpose|uses? (?:this|the) (?:ability|power) to)\\b","message":"My hero''s main purpose is to..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m9-leaflet-text')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 10: Superpower Checkpoint
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Superpower Checkpoint', 'Congratulations, Hero! You completed the first stage of training. Solve this special Superpower Checkpoint before entering the next area of the academy.', 10, 'starter', 200, 'Superpower Trainee', 'Hero Training Arena', 21, 63, 'unit-6-mission-10')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Sort: analyze each situation and select the ability that would be most useful. Base every choice on the problem that needs to be solved.', 1, 'u6-m10-power-sort', '{"correctFeedback":"Good choice! That ability directly addresses the situation.","incorrectFeedback":"Look at the main problem in the situation and choose the ability that solves it most directly."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hospital needs someone who can help injured people recover faster. Which ability is most useful?","options":["Super speed","Healing power","Flying","Invisibility"],"explanation":"Healing power is the best choice because the situation involves injured people who need to recover."}'::jsonb, '"Healing power"'::jsonb, 1, 'u6-m10-sort-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A scientist needs to enter a secret laboratory without being seen. Which ability is most useful?","options":["Water control","Super strength","Invisibility","Healing power"],"explanation":"Invisibility would allow the scientist to enter without being noticed."}'::jsonb, '"Invisibility"'::jsonb, 2, 'u6-m10-sort-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A forest ranger needs help communicating with animals. Which ability is most useful?","options":["Fire control","Animal communication","Telepathy","Super speed"],"explanation":"Animal communication directly lets the hero understand and speak with forest animals."}'::jsonb, '"Animal communication"'::jsonb, 3, 'u6-m10-sort-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A bridge has collapsed and a heavy piece of metal is blocking the road. Which ability is most useful?","options":["Flying","Telepathy","Invisibility","Super strength"],"explanation":"Super strength would help move the heavy metal and reopen the road."}'::jsonb, '"Super strength"'::jsonb, 4, 'u6-m10-sort-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A rescue team needs to reach a mountain quickly. Which ability is most useful?","options":["Flying","Telepathy","Healing power","Water control"],"explanation":"Flying provides a fast and direct route to a high mountain location."}'::jsonb, '"Flying"'::jsonb, 5, 'u6-m10-sort-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A person is trapped during a flood. Which ability is most useful?","options":["Invisibility","Super strength","Control water","Telepathy"],"explanation":"Controlling water could reduce the flood danger and create a safe rescue route."}'::jsonb, '"Control water"'::jsonb, 6, 'u6-m10-sort-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero Mistakes: inspect each superhero statement and choose the version that repairs its grammar or meaning.', 2, 'u6-m10-hero-mistakes', '{"correctFeedback":"Error repaired! Your hero language is checkpoint-ready.","incorrectFeedback":"Check both the grammar pattern and the meaning of the ability before choosing."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “My hero can controls fire.”","options":["My hero can controlling fire.","My hero can control fire.","My hero can controlled fire."],"explanation":"After can, use the base form of the verb: control."}'::jsonb, '"My hero can control fire."'::jsonb, 1, 'u6-m10-error-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If I had super speed, I will help people.”","options":["If I had super speed, I helped people.","If I have super speed, I will help people.","If I had super speed, I would help people."],"explanation":"The Second Conditional uses past simple after if and would + base verb in the result."}'::jsonb, '"If I had super speed, I would help people."'::jsonb, 2, 'u6-m10-error-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which sentence correctly describes Shadow''s invisibility?","options":["Shadow can become invisible, so people can see him clearly.","Shadow cannot become invisible, so people cannot see him.","Shadow can become invisible, so people cannot see him easily."],"explanation":"If Shadow becomes invisible, other people cannot see him easily."}'::jsonb, '"Shadow can become invisible, so people cannot see him easily."'::jsonb, 3, 'u6-m10-error-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“If Aqua controlled water, she would help during floods.” Is this sentence correct?","options":["No. It should use ‘will’.","Yes, it is correct.","No. It should use ‘can’."],"explanation":"Controlled + would help correctly follows the Second Conditional structure."}'::jsonb, '"Yes, it is correct."'::jsonb, 4, 'u6-m10-error-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “Titan can moves heavy objects.”","options":["Titan can moved heavy objects.","Titan can moving heavy objects.","Titan can move heavy objects."],"explanation":"Use the base verb move after can."}'::jsonb, '"Titan can move heavy objects."'::jsonb, 5, 'u6-m10-error-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Repair: “If I could fly, I would traveled around the world.”","options":["If I could fly, I traveled around the world.","If I could fly, I would travel around the world.","If I can fly, I would traveled around the world."],"explanation":"Would must be followed by the base verb travel."}'::jsonb, '"If I could fly, I would travel around the world."'::jsonb, 6, 'u6-m10-error-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Final Training Challenge: study the emergency message and organize the heroes according to the abilities the rescue requires.', 3, 'u6-m10-final-training', '{"correctFeedback":"Checkpoint decision confirmed! Your plan uses the available abilities responsibly.","incorrectFeedback":"Return to the emergency message and match each problem with the hero who can solve it."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Your team receives an emergency message. A powerful storm has damaged several buildings near the city. Some roads are flooded. A rescue team is already helping people, but one building is difficult to reach. The entrance is blocked by heavy objects, and several people are still inside. Your team has three heroes: Aqua can control water. Titan has super strength. Shadow can become invisible. The team must decide how to organize the rescue.","prompt":"Which hero should help with the flooded roads?","options":["Titan","None","Aqua","Shadow"],"explanation":"Aqua can control water, so she can reduce the danger on the flooded roads."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m10-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should clear the blocked entrance?","options":["Aqua","Shadow","Titan","None"],"explanation":"Titan''s super strength is appropriate for moving the heavy objects blocking the entrance."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m10-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why could Shadow be useful during the rescue?","options":["He can move heavy objects.","He can become invisible and enter difficult areas without being seen.","He can create storms.","He can control water."],"explanation":"Shadow can investigate difficult or dangerous areas discreetly while the other heroes handle water and debris."}'::jsonb, '"He can become invisible and enter difficult areas without being seen."'::jsonb, 3, 'u6-m10-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which rescue plan is the most effective?","options":["Only Shadow helps the team.","Titan controls the water while Shadow moves the heavy objects.","Aqua controls the water while Titan clears the entrance.","Shadow controls the water while Aqua moves the heavy objects."],"explanation":"This plan assigns each major problem to the hero whose power directly addresses it."}'::jsonb, '"Aqua controls the water while Titan clears the entrance."'::jsonb, 4, 'u6-m10-final-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer from the situation?","options":["Strong heroes are always better.","One superpower is always enough.","Invisible heroes cannot help people.","Different abilities can work together to solve a problem."],"explanation":"The rescue succeeds when Aqua, Titan, and Shadow use different abilities for appropriate parts of the same problem."}'::jsonb, '"Different abilities can work together to solve a problem."'::jsonb, 5, 'u6-m10-final-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 11: Power Upgrade
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Upgrade', 'The Energy Research Center''s Power Upgrade machine is malfunctioning. Repair the mixed instructions, reconnect the power systems, and activate the machine.', 11, 'explorer', 150, 'Power Engineer', 'Energy Research Center', 12, 48, 'unit-6-mission-11')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Repair the Instructions: the sentence pieces are mixed. Select the option that places every piece in a logical and grammatically correct sequence.', 1, 'u6-m11-repair-instructions', '{"correctFeedback":"Instruction repaired! The sentence structure is correctly connected.","incorrectFeedback":"Check where the if-clause begins and place would before the base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mixed pieces: [help people] [if I had super speed] [I would] [quickly]","options":["I would if I had super speed quickly help people.","If I had super speed, I would help people quickly.","Help people if I had super speed I would quickly.","Quickly I would help people if had super speed."],"explanation":"The if-clause comes first, followed by I would + help and the adverb quickly."}'::jsonb, '"If I had super speed, I would help people quickly."'::jsonb, 1, 'u6-m11-order-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mixed pieces: [during floods] [if Aqua controlled water] [she would] [help the city]","options":["She would during floods if Aqua controlled water help the city.","Help the city during floods she would if Aqua controlled water.","If Aqua controlled water, she would help the city during floods.","During floods if Aqua controlled water help the city she would."],"explanation":"Start with If Aqua controlled water, then complete the result with she would help the city during floods."}'::jsonb, '"If Aqua controlled water, she would help the city during floods."'::jsonb, 2, 'u6-m11-order-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mixed pieces: [enter dangerous places] [if Shadow were invisible] [he would] [without being seen]","options":["Without being seen he would if Shadow were invisible enter dangerous places.","If Shadow were invisible, he would enter dangerous places without being seen.","He would without being seen enter dangerous places if Shadow were invisible.","Enter dangerous places if Shadow were invisible without being seen he would."],"explanation":"The condition is followed by he would enter; without being seen completes the action."}'::jsonb, '"If Shadow were invisible, he would enter dangerous places without being seen."'::jsonb, 3, 'u6-m11-order-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mixed pieces: [move heavy objects] [Titan would] [if he had super strength] [easily]","options":["Titan would easily if he had super strength move heavy objects.","Move heavy objects Titan would easily if he had super strength.","If he had super strength, Titan would move heavy objects easily.","Easily Titan would if he had super strength move heavy objects."],"explanation":"If he had super strength introduces the condition; Titan would move gives the result."}'::jsonb, '"If he had super strength, Titan would move heavy objects easily."'::jsonb, 4, 'u6-m11-order-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Mixed pieces: [protect animals] [if I could communicate with animals] [I would] [in danger]","options":["I would in danger protect animals if I could communicate with animals.","Protect animals if I could communicate with animals I would in danger.","In danger I would if I could communicate with animals protect animals.","If I could communicate with animals, I would protect animals in danger."],"explanation":"The imaginary condition comes first, followed by I would protect and the phrase in danger."}'::jsonb, '"If I could communicate with animals, I would protect animals in danger."'::jsonb, 5, 'u6-m11-order-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power System Puzzle: complete each situation with the ability whose meaning best solves the contextual problem.', 2, 'u6-m11-power-system', '{"correctFeedback":"Power connection restored! That ability matches the situation.","incorrectFeedback":"Reconsider the problem and the specific meaning of each ability."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The road is blocked by a very heavy object. A hero with _____ could move it.","options":["animal communication","super strength","invisibility","telepathy"],"explanation":"Super strength allows a hero to lift or move an object that is too heavy for an ordinary person."}'::jsonb, '"super strength"'::jsonb, 1, 'u6-m11-system-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A rescue worker needs to enter a dangerous building without being noticed. A hero with _____ could do this.","options":["water control","healing power","invisibility","super strength"],"explanation":"Invisibility makes the hero difficult to see while entering the area."}'::jsonb, '"invisibility"'::jsonb, 2, 'u6-m11-system-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The city is experiencing a flood. A hero who can _____ could move water away from homes.","options":["fly","become invisible","control water","read minds"],"explanation":"Water control directly helps redirect dangerous floodwater."}'::jsonb, '"control water"'::jsonb, 3, 'u6-m11-system-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A lost child is scared and cannot explain where she is. A hero with _____ might understand what she is thinking.","options":["fire control","flying ability","super speed","telepathy"],"explanation":"Telepathy is the ability to communicate through or understand thoughts."}'::jsonb, '"telepathy"'::jsonb, 4, 'u6-m11-system-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"An injured person needs help after an accident. A hero with _____ could help the person recover.","options":["telekinesis","healing power","super speed","invisibility"],"explanation":"Healing power helps an injured person recover from physical harm."}'::jsonb, '"healing power"'::jsonb, 5, 'u6-m11-system-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dangerous mountain area is difficult to reach. A hero with _____ could travel through the air.","options":["water control","telepathy","flying ability","healing power"],"explanation":"Flying ability lets a hero travel through the air to reach a high or remote place."}'::jsonb, '"flying ability"'::jsonb, 6, 'u6-m11-system-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Activate the Machine: study the final laboratory problem and assign each hero to the task their ability can solve.', 3, 'u6-m11-activate-machine', '{"correctFeedback":"System activated! Your reasoning connected the correct power module.","incorrectFeedback":"Review the room conditions and each hero''s stated ability before trying again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Three heroes arrive at the Energy Research Center. Aqua can control water. Titan has super strength. Shadow can become invisible. The Power Upgrade machine is inside a room filled with water. The door is blocked by a large metal object, and the lights inside the room are broken.","prompt":"Which hero should control the water?","options":["Shadow","None","Aqua","Titan"],"explanation":"Aqua can control water, so she can address the flooded room."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m11-activate-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should move the large metal object?","options":["Aqua","Titan","None","Shadow"],"explanation":"Titan''s super strength allows him to move the heavy metal blocking the door."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m11-activate-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why could Shadow be useful?","options":["He can control water.","He can create light.","He can become invisible and investigate the room without being easily noticed.","He can move heavy metal objects."],"explanation":"Shadow can investigate discreetly, although his power does not remove the water or metal."}'::jsonb, '"He can become invisible and investigate the room without being easily noticed."'::jsonb, 3, 'u6-m11-activate-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which sequence is the most logical?","options":["Shadow controls the water → Titan creates light → Aqua moves the obstruction.","Titan controls the water → Shadow moves the obstruction → Aqua investigates.","Titan moves the obstruction → Aqua controls the water → Shadow investigates the room.","Aqua moves the obstruction → Shadow controls the water → Titan investigates."],"explanation":"The entrance must be opened, the flooded room made safer, and then the interior investigated."}'::jsonb, '"Titan moves the obstruction → Aqua controls the water → Shadow investigates the room."'::jsonb, 4, 'u6-m11-activate-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer from the situation?","options":["Invisible heroes cannot participate in rescue missions.","A successful team can use different abilities for different problems.","Water-control powers are always the most useful.","The strongest hero can solve every problem alone."],"explanation":"Each obstacle requires a different ability, so the team succeeds by combining appropriate powers."}'::jsonb, '"A successful team can use different abilities for different problems."'::jsonb, 5, 'u6-m11-activate-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 12: The Unexpected Power
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Unexpected Power', 'Something unusual happened inside the Energy Research Center. A student discovered a new ability, but nobody knows exactly what it can do. Predict its effects and investigate the evidence.', 12, 'explorer', 150, 'Power Predictor', 'Energy Research Center', 27, 39, 'unit-6-mission-12')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'What Do You Predict? Study the first observation and make careful predictions. At this stage, separate what happened from what might be true.', 1, 'u6-m12-predict', '{"correctFeedback":"Logical prediction! Your answer uses the available observation.","incorrectFeedback":"Review the scenario and choose the idea most directly supported by what happened."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"During a training session, Maya touches a damaged robot. Suddenly, the robot starts working again. Maya looks surprised. The teachers notice that the robot only works when Maya touches it.","prompt":"What ability might Maya have?","options":["Super speed","Healing or repairing objects","Invisibility","Flying"],"explanation":"The damaged robot works after Maya touches it, so repair is the strongest initial prediction."}'::jsonb, '"Healing or repairing objects"'::jsonb, 1, 'u6-m12-predict-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What evidence best supports that prediction?","options":["The robot is old.","Maya is surprised.","The robot works after Maya touches it.","The session is at the academy."],"explanation":"The change from damaged to working immediately after Maya''s touch is the key evidence."}'::jsonb, '"The robot works after Maya touches it."'::jsonb, 2, 'u6-m12-predict-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What would be the most useful test for Maya''s ability?","options":["Ask Maya to fly.","Ask Maya to touch another damaged object.","Ask Maya to hide.","Ask Maya to run around the academy."],"explanation":"Repeating the same action with another damaged object tests whether the result can happen again."}'::jsonb, '"Ask Maya to touch another damaged object."'::jsonb, 3, 'u6-m12-predict-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Maya''s power repairs objects, what might she be able to help with?","options":["Becoming invisible","Reading people''s thoughts","Flying over buildings","Damaged machines"],"explanation":"Damaged machines are objects that a repairing ability could logically restore."}'::jsonb, '"Damaged machines"'::jsonb, 4, 'u6-m12-predict-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which statement is only a prediction at this point?","options":["The teachers observed the event.","Maya can repair any object.","Maya touched the robot.","The robot started working after Maya touched it."],"explanation":"Only one object has been observed, so claiming she can repair any object has not been confirmed."}'::jsonb, '"Maya can repair any object."'::jsonb, 5, 'u6-m12-predict-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Read the Evidence — The New Power: compare the three tests and determine what the evidence confirms about Maya''s ability.', 2, 'u6-m12-read-evidence', '{"correctFeedback":"Evidence located! Your conclusion matches the test results.","incorrectFeedback":"Return to the test results and find the sentence that supports the answer."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"The teachers decided to test Maya''s strange ability. First, they gave her a broken communication device. Maya touched it, and the device started working again. Next, the teachers gave Maya a damaged training robot. After she touched the robot, it moved again. However, something unexpected happened during the third test. The teachers gave Maya a broken window. Maya touched the glass, but nothing happened. The teachers realized that Maya could repair some objects, but her ability did not work on everything. Maya was excited to discover her new power. Her teacher explained that having a special ability was only the beginning. Maya needed to learn when and how to use it responsibly.","prompt":"What happened when Maya touched the communication device?","options":["It disappeared.","It started working again.","It became more damaged.","Nothing happened."],"explanation":"The first test says the communication device started working after Maya touched it."}'::jsonb, '"It started working again."'::jsonb, 1, 'u6-m12-read-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What happened when Maya touched the training robot?","options":["It moved again.","Its window broke.","It flew away.","Nothing happened."],"explanation":"The damaged training robot moved again after Maya touched it."}'::jsonb, '"It moved again."'::jsonb, 2, 'u6-m12-read-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What object did Maya fail to repair?","options":["A communication device","A training robot","A broken window","A laboratory door"],"explanation":"Maya touched the broken glass, but nothing happened."}'::jsonb, '"A broken window"'::jsonb, 3, 'u6-m12-read-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer about Maya''s ability?","options":["It only works on glass.","It can repair every object.","It can repair some objects, but not everything.","It makes every object invisible."],"explanation":"Two devices worked again, but the window did not, so the power has limits."}'::jsonb, '"It can repair some objects, but not everything."'::jsonb, 4, 'u6-m12-read-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why does the teacher say Maya must learn to use her ability responsibly?","options":["The teacher wants Maya to stop helping.","Having a power is not enough; she must understand when and how to use it.","Maya already knows everything about the ability.","The ability is only useful for competitions."],"explanation":"The teacher explains that discovering an ability is only the beginning; responsible use requires judgment."}'::jsonb, '"Having a power is not enough; she must understand when and how to use it."'::jsonb, 5, 'u6-m12-read-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"In the sentence “something unexpected happened,” what does unexpected mean?","options":["Something very common","Something dangerous","Something nobody expected","Something very easy"],"explanation":"Unexpected describes a result that people did not predict—the window did not repair."}'::jsonb, '"Something nobody expected"'::jsonb, 6, 'u6-m12-read-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Prediction Check: compare each statement with the completed tests. Decide whether it is CONFIRMED BY THE TEXT or NOT CONFIRMED BY THE TEXT.', 3, 'u6-m12-prediction-check', '{"correctFeedback":"Prediction checked! Your decision agrees with the evidence.","incorrectFeedback":"Revisit the reading and check whether the tests actually prove this statement."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya can repair some objects.","options":["NOT CONFIRMED BY THE TEXT","CONFIRMED BY THE TEXT"],"explanation":"The device and robot worked again after Maya touched them."}'::jsonb, '"CONFIRMED BY THE TEXT"'::jsonb, 1, 'u6-m12-check-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya can repair every object she touches.","options":["CONFIRMED BY THE TEXT","NOT CONFIRMED BY THE TEXT"],"explanation":"Not confirmed: Maya touched the broken window, but nothing happened."}'::jsonb, '"NOT CONFIRMED BY THE TEXT"'::jsonb, 2, 'u6-m12-check-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya repaired a communication device.","options":["CONFIRMED BY THE TEXT","NOT CONFIRMED BY THE TEXT"],"explanation":"The communication device started working again during the first test."}'::jsonb, '"CONFIRMED BY THE TEXT"'::jsonb, 3, 'u6-m12-check-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya repaired a training robot.","options":["NOT CONFIRMED BY THE TEXT","CONFIRMED BY THE TEXT"],"explanation":"The robot moved again after Maya touched it."}'::jsonb, '"CONFIRMED BY THE TEXT"'::jsonb, 4, 'u6-m12-check-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya can repair broken windows.","options":["NOT CONFIRMED BY THE TEXT","CONFIRMED BY THE TEXT"],"explanation":"The window test failed, so this prediction is not supported."}'::jsonb, '"NOT CONFIRMED BY THE TEXT"'::jsonb, 5, 'u6-m12-check-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya needs to learn how to use her power responsibly.","options":["CONFIRMED BY THE TEXT","NOT CONFIRMED BY THE TEXT"],"explanation":"Her teacher explicitly explains that Maya must learn when and how to use the ability responsibly."}'::jsonb, '"CONFIRMED BY THE TEXT"'::jsonb, 6, 'u6-m12-check-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 13: Power Battle Strategy
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Battle Strategy', 'The Sky Challenge Arena is ready. Different teams face different problems. Choose abilities strategically—not simply the strongest hero—and support every plan with evidence.', 13, 'explorer', 150, 'Power Strategist', 'Sky Challenge Zone', 42, 48, 'unit-6-mission-13')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Know Your Heroes: compare each hero''s ability, strength, limitation, and best use before making a strategic choice.', 1, 'u6-m13-know-heroes', '{"correctFeedback":"Strong comparison! Your answer matches both the hero''s strength and the challenge.","incorrectFeedback":"Compare the hero profiles again, especially their limitations and best uses."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"AQUA — Ability: control water. Strength: she can move large amounts of water. Limitation: her power is less useful in completely dry environments. Best use: floods and water emergencies. TITAN — Ability: super strength. Strength: he can move very heavy objects. Limitation: he cannot fly. Best use: rescue and blocked areas. SHADOW — Ability: invisibility. Strength: he can move without being seen. Limitation: he cannot move very heavy objects. Best use: secret investigations. SKY — Ability: flying. Strength: she can reach high and distant places quickly. Limitation: she cannot control water or move extremely heavy objects. Best use: aerial rescue and transportation.","prompt":"Which hero is most useful for moving a heavy object?","options":["Shadow","Aqua","Titan","Sky"],"explanation":"Titan''s super strength is specifically useful for moving very heavy objects."}'::jsonb, '"Titan"'::jsonb, 1, 'u6-m13-compare-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero is best for investigating a secret location?","options":["Sky","Titan","Shadow","Aqua"],"explanation":"Shadow can move without being seen, making him the strongest choice for a secret investigation."}'::jsonb, '"Shadow"'::jsonb, 2, 'u6-m13-compare-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero would be most useful during a flood?","options":["Titan","Aqua","Sky","Shadow"],"explanation":"Aqua can control large amounts of water, and floods are her stated best use."}'::jsonb, '"Aqua"'::jsonb, 3, 'u6-m13-compare-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero can reach a high place quickly?","options":["Aqua","Shadow","Sky","Titan"],"explanation":"Sky can fly and reach high or distant places quickly."}'::jsonb, '"Sky"'::jsonb, 4, 'u6-m13-compare-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero has a limitation related to dry environments?","options":["Shadow","Titan","Aqua","Sky"],"explanation":"Aqua''s water-control power is less useful where no water is available."}'::jsonb, '"Aqua"'::jsonb, 5, 'u6-m13-compare-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero would NOT be the best choice for moving a heavy object?","options":["Aqua","Sky","Titan","Shadow"],"explanation":"Shadow''s profile explicitly states that he cannot move very heavy objects; Titan is designed for that task."}'::jsonb, '"Shadow"'::jsonb, 6, 'u6-m13-compare-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Build the Strategy: select the TWO-HERO combination that covers every important part of each challenge. The pair is revealed only after submission.', 2, 'u6-m13-build-strategy', '{"correctFeedback":"Strategy confirmed! The two abilities complement each other.","incorrectFeedback":"Identify both separate problems, then choose one hero for each need."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A flooded building has people trapped on an upper floor. Which TWO heroes form the best team?","options":["Titan + Shadow","Aqua + Sky","Shadow + Aqua","Titan + Sky"],"explanation":"Aqua can control the floodwater while Sky can reach the upper floor quickly."}'::jsonb, '"Aqua + Sky"'::jsonb, 1, 'u6-m13-strategy-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A collapsed building has a blocked entrance and people who need to be located. Which TWO heroes form the best team?","options":["Sky + Aqua","Aqua + Titan","Titan + Shadow","Shadow + Sky"],"explanation":"Titan can move the heavy blockage, while Shadow can investigate difficult areas without being seen."}'::jsonb, '"Titan + Shadow"'::jsonb, 2, 'u6-m13-strategy-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A mountain rescue requires reaching a high location and moving heavy equipment. Which TWO heroes form the best team?","options":["Aqua + Shadow","Sky + Titan","Shadow + Sky","Titan + Aqua"],"explanation":"Sky reaches the high location, and Titan handles the heavy rescue equipment."}'::jsonb, '"Sky + Titan"'::jsonb, 3, 'u6-m13-strategy-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A secret laboratory must be investigated without attracting attention, and the team needs fast aerial access. Which TWO heroes form the best team?","options":["Aqua + Titan","Titan + Shadow","Shadow + Sky","Sky + Aqua"],"explanation":"Shadow investigates discreetly while Sky provides quick access and transportation."}'::jsonb, '"Shadow + Sky"'::jsonb, 4, 'u6-m13-strategy-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A coastal city is flooding, and heavy objects block the rescue routes. Which TWO heroes form the best team?","options":["Shadow + Sky","Aqua + Titan","Titan + Shadow","Sky + Aqua"],"explanation":"Aqua controls the floodwater, and Titan removes the heavy obstacles."}'::jsonb, '"Aqua + Titan"'::jsonb, 5, 'u6-m13-strategy-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Final Power Battle: the academy can send only three heroes. Build the plan that addresses the water, blocked entrance, and rooftop rescue.', 3, 'u6-m13-final-battle', '{"correctFeedback":"Strategic victory! Your choice is supported by the conditions of the rescue.","incorrectFeedback":"Break the scenario into separate problems and match each one with an appropriate strength."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"A powerful storm has damaged part of the city. There is water in the streets. A large object is blocking the entrance to a building. Several people are trapped inside. One person is on the roof and cannot reach the ground safely. The academy can send only THREE heroes. Available heroes: Aqua, Titan, Shadow, and Sky.","prompt":"Which THREE heroes should the academy send?","options":["Aqua + Shadow + Sky","Titan + Shadow + Sky","Aqua + Titan + Shadow","Aqua + Titan + Sky"],"explanation":"Aqua controls the water, Titan moves the heavy blockage, and Sky reaches the person on the roof."}'::jsonb, '"Aqua + Titan + Sky"'::jsonb, 1, 'u6-m13-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Shadow not essential for this particular rescue?","options":["Shadow cannot help in any rescue.","The main problems require water control, heavy lifting, and reaching a high location.","Shadow is the strongest hero available.","The storm makes invisibility impossible."],"explanation":"The three urgent problems align directly with Aqua, Titan, and Sky; secret investigation is not essential here."}'::jsonb, '"The main problems require water control, heavy lifting, and reaching a high location."'::jsonb, 2, 'u6-m13-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If the water disappeared but the entrance remained blocked, which hero would become most important?","options":["Shadow","Sky","Titan","Aqua"],"explanation":"With no floodwater, the remaining obstacle is the heavy object, which matches Titan''s strength."}'::jsonb, '"Titan"'::jsonb, 3, 'u6-m13-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If the person on the roof needed immediate help, which hero would become most important?","options":["Aqua","Titan","Shadow","Sky"],"explanation":"Sky can fly directly to a high place and begin an aerial rescue immediately."}'::jsonb, '"Sky"'::jsonb, 4, 'u6-m13-final-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What is the main lesson of the challenge?","options":["Every hero should use the same ability.","The strongest hero is always the best.","Heroes with limitations cannot help.","The best strategy depends on the problem and the strengths of each hero."],"explanation":"Good strategy comes from matching different strengths to the specific needs of a problem, not ranking heroes by power alone."}'::jsonb, '"The best strategy depends on the problem and the strengths of each hero."'::jsonb, 5, 'u6-m13-final-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 14: The Hero's Choice
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Hero''s Choice', 'A new emergency has appeared in the city. You are the hero, and there is more than one way to solve the problem. Your choices will create your own superhero story.', 14, 'explorer', 150, 'Hero Storyteller', 'Sky Challenge Zone', 57, 37, 'unit-6-mission-14')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'school_profile'::public.activity_type, 'Build the Story: choose a location, an emergency, and a special ability. Every available combination can become a coherent hero story.', 1, 'u6-m14-story-builder', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Story location","options":["A crowded city","A mountain village","A coastal town","A futuristic laboratory"]}'::jsonb, '"student-choice"'::jsonb, 1, 'u6-m14-location')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Story problem","options":["A powerful storm is approaching","A group of people is trapped","A dangerous machine has stopped working","A bridge has collapsed"]}'::jsonb, '"student-choice"'::jsonb, 2, 'u6-m14-problem')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Hero''s special ability","options":["Super strength","Flying","Control water","Invisibility"]}'::jsonb, '"student-choice"'::jsonb, 3, 'u6-m14-ability')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Choose the Hero''s Action: select the logical response that moves the story forward and correctly uses If + past simple + would + base verb.', 2, 'u6-m14-hero-actions', '{"correctFeedback":"Good story decision! The action fits the emergency and uses the Second Conditional correctly.","incorrectFeedback":"Check whether the action solves the story problem and whether would is followed by a base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A storm is approaching a coastal town, and the hero can control water. What would the hero do?","options":["If the hero controls water, they moved it away from the houses.","If the hero controlled water, they would move it away from the houses.","If the hero controlled water, they move it away from the houses."],"explanation":"Moving water away protects the houses, and controlled + would move forms the Second Conditional."}'::jsonb, '"If the hero controlled water, they would move it away from the houses."'::jsonb, 1, 'u6-m14-action-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"People are trapped on a high mountain path, and the hero can fly. What would the hero do?","options":["If the hero could fly, they reached the trapped people quickly.","If the hero can fly, they would reached the trapped people quickly.","If the hero could fly, they would reach the trapped people quickly."],"explanation":"Flying directly addresses the high location, and would reach uses the correct base verb."}'::jsonb, '"If the hero could fly, they would reach the trapped people quickly."'::jsonb, 2, 'u6-m14-action-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A collapsed bridge blocks an emergency route, and the hero has super strength. What would the hero do?","options":["If the hero had super strength, they would move the heavy pieces safely.","If the hero has super strength, they moved the heavy pieces safely.","If the hero had super strength, they would moved the heavy pieces safely."],"explanation":"Moving heavy pieces helps reopen the route, and had + would move follows the target structure."}'::jsonb, '"If the hero had super strength, they would move the heavy pieces safely."'::jsonb, 3, 'u6-m14-action-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dangerous machine fails inside a restricted laboratory, and the hero can become invisible. What would the hero do?","options":["If the hero were invisible, they enter carefully and inspected the machine.","If the hero were invisible, they would enter carefully and inspect the machine.","If the hero is invisible, they would entered and inspect the machine."],"explanation":"The hero can approach discreetly, and were + would enter correctly describes the imagined action."}'::jsonb, '"If the hero were invisible, they would enter carefully and inspect the machine."'::jsonb, 4, 'u6-m14-action-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The emergency is becoming worse and nearby people need protection. What is the best next action?","options":["If the hero understands the danger, they guided people to safety.","If the hero understood the danger, they would guide people to a safe place.","If the hero understood the danger, they would guided people to safety."],"explanation":"Guiding people to safety prevents the problem from becoming worse, and would guide is grammatically correct."}'::jsonb, '"If the hero understood the danger, they would guide people to a safe place."'::jsonb, 5, 'u6-m14-action-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Write the Hero Story: create 7–8 original sentences from your choices. Review the feedback, revise important errors, and resubmit before completing the story.', 3, 'u6-m14-story-writing', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Write your superhero story. Include the location, problem, hero, special ability, the hero''s action, how others are helped, one Second Conditional sentence, and an ending.","minSentences":7,"maxSentences":8,"requireSecondConditional":true,"sentenceStarters":["The story takes place...","Suddenly...","The hero...","The hero''s special ability...","To solve the problem...","The hero helps others by...","If the hero had..., they would...","In the end..."],"writingRequirements":[{"label":"the story location","pattern":"\\b(city|village|town|laboratory|mountain|coast|building|bridge)\\b","message":"The story takes place..."},{"label":"an emergency problem","pattern":"\\b(storm|trapped|dangerous|machine|collapsed|emergency|problem|flood|bridge)\\b","message":"The problem begins when..."},{"label":"a hero","pattern":"\\b(hero|superhero)\\b","message":"The hero is..."},{"label":"a special ability","pattern":"\\b(ability|power|strength|flying|fly|water|invisible|invisibility)\\b","message":"The hero''s special ability is..."},{"label":"the hero''s action","pattern":"\\b(move|control|fly|enter|inspect|rescue|protect|guide|save|help)\\b","message":"To solve the problem, the hero..."},{"label":"how the hero helps others","pattern":"\\b(help|helps|rescue|rescues|protect|protects|save|saves|safe|safety)\\b","message":"The hero helps others by..."},{"label":"an ending","pattern":"\\b(in the end|finally|at last|afterward|everyone was safe|problem was solved)\\b","message":"In the end..."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m14-story-text')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 15: Power Lab: System Failure
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Lab: System Failure', 'Warning! The Power Training System is assigning abilities to the wrong situations and producing faulty instructions. Diagnose each problem and restore the academy database.', 15, 'explorer', 150, 'Power Technician', 'Energy Research Center', 73, 45, 'unit-6-mission-15')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Find the Fault: compare each emergency with the assigned hero and ability. Decide whether the assignment is CORRECT or a MALFUNCTION.', 1, 'u6-m15-find-fault', '{"correctFeedback":"Diagnosis confirmed! Your decision matches the ability and the situation.","incorrectFeedback":"Compare the assigned ability with the exact action the emergency requires."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A heavy metal door blocks a rescue team. Assigned hero: Shadow. Ability: invisibility.","options":["CORRECT","MALFUNCTION"],"explanation":"Invisibility does not move a heavy door. A hero with super strength would be more useful."}'::jsonb, '"MALFUNCTION"'::jsonb, 1, 'u6-m15-fault-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A coastal city is experiencing a major flood. Assigned hero: Aqua. Ability: control water.","options":["MALFUNCTION","CORRECT"],"explanation":"Aqua''s water-control ability directly addresses the flooding."}'::jsonb, '"CORRECT"'::jsonb, 2, 'u6-m15-fault-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"People need to reach the top of a tall building quickly. Assigned hero: Aqua. Ability: control water.","options":["MALFUNCTION","CORRECT"],"explanation":"Water control is not the most useful power for reaching a high location quickly; flying would fit better."}'::jsonb, '"MALFUNCTION"'::jsonb, 3, 'u6-m15-fault-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A secret laboratory must be investigated without attracting attention. Assigned hero: Shadow. Ability: invisibility.","options":["CORRECT","MALFUNCTION"],"explanation":"Invisibility lets Shadow investigate without being easily noticed."}'::jsonb, '"CORRECT"'::jsonb, 4, 'u6-m15-fault-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A rescue team needs to understand what a frightened person is thinking. Assigned hero: Mind Master. Ability: telepathy.","options":["MALFUNCTION","CORRECT"],"explanation":"Telepathy could help Mind Master understand the frightened person''s thoughts."}'::jsonb, '"CORRECT"'::jsonb, 5, 'u6-m15-fault-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A person is trapped under heavy concrete. Assigned hero: Titan. Ability: super strength.","options":["CORRECT","MALFUNCTION"],"explanation":"Titan''s super strength can move the heavy concrete during the rescue."}'::jsonb, '"CORRECT"'::jsonb, 6, 'u6-m15-fault-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Repair the Instruction: the system message contains a language failure. Select the corrected command and restore that module.', 2, 'u6-m15-repair-instruction', '{"correctFeedback":"Instruction repaired! The language module is working again.","incorrectFeedback":"Identify the exact verb-form error in the system message and try again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “Shadow can becomes invisible.”","options":["Shadow can became invisible.","Shadow can become invisible.","Shadow can becoming invisible."],"explanation":"After can, use the base form of the verb: become."}'::jsonb, '"Shadow can become invisible."'::jsonb, 1, 'u6-m15-repair-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “If Titan had super strength, he will move the object.”","options":["If Titan has super strength, he would move the object.","If Titan had super strength, he moved the object.","If Titan had super strength, he would move the object."],"explanation":"The Second Conditional uses past simple in the if-clause and would + base verb in the result."}'::jsonb, '"If Titan had super strength, he would move the object."'::jsonb, 2, 'u6-m15-repair-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “Aqua can controls water.”","options":["Aqua can control water.","Aqua can controlling water.","Aqua can controlled water."],"explanation":"The modal can must be followed by the base verb control."}'::jsonb, '"Aqua can control water."'::jsonb, 3, 'u6-m15-repair-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “If I could fly, I would traveled to the mountains.”","options":["If I could fly, I traveled to the mountains.","If I can fly, I would traveled to the mountains.","If I could fly, I would travel to the mountains."],"explanation":"After would, use the base verb travel—not traveled."}'::jsonb, '"If I could fly, I would travel to the mountains."'::jsonb, 4, 'u6-m15-repair-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “Titan have super strength.”","options":["Titan having super strength.","Titan has super strength.","Titan have super strength."],"explanation":"Titan is a singular subject, so the Present Simple form is has."}'::jsonb, '"Titan has super strength."'::jsonb, 5, 'u6-m15-repair-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"System message: “If Shadow were invisible, he would enters the building.”","options":["If Shadow is invisible, he would enters the building.","If Shadow were invisible, he would enter the building.","If Shadow were invisible, he entered the building."],"explanation":"Would must be followed by the base verb enter."}'::jsonb, '"If Shadow were invisible, he would enter the building."'::jsonb, 6, 'u6-m15-repair-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'System Test: three failures are happening simultaneously. Assign the correct hero to each subsystem and verify the final team configuration.', 3, 'u6-m15-system-test', '{"correctFeedback":"System test passed! The selected ability solves the identified failure.","incorrectFeedback":"Review each failed system and match it with the hero whose ability directly addresses it."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Three systems have failed at the same time. The city streets are flooded. A rescue vehicle cannot move because a heavy object is blocking the road. A communication device is broken. The academy can send three heroes: Aqua — control water. Titan — super strength. Maya — repair some damaged objects.","prompt":"Which hero should deal with the flooded streets?","options":["Titan","Maya","Aqua","None"],"explanation":"Aqua can control water and address the flooded streets."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m15-test-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should move the heavy object?","options":["None","Aqua","Titan","Maya"],"explanation":"Titan''s super strength is appropriate for moving the obstacle blocking the vehicle."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m15-test-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should repair the communication device?","options":["Titan","Maya","None","Aqua"],"explanation":"Maya''s ability works on some damaged devices, making her the logical technician for the communicator."}'::jsonb, '"Maya"'::jsonb, 3, 'u6-m15-test-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which team combination is the most logical?","options":["Titan + Shadow + Maya","Aqua + Titan + Maya","Maya + Shadow + Aqua","Aqua + Shadow + Titan"],"explanation":"Each hero addresses one different failure: water, heavy obstruction, and damaged technology."}'::jsonb, '"Aqua + Titan + Maya"'::jsonb, 4, 'u6-m15-test-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What does the simulation demonstrate?","options":["Strong heroes are always the most useful.","Heroes should use only one type of ability.","One power can solve every problem.","Different abilities can solve different problems."],"explanation":"The simulation succeeds because each problem is diagnosed separately and assigned to a suitable ability."}'::jsonb, '"Different abilities can solve different problems."'::jsonb, 5, 'u6-m15-test-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 16: Power Emergency Simulation
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Emergency Simulation', 'Alert! Superpower Academy has received an emergency signal. You are the emergency commander, and the situation is changing quickly. Update your response as each new message arrives.', 16, 'explorer', 150, 'Emergency Commander', 'Emergency Command Center', 88, 34, 'unit-6-mission-16')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'STAGE 1 · FIRST ALERT: review the initial emergency and deploy three heroes whose abilities address the known risks.', 1, 'u6-m16-first-alert', '{"correctFeedback":"Initial command confirmed! The selected hero matches the current emergency information.","incorrectFeedback":"Review the first alert and match the problem with the hero''s stated ability."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"An electrical storm has damaged several parts of the city. A small group of people is trapped on the roof of a building. The streets below are becoming difficult to cross. The academy can send three heroes. SKY can fly and reach high places quickly. AQUA can control water, move water, and create water barriers. TITAN has super strength and can move heavy objects. SHADOW can become invisible and enter places without being easily noticed. MAYA can repair some damaged machines and devices.","prompt":"Which hero should reach the people on the roof?","options":["Aqua","Titan","Sky","Shadow"],"explanation":"Sky can fly and reach a high roof quickly."}'::jsonb, '"Sky"'::jsonb, 1, 'u6-m16-first-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero could help if water begins covering the streets?","options":["Maya","Aqua","Shadow","Titan"],"explanation":"Aqua can control water and create barriers against it."}'::jsonb, '"Aqua"'::jsonb, 2, 'u6-m16-first-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero would be useful if the entrance becomes blocked?","options":["Shadow","Sky","Titan","Aqua"],"explanation":"Titan''s super strength can move a heavy object blocking the entrance."}'::jsonb, '"Titan"'::jsonb, 3, 'u6-m16-first-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which THREE heroes should the commander initially choose?","options":["Maya + Shadow + Sky","Aqua + Maya + Shadow","Sky + Aqua + Titan","Titan + Shadow + Maya"],"explanation":"Sky reaches the roof, Aqua prepares for water in the streets, and Titan can clear a blocked entrance."}'::jsonb, '"Sky + Aqua + Titan"'::jsonb, 4, 'u6-m16-first-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, '⚠ NEW ALERT · SITUATION UPDATE: new evidence has arrived. Reconsider the Stage 1 plan instead of repeating it automatically.', 2, 'u6-m16-situation-update', '{"correctFeedback":"Plan updated! The best decision can change when the situation changes.","incorrectFeedback":"The emergency has changed. Focus on the new communication failure and adjust the team."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"SITUATION UPDATE: The emergency team has received a second message. The roof is now safe, but the building''s communication system has stopped working. The rescue team cannot contact the people inside. The commander must reconsider the previous strategy.","prompt":"Which hero is now especially useful?","options":["Shadow","Titan","Maya","Aqua"],"explanation":"Maya can repair damaged devices, so she directly addresses the failed communication system."}'::jsonb, '"Maya"'::jsonb, 1, 'u6-m16-update-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is Maya useful in this updated situation?","options":["She can move heavy doors.","She can repair damaged devices.","She can control water.","She can fly to the roof."],"explanation":"The new problem is a broken communication device, which matches Maya''s repair ability."}'::jsonb, '"She can repair damaged devices."'::jsonb, 2, 'u6-m16-update-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero becomes less important for this new problem now that the roof is safe?","options":["Maya","Titan","Sky","Aqua"],"explanation":"Sky was essential for the roof rescue, but that location is now safe and communication is the urgent problem."}'::jsonb, '"Sky"'::jsonb, 3, 'u6-m16-update-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What should the emergency commander do?","options":["Stop the rescue.","Keep exactly the same plan without considering the new problem.","Send only the strongest hero.","Change the team according to the new situation."],"explanation":"An effective commander uses new information to adapt the team and its priorities."}'::jsonb, '"Change the team according to the new situation."'::jsonb, 4, 'u6-m16-update-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, '🚨 EMERGENCY UPDATE · FINAL STAGE: several problems now exist at once. Build a response that addresses the water, communication system, and blocked exit.', 3, 'u6-m16-final-emergency', '{"correctFeedback":"Final command accepted! Your decision responds to the latest emergency conditions.","incorrectFeedback":"Use only the newest information and assign one suitable ability to each urgent problem."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"EMERGENCY UPDATE: Just as the team begins the rescue, another message arrives. Water has entered the lower part of the building. The communication system is still broken. A heavy door is blocking the safest exit. People are trapped inside. Available heroes: Aqua, Titan, Maya, Sky, and Shadow.","prompt":"Which hero should control the water?","options":["Sky","Maya","Aqua","Titan"],"explanation":"Aqua''s water-control ability can reduce the danger in the lower part of the building."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m16-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should repair the communication system?","options":["Shadow","Titan","Maya","Aqua"],"explanation":"Maya can repair some damaged devices, including the communication system."}'::jsonb, '"Maya"'::jsonb, 2, 'u6-m16-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should move the heavy door?","options":["Aqua","Sky","Titan","Maya"],"explanation":"Titan''s super strength is the most direct solution for the heavy blocked exit."}'::jsonb, '"Titan"'::jsonb, 3, 'u6-m16-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero could enter the building without being easily noticed?","options":["Titan","Shadow","Aqua","Sky"],"explanation":"Shadow''s invisibility allows discreet entry, although the three main failures require Aqua, Titan, and Maya."}'::jsonb, '"Shadow"'::jsonb, 4, 'u6-m16-final-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which combination of THREE heroes solves the main problems most directly?","options":["Maya + Sky + Shadow","Aqua + Titan + Maya","Sky + Shadow + Titan","Shadow + Sky + Aqua"],"explanation":"Aqua handles water, Titan moves the door, and Maya repairs communication."}'::jsonb, '"Aqua + Titan + Maya"'::jsonb, 5, 'u6-m16-final-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What is the most important lesson from the simulation?","options":["Heroes should use only their strongest ability.","The same team should always be used.","The best team depends on the problems that need to be solved.","The strongest hero should always lead."],"explanation":"Emergency decisions must adapt as the problems change; no single team is automatically best for every situation."}'::jsonb, '"The best team depends on the problems that need to be solved."'::jsonb, 6, 'u6-m16-final-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 17: Hero Emergency Messages
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Hero Emergency Messages', 'The Emergency Command Center is receiving incomplete and unclear messages from across the city. Decode the important information and send precise instructions to the hero team.', 17, 'explorer', 150, 'Hero Communicator', 'Emergency Command Center', 74, 25, 'unit-6-mission-17')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Decode the Messages: each short transmission contains urgent details. Identify the single piece of information the response team needs most.', 1, 'u6-m17-decode', '{"correctFeedback":"Message decoded! You identified the key emergency information.","incorrectFeedback":"Ignore unnecessary details and focus on the immediate problem or need."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Emergency near the river! The water is rising quickly. Several houses are already flooded.","prompt":"What is the main problem?","options":["A broken machine","A flood","A missing person","A fire"],"explanation":"The rising river and flooded houses show that flooding is the main emergency."}'::jsonb, '"A flood"'::jsonb, 1, 'u6-m17-message-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Help needed at the old warehouse. The entrance is blocked by a large metal object. People may still be inside.","prompt":"What is the main problem?","options":["The river is rising.","The entrance is blocked.","The communication system is broken.","The building is invisible."],"explanation":"The blocked entrance prevents rescuers from reaching the people inside."}'::jsonb, '"The entrance is blocked."'::jsonb, 2, 'u6-m17-message-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Urgent! The communication device at the academy has stopped working. The rescue team cannot contact the heroes.","prompt":"What problem needs to be solved first?","options":["The weather","The flooded street","The communication device","The broken door"],"explanation":"Repairing communication is necessary so the rescue team can contact and coordinate the heroes."}'::jsonb, '"The communication device"'::jsonb, 3, 'u6-m17-message-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"A group of people is trapped on the roof of a tall building. The stairs are damaged.","prompt":"What is the most important information?","options":["The weather is sunny.","The stairs are beautiful.","The people are on the roof and need another way down.","The building is old."],"explanation":"The urgent need is a safe alternative route for the people trapped on the roof."}'::jsonb, '"The people are on the roof and need another way down."'::jsonb, 4, 'u6-m17-message-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Alert from the mountain road! A rescue vehicle cannot continue. A fallen tree is blocking the only route to the village.","prompt":"What must the hero team address?","options":["The color of the rescue vehicle","The weather in the city","The fallen tree blocking the road","A broken communication device"],"explanation":"The fallen tree is preventing the rescue vehicle from reaching the village."}'::jsonb, '"The fallen tree blocking the road"'::jsonb, 5, 'u6-m17-message-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"Emergency at the research center! A power cable is damaged, and the main control device will not turn on. The laboratory team needs technical help.","prompt":"What is the key need?","options":["Move water away from a river.","Reach people on a roof.","Repair the damaged control system.","Investigate a secret warehouse."],"explanation":"The damaged cable and inactive control device require a hero with repair skills."}'::jsonb, '"Repair the damaged control system."'::jsonb, 6, 'u6-m17-message-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Choose the Right Message: select the clearest transmission. A useful emergency message states the location or problem and gives an appropriate action.', 2, 'u6-m17-right-message', '{"correctFeedback":"Clear communication! The hero knows where to go, what happened, and what action to take.","incorrectFeedback":"Choose the message with relevant details and a specific, appropriate instruction."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua needs to know where help is needed.","options":["Aqua, the river is interesting.","Aqua, there is a flood near the river. Please help the families.","Aqua, something is happening somewhere."],"explanation":"This message names the hero, location, problem, and people who need help."}'::jsonb, '"Aqua, there is a flood near the river. Please help the families."'::jsonb, 1, 'u6-m17-clear-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Titan needs to know what he must do.","options":["Titan, maybe you can do something.","Titan, the entrance is blocked by a heavy object. Please move it.","Titan, there is a thing near the building."],"explanation":"The message describes the obstacle and gives Titan a precise action suited to his strength."}'::jsonb, '"Titan, the entrance is blocked by a heavy object. Please move it."'::jsonb, 2, 'u6-m17-clear-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Sky needs to help people on a roof.","options":["Sky, please fly somewhere.","Sky, the building is very tall.","Sky, several people are trapped on the roof. Please help them reach safety."],"explanation":"The message clearly explains who needs help, where they are, and the rescue goal."}'::jsonb, '"Sky, several people are trapped on the roof. Please help them reach safety."'::jsonb, 3, 'u6-m17-clear-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya needs to repair a communication device.","options":["Maya, something is broken.","Maya, the academy has many devices.","Maya, the communication device is broken. Please repair it."],"explanation":"The message identifies the exact device and asks for a specific repair."}'::jsonb, '"Maya, the communication device is broken. Please repair it."'::jsonb, 4, 'u6-m17-clear-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Shadow needs to investigate a dangerous location.","options":["Shadow, buildings are dangerous.","Shadow, enter the building carefully and report what you find.","Shadow, please disappear."],"explanation":"This gives Shadow a safe, clear investigation instruction and asks for a report."}'::jsonb, '"Shadow, enter the building carefully and report what you find."'::jsonb, 5, 'u6-m17-clear-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua needs to know why she is being sent to the river.","options":["Aqua, go to the river.","Aqua, the water is blue.","Aqua, the river is flooding the streets. Please control the water."],"explanation":"The message explains the flood and the action Aqua should take."}'::jsonb, '"Aqua, the river is flooding the streets. Please control the water."'::jsonb, 6, 'u6-m17-clear-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'writing'::public.activity_type, 'Send the Emergency Update: write a clear 3–4 sentence message to Titan. Review the feedback, revise any important errors, and resend the corrected transmission.', 3, 'u6-m17-emergency-update', '{}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Several people are trapped inside a building. The entrance is blocked by a heavy object. Titan is nearby. Send Titan a short emergency message that explains who needs help, the problem, and what he should do.","minSentences":3,"maxSentences":4,"sentenceStarters":["Titan,...","Several people...","The entrance...","Please..."],"writingRequirements":[{"label":"who needs help","pattern":"\\b(people|person|family|families|students|rescue team)\\b","message":"Several people need help..."},{"label":"the emergency problem","pattern":"\\b(entrance|door|blocked|heavy object|trapped|building)\\b","message":"The entrance is blocked..."},{"label":"the requested action","pattern":"\\b(please|should|need(?:s)? to)\\s+(move|lift|remove|help|rescue|clear)\\b","message":"Please move the object and help the people."}]}'::jsonb, '"student-created"'::jsonb, 1, 'u6-m17-update-text')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 18: Power Ethics
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Ethics', 'The Hero Academy Council is reviewing how students use their abilities. Decide whether each power protects and assists others or creates a problem through irresponsible use.', 18, 'explorer', 150, 'Responsible Hero', 'Hero Academy Council', 59, 31, 'unit-6-mission-18')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Hero or Problem? Evaluate the purpose and effect of each action. Decide whether it is a HELPFUL USE or a PROBLEMATIC USE of an ability.', 1, 'u6-m18-hero-or-problem', '{"correctFeedback":"Thoughtful evaluation! Your choice considers how the power affects other people.","incorrectFeedback":"Consider whether the action protects or assists someone and whether it respects safety, privacy, and permission."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Shadow uses invisibility to enter a friend''s house secretly without permission.","options":["HELPFUL USE","PROBLEMATIC USE"],"explanation":"This use ignores permission and the friend''s privacy; invisibility does not make entering acceptable."}'::jsonb, '"PROBLEMATIC USE"'::jsonb, 1, 'u6-m18-use-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero uses telepathy to read someone''s thoughts secretly only because they are curious.","options":["PROBLEMATIC USE","HELPFUL USE"],"explanation":"Reading private thoughts without a protective need or permission does not respect personal privacy."}'::jsonb, '"PROBLEMATIC USE"'::jsonb, 2, 'u6-m18-use-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua uses water control to help families during a flood.","options":["PROBLEMATIC USE","HELPFUL USE"],"explanation":"Aqua uses the ability to reduce danger and assist families during an emergency."}'::jsonb, '"HELPFUL USE"'::jsonb, 3, 'u6-m18-use-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero uses super speed to take another student''s belongings before anyone notices.","options":["HELPFUL USE","PROBLEMATIC USE"],"explanation":"The ability is being used to take something without permission, which harms another person."}'::jsonb, '"PROBLEMATIC USE"'::jsonb, 4, 'u6-m18-use-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Sky uses flying to reach a person trapped on a high building.","options":["HELPFUL USE","PROBLEMATIC USE"],"explanation":"Sky uses flying for an appropriate rescue that helps someone reach safety."}'::jsonb, '"HELPFUL USE"'::jsonb, 5, 'u6-m18-use-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Titan uses his strength to move a heavy object blocking an emergency exit.","options":["PROBLEMATIC USE","HELPFUL USE"],"explanation":"Titan removes a dangerous obstruction and helps people use the emergency exit safely."}'::jsonb, '"HELPFUL USE"'::jsonb, 6, 'u6-m18-use-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Use Review: compare two possible actions and choose the one that uses the ability responsibly for the situation.', 2, 'u6-m18-power-review', '{"correctFeedback":"Responsible choice! The action uses the power for a clear need while respecting others.","incorrectFeedback":"Compare the likely effects of both actions and choose the one connected to safety, assistance, or protection."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua sees a flooded street. Which action is more responsible?","options":["Create a huge wave just for fun.","Control the water and create a safe path for people."],"explanation":"Creating a safe path responds to the emergency; making a wave for fun could increase the danger."}'::jsonb, '"Control the water and create a safe path for people."'::jsonb, 1, 'u6-m18-review-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Shadow needs to investigate a dangerous building. Which action is more responsible?","options":["Enter a private room and read personal information.","Enter carefully and report what he discovers."],"explanation":"Careful investigation serves the safety mission without using invisibility to invade unrelated privacy."}'::jsonb, '"Enter carefully and report what he discovers."'::jsonb, 2, 'u6-m18-review-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Titan sees a blocked road during an emergency. Which action is more responsible?","options":["Move people''s cars without asking simply because he can.","Move the heavy object to open the emergency road."],"explanation":"Opening the rescue route addresses an urgent public need; moving property without a reason ignores permission."}'::jsonb, '"Move the heavy object to open the emergency road."'::jsonb, 3, 'u6-m18-review-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero can communicate with animals. Which action is more responsible?","options":["Use the ability to scare animals for entertainment.","Use the ability to help find a missing animal."],"explanation":"Finding a missing animal is a helpful purpose; frightening animals for entertainment could harm them."}'::jsonb, '"Use the ability to help find a missing animal."'::jsonb, 4, 'u6-m18-review-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A hero can read minds. Which action is more responsible?","options":["Read everyone''s thoughts because the hero is curious.","Respect privacy and use the ability only when necessary to protect someone."],"explanation":"A protective need and respect for privacy provide responsible limits for telepathy."}'::jsonb, '"Respect privacy and use the ability only when necessary to protect someone."'::jsonb, 5, 'u6-m18-review-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Sky sees someone trapped on a roof. Which action is more responsible?","options":["Fly away because helping is not part of the power.","Fly to the roof and help the person reach safety."],"explanation":"Sky''s ability directly enables a safe rescue from the roof."}'::jsonb, '"Fly to the roof and help the person reach safety."'::jsonb, 6, 'u6-m18-review-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Council Decision: examine the telepathy case and choose conclusions that respect both the ability''s potential and other people''s rights.', 3, 'u6-m18-council-decision', '{"correctFeedback":"Council decision approved! Your reasoning balances helpful action with responsibility.","incorrectFeedback":"Return to the case and consider privacy, purpose, necessity, and the effect on other people."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"During a training session, a student discovers that they can read people''s thoughts. The student wants to use the ability to find out what other students think about them. The teacher asks the student to consider whether having an ability means they should always use it.","prompt":"What is the main problem?","options":["The student cannot control water.","The student wants to access other people''s thoughts without a clear need.","The student does not know how to read.","The student wants to become invisible."],"explanation":"The concern is not the existence of telepathy but the plan to access private thoughts only from curiosity."}'::jsonb, '"The student wants to access other people''s thoughts without a clear need."'::jsonb, 1, 'u6-m18-council-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why could this use of telepathy be problematic?","options":["It makes people fly.","It cannot be used indoors.","It makes the student too fast.","It could affect other people''s privacy."],"explanation":"Thoughts are personal information, so accessing them without a clear need can violate privacy."}'::jsonb, '"It could affect other people''s privacy."'::jsonb, 2, 'u6-m18-council-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which use would be more responsible?","options":["Read a friend''s thoughts without permission.","Use telepathy to win every competition.","Use the ability when necessary to protect someone from danger.","Read everyone''s thoughts for fun."],"explanation":"A necessary protective use has a clear helpful purpose and limits unnecessary intrusion."}'::jsonb, '"Use the ability when necessary to protect someone from danger."'::jsonb, 3, 'u6-m18-council-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer from the teacher''s question?","options":["Heroes should never use their abilities.","Powerful heroes should use abilities whenever possible.","Telepathy is not a real ability.","Having a power does not mean it should always be used."],"explanation":"The teacher is asking the student to consider judgment, purpose, and consequences before using the power."}'::jsonb, '"Having a power does not mean it should always be used."'::jsonb, 4, 'u6-m18-council-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What is the main message of the mission?","options":["The strongest power is always the best.","Heroes should use abilities responsibly and consider how their actions affect others.","Some abilities are completely useless.","Heroes should never help people."],"explanation":"Responsible heroes consider both what a power can do and how its use affects safety, privacy, and other people."}'::jsonb, '"Heroes should use abilities responsibly and consider how their actions affect others."'::jsonb, 5, 'u6-m18-council-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 19: Power Exchange
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Exchange', 'The Hero Academy has opened the Power Exchange. Energy is limited, so you cannot choose every ability. Build efficient power combinations for each challenge.', 19, 'explorer', 150, 'Power Architect', 'Hero Academy Council', 44, 21, 'unit-6-mission-19')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Market: spend limited energy wisely. Choose the ability whose function most directly addresses each situational need.', 1, 'u6-m19-power-market', '{"correctFeedback":"Useful purchase! This power directly supports the required action.","incorrectFeedback":"Compare what the situation requires with what each ability actually allows a hero to do."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to reach the top of a tall building without using the stairs. Which power is most useful?","options":["Healing power","Flying","Control water","Telepathy"],"explanation":"Flying lets a hero travel directly to a high location without stairs."}'::jsonb, '"Flying"'::jsonb, 1, 'u6-m19-market-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to discover what a frightened person is thinking. Which power is most useful?","options":["Invisibility","Super strength","Telepathy","Flying"],"explanation":"Telepathy allows communication with or understanding of another person''s thoughts."}'::jsonb, '"Telepathy"'::jsonb, 2, 'u6-m19-market-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to move a huge object blocking a rescue route. Which power is most useful?","options":["Animal communication","Healing power","Invisibility","Super strength"],"explanation":"Super strength lets a hero move an object too heavy for an ordinary rescuer."}'::jsonb, '"Super strength"'::jsonb, 3, 'u6-m19-market-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to help an injured person recover. Which power is most useful?","options":["Telepathy","Healing power","Super speed","Flying"],"explanation":"Healing power directly supports recovery from an injury."}'::jsonb, '"Healing power"'::jsonb, 4, 'u6-m19-market-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to enter a dangerous place without being easily noticed. Which power is most useful?","options":["Super strength","Control water","Invisibility","Healing power"],"explanation":"Invisibility helps the hero enter without attracting attention."}'::jsonb, '"Invisibility"'::jsonb, 5, 'u6-m19-market-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You need to understand what an animal is trying to communicate. Which power is most useful?","options":["Super speed","Fire control","Animal communication","Flying"],"explanation":"Animal communication enables the hero to understand the animal''s message."}'::jsonb, '"Animal communication"'::jsonb, 6, 'u6-m19-market-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Upgrade Decisions: select exactly one TWO-POWER PACKAGE for each challenge. The correct pair must address two different needs efficiently.', 2, 'u6-m19-upgrade-decisions', '{"correctFeedback":"Efficient upgrade! The two abilities complement each other and cover the whole challenge.","incorrectFeedback":"Identify the two separate needs in the challenge, then choose one suitable power for each."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A city is flooding, and people are trapped on a building''s roof. Which TWO powers form the best package?","options":["Telepathy + Invisibility","Flying + Control water","Invisibility + Control water","Flying + Telepathy"],"explanation":"Flying reaches the roof, while water control manages the flooding below."}'::jsonb, '"Flying + Control water"'::jsonb, 1, 'u6-m19-upgrade-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A collapsed building has heavy objects blocking the entrance, and people may be trapped inside. Which TWO powers form the best package?","options":["Healing power + Invisibility","Invisibility + Super strength","Super strength + Telepathy","Telepathy + Healing power"],"explanation":"Super strength clears the heavy blockage, and telepathy can help locate or communicate with trapped people."}'::jsonb, '"Super strength + Telepathy"'::jsonb, 2, 'u6-m19-upgrade-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A forest animal is injured, and another animal has disappeared. Which TWO powers form the best package?","options":["Fire control + Super speed","Animal communication + Super speed","Healing power + Fire control","Animal communication + Healing power"],"explanation":"Healing power assists the injured animal, and animal communication helps search for the missing one."}'::jsonb, '"Animal communication + Healing power"'::jsonb, 3, 'u6-m19-upgrade-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dangerous secret laboratory must be investigated, and important hidden information must be recovered. Which TWO powers form the best package?","options":["Control water + Super strength","Invisibility + Telepathy","Telepathy + Control water","Super strength + Invisibility"],"explanation":"Invisibility supports discreet entry, while telepathy can help discover important information."}'::jsonb, '"Invisibility + Telepathy"'::jsonb, 4, 'u6-m19-upgrade-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A rescue team must reach a distant location quickly and help an injured person. Which TWO powers form the best package?","options":["Animal communication + Fire control","Healing power + Animal communication","Flying + Fire control","Flying + Healing power"],"explanation":"Flying provides rapid transportation, and healing power supports the injured person."}'::jsonb, '"Flying + Healing power"'::jsonb, 5, 'u6-m19-upgrade-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A damaged communication center must be investigated, and the team needs to understand what people inside are planning. Which TWO powers form the best package?","options":["Super strength + Control water","Telepathy + Super strength","Invisibility + Telepathy","Control water + Invisibility"],"explanation":"Invisibility supports careful investigation, and telepathy helps understand people''s thoughts or plans."}'::jsonb, '"Invisibility + Telepathy"'::jsonb, 6, 'u6-m19-upgrade-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Final Build: the academy has energy for only four abilities. Connect each city problem to a specific function, then choose the complete four-power build.', 3, 'u6-m19-final-build', '{"correctFeedback":"Power architecture complete! Each selected ability solves a specific problem.","incorrectFeedback":"Map every problem to one direct function before choosing the final build."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"THE ACADEMY''S BIGGEST TEST: A large storm has damaged an important part of the city. Four problems must be solved: several streets are flooded; a rescue entrance is blocked by heavy objects; people are trapped on the upper floors of a building; and the rescue team needs to know where the trapped people are. The academy can choose only FOUR abilities from control water, super strength, flying, telepathy, invisibility, and healing power.","prompt":"Which power should deal with the flooded streets?","options":["Telepathy","Invisibility","Control water","Healing power"],"explanation":"Water control directly addresses the flood covering the streets."}'::jsonb, '"Control water"'::jsonb, 1, 'u6-m19-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power should clear the blocked entrance?","options":["Flying","Super strength","Telepathy","Invisibility"],"explanation":"Super strength can move the heavy objects blocking the rescue entrance."}'::jsonb, '"Super strength"'::jsonb, 2, 'u6-m19-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power should reach the upper floors?","options":["Healing power","Control water","Flying","Telepathy"],"explanation":"Flying lets a hero access the upper floors directly."}'::jsonb, '"Flying"'::jsonb, 3, 'u6-m19-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which power could help locate the trapped people?","options":["Invisibility","Telepathy","Super strength","Control water"],"explanation":"Telepathy can help detect or communicate with people whose location is unknown."}'::jsonb, '"Telepathy"'::jsonb, 4, 'u6-m19-final-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which FOUR-POWER BUILD solves the four main problems most directly?","options":["Telepathy + Invisibility + Healing power + Fire control","Super strength + Healing power + Invisibility + Animal communication","Control water + Super strength + Flying + Telepathy","Invisibility + Healing power + Flying + Fire control"],"explanation":"Excellent: water control handles flooding, strength clears the entrance, flying reaches upper floors, and telepathy locates people."}'::jsonb, '"Control water + Super strength + Flying + Telepathy"'::jsonb, 5, 'u6-m19-final-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 20: The Superpower Trial
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Superpower Trial', 'Welcome to the Superpower Trial! Complete three final challenges—analyze, decide, and solve—to finish the first major stage of your academy training.', 20, 'explorer', 250, 'SUPERPOWER MASTER', 'Superpower Academy Arena', 29, 29, 'unit-6-mission-20')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'TRIAL 1 · POWER UNDER PRESSURE: make six rapid decisions from limited information. Select the ability that responds most directly to each immediate danger.', 1, 'u6-m20-trial-pressure', '{"correctFeedback":"Rapid response confirmed! That ability directly addresses the emergency.","incorrectFeedback":"Focus on the single urgent need and choose the ability whose function solves it most directly."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A flood is entering several homes. Which power should respond?","options":["Super speed","Invisibility","Control water","Telepathy"],"explanation":"Water control can redirect the flood and help protect the homes."}'::jsonb, '"Control water"'::jsonb, 1, 'u6-m20-pressure-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A heavy metal door is blocking the emergency exit. Which power should respond?","options":["Healing power","Telepathy","Super strength","Flying"],"explanation":"Super strength can move the heavy metal obstruction."}'::jsonb, '"Super strength"'::jsonb, 2, 'u6-m20-pressure-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A person is trapped on the roof of a tall building. Which power should respond?","options":["Animal communication","Invisibility","Flying","Control water"],"explanation":"Flying allows a hero to reach the high roof directly."}'::jsonb, '"Flying"'::jsonb, 3, 'u6-m20-pressure-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A rescue team needs to understand where a missing person may be hiding. Which power should respond?","options":["Fire control","Telepathy","Flying","Super strength"],"explanation":"Telepathy may help the team detect or understand the missing person''s thoughts."}'::jsonb, '"Telepathy"'::jsonb, 4, 'u6-m20-pressure-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"A dangerous laboratory must be investigated without attracting attention. Which power should respond?","options":["Healing power","Control water","Invisibility","Super speed"],"explanation":"Invisibility supports careful investigation without being easily noticed."}'::jsonb, '"Invisibility"'::jsonb, 5, 'u6-m20-pressure-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"An injured person needs help recovering after an accident. Which power should respond?","options":["Telepathy","Flying","Super strength","Healing power"],"explanation":"Healing power directly assists physical recovery after an injury."}'::jsonb, '"Healing power"'::jsonb, 6, 'u6-m20-pressure-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'TRIAL 2 · THE IMPOSSIBLE CHOICE: decide what the hero would logically do, expressed with If + past simple + would + base verb.', 2, 'u6-m20-trial-choice', '{"correctFeedback":"Impossible choice solved! The action is logical and the Second Conditional is correctly formed.","incorrectFeedback":"Check both the decision and the structure: past form after if, then would + base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You suddenly have super speed. What would you do to help your city?","options":["If I had super speed, I helped people quickly.","If I have super speed, I would help people quickly.","If I had super speed, I would help people quickly."],"explanation":"Had introduces the imaginary power, and would help expresses the imagined action."}'::jsonb, '"If I had super speed, I would help people quickly."'::jsonb, 1, 'u6-m20-choice-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can fly, and a child is trapped on a high building. What would you do?","options":["If I could fly, I rescue the child.","If I could fly, I would rescue the child.","If I can fly, I rescued the child."],"explanation":"Could fly + would rescue correctly expresses an imaginary rescue decision."}'::jsonb, '"If I could fly, I would rescue the child."'::jsonb, 2, 'u6-m20-choice-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can control water, and your city is flooding. What would you do?","options":["If I controlled water, I protect the houses.","If I control water, I protected the houses.","If I controlled water, I would protect the houses."],"explanation":"Controlled + would protect follows the Second Conditional and addresses the flood."}'::jsonb, '"If I controlled water, I would protect the houses."'::jsonb, 3, 'u6-m20-choice-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You can become invisible and need to investigate a dangerous location. What would you do?","options":["If I were invisible, I entered carefully.","If I am invisible, I would entered carefully.","If I were invisible, I would enter carefully."],"explanation":"Were introduces the imaginary state, and would enter uses the required base verb."}'::jsonb, '"If I were invisible, I would enter carefully."'::jsonb, 4, 'u6-m20-choice-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You have super strength, and a road is blocked after an accident. What would you do?","options":["If I had super strength, I move the object.","If I had super strength, I would move the object.","If I have super strength, I moved the object."],"explanation":"Had + would move correctly describes the useful imaginary action."}'::jsonb, '"If I had super strength, I would move the object."'::jsonb, 5, 'u6-m20-choice-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'TRIAL 3 · FINAL HERO CHALLENGE: solve four simultaneous failures, identify the least essential ability, and assemble the only complete four-hero response.', 3, 'u6-m20-final-trial', '{"correctFeedback":"Boss trial decision confirmed! Your team assignment addresses a specific problem with each ability.","incorrectFeedback":"Break the emergency into four separate needs and assign the hero whose ability directly matches each one.","completionMessage":"SUPERPOWER TRIAL COMPLETE! You completed the first major stage of your Superpower Academy training!"}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"THE FINAL EMERGENCY: A powerful storm has hit the city. Four problems are happening at the same time: several streets are flooded; a rescue entrance is blocked by a heavy object; two people are trapped on the roof of a building; and the academy''s communication device is broken. Available heroes: AQUA controls water. TITAN has super strength. SKY can fly. MAYA repairs damaged objects. SHADOW can become invisible.","prompt":"Which hero should help with the flooding?","options":["Shadow","Maya","Aqua","Titan"],"explanation":"Aqua controls water and can reduce the flooding."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m20-final-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should clear the blocked entrance?","options":["Sky","Titan","Aqua","Maya"],"explanation":"Titan''s super strength can move the heavy object blocking the entrance."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m20-final-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should reach the people on the roof?","options":["Aqua","Shadow","Maya","Sky"],"explanation":"Sky can fly directly to the roof and begin the rescue."}'::jsonb, '"Sky"'::jsonb, 3, 'u6-m20-final-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero should repair the communication device?","options":["Titan","Maya","Sky","Shadow"],"explanation":"Maya''s repair ability directly addresses the damaged device."}'::jsonb, '"Maya"'::jsonb, 4, 'u6-m20-final-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero is least essential for the four main problems?","options":["Maya","Aqua","Shadow","Titan"],"explanation":"Shadow is useful in other situations, but invisibility is not directly required for flooding, lifting, rooftop access, or device repair."}'::jsonb, '"Shadow"'::jsonb, 5, 'u6-m20-final-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The academy can send only FOUR heroes. Which team should it choose?","options":["Shadow + Maya + Titan + Sky","Aqua + Shadow + Maya + Sky","Aqua + Titan + Sky + Maya","Shadow + Titan + Sky + Aqua"],"explanation":"This team assigns one matching ability to each of the four urgent problems."}'::jsonb, '"Aqua + Titan + Sky + Maya"'::jsonb, 6, 'u6-m20-final-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What makes this team effective?","options":["The team chooses heroes randomly.","All four heroes have the same ability.","The team only needs the strongest hero.","Each hero''s ability responds to a different problem."],"explanation":"The team is effective because its abilities are complementary and collectively cover every urgent need."}'::jsonb, '"Each hero''s ability responds to a different problem."'::jsonb, 7, 'u6-m20-final-7')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 21: The Power Database
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Power Database', 'The academy discovered an incomplete archive of superhero records. Analyze the structured cards and recover what each hero can—and cannot—do.', 21, 'challenger', 150, 'Power Analyst', 'Superpower Research Center', 14, 20, 'unit-6-mission-21')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Read the Power Cards: scan the structured fields for ability, strength, limitation, and best use. Locate and compare data rather than reading a continuous story.', 1, 'u6-m21-power-cards', '{"correctFeedback":"Data located! Your answer matches the relevant Power Card fields.","incorrectFeedback":"Return to the cards and compare the exact strength, limitation, or best-use field requested."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"POWER CARD: AQUA | Ability: control water | Strength: moves large amounts of water | Limitation: less useful in dry environments | Best for: flood emergencies. POWER CARD: TITAN | Ability: super strength | Strength: moves heavy objects | Limitation: cannot fly | Best for: rescue missions. POWER CARD: SHADOW | Ability: invisibility | Strength: moves without being seen | Limitation: cannot move very heavy objects | Best for: secret investigations. POWER CARD: SKY | Ability: flying | Strength: reaches high places quickly | Limitation: cannot control water | Best for: aerial rescue.","prompt":"Which hero is most useful during a flood?","options":["Sky","Aqua","Shadow","Titan"],"explanation":"Aqua''s best-use field identifies flood emergencies."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m21-card-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero cannot fly?","options":["Shadow","Titan","Aqua","Sky"],"explanation":"Titan''s limitation field states that he cannot fly."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m21-card-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero is best for a secret investigation?","options":["Titan","Aqua","Shadow","Sky"],"explanation":"Shadow''s invisibility and ability to move unseen fit a secret investigation."}'::jsonb, '"Shadow"'::jsonb, 3, 'u6-m21-card-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero can reach a high place quickly?","options":["Aqua","Shadow","Sky","Titan"],"explanation":"Sky''s strength field says she can reach high places quickly."}'::jsonb, '"Sky"'::jsonb, 4, 'u6-m21-card-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero has a limitation related to dry environments?","options":["Titan","Sky","Aqua","Shadow"],"explanation":"Aqua''s water power is less useful where the environment is completely dry."}'::jsonb, '"Aqua"'::jsonb, 5, 'u6-m21-card-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which TWO heroes have abilities directly useful for rescue situations?","options":["Aqua + Shadow","Titan + Sky","Shadow + Sky","Aqua + Titan"],"explanation":"Titan is listed for rescue missions, while Sky is listed for aerial rescue."}'::jsonb, '"Titan + Sky"'::jsonb, 6, 'u6-m21-card-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Database Detective · Find the Data: determine which hero—or pair—matches each statement using only the structured Power Card records.', 2, 'u6-m21-database-detective', '{"correctFeedback":"Database match confirmed! The profile data supports this identification.","incorrectFeedback":"Compare the statement with the recorded strengths and limitations before selecting a profile."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"This hero can move large amounts of water.","options":["Shadow","Sky","Aqua","Titan"],"explanation":"Moving large amounts of water is Aqua''s recorded strength."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m21-data-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"This hero can enter a place without being seen.","options":["Titan","Shadow","Aqua","Sky"],"explanation":"Shadow''s invisibility allows movement without being seen."}'::jsonb, '"Shadow"'::jsonb, 2, 'u6-m21-data-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"This hero can move heavy objects.","options":["Aqua","Sky","Titan","Shadow"],"explanation":"Titan''s super strength is recorded as the ability to move heavy objects."}'::jsonb, '"Titan"'::jsonb, 3, 'u6-m21-data-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"This hero can reach high places quickly.","options":["Shadow","Titan","Aqua","Sky"],"explanation":"Sky''s flying ability enables rapid access to high locations."}'::jsonb, '"Sky"'::jsonb, 4, 'u6-m21-data-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which TWO heroes could be useful in a rescue involving a high building?","options":["Shadow + Aqua","Sky + Titan","Aqua + Titan","Sky + Shadow"],"explanation":"Sky reaches high places, while Titan can remove heavy obstacles during the rescue."}'::jsonb, '"Sky + Titan"'::jsonb, 5, 'u6-m21-data-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which TWO heroes have limitations that can reduce usefulness in particular environments?","options":["Shadow + Sky","Aqua + Titan","Titan + Shadow","Sky + Aqua"],"explanation":"Aqua is less useful in dry environments, and Titan cannot fly, which limits access to high locations."}'::jsonb, '"Aqua + Titan"'::jsonb, 6, 'u6-m21-data-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Find the Pattern: apply the database fields to three emergencies, then identify the general rule behind effective hero assignments.', 3, 'u6-m21-find-pattern', '{"correctFeedback":"Pattern found! Your conclusion connects the emergency data with strengths and limitations.","incorrectFeedback":"Match each emergency need to a strength and check whether a limitation prevents the assignment."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"DATABASE TEAM REQUEST: Emergency A — a flood in a coastal city. Emergency B — a collapsed building with heavy debris. Emergency C — a person trapped on a high roof. Use each Power Card''s ability, strength, limitation, and best use to assign the response.","prompt":"Who is the best choice for Emergency A, the coastal flood?","options":["Titan","Shadow","Aqua","Sky"],"explanation":"Aqua''s water control and flood specialization directly match Emergency A."}'::jsonb, '"Aqua"'::jsonb, 1, 'u6-m21-pattern-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Who is the best choice for Emergency B, the collapsed building?","options":["Aqua","Sky","Titan","Shadow"],"explanation":"Titan can move the heavy debris found in a collapsed building."}'::jsonb, '"Titan"'::jsonb, 2, 'u6-m21-pattern-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Who is the best choice for Emergency C, the high roof?","options":["Shadow","Sky","Aqua","Titan"],"explanation":"Sky can fly and reach the high roof quickly."}'::jsonb, '"Sky"'::jsonb, 3, 'u6-m21-pattern-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which hero is less useful for Emergency C specifically because of a recorded limitation?","options":["Sky","Aqua","Titan","Shadow"],"explanation":"Titan cannot fly, so his limitation prevents direct access to the high roof."}'::jsonb, '"Titan"'::jsonb, 4, 'u6-m21-pattern-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which TWO heroes could work together when a rescue includes both a blocked entrance and a high roof?","options":["Aqua + Shadow","Sky + Aqua","Titan + Sky","Shadow + Titan"],"explanation":"Titan clears the heavy entrance blockage, while Sky reaches the roof."}'::jsonb, '"Titan + Sky"'::jsonb, 5, 'u6-m21-pattern-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What pattern does the database reveal?","options":["Every hero has the same ability.","Limitations do not matter.","The strongest ability is always best.","Each hero has strengths and limitations, so the best choice depends on the situation."],"explanation":"Data-based decisions compare both advantages and limits with the exact requirements of the situation."}'::jsonb, '"Each hero has strengths and limitations, so the best choice depends on the situation."'::jsonb, 6, 'u6-m21-pattern-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 22: Power Transformation
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Transformation', 'The Superpower Research Center has activated its Transformation Machine. Convert each message into a new form without losing—or misunderstanding—its meaning.', 22, 'challenger', 150, 'Power Transformer', 'Superpower Research Center', 26, 10, 'unit-6-mission-22')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power Converter: select the transformed sentence that preserves the complete meaning of the original statement.', 1, 'u6-m22-power-converter', '{"correctFeedback":"Meaning preserved! The transformation expresses the same ability in a different form.","incorrectFeedback":"Compare ability, possibility, time, and negation. The correct transformation must keep every important meaning."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Leo can fly.” Which sentence has the same meaning?","options":["Leo flew yesterday.","Leo is able to fly.","Leo would fly.","Leo cannot fly."],"explanation":"Can fly and is able to fly both express Leo''s present ability."}'::jsonb, '"Leo is able to fly."'::jsonb, 1, 'u6-m22-convert-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Aqua can control water.” Which sentence has the same meaning?","options":["Aqua would control water.","Aqua cannot control water.","Aqua is able to control water.","Aqua controlled water yesterday."],"explanation":"Can control and is able to control express the same ability."}'::jsonb, '"Aqua is able to control water."'::jsonb, 2, 'u6-m22-convert-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Shadow cannot be seen when he uses his power.” Which sentence has the closest meaning?","options":["Shadow can control water.","Shadow can become invisible.","Shadow can read minds.","Shadow can fly."],"explanation":"Becoming invisible explains why Shadow cannot be seen."}'::jsonb, '"Shadow can become invisible."'::jsonb, 3, 'u6-m22-convert-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Titan is able to move heavy objects.” Which sentence has the same meaning?","options":["Titan moved heavy objects yesterday.","Titan cannot move heavy objects.","Titan would move heavy objects.","Titan can move heavy objects."],"explanation":"Is able to move and can move describe the same present ability."}'::jsonb, '"Titan can move heavy objects."'::jsonb, 4, 'u6-m22-convert-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Maya can repair some machines.” Which sentence has the same meaning?","options":["Maya would repair machines.","Maya repaired every machine.","Maya is able to repair some machines.","Maya cannot repair machines."],"explanation":"The transformed sentence keeps both the ability and the limitation expressed by some."}'::jsonb, '"Maya is able to repair some machines."'::jsonb, 5, 'u6-m22-convert-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Sky is able to reach high places quickly.” Which sentence has the same meaning?","options":["Sky cannot reach high places.","Sky reached high places yesterday.","Sky can reach high places quickly.","Sky would reach high places."],"explanation":"Can reach is equivalent to is able to reach and preserves quickly."}'::jsonb, '"Sky can reach high places quickly."'::jsonb, 6, 'u6-m22-convert-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Change the Scenario: transform each possible or real situation into an imaginary superhero decision using If + past simple + would + base verb.', 2, 'u6-m22-change-scenario', '{"correctFeedback":"Scenario transformed! The if-clause creates the imaginary condition, and the would-clause gives its result.","incorrectFeedback":"Check the two connected parts: IF + past form, followed by WOULD + base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You do not have super speed, but imagine that you had it.","options":["If I had super speed, I helped people quickly.","If I have super speed, I help people quickly.","If I had super speed, I would help people quickly."],"explanation":"If I had introduces the imaginary power; I would help gives the imagined result."}'::jsonb, '"If I had super speed, I would help people quickly."'::jsonb, 1, 'u6-m22-scenario-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"You cannot fly, but imagine that you could.","options":["If I could fly, I travel around the world.","If I could fly, I would travel around the world.","If I can fly, I traveled around the world."],"explanation":"Could fly forms the imaginary if-clause, and would travel forms the result."}'::jsonb, '"If I could fly, I would travel around the world."'::jsonb, 2, 'u6-m22-scenario-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Imagine that Aqua could control every drop of water.","options":["If Aqua controlled water, she helps during floods.","If Aqua controls water, she helped during floods.","If Aqua controlled water, she would help during floods."],"explanation":"Controlled is the past form in the if-clause; would help describes the imagined outcome."}'::jsonb, '"If Aqua controlled water, she would help during floods."'::jsonb, 3, 'u6-m22-scenario-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Imagine that Shadow were invisible.","options":["If Shadow were invisible, he enters the building carefully.","If Shadow is invisible, he entered the building carefully.","If Shadow were invisible, he would enter the building carefully."],"explanation":"Were sets the imaginary condition, and would enter gives the possible action."}'::jsonb, '"If Shadow were invisible, he would enter the building carefully."'::jsonb, 4, 'u6-m22-scenario-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Imagine that Titan had even more strength.","options":["If Titan had more strength, he moves the largest objects.","If Titan had more strength, he would move the largest objects.","If Titan has more strength, he moved the largest objects."],"explanation":"Had belongs in the if-clause, while would move correctly expresses the imagined result."}'::jsonb, '"If Titan had more strength, he would move the largest objects."'::jsonb, 5, 'u6-m22-scenario-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Imagine that Maya could repair any machine.","options":["If Maya can repair any machine, she helped the academy.","If Maya could repair any machine, she would help the academy.","If Maya could repair any machine, she helps the academy."],"explanation":"Could repair creates the imaginary condition, and would help states its result."}'::jsonb, '"If Maya could repair any machine, she would help the academy."'::jsonb, 6, 'u6-m22-scenario-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Transformation Challenge: compare the original and new statements, then identify exactly how ability, possibility, or meaning changed.', 3, 'u6-m22-transformation', '{"correctFeedback":"Transformation interpreted! You identified how the language changed the meaning.","incorrectFeedback":"Compare positive versus negative ability, real versus imaginary meaning, and the result introduced by would."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Shadow can become invisible.” New: “Shadow can''t become invisible.” What changed?","options":["Shadow gained a new ability.","Nothing changed.","The ability changed from possible to impossible.","Shadow became faster."],"explanation":"Can expresses ability, while can''t removes that ability."}'::jsonb, '"The ability changed from possible to impossible."'::jsonb, 1, 'u6-m22-meaning-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Aqua can control water.” New: “If Aqua controlled water, she would help during floods.” What does the new sentence describe?","options":["A past event.","A permanent fact.","An imaginary situation.","Something that happened yesterday."],"explanation":"The Second Conditional presents water control and its result as an imagined situation."}'::jsonb, '"An imaginary situation."'::jsonb, 2, 'u6-m22-meaning-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Titan can move heavy objects.” New: “Titan cannot move heavy objects.” What does the new statement mean?","options":["Titan moved an object yesterday.","Titan wants to move an object.","Titan does not have the ability to move heavy objects.","Titan is moving an object now."],"explanation":"Cannot changes the statement from having the ability to not having it."}'::jsonb, '"Titan does not have the ability to move heavy objects."'::jsonb, 3, 'u6-m22-meaning-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Sky can fly.” New: “If Sky could fly, she would rescue people on high buildings.” What does the new sentence communicate?","options":["A daily routine.","An imagined possibility and its result.","A scientific fact.","A past action."],"explanation":"Could fly introduces an imagined possibility, and would rescue describes its result."}'::jsonb, '"An imagined possibility and its result."'::jsonb, 4, 'u6-m22-meaning-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Maya can repair some machines.” New: “If Maya could repair every machine, she would help more people.” What is being imagined?","options":["Maya repairing a machine yesterday.","Maya becoming invisible.","Maya having a greater ability.","Maya losing her ability."],"explanation":"The new statement expands her limited ability from some machines to every machine."}'::jsonb, '"Maya having a greater ability."'::jsonb, 5, 'u6-m22-meaning-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Original: “Titan can help during rescues.” New: “If Titan had super speed, he would arrive faster.” What does the Second Conditional add?","options":["A completed action.","A past event.","An imaginary ability and a possible result.","A daily routine."],"explanation":"Super speed is imagined, and arriving faster is the possible result of having that ability."}'::jsonb, '"An imaginary ability and a possible result."'::jsonb, 6, 'u6-m22-meaning-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 23: The Hidden Signal
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'The Hidden Signal', 'A strange signal appeared inside Superpower Academy. The research team found four separated evidence fragments. Connect them without treating an unproven explanation as a fact.', 23, 'challenger', 150, 'Signal Detective', 'Superpower Research Center', 43, 14, 'unit-6-mission-23')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Collect the Evidence: examine four separate timestamped cards. Some questions require connecting events from different cards rather than locating one isolated sentence.', 1, 'u6-m23-collect-evidence', '{"correctFeedback":"Evidence collected! Your answer agrees with the timestamped record.","incorrectFeedback":"Compare the times and details across all four cards before choosing again."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"EVIDENCE CARD 1 · 4:10 PM — The academy''s communication system suddenly stopped working. The lights in the research center remained on. | EVIDENCE CARD 2 · 4:12 PM — A researcher heard a strange sound near the energy laboratory. The sound lasted only a few seconds. | EVIDENCE CARD 3 · 4:15 PM — Maya entered the laboratory. She discovered that one damaged machine had started working again. | EVIDENCE CARD 4 · 4:18 PM — The communication system started working again. Nobody had repaired it manually.","prompt":"What stopped working at 4:10 PM?","options":["The academy''s communication system.","The research center lights.","Every machine in the laboratory.","The academy doors."],"explanation":"FACT · Card 1 states that the communication system stopped working at 4:10 PM."}'::jsonb, '"The academy''s communication system."'::jsonb, 1, 'u6-m23-collect-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Where did the researcher hear the strange sound?","options":["Near the energy laboratory.","On the academy roof.","Beside the communication tower.","Outside the city."],"explanation":"FACT · Card 2 places the sound near the energy laboratory."}'::jsonb, '"Near the energy laboratory."'::jsonb, 2, 'u6-m23-collect-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What did Maya discover?","options":["The lights had stopped working.","A damaged machine had started working again.","The communication system had been repaired manually.","The laboratory was completely empty."],"explanation":"FACT · Card 3 records the damaged machine working again after Maya entered."}'::jsonb, '"A damaged machine had started working again."'::jsonb, 3, 'u6-m23-collect-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What happened three minutes after Maya entered the laboratory?","options":["The laboratory lights went out.","Maya left the academy.","The communication system started working again.","A researcher repaired the system manually."],"explanation":"FACT · Card 3 is timed 4:15 PM and Card 4 records the system restarting at 4:18 PM."}'::jsonb, '"The communication system started working again."'::jsonb, 4, 'u6-m23-collect-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What can we infer from the combined evidence?","options":["The academy was completely empty.","The strange event may be connected to the energy laboratory.","The researchers planned the problem.","The lights caused the problem."],"explanation":"INFERENCE · The sound and reactivated machine both involve the laboratory, but the connection is not yet proven."}'::jsonb, '"The strange event may be connected to the energy laboratory."'::jsonb, 5, 'u6-m23-collect-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why is the exact cause still unknown?","options":["Nobody was inside the academy.","The communication system never stopped working.","Maya destroyed the machine.","The evidence shows what happened but does not clearly identify the cause."],"explanation":"INFERENCE · The timeline records events, but no card proves which event caused the communication system to restart."}'::jsonb, '"The evidence shows what happened but does not clearly identify the cause."'::jsonb, 6, 'u6-m23-collect-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Connect the Clues: choose the evidence-card pair that best supports each conclusion. One challenge needs only a single card, as stated.', 2, 'u6-m23-connect-clues', '{"correctFeedback":"Evidence connection confirmed! These records support the conclusion without claiming more than they prove.","incorrectFeedback":"Check which cards contain the two facts needed for the conclusion, and separate possibility from proof."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: Something unusual happened between 4:12 and 4:18. Which TWO cards support it?","options":["Cards 1 + 3","Cards 2 + 4","Cards 1 + 2","Cards 3 + 4"],"explanation":"FACT CONNECTION · Card 2 records the strange sound; Card 4 records the unexplained system recovery."}'::jsonb, '"Cards 2 + 4"'::jsonb, 1, 'u6-m23-connect-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: The problem was connected to the research center. Which TWO cards provide the strongest support?","options":["Cards 1 + 4","Cards 2 + 3","Cards 1 + 2","Cards 3 + 4"],"explanation":"INFERENCE · The sound near the energy laboratory and the reactivated machine suggest a connection to the research center."}'::jsonb, '"Cards 2 + 3"'::jsonb, 2, 'u6-m23-connect-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: The lights were not affected by the initial problem. Which ONE card proves it?","options":["Card 4","Card 2","Card 1","Card 3"],"explanation":"FACT · Card 1 directly states that the research center lights remained on."}'::jsonb, '"Card 1"'::jsonb, 3, 'u6-m23-connect-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: Maya may be connected to the unusual event, but the evidence does not prove it. Which TWO cards support this careful possibility?","options":["Cards 2 + 3","Cards 3 + 4","Cards 1 + 2","Cards 1 + 4"],"explanation":"POSSIBLE EXPLANATION · Maya and the working machine appear before the system restarts, but timing alone does not prove cause."}'::jsonb, '"Cards 3 + 4"'::jsonb, 4, 'u6-m23-connect-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: The communication system recovered without a normal manual repair. Which TWO cards support it?","options":["Cards 2 + 4","Cards 1 + 4","Cards 2 + 3","Cards 1 + 3"],"explanation":"FACT CONNECTION · Card 1 establishes the failure; Card 4 establishes recovery without manual repair."}'::jsonb, '"Cards 1 + 4"'::jsonb, 5, 'u6-m23-connect-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Conclusion: The academy still needs more information. Which TWO cards expose an unexplained connection?","options":["Cards 1 + 4","Cards 3 + 4","Cards 2 + 3","Cards 1 + 2"],"explanation":"INFERENCE · The sound and working machine are facts, but the evidence does not confirm how—or whether—they are connected."}'::jsonb, '"Cards 2 + 3"'::jsonb, 6, 'u6-m23-connect-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Solve the Signal: add the final research detail and choose conclusions that clearly distinguish FACT, INFERENCE, and POSSIBLE EXPLANATION.', 3, 'u6-m23-solve-signal', '{"correctFeedback":"Signal analysis accepted! Your conclusion stays within what the evidence can support.","incorrectFeedback":"Avoid words like definitely when the evidence only suggests a possible connection."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"FINAL RESEARCH DETAIL: Maya''s ability can repair some damaged machines. However, Maya says that she did not intentionally repair the communication system. The academy still does not know exactly why the system started working again.","prompt":"What ability does Maya have?","options":["She can repair some damaged machines.","She can control every academy system.","She can become invisible.","She can read people''s thoughts."],"explanation":"FACT · The final detail states that Maya can repair some damaged machines."}'::jsonb, '"She can repair some damaged machines."'::jsonb, 1, 'u6-m23-solve-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Did Maya say that she intentionally repaired the communication system?","options":["The record does not mention Maya.","Yes.","No.","The teachers confirmed that she did."],"explanation":"FACT · Maya explicitly says she did not intentionally repair it."}'::jsonb, '"No."'::jsonb, 2, 'u6-m23-solve-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Which explanation is most consistent with all the evidence?","options":["The communication system was never broken.","Maya definitely repaired the communication system.","The strange sound definitely caused the failure.","Maya''s ability may have affected the system, but the evidence does not prove it caused the restart."],"explanation":"POSSIBLE EXPLANATION · Maya''s ability and timing make a connection possible, but no evidence proves causation."}'::jsonb, '"Maya''s ability may have affected the system, but the evidence does not prove it caused the restart."'::jsonb, 3, 'u6-m23-solve-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Why should researchers avoid saying Maya definitely caused the event?","options":["Maya has no ability.","The system was working perfectly.","There is not enough evidence to prove the connection.","Nobody saw Maya enter the academy."],"explanation":"INFERENCE RULE · A reasonable possibility must not be reported as a confirmed fact without sufficient proof."}'::jsonb, '"There is not enough evidence to prove the connection."'::jsonb, 4, 'u6-m23-solve-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"What is the main lesson of the investigation?","options":["Evidence is not important when solving a problem.","The first explanation is always correct.","Conclusions should be based on evidence, and possible explanations are not confirmed facts.","Superpowers can never cause unexpected results."],"explanation":"EVIDENCE PRINCIPLE · Strong reasoning labels what is known, what is inferred, and what remains only possible."}'::jsonb, '"Conclusions should be based on evidence, and possible explanations are not confirmed facts."'::jsonb, 5, 'u6-m23-solve-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 24: What If...?
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'What If...?', 'The Simulation Lab''s What-If Machine accepts only logical imaginary situations. Connect each condition, consequence, and scenario using the correct structure.', 24, 'challenger', 150, 'What-If Master', 'Hero Academy Simulation Lab', 62, 9, 'unit-6-mission-24')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'matching'::public.activity_type, 'Match the Possibilities: actively connect each imaginary if-clause with the consequence that is both logical and grammatically complete.', 1, 'u6-m24-match-possibilities', '{"correctFeedback":"Logical connection! The condition and consequence create a meaningful Second Conditional sentence.","incorrectFeedback":"Check the ability in the if-clause and connect it to a result that power could logically produce."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Connect all six What-If possibilities.","pairs":[{"left":"If I had super speed,","right":"I would arrive at the academy very quickly."},{"left":"If Aqua controlled water,","right":"she would help the city during floods."},{"left":"If Shadow were invisible,","right":"he would enter the building without being seen."},{"left":"If Sky could fly,","right":"she would reach the roof easily."},{"left":"If Titan had super strength,","right":"he would move the heavy object."},{"left":"If Maya could repair every machine,","right":"she would repair the academy''s broken machines."}]}'::jsonb, '"all"'::jsonb, 1, 'u6-m24-possibility-pairs')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Choose the Consequence: select the result that logically completes each imaginary situation. Consider meaning, not only the presence of would.', 2, 'u6-m24-consequence', '{"correctFeedback":"Consequence accepted! The result logically follows the imagined ability.","incorrectFeedback":"This is an imaginary situation: connect it to a relevant result expressed with would + base verb."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If I had super speed, I would...","options":["am arriving at the rescue location now.","arrive at the rescue location quickly.","arrived at the rescue location yesterday."],"explanation":"Super speed logically supports arriving quickly, and arrive is the base verb after would."}'::jsonb, '"arrive at the rescue location quickly."'::jsonb, 1, 'u6-m24-result-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Aqua controlled water, she would...","options":["is helping families now.","helped families yesterday.","help families during floods."],"explanation":"Water control logically helps during floods; would help expresses the imaginary result."}'::jsonb, '"help families during floods."'::jsonb, 2, 'u6-m24-result-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Shadow were invisible, he would...","options":["entered the building yesterday.","enter the building without being noticed.","enters the building every day."],"explanation":"Invisibility logically supports entering unseen, and would enter takes the base form."}'::jsonb, '"enter the building without being noticed."'::jsonb, 3, 'u6-m24-result-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Sky could fly, she would...","options":["reached the people yesterday.","is reaching the people now.","reach the people on the roof."],"explanation":"Flying allows access to a roof; would reach correctly gives the imagined consequence."}'::jsonb, '"reach the people on the roof."'::jsonb, 4, 'u6-m24-result-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Titan had super strength, he would...","options":["moves heavy objects every day.","move the heavy object.","moved the heavy object yesterday."],"explanation":"Super strength logically enables lifting, and would move uses the base verb."}'::jsonb, '"move the heavy object."'::jsonb, 5, 'u6-m24-result-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"If Maya could repair every machine, she would...","options":["helped the academy yesterday.","help the academy repair damaged equipment.","helps the academy every morning."],"explanation":"A greater repair ability would help with damaged equipment; would help uses the base form."}'::jsonb, '"help the academy repair damaged equipment."'::jsonb, 6, 'u6-m24-result-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Build the What-If Chain: the sentence blocks are mixed. Select the block sequence that reconstructs a complete and logical Second Conditional sentence.', 3, 'u6-m24-what-if-chain', '{"correctFeedback":"What-If chain complete! The if-clause is followed by would + base verb and the situational detail.","incorrectFeedback":"Remember the chain: IF + past form → WOULD + base verb → situation detail."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: You have super speed. Arrange [at the rescue location] [I would arrive quickly] [If I had super speed]","options":["I would arrive quickly → at the rescue location → If I had super speed.","If I had super speed → I would arrive quickly → at the rescue location.","At the rescue location → If I had super speed → I would arrive quickly."],"explanation":"The condition comes first, followed by would arrive and the rescue-location detail."}'::jsonb, '"If I had super speed → I would arrive quickly → at the rescue location."'::jsonb, 1, 'u6-m24-chain-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: Aqua controls water. Arrange [during the flood] [If Aqua controlled water] [she would protect the houses]","options":["During the flood → she would protect the houses → If Aqua controlled water.","She would protect the houses → If Aqua controlled water → during the flood.","If Aqua controlled water → she would protect the houses → during the flood."],"explanation":"The imaginary water-control condition introduces the result and its flood context."}'::jsonb, '"If Aqua controlled water → she would protect the houses → during the flood."'::jsonb, 2, 'u6-m24-chain-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: Shadow is invisible. Arrange [without being noticed] [he would enter the building] [If Shadow were invisible]","options":["He would enter the building → without being noticed → If Shadow were invisible.","If Shadow were invisible → he would enter the building → without being noticed.","Without being noticed → If Shadow were invisible → he would enter the building."],"explanation":"Use were in the if-clause, then would enter, followed by how the action occurs."}'::jsonb, '"If Shadow were invisible → he would enter the building → without being noticed."'::jsonb, 3, 'u6-m24-chain-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: Sky can fly. Arrange [on the roof] [If Sky could fly] [she would rescue the people]","options":["On the roof → she would rescue the people → If Sky could fly.","She would rescue the people → If Sky could fly → on the roof.","If Sky could fly → she would rescue the people → on the roof."],"explanation":"Could fly creates the condition, and would rescue gives the logical result."}'::jsonb, '"If Sky could fly → she would rescue the people → on the roof."'::jsonb, 4, 'u6-m24-chain-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Situation: Titan has super strength. Arrange [blocking the entrance] [he would move the heavy object] [If Titan had super strength]","options":["He would move the heavy object → blocking the entrance → If Titan had super strength.","If Titan had super strength → he would move the heavy object → blocking the entrance.","Blocking the entrance → If Titan had super strength → he would move the heavy object."],"explanation":"Had introduces the imagined strength, would move gives the action, and the final block identifies the object."}'::jsonb, '"If Titan had super strength → he would move the heavy object → blocking the entrance."'::jsonb, 5, 'u6-m24-chain-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  -- Mission 25: Power Profile Lab
  insert into public.missions(unit_id, title, description, sort_order, difficulty, xp_reward, badge_reward, location, map_x, map_y, content_key)
  values (v_unit_id, 'Power Profile Lab', 'The Superpower Research Center is preparing official hero profiles. Analyze each hero''s information and place the correct vocabulary in its meaningful category.', 25, 'challenger', 150, 'Power Specialist', 'Superpower Research Center', 82, 17, 'unit-6-mission-25')
  on conflict (content_key) do update set unit_id=excluded.unit_id, title=excluded.title, description=excluded.description, sort_order=excluded.sort_order, difficulty=excluded.difficulty, xp_reward=excluded.xp_reward, badge_reward=excluded.badge_reward, location=excluded.location, map_x=excluded.map_x, map_y=excluded.map_y
  returning id into v_mission_id;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'multiple_choice'::public.activity_type, 'Power in Context: use the complete situation to select the profile word that best completes its meaning—not merely a memorized definition.', 1, 'u6-m25-power-context', '{"correctFeedback":"Context understood! The selected word describes the role that information plays in a hero profile.","incorrectFeedback":"Read the clues around the blank and decide whether they describe what a hero can do, a strong point, a limit, a purpose, or a characteristic."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Maya can fix some broken machines. Her special _____ allows her to repair damaged technology.","options":["danger","limitation","ability","weakness"],"explanation":"An ability is something a person is able to do; Maya can repair technology."}'::jsonb, '"ability"'::jsonb, 1, 'u6-m25-context-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Titan can move extremely heavy objects. His greatest _____ is his super strength.","options":["problem","location","limitation","strength"],"explanation":"A strength is a particularly useful or powerful quality; Titan excels at heavy lifting."}'::jsonb, '"strength"'::jsonb, 2, 'u6-m25-context-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Shadow can become invisible, but he cannot move very heavy objects. Moving heavy objects is one of his _____.","options":["missions","abilities","strengths","limitations"],"explanation":"A limitation describes what an ability or hero cannot do effectively."}'::jsonb, '"limitations"'::jsonb, 3, 'u6-m25-context-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Sky can reach high places quickly because she can fly. Flying is one of her greatest _____.","options":["mistakes","dangers","strengths","problems"],"explanation":"Flying is a useful advantage that makes Sky effective in aerial rescues."}'::jsonb, '"strengths"'::jsonb, 4, 'u6-m25-context-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"Aqua protects families during floods. Her main _____ is to help people during water emergencies.","options":["location","purpose","weakness","limitation"],"explanation":"A purpose explains the goal or reason for using an ability."}'::jsonb, '"purpose"'::jsonb, 5, 'u6-m25-context-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"The hero is brave and always tries to help others. These qualities describe the hero''s _____.","options":["equipment","ability","personality","location"],"explanation":"Personality describes character qualities such as being brave, helpful, patient, or caring."}'::jsonb, '"personality"'::jsonb, 6, 'u6-m25-context-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Build the Profile: analyze each short hero situation and identify which statement belongs to the requested profile category.', 2, 'u6-m25-build-profile', '{"correctFeedback":"Profile field confirmed! You distinguished the requested category from the hero''s other information.","incorrectFeedback":"Identify whether the question asks what the hero can do, does especially well, cannot do, is like, or aims to accomplish."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"LEO: Leo can fly. He reaches high buildings quickly. He is brave and helpful. He cannot control water. He uses flying to rescue people.","prompt":"Which statement describes Leo''s LIMITATION?","options":["He rescues people.","He is brave.","He cannot control water.","He can fly."],"explanation":"Cannot control water identifies something Leo''s power does not enable him to do."}'::jsonb, '"He cannot control water."'::jsonb, 1, 'u6-m25-profile-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"AQUA: She controls water, moves large amounts of it, is responsible, helps families during floods, and is less effective in dry places. Which statement describes her PURPOSE?","options":["She controls water.","Her power is less useful in dry places.","She is responsible.","She helps families during floods."],"explanation":"Helping families during floods explains why Aqua uses her ability."}'::jsonb, '"She helps families during floods."'::jsonb, 2, 'u6-m25-profile-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"TITAN: He has super strength, moves heavy objects, is brave and determined, cannot fly, and helps during rescues. Which statement describes his STRENGTH?","options":["He helps during rescues.","He can move heavy objects.","He is determined.","He cannot fly."],"explanation":"Moving heavy objects is the powerful advantage Titan brings to a challenge."}'::jsonb, '"He can move heavy objects."'::jsonb, 3, 'u6-m25-profile-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"SHADOW: He becomes invisible, moves unseen, is quiet and careful, cannot lift very heavy objects, and investigates danger. Which statement describes his PERSONALITY?","options":["He investigates dangerous places.","He cannot move heavy objects.","He is quiet and careful.","He can become invisible."],"explanation":"Quiet and careful are character traits, so they belong under personality."}'::jsonb, '"He is quiet and careful."'::jsonb, 4, 'u6-m25-profile-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"MAYA: She repairs some machines, makes damaged devices work, is creative and intelligent, cannot repair every object, and helps the academy. Which statement describes her ABILITY?","options":["She is creative.","Her ability does not work on every object.","She can repair some machines.","She helps the academy."],"explanation":"Repairing some machines states what Maya is able to do."}'::jsonb, '"She can repair some machines."'::jsonb, 5, 'u6-m25-profile-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;

  insert into public.activities(mission_id, type, instructions, sort_order, content_key, metadata)
  values (v_mission_id, 'reading'::public.activity_type, 'Profile Check: inspect Nova''s completed profile. Decide whether each statement is filed under the CORRECT CATEGORY or the WRONG CATEGORY.', 3, 'u6-m25-profile-check', '{"correctFeedback":"Category checked! The profile information is now organized correctly.","incorrectFeedback":"Compare the statement''s meaning with the category: ability, strength, limitation, personality, or purpose.","completionMessage":"VOCABULARY REVIEW: ABILITY — what a hero can do. STRENGTH — something the hero does especially well. LIMITATION — something the ability cannot do. PERSONALITY — qualities that describe the hero''s character. PURPOSE — why the hero uses the ability."}'::jsonb)
  on conflict (content_key) do update set mission_id=excluded.mission_id, type=excluded.type, instructions=excluded.instructions, sort_order=excluded.sort_order, metadata=excluded.metadata
  returning id into v_activity_id;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"passage":"HERO: NOVA | ABILITY: She can communicate with animals. | STRENGTH: She can understand animals when they are frightened. | LIMITATION: Her ability does not work with machines. | PERSONALITY: She is patient and caring. | PURPOSE: She helps protect animals in danger.","prompt":"“Her ability does not work with machines.” Category shown: LIMITATION","options":["WRONG CATEGORY","CORRECT CATEGORY"],"explanation":"LIMITATION · The statement explains where Nova''s ability does not work."}'::jsonb, '"CORRECT CATEGORY"'::jsonb, 1, 'u6-m25-check-3')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“She is patient and caring.” Category shown: LIMITATION","options":["CORRECT CATEGORY","WRONG CATEGORY"],"explanation":"PERSONALITY · Patient and caring describe Nova''s character, not a restriction on her power."}'::jsonb, '"WRONG CATEGORY"'::jsonb, 2, 'u6-m25-check-2')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“She can communicate with animals.” Category shown: ABILITY","options":["WRONG CATEGORY","CORRECT CATEGORY"],"explanation":"ABILITY · This states what Nova can do."}'::jsonb, '"CORRECT CATEGORY"'::jsonb, 3, 'u6-m25-check-1')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“She helps protect animals in danger.” Category shown: ABILITY","options":["CORRECT CATEGORY","WRONG CATEGORY"],"explanation":"PURPOSE · Protecting animals explains why Nova uses her ability."}'::jsonb, '"WRONG CATEGORY"'::jsonb, 4, 'u6-m25-check-6')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“She helps protect animals in danger.” Category shown: PURPOSE","options":["WRONG CATEGORY","CORRECT CATEGORY"],"explanation":"PURPOSE · The statement gives the helpful goal of Nova''s actions."}'::jsonb, '"CORRECT CATEGORY"'::jsonb, 5, 'u6-m25-check-4')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
  insert into public.activity_items(activity_id, content, answer, sort_order, content_key)
  values (v_activity_id, '{"prompt":"“She can understand animals when they are frightened.” Category shown: PERSONALITY","options":["CORRECT CATEGORY","WRONG CATEGORY"],"explanation":"STRENGTH · Understanding frightened animals is a useful advantage of Nova''s ability. VOCABULARY REVIEW — ABILITY: what a hero can do. STRENGTH: what the hero does especially well. LIMITATION: what the ability cannot do. PERSONALITY: the hero''s character qualities. PURPOSE: why the hero uses the ability."}'::jsonb, '"WRONG CATEGORY"'::jsonb, 6, 'u6-m25-check-5')
  on conflict (content_key) do update set activity_id=excluded.activity_id, content=excluded.content, answer=excluded.answer, sort_order=excluded.sort_order;
end
$seed$;

-- Mission objectives are preserved separately from descriptions.
update public.missions set objective='Discover your first abilities and start your hero training journey.' where content_key='unit-6-mission-1';
update public.missions set objective='Identify superhero abilities, describe what heroes can do, and understand how powers can be used responsibly.' where content_key='unit-6-mission-2';
update public.missions set objective='Analyze hero clues, infer information, identify useful abilities, and create a short investigation report.' where content_key='unit-6-mission-3';
update public.missions set objective='Choose appropriate abilities for different situations and apply the Second Conditional in meaningful contexts.' where content_key='unit-6-mission-4';
update public.missions set objective='Understand an emergency report, identify relevant details, make inferences, and select appropriate actions based on evidence.' where content_key='unit-6-mission-5';
update public.missions set objective='Combine abilities, actions, and purposes to create a useful superhero power profile.' where content_key='unit-6-mission-6';
update public.missions set objective='Use the Second Conditional to discuss imaginary superhero situations and choose logical actions.' where content_key='unit-6-mission-7';
update public.missions set objective='Identify relevant information, make literal and inferential conclusions, and reconstruct a hero profile from textual evidence.' where content_key='unit-6-mission-8';
update public.missions set objective='Organize information about a superhero ability and create a short digital leaflet using appropriate vocabulary and clear sentences.' where content_key='unit-6-mission-9';
update public.missions set objective='Apply superhero vocabulary, interpret situations, identify language errors, and make logical decisions.' where content_key='unit-6-mission-10';
update public.missions set objective='Organize information, understand superhero vocabulary in context, identify logical sequences, and apply information to solve power-related problems.' where content_key='unit-6-mission-11';
update public.missions set objective='Predict outcomes, identify textual evidence, distinguish predictions from confirmed information, and make logical conclusions.' where content_key='unit-6-mission-12';
update public.missions set objective='Compare superhero abilities, identify strengths and limitations, and select logical strategies for different challenges.' where content_key='unit-6-mission-13';
update public.missions set objective='Make decisions about a superhero story and produce a short narrative using superhero vocabulary and the Second Conditional.' where content_key='unit-6-mission-14';
update public.missions set objective='Analyze superhero abilities, identify incorrect power assignments, recognize contextual language errors, and repair a malfunctioning training system.' where content_key='unit-6-mission-15';
update public.missions set objective='Interpret changing situations, select appropriate abilities, and adapt decisions as new information appears.' where content_key='unit-6-mission-16';
update public.missions set objective='Identify key information in short emergency messages and communicate important instructions clearly using appropriate superhero language.' where content_key='unit-6-mission-17';
update public.missions set objective='Analyze responsible use of superhero abilities, distinguish helpful and inappropriate actions, and justify decisions using situational evidence.' where content_key='unit-6-mission-18';
update public.missions set objective='Compare superhero abilities, understand their contextual functions, and select combinations of powers that solve complex problems.' where content_key='unit-6-mission-19';
update public.missions set objective='Apply superhero abilities, Second Conditional structures, contextual meaning, problem solving, and responsible decision making in an escalating boss challenge.' where content_key='unit-6-mission-20';
update public.missions set objective='Interpret superhero data cards, compare abilities, identify strengths and limitations, and draw conclusions from structured information.' where content_key='unit-6-mission-21';
update public.missions set objective='Transform superhero statements, recognize equivalent language, and apply the Second Conditional and ability expressions in meaningful contexts.' where content_key='unit-6-mission-22';
update public.missions set objective='Identify literal information, connect details across text fragments, make careful inferences, and distinguish possible explanations from confirmed facts.' where content_key='unit-6-mission-23';
update public.missions set objective='Understand and use the Second Conditional to connect imaginary superhero situations with logical possible consequences.' where content_key='unit-6-mission-24';
update public.missions set objective='Understand vocabulary related to abilities, characteristics, strengths, limitations, purposes, and hero actions through contextual profile analysis.' where content_key='unit-6-mission-25';
