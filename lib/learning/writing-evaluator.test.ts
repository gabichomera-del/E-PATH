import test from "node:test";
import assert from "node:assert/strict";
import { analyzeWriting } from "./writing-evaluator.ts";

test("corrects third-person singular verbs", () => {
  const result = analyzeWriting("My hero can fly and he help people.");
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "he help" && issue.suggestion.toLowerCase() === "he helps"));
});

test("corrects the if-clause in the second conditional", () => {
  const result = analyzeWriting("If I have invisibility, I would save people.", { requireSecondConditional: true });
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "if i have" && issue.suggestion === "If I had"));
});

test("corrects a third-person second conditional without suggesting has", () => {
  const result = analyzeWriting("If he have super speed, he would rescue people.", { requireSecondConditional: true });
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "if he have" && issue.suggestion === "If he had"));
  assert.ok(!result.issues.some((issue) => issue.suggestion.toLowerCase() === "he has"));
});

test("corrects common spelling mistakes", () => {
  const result = analyzeWriting("My hero has super strenght.");
  assert.ok(result.issues.some((issue) => issue.original === "strenght" && issue.suggestion === "strength"));
});

test("uses the base form after can", () => {
  const result = analyzeWriting("Titan can moves objects.");
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "can moves" && issue.suggestion.toLowerCase() === "can move"));
});

test("corrects rescue spelling in rescue plans", () => {
  const result = analyzeWriting("I would rescuse people.");
  assert.ok(result.issues.some((issue) => issue.original === "rescuse" && issue.suggestion === "rescue"));
});

test("corrects a hero-profile second conditional", () => {
  const result = analyzeWriting("If my hero has another power, she would fly.", { requireSecondConditional: true });
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "if my hero has" && issue.suggestion === "If my hero had"));
});

test("corrects creative spelling in hero leaflets", () => {
  const result = analyzeWriting("My hero is very cretive.");
  assert.ok(result.issues.some((issue) => issue.original === "cretive" && issue.suggestion === "creative"));
});

test("corrects story spelling and singular hero verbs", () => {
  const result = analyzeWriting("The storm was dengerous. My hero help the people.");
  assert.ok(result.issues.some((issue) => issue.original === "dengerous" && issue.suggestion === "dangerous"));
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "my hero help" && issue.suggestion.toLowerCase() === "my hero helps"));
});

test("uses the base form after can in hero stories", () => {
  const result = analyzeWriting("My hero can helped the people.");
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "can helped" && issue.suggestion.toLowerCase() === "can help"));
});

test("reviews functional emergency messages", () => {
  const result = analyzeWriting("The entrence is blocked. Titan need help the people. Please moves the object.");
  assert.ok(result.issues.some((issue) => issue.original === "entrence" && issue.suggestion === "entrance"));
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "titan need help" && issue.suggestion === "Titan needs to help"));
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "please moves" && issue.suggestion === "Please move"));
});

test("detects I is and suggests I am", () => {
  const result = analyzeWriting("I is brave.");
  assert.ok(!result.canComplete);
  assert.ok(result.issues.some((issue) => issue.original === "I is" && issue.suggestion === "I am"));
});

test("detects capitalization and spelling errors together", () => {
  const result = analyzeWriting("i am brve.");
  assert.ok(result.issues.some((issue) => issue.category === "capitalization" && issue.suggestion === "I"));
  assert.ok(result.issues.some((issue) => issue.category === "spelling" && issue.suggestion === "brave"));
});

test("corrects have with a third-person subject", () => {
  const result = analyzeWriting("He have a superpower.");
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "he have" && issue.suggestion.toLowerCase() === "he has"));
});

test("uses the base form after can with flies", () => {
  const result = analyzeWriting("She can flies.");
  assert.ok(result.issues.some((issue) => issue.original.toLowerCase() === "can flies" && issue.suggestion.toLowerCase() === "can fly"));
});

test("capitalizes a two-word hero name", () => {
  const result = analyzeWriting("my hero is sky guardian.");
  assert.ok(result.issues.some((issue) => issue.suggestion === "My hero is Sky Guardian"));
});

test("blocks an incorrect required second conditional", () => {
  const result = analyzeWriting("If I have more power, I would help people.", { requireSecondConditional: true });
  assert.ok(!result.canComplete);
  assert.ok(result.issues.some((issue) => issue.suggestion === "If I had"));
});

test("accepts a correct coordinated sentence", () => {
  const result = analyzeWriting("I am brave and I help people.");
  assert.equal(result.blockingIssues.length, 0);
});

test("accepts a valid alternative rescue sentence", () => {
  const result = analyzeWriting("I help people by rescuing them.");
  assert.equal(result.blockingIssues.length, 0);
});

test("reports multiple independent high-confidence errors", () => {
  const result = analyzeWriting("I is brave and i help peaple.");
  assert.ok(result.issues.some((issue) => issue.suggestion === "I am"));
  assert.ok(result.issues.some((issue) => issue.category === "capitalization" && issue.suggestion === "I"));
  assert.ok(result.issues.some((issue) => issue.category === "spelling" && issue.suggestion === "people"));
});

test("accepts a grammatically valid alternative to a model answer", () => {
  const result = analyzeWriting("I help people because I am kind.");
  assert.equal(result.blockingIssues.length, 0);
});
