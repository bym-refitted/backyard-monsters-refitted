import z from "zod";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { KoaController } from "../../utils/KoaController.js";
import { BaseType } from "../../enums/Base.js";
import { Save } from "../../models/save.model.js";

const InfernoMonstersSchema = z.object({
  type: z.string(),
  imonsters: z.string().optional().transform((data) => (data ? JSON.parse(data) : {})),
});

export const infernoMonsters: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let { type, imonsters } = InfernoMonstersSchema.parse(ctx.request.body);

  let infernoSave = await postgres.em.findOne(Save, {
    userid: user.userid,
    type: BaseType.INFERNO,
  });

  if (type === BaseType.GET) imonsters = infernoSave.monsters;

  if (type === BaseType.SET) {
    infernoSave.monsters = imonsters;
    await postgres.em.persistAndFlush(infernoSave);
  }

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    imonsters,
  };
};
