import { Context } from "koa";
import { User } from "../../models/user.model";
import { discordAgeErr } from "../../errors/errors";
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

export type AttackPayload = z.infer<typeof AttackSchema>;

export const validateAttack = async (
  ctx: Context,
  user: User,
  attackPayload: AttackPayload | undefined
) => {
  if (!ctx.meetsDiscordAgeCheck) throw discordAgeErr();

  if (!attackPayload) {
    // TODO: Report log here or ban, then throw error
    console.log("Possible client code change detected. Attack payload is undefined.");
  }

  const { champion } = user.save;

  // TODO:
  // 1. Validate that the data sent is correct e.g. sends correct IDs such 'C1' or 'G1'
  // 2. Validate champion with `championStats.ts` by getting level from db?
  // 3. Validate monsters with `monsterStats.ts` and counts from flinger

  console.log("Attack Payload:");
  console.dir(attackPayload, { depth: null, colors: true })};
