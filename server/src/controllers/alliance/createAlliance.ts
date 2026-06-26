import { UniqueConstraintViolationException, type RequiredEntityData } from "@mikro-orm/core";

import { Status } from "../../enums/StatusCodes.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { CreateAllianceSchema } from "../../schemas/AllianceSchemas.js";
import {
  allianceNameTakenErr,
  allianceNoWorldErr,
  alreadyInAllianceErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Creates an alliance in the user's world, with them as leader. Rejects if they
 * are already in an alliance, have no world, or the name is taken..
 *
 * @param {Context} ctx - Koa context.
 */
export const createAlliance: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  if (user.alliance_id) throw alreadyInAllianceErr();

  const { worldid } = user.save!;

  if (!worldid) throw allianceNoWorldErr();

  const data = CreateAllianceSchema.parse(ctx.request.body);

  const newAlliance = {
    name: data.alliance_name,
    image: data.alliance_image,
    description: data.alliance_desc,
    leader_userid: user.userid,
    world_id: worldid,
    member_count: 1,
  } as unknown as RequiredEntityData<Alliance>;

  const alliance = postgres.em.create(Alliance, newAlliance);

  try {
    postgres.em.persist(alliance);
    await postgres.em.flush();
  } catch (error) {
    if (error instanceof UniqueConstraintViolationException) throw allianceNameTakenErr();
    throw error;
  }

  user.alliance_id = alliance.id;
  user.alliance_role = AllianceRole.LEADER;

  postgres.em.persist(user);
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
      leader: user.username,
      world_id: alliance.world_id,
    },
  };
};
