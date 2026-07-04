import { Status } from "../../enums/StatusCodes.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { EditAllianceSchema } from "../../schemas/AllianceSchemas.js";
import { permissionErr } from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Updates the shield image and description of the authenticated user's alliance.
 * The name is immutable and is not accepted. Only the alliance leader may edit.
 *
 * @param {Context} ctx - Koa context.
 */
export const editAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const isLeader = user.alliance_role === AllianceRole.LEADER;

  if (!user.alliance_id || !isLeader) throw permissionErr();

  const alliance = await postgres.em.findOne(Alliance, { id: user.alliance_id });

  if (!alliance) throw permissionErr();

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
      members: alliance.member_count,
      leader: alliance.leader_name,
      world_id: alliance.world_id,
    },
  };
};
