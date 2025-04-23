import z from "zod";

const ChampionSchema = z.object({
  type: z.string(),
  stats: z.record(z.any()),
});

const MonsterSchema = z.object({
  id: z.string(),
  count: z.number(),
  stats: z.record(z.any()),
});

const AttackSchema = z.object({
  champions: z.array(ChampionSchema).optional(),
  monsters: z.array(MonsterSchema).optional(),
});

export type AttackData = z.infer<typeof AttackSchema> | undefined;
