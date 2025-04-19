import z from "zod";
import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";

const MonsterSchema = z.object({
  id: z.string(),
  count: z.number(),
  stats: z.array(z.any()),
});

const AttackSchema = z.array(MonsterSchema);

export const validateAttack: KoaController = async (ctx) => {
  const monsters = AttackSchema.parse(ctx.request.body);

  console.log("validateAttack Monsters:", monsters);
  ctx.status = Status.OK;
  ctx.body = {};
};
