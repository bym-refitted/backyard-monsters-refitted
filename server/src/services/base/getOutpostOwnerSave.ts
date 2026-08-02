import { BaseType } from "../../enums/Base.js";
import { Save } from "../../models/save.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";

/**
 * Resolves the main yard save that owns an outpost.
 *
 * Outposts share their owner's main yard resource pool rather than holding one of
 * their own; the main save is the only writer, so both reads and loot writes for
 * an outpost have to be redirected here.
 *
 * @param {Save} save - The save to resolve, of any type
 * @param {User} user - The requesting user, whose own save is already populated
 * @returns {Promise<Save | null>} The owner's main save, or null if `save` is not an outpost
 */
export const getOutpostOwnerSave = async (save: Save, user: User): Promise<Save | null> => {
  if (save.type !== BaseType.OUTPOST) return null;

  if (save.saveuserid === user.userid) return user.save || null;

  return await postgres.em.findOne(Save, { saveuserid: save.saveuserid, type: BaseType.MAIN });
};
