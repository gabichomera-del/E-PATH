export type WritingIssueCategory = "spelling" | "grammar" | "agreement" | "verb_form" | "word_order" | "articles" | "pronouns" | "plural" | "prepositions" | "vocabulary" | "capitalization" | "punctuation" | "structure" | "target_language";
export type WritingIssue = { category: WritingIssueCategory; original: string; suggestion: string; message: string; blocking: boolean };
export type RequiredElement = { label: string; pattern: RegExp; message: string };
export type WritingRules = { minWords?: number; minSentences?: number; maxSentences?: number; requireSecondConditional?: boolean; requiredElements?: RequiredElement[] };
export type WritingAnalysis = { issues: WritingIssue[]; blockingIssues: WritingIssue[]; suggestions: WritingIssue[]; canComplete: boolean; wordCount: number; sentenceCount: number };
export type WritingSubmissionRecord = { firstSubmittedVersion: unknown; detectedErrors: WritingIssue[]; feedbackShown: string[]; finalCorrectedVersion: unknown; completionStatus: "COMPLETED" };

const spelling: Record<string, string> = { invisiblity: "invisibility", strenght: "strength", rescuse: "rescue", resque: "rescue", becaus: "because", becouse: "because", usefull: "useful", invisable: "invisible", superheroe: "superhero", peple: "people", peaple: "people", freind: "friend", watre: "water", controle: "control", brabe: "brave", brve: "brave", creativ: "creative", cretive: "creative", dengerous: "dangerous", entrence: "entrance", heroe: "hero", hability: "ability", protec: "protect" };

function preserveCase(source: string, replacement: string) {
  return source[0] === source[0]?.toUpperCase() ? replacement[0].toUpperCase() + replacement.slice(1) : replacement;
}

function titleCase(value: string) {
  return value.replace(/\b[a-z]/g, (letter) => letter.toUpperCase());
}

