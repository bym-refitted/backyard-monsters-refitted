import { Status } from "../../../enums/StatusCodes.js";
import { BaseUpdateSchema } from "../../../schemas/BaseUpdateSchema.js";
import { postgres } from "../../../server.js";
import { recordBaseUpdates, takeBaseUpdates } from "../../../services/base/baseUpdates.js";
import type { KoaController } from "../../../utils/KoaController.js";
import type { User } from "../../../database/models/user.model.js";

/**
 * The per base activity feed. The client posts a building event here whenever one
 * happens on the base it is standing in, and reads back whatever has been left on its
 * own base while it was away.
 *
 * Only events from a visit are stored: in build mode the player is in their own base, so
 * there is nobody to tell. The `BH` opcode is the one that matters, since replaying it is
 * what pushes the helper onto the building's help list, knocks time off the owner's
 * countdown and raises the "X helped you build your Y" popup.
 *
 * @param {Context} ctx - The Koa context object.
 */
export const saveUpdate: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { baseid, help, data } = BaseUpdateSchema.parse(ctx.request.body);

  if (help && data.length > 0) await recordBaseUpdates(user, baseid, data);

  await postgres.em.populate(user, ["save"]);

  const updates = user.save ? await takeBaseUpdates(user.save.baseid) : [];

  ctx.status = Status.OK;
  ctx.body = { error: 0, updates };
};
