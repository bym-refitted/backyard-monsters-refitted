import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";

export const getTemplates: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let save = user.save;

  await ORMContext.em.populate(user, ["save"]);
  const template = save.savetemplate;

  ctx.status = 200;
  ctx.body = {
    error: 0,
    ...template
  };
};
