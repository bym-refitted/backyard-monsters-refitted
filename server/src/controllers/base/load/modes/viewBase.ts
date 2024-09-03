import { Context } from "vm";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { getWildMonsterSave } from "../../../../services/maproom/v2/wildMonsters";
import { logging } from "../../../../utils/logger";

// TODO: Rewrite
export const viewBase = async (
  ctx: Context,
  baseid: string
): Promise<Save> => {
  const fork = ORMContext.em.fork();
  const user: User = ctx.authUser;
  await fork.populate(user, ["save"]);

  let save = await fork.findOne(Save, {
    baseid: baseid,
  });

  if (save && save.wmid !== 0) {
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const diff = currentTimestamp - save.savetime;
    if (diff > 3600) {
      await ORMContext.em.removeAndFlush(save);
    }
  }

  if (!save) {
    logging("Loading wild monster default base");
    save = getWildMonsterSave(parseInt(baseid), user.save.worldid);
  }

  return save;
};
