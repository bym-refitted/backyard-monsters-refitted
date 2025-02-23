import z from "zod";
import { Status } from "../../enums/StatusCodes";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { BaseType } from "../../enums/Base";
import { Save } from "../../models/save.model";

const InfernoMonstersSchema = z.object({
  type: z.string(),
  imonsters: z.string().optional().transform((data) => (data ? JSON.parse(data) : {})),
});

export const infernoMonsters: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let { type, imonsters } = InfernoMonstersSchema.parse(ctx.request.body);

  let infernoSave = await ORMContext.em.findOne(Save, {
    userid: user.userid,
    type: BaseType.INFERNO,
  });

  if (type === BaseType.GET) imonsters = infernoSave.monsters;

  if (type === BaseType.SET) {
    infernoSave.monsters = imonsters;
    await ORMContext.em.persistAndFlush(infernoSave);
  }

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    imonsters,
  };
};
