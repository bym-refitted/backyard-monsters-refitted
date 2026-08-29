import { UniqueConstraintViolationException, type RequiredEntityData } from "@mikro-orm/core";

import { Status } from "../../enums/StatusCodes.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { CreateAllianceSchema } from "../../schemas/AllianceSchemas.js";
import { addAllianceMember } from "../../services/alliance/membership.js";
import { getWorldMapVersion } from "../../services/maproom/knownWorlds.js";
import {
  allianceNameTakenErr,
  allianceNoWorldErr,
  alreadyInAllianceErr,
  unknownWorldErr,
} from "../../errors/errors.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Creates an alliance in the user's world, with them as leader. Rejects if they
 * are already in an alliance, have no world, or the name is taken.
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

  const mapVersion = await getWorldMapVersion(worldid);

  if (mapVersion === undefined) throw unknownWorldErr();

  const allianceData = {
    name: data.alliance_name,
    image: data.alliance_image,
    description: data.alliance_desc,
    leader_userid: user.userid,
    leader_name: user.username,
    world_id: worldid,
    map_version: mapVersion,
  } as unknown as RequiredEntityData<Alliance>;

  const alliance = await postgres.em.transactional(async (em) => {
      const newAlliance = em.create(Alliance, allianceData);

      em.persist(newAlliance);
      await em.flush();

      await addAllianceMember(user, newAlliance, AllianceRole.LEADER, em);

      return newAlliance;
    }).catch((error) => {
      if (error instanceof UniqueConstraintViolationException) throw allianceNameTakenErr();
      throw error;
    });

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    alliance: {
      alliance_id: alliance.id,
      name: alliance.name,
      image: alliance.image,
      description: alliance.description,
      leader: user.username,
      world_id: alliance.world_id,
    },
  };
};
