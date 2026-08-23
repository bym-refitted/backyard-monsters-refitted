import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { EditAllianceSchema } from "../../schemas/AllianceSchemas.js";
import { requireAllianceLeader } from "../../services/alliance/allianceAccess.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Updates the shield image and description of the authenticated user's alliance.
 * The name is immutable and is not accepted. Only the alliance leader may edit.
 *
 * @param {Context} ctx - Koa context.
 */
export const editAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const alliance = await requireAllianceLeader(user);

  const data = EditAllianceSchema.parse(ctx.request.body);

  alliance.image = data.alliance_image;
  alliance.description = data.alliance_desc;

  await postgres.em.flush();

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    alliance: {
      alliance_id: alliance.id,
      name: alliance.name,
      image: alliance.image,
      description: alliance.description,
      leader: alliance.leader_name,
      world_id: alliance.world_id,
    },
  };
};
