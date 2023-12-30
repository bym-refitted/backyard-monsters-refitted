import { User } from "../../models/user.model";
import { ORMContext } from "../../server";
import { KoaController } from "../../utils/KoaController";

interface RequestBody {
  slotid: number;
  name: string;
  data: Record<string, {}>;
  h?: string;
}

export const saveTemplate: KoaController = async (ctx) => {
  const requestBody = ctx.request.body as RequestBody;
  const user: User = ctx.authUser;
  let save = user.save;

  delete requestBody.h;
  await ORMContext.em.populate(user, ["save"]);

  const existingSlotIndex = save.savetemplate.findIndex(
    (template) => template.slotid === requestBody.slotid
  );

  if (existingSlotIndex !== -1) {
    // Overwrite the existing layout
    save.savetemplate[existingSlotIndex] = { ...requestBody };
  } else {
    // Insert new layout if slotid doesn't exist
    save.savetemplate.push({ ...requestBody });
  }
  await ORMContext.em.persistAndFlush(save);

  ctx.status = 200;
  ctx.body = {
    error: 0,
    ...save.savetemplate
  };
};
