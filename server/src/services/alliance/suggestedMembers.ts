import { BaseType } from "../../enums/Base.js";
import { AllianceInviteStatus } from "../../enums/Alliance.js";
import { AllianceInvite } from "../../models/allianceinvite.model.js";
import type { Alliance } from "../../models/alliance.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { getLastSeen } from "../maproom/getLastSeen.js";
import { getCachedWorlds } from "../maproom/knownWorlds.js";
import { ALLIANCE_MEMBER_FIELDS, toAllianceMember, type AllianceMember } from "./allianceMember.js";

const SUGGESTED_LIMIT = 50;

/**
 * Builds the Suggested tab's candidate list for one alliance.
 *
 * Candidates are unaffiliated players on the alliance's own Map Room version, newest
 * player first. Ordering on save.savetime is what makes the list worth reading: an
 * invite only pays off if it reaches someone still playing.
 *
 * Anyone with a pending exchange already open with this alliance is left out.
 *
 * @param {Alliance} alliance - The alliance doing the recruiting.
 * @returns {Promise<AllianceMember[]>} Candidate rows, most recently active first.
 */
export const getSuggestedMembers = async (alliance: Alliance): Promise<AllianceMember[]> => {
  const worlds = await getCachedWorlds();

  const worldIds = worlds
    .filter((world) => world.map_version === alliance.map_version)
    .map((world) => world.uuid);

  if (worldIds.length === 0) return [];

  const invite = await postgres.em.find(
    AllianceInvite,
    { alliance_id: alliance.id, status: AllianceInviteStatus.PENDING },
    { fields: ["user_id"] },
  );

  const alreadyAsked = invite.map((invite) => invite.user_id);

  const candidates = await postgres.em.find(
    User,
    {
      alliance_id: null,
      userid: { $nin: alreadyAsked },
      save: { type: BaseType.MAIN, worldid: { $in: worldIds } },
    },
    {
      fields: ALLIANCE_MEMBER_FIELDS,
      orderBy: { save: { savetime: "DESC" } },
      limit: SUGGESTED_LIMIT,
    },
  );

  const lastSeen = await getLastSeen(candidates.map((user) => user.userid), BaseType.MAIN);
  const now = getCurrentDateTime();

  return candidates
    .map((user) => toAllianceMember(user, lastSeen, now))
    .filter((user) => user !== null);
};
