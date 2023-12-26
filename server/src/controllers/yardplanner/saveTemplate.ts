import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";

interface Template {
  slotid: number;
  name: string;
  data: Record<string, {}>;
}

interface RequestBody {
  templates?: Template[];
  h?: string;
}

export const saveTemplate: KoaController = async (ctx) => {
  const requestBody = ctx.request.body as RequestBody;
  const user: User = ctx.authUser;
  let save = user.save;

  delete requestBody.h;
  const templates = { templates: { ...requestBody } };

  save.savetemplate = templates;
  await ORMContext.em.persistAndFlush(save);

  ctx.status = 200;
  ctx.body = {
    error: 0,
    ...save.savetemplate,
    h: "someHashValue",
  };
};
