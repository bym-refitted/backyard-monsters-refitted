import { Save } from "../../../database/models/save.model.js";
import { User } from "../../../database/models/user.model.js";
import { postgres } from "../../../server.js";
import { AttackPermission, MapRoomVersion } from "../../../enums/MapRoom.js";
import { TruceStatus } from "../../../enums/TruceStatus.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { getLastSeen } from "../getLastSeen.js";
import { getTruces } from "../getTruces.js";
import { isAttackActive } from "../../base/isAttackActive.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import type { NeighbourData } from "../../../types/NeighbourData.js";
import { BaseType } from "../../../enums/Base.js";
import { levelPermission } from "../attackPermission.js";


type Base = BaseType.MAIN | BaseType.INFERNO;

export interface UpdateNeighbourData {
  cachedNeighbours: NeighbourData[];
  baseType: Base;
  viewerLevel: number;
  currentUserId?: number;
  friends?: Set<number>;
}

/**
 * Save fields fetched when updating live neighbour data.
 * Restricted to only what this function needs.
 */
const NEIGHBOUR_SAVE_FIELDS = [
  "userid",
  "baseid",
  "protected",
  "createtime",
  "attackid",
  "attacks",
  "damage",
  "points",
  "basevalue",
] as const;

/**
 * User fields fetched to refresh the display details cached on each neighbour.
 */
const NEIGHBOUR_USER_FIELDS = ["userid", "username", "pic_square"] as const;

/**
 * Updates dynamic fields on cached neighbour data with current save state.
 * Runs on every getNeighbours call to keep attack permissions and level up to date.
 * Filters out neighbours whose saves no longer exist in the database,
 * and any who have since upgraded off MR1.
 *
 * @param {UpdateNeighbourData} options - Update options
 * @param {NeighbourData[]} options.cachedNeighbours - The cached neighbour data
 * @param {Base.MAIN | Base.INFERNO} options.baseType - Which save type to query for live updates
 * @param {number} options.viewerLevel - The level of the player reading the list, for the level restriction
 * @param {number} [options.currentUserId] - The player reading the list, for their truces
 * @param {Set<number>} [options.friends] - Their friends, resolved once by the caller
 * @returns {Promise<NeighbourData[]>} - Updated neighbour data with current attack permissions
 */
export const updateNeighbourData = async ({
  cachedNeighbours,
  baseType,
  viewerLevel,
  currentUserId,
  friends = new Set(),
}: UpdateNeighbourData): Promise<NeighbourData[]> => {
  if (!cachedNeighbours.length) return cachedNeighbours;

  const userIds = cachedNeighbours.map((neighbour) => neighbour.userid);
  const mr1Filter = baseType === BaseType.MAIN ? { mapversion: MapRoomVersion.V1 } : {};

  const [neighbourUsers, neighbourSaves, lastSeens, truces] = await Promise.all([
    postgres.em.find(
      User,
      { userid: { $in: userIds } },
      { fields: NEIGHBOUR_USER_FIELDS }
    ),

    postgres.em.find(
      Save,
      { type: baseType, userid: { $in: userIds }, ...mr1Filter },
      { fields: NEIGHBOUR_SAVE_FIELDS }
    ),

    getLastSeen(userIds, baseType),

    getTruces(currentUserId, userIds),
  ]);

  const saves = new Map(neighbourSaves.map((save) => [save.userid, save]));
  const owners = new Map(neighbourUsers.map((owner) => [owner.userid, owner]));

  const currentTime = getCurrentDateTime();
  let needsFlush = false;

  for (const save of neighbourSaves) {
    if (save.protected > 0 && save.protected <= currentTime) {
      save.protected = 0;
      postgres.em.persist(save);
      needsFlush = true;
    }
  }

  const updatedNeighbours = cachedNeighbours.flatMap((neighbour) => {
    const neighbourSave = saves.get(neighbour.userid);

    if (!neighbourSave) return [];

    const isProtected = neighbourSave.protected > 0 && neighbourSave.protected > currentTime;
    const lastAttack = neighbourSave.attacks.at(-1);
    const isUnderAttack = isAttackActive(neighbourSave);

    if (neighbourSave.attackid !== 0 && !isUnderAttack) {
      neighbourSave.attackid = 0;
      postgres.em.persist(neighbourSave);
      needsFlush = true;
    }

    const sevenDays = 7 * 24 * 60 * 60;
    const sevenDayExpiry = neighbourSave.createtime + sevenDays;
    const specialProtection = isProtected && neighbourSave.protected === sevenDayExpiry;

    const level = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);
    const retaliations = neighbour.retaliatecount ?? 0;

    if (specialProtection) {
      neighbour.attackpermitted = AttackPermission.SPECIAL_PROTECTION;
    } else if (isProtected) {
      neighbour.attackpermitted = AttackPermission.DAMAGE_PROTECTION;
    } else if (isUnderAttack && lastAttack) {
      neighbour.attackpermitted = AttackPermission.UNDER_ATTACK;
      neighbour.attacker = lastAttack.name;
    } else {
      const levels = {
        attackerLevel: viewerLevel,
        defenderLevel: level,
        retaliations,
      };

      neighbour.attackpermitted = levelPermission(levels);
    }

    const isVengeance = neighbour.attackpermitted === AttackPermission.VENGEANCE_MODE;

    neighbour.retaliatecount = isVengeance ? retaliations : 0;

    neighbour.friend = friends.has(neighbour.userid) ? 1 : 0;
    neighbour.baseid = neighbourSave.baseid;
    neighbour.level = level;
    neighbour.saved = lastSeens.get(neighbour.userid) ?? 0;

    const owner = owners.get(neighbour.userid);

    if (owner) {
      neighbour.username = owner.username;
      neighbour.basename = owner.username;
      neighbour.ownerName = owner.username;
      neighbour.pic = owner.pic_square || "";
    }

    const truce = truces.get(neighbour.userid);

    if (!truce) return [neighbour];

    neighbour.trucestate = truce.trucestate;
    
    if (truce.expires_at) neighbour.truceexpire = truce.expires_at - currentTime;
    
    if (truce.trucestate === TruceStatus.ACCEPTED) {
      neighbour.attackpermitted = AttackPermission.TRUCE_ACTIVE;
    }

    return [neighbour];
  });

  if (needsFlush) await postgres.em.flush();

  return updatedNeighbours;
};