export function analyzeWriting(text: string, rules: WritingRules = {}): WritingAnalysis {
  const value = text.trim(); const issues: WritingIssue[] = [];
  const add = (issue: WritingIssue) => { if (!issues.some((item) => item.category === issue.category && item.original === issue.original && item.suggestion === issue.suggestion)) issues.push(issue); };
  const words = value.match(/[A-Za-z']+/g) ?? []; const sentenceParts = value.split(/[.!?]+/).map((part) => part.trim()).filter(Boolean);
  for (const word of words) { const correction = spelling[word.toLowerCase()]; if (correction) add({ category: "spelling", original: word, suggestion: correction, message: `Check the spelling: ${word} → ${correction}.`, blocking: true }); }
  const agreementRules: { pattern: RegExp; replacement: (match: RegExpMatchArray) => string; message: string }[] = [
    { pattern: /\bI\s+(is|are)\b/g, replacement: () => "I am", message: "Use 'am' with 'I'." },
    { pattern: /\b(He|She|It)\s+are\b/gi, replacement: (match) => `${preserveCase(match[1], match[1].toLowerCase())} is`, message: "Use 'is' with he, she, or it." },
    { pattern: /\b(They|We)\s+is\b/gi, replacement: (match) => `${preserveCase(match[1], match[1].toLowerCase())} are`, message: "Use 'are' with we or they." },
    { pattern: /\b(He|She|It)\s+have\b/gi, replacement: (match) => `${preserveCase(match[1], match[1].toLowerCase())} has`, message: "Use 'has' with he, she, or it." },
    { pattern: /\b(They|We)\s+has\b/gi, replacement: (match) => `${preserveCase(match[1], match[1].toLowerCase())} have`, message: "Use 'have' with we or they." },
  ];
  agreementRules.forEach((rule) => { for (const match of value.matchAll(rule.pattern)) {
    const prefix = value.slice(Math.max(0, (match.index ?? 0) - 3), match.index);
    if (/if\s$/i.test(prefix) && /\shave$/i.test(match[0])) continue;
    add({ category: "agreement", original: match[0], suggestion: rule.replacement(match), message: rule.message, blocking: true });
  } });
  for (const match of value.matchAll(/\b(my hero|he|she|it)\s+have\b/gi)) {
    const prefix = value.slice(Math.max(0, (match.index ?? 0) - 3), match.index);
    if (!/if\s$/i.test(prefix)) add({ category: "grammar", original: match[0], suggestion: `${match[1]} has`, message: "Use 'has' with he, she, it, or a singular hero.", blocking: true });
  }
  for (const match of value.matchAll(/\b(he|she|it|my hero)\s+(help|protect|save|rescue|control|use|move|create|lift|need)\b/gi)) add({ category: "agreement", original: match[0], suggestion: `${match[1]} ${match[2]}${match[2].toLowerCase()==="rescue"?"s":"s"}`, message: "Remember: he, she, it, or one hero + verb-s.", blocking: true });
  for (const match of value.matchAll(/\b(she|he|it)\s+don't\b/gi)) add({ category: "agreement", original: match[0], suggestion: `${match[1]} doesn't`, message: "Use 'doesn't' with he, she, or it.", blocking: true });
  for (const match of value.matchAll(/\bTitan\s+need\s+help\b/gi)) add({ category: "grammar", original: match[0], suggestion: "Titan needs to help", message: "Use 'needs to help' to make this instruction complete.", blocking: true });
  for (const match of value.matchAll(/\b(he|she|it)\s+fly\b/gi)) add({ category: "grammar", original: match[0], suggestion: `${match[1]} flies`, message: "Use 'flies' with he, she, or it.", blocking: true });
  const modalVerbCorrections: Record<string, string> = { flies: "fly", runs: "run", controls: "control", reads: "read", becomes: "become", helps: "help", helped: "help", moves: "move", protects: "protect", saves: "save", uses: "use", creates: "create", lifts: "lift" };
  for (const match of value.matchAll(/\b(can|can't|cannot)\s+(flies|runs|controls|reads|becomes|helps|helped|moves|protects|saves|uses|creates|lifts)\b/gi)) add({ category: "verb_form", original: match[0], suggestion: `${match[1]} ${modalVerbCorrections[match[2].toLowerCase()]}`, message: `After ${match[1]}, use the base form of the verb.`, blocking: true });
  for (const match of value.matchAll(/\bplease\s+(moves|helps|protects|saves|repairs|controls|enters)\b/gi)) add({ category: "grammar", original: match[0], suggestion: `Please ${match[1].replace(/s$/i, "")}`, message: "After 'please', use the base form of the verb.", blocking: true });
  for (const match of value.matchAll(/\bif\s+(i|he|she|it|my hero)\s+(?:have|has)\b/gi)) if (/\bwould\b/i.test(value)) add({ category: "target_language", original: match[0], suggestion: `If ${match[1]} had`, message: "Remember: If + past simple + would + base verb.", blocking: true });
  for (const match of value.matchAll(/\bwould\s+(helped|protected|saved|explored|used)\b/gi)) add({ category: "grammar", original: match[0], suggestion: `would ${match[1].replace(/ed$/i, "")}`, message: "Use the base verb after would.", blocking: true });
  for (const match of value.matchAll(/\b(Me)\s+(help|protect|save|rescue)\b/g)) add({ category: "pronouns", original: match[0], suggestion: `I ${match[2]}`, message: "Use 'I' as the subject of the sentence.", blocking: true });
  for (const match of value.matchAll(/\b(Her)\s+is\b/g)) add({ category: "pronouns", original: match[0], suggestion: "She is", message: "Use 'she' as the subject.", blocking: true });
  for (const match of value.matchAll(/\b(is|becomes)\s+(superhero|hero)\b/gi)) add({ category: "articles", original: match[0], suggestion: `${match[1]} a ${match[2]}`, message: `Use 'a' before '${match[2]}'.`, blocking: true });
  for (const match of value.matchAll(/\ba\s+(ability|invisible|important|exciting)\b/gi)) add({ category: "articles", original: match[0], suggestion: `an ${match[1]}`, message: "Use 'an' before a vowel sound.", blocking: true });
  const plurals: Record<string,string> = { hero: "heroes", person: "people", power: "powers", ability: "abilities" };
  for (const match of value.matchAll(/\b(two|three|four|five|many)\s+(hero|person|power|ability)\b/gi)) add({ category: "plural", original: match[0], suggestion: `${match[1]} ${plurals[match[2].toLowerCase()]}`, message: "Use a plural noun after a number or 'many'.", blocking: true });
  for (const match of value.matchAll(/\bgood\s+in\s+([a-z]+ing)\b/gi)) add({ category: "prepositions", original: match[0], suggestion: `good at ${match[1]}`, message: "Use 'good at' before an activity.", blocking: true });
  for (const match of value.matchAll(/\bI\s+people\s+help\s+by\s+rescuing\b/gi)) add({ category: "word_order", original: match[0], suggestion: "I help people by rescuing them", message: "Put the verb after the subject: I help people.", blocking: true });
  for (const match of value.matchAll(/\bVery\s+I\s+am\s+([a-z]+)\b/gi)) add({ category: "word_order", original: match[0], suggestion: `I am very ${match[1]}`, message: "Put 'very' before the adjective.", blocking: true });
  for (const match of value.matchAll(/\b(my hero)\s+(very|really|always)\s+([a-z]+)\b/gi)) add({ category: "structure", original: match[0], suggestion: `${match[1]} is ${match[2]} ${match[3]}`, message: "Add 'is' after 'my hero'.", blocking: true });
  for (const match of value.matchAll(/\bI\s+help\s+people\s+rescuing\s+them\b/gi)) add({ category: "structure", original: match[0], suggestion: "I help people by rescuing them", message: "Add 'by' before the action.", blocking: true });
  for (const match of value.matchAll(/\b(am|is|are|have|has|can|would)\s+\1\b/gi)) add({ category: "structure", original: match[0], suggestion: match[1], message: "Remove the repeated word.", blocking: true });
  for (const match of value.matchAll(/\bmake\s+people\s+from\s+danger\b/gi)) add({ category: "vocabulary", original: match[0], suggestion: "protect people from danger", message: "Use 'protect people from danger' for this meaning.", blocking: true });
  for (const match of value.matchAll(/\bi\b/g)) add({ category: "capitalization", original: match[0], suggestion: "I", message: "Always write the pronoun 'I' with a capital letter.", blocking: true });
  for (const match of value.matchAll(/\bmy hero is ([a-z]+\s+[a-z]+)(?=[.!?])/gi)) {
    const name = match[1]; const descriptiveWords = /\b(very|really|brave|kind|friendly|helpful|strong|creative|responsible|invisible)\b/i;
    if (!descriptiveWords.test(name) && name !== titleCase(name)) add({ category: "capitalization", original: match[0], suggestion: `My hero is ${titleCase(name)}`, message: "Start each word in the hero's name with a capital letter.", blocking: true });
  }
  for (const match of value.matchAll(/\b(I|He|She|They|We)\s+(?:am|is|are|can|help|helps|protect|protects)[^.!?]{1,40}\s+(I|He|She|They|We)\s+(?:am|is|are|can|help|helps)\b/g)) {
    const secondSubjectAt = match[0].lastIndexOf(match[2]);
    const beforeSecondSubject = match[0].slice(0, secondSubjectAt);
    if (/\b(and|because|but|so)\s*$/i.test(beforeSecondSubject)) continue;
    add({ category: "punctuation", original: match[0], suggestion: `${beforeSecondSubject.trim()}. ${match[0].slice(secondSubjectAt)}`, message: "Separate complete sentences with a period.", blocking: true });
  }
  const rawSentences = value.match(/[^.!?]+[.!?]?/g) ?? [];
  rawSentences.forEach((sentence) => { const original = sentence.trim(); if (!original) return; if (original[0] !== original[0].toUpperCase()) add({ category: "structure", original, suggestion: original[0].toUpperCase() + original.slice(1), message: "Start every sentence with a capital letter.", blocking: true }); });
  if (value && !/[.!?]$/.test(value)) add({ category: "structure", original: rawSentences.at(-1)?.trim() ?? value, suggestion: `${rawSentences.at(-1)?.trim() ?? value}.`, message: "Finish the sentence with punctuation.", blocking: true });
  if (rules.minWords && words.length < rules.minWords) add({ category: "structure", original: `${words.length} words`, suggestion: `At least ${rules.minWords} words`, message: "Add more detail before completing the activity.", blocking: true });
  if (rules.minSentences && sentenceParts.length < rules.minSentences) add({ category: "structure", original: `${sentenceParts.length} sentences`, suggestion: `${rules.minSentences}–${rules.maxSentences ?? rules.minSentences} sentences`, message: "Complete the required writing length.", blocking: true });
  if (rules.maxSentences && sentenceParts.length > rules.maxSentences) add({ category: "structure", original: `${sentenceParts.length} sentences`, suggestion: `No more than ${rules.maxSentences} sentences`, message: "Combine or remove extra sentences.", blocking: true });
  if (rules.requireSecondConditional && !/\bif\s+(?:i|he|she|it|my hero)\s+(?:had|were|could|discovered|used)\b[^.!?]*\b(?:i|he|she|it|they|my hero)\s+would\s+[a-z]+\b/i.test(value)) add({ category: "target_language", original: "Second Conditional missing", suggestion: "If the hero had..., the hero would...", message: "Include If + past simple + would + base verb.", blocking: true });
  rules.requiredElements?.forEach((requirement) => { if (!requirement.pattern.test(value)) add({ category: "target_language", original: `${requirement.label} missing`, suggestion: requirement.message, message: `Include ${requirement.label.toLowerCase()}.`, blocking: true }); });
  const blockingIssues = issues.filter((issue) => issue.blocking); return { issues, blockingIssues, suggestions: issues.filter((issue) => !issue.blocking), canComplete: blockingIssues.length === 0, wordCount: words.length, sentenceCount: sentenceParts.length };
}

export function createWritingRecord(first: unknown, issues: WritingIssue[], final: unknown): WritingSubmissionRecord { return { firstSubmittedVersion: first, detectedErrors: issues, feedbackShown: issues.map((issue) => issue.message), finalCorrectedVersion: final, completionStatus: "COMPLETED" }; }
