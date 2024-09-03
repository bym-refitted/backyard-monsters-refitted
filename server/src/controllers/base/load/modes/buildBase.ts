import { Context } from "vm";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

// TODO: Rewrite
export const buildBase = async (
  ctx: Context,
  baseid: string
): Promise<Save> => {
  const fork = ORMContext.em.fork();
  const user: User = ctx.authUser;
  await fork.populate(user, ["save"]);
  const authSave: Save = user.save;
  let save = authSave;

  if (baseid !== "0" && baseid !== authSave.baseid) {
    save = await fork.findOne(Save, {
      baseid: baseid,
    });

    if (save) {
      if (save.saveuserid === user.userid) {
        save.credits = authSave.credits;
        save.resources = authSave.resources;
        save.outposts = authSave.outposts;
        save.buildingresources = authSave.buildingresources;
        save.points = authSave.points;
        save.basevalue = authSave.basevalue;
        save.lockerdata = authSave.lockerdata;
        save.academy = authSave.academy;
        save.researchdata = authSave.researchdata;
        save.quests = authSave.quests;
        save.rewards = authSave.rewards;
        save.id = authSave.id;
        save.savetime = authSave.savetime;
      }
    }
  }

  return save;
};
