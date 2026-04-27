import { Save } from "../../models/save.model.js";
import { postgres } from "../../server.js";
import { AttackPermission } from "../../enums/MapRoom.js";
import { TruceStatus } from "../../enums/TruceStatus.js";
import { getCurrentDateTime } from "../../utils/getCurrentDateTime.js";
import { getLastSeen } from "./getLastSeen.js";
import { getTruces } from "./getTruces.js";
import { isAttackActive } from "../base/isAttackActive.js";
import { calculateBaseLevel } from "../base/calculateBaseLevel.js";
import type { NeighbourData } from "../../types/NeighbourData.js";
import type { BaseType } from "../../enums/Base.js";


type Base = BaseType.MAIN | BaseType.INFERNO;

/**
 * Save fields fetched when updating live neighbour data.
 * Restricted to only what this function needs.
 */
const NEIGHBOUR_SAVE_FIELDS = [
  "userid",
  "protected",
  "attackid",
  "attacks",
  "damage",
  "points",
  "basevalue",
] as const;

/**
 * Updates dynamic fields on cached neighbour data with current save state.
 * Runs on every getNeighbours call to keep attack permissions and level up to date.
 * Filters out neighbours whose saves no longer exist in the database.
 *
 * @param {NeighbourData[]} cachedNeighbours - The cached neighbour data
 * @param {Base.MAIN | Base.INFERNO} baseType - Which save type to query for live updates
 * @returns {Promise<NeighbourData[]>} - Updated neighbour data with current attack permissions
 */
export const updateNeighbourData = async (cachedNeighbours: NeighbourData[], baseType: Base, currentUserId?: number): Promise<NeighbourData[]> => {
  if (!cachedNeighbours.length) return cachedNeighbours;

  const userIds = cachedNeighbours.map((neighbour) => neighbour.userid);

  const [neighbourSaves, lastSeens, truces] = await Promise.all([
    postgres.em.find(
      Save,
      { type: baseType, userid: { $in: userIds } },
      { fields: NEIGHBOUR_SAVE_FIELDS }
    ) as unknown as Promise<Save[]>,

    getLastSeen(userIds, baseType),
    getTruces(currentUserId, userIds),
  ]);

  const saves = new Map<number, Save>();
  neighbourSaves.forEach((save) => saves.set(save.userid, save));

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

    // TODO: 
    // 1. Add AttackPermission.LEVEL_RESTRICTION if this neighbour is more than 5 levels above the attacker.
    // 2. Add AttackPermission.VENGEANCE_MODE for breaking the level restriction if a low level attacked a high level.
    // 3. Add AttackPermission.SPECIAL_PROTECTION for players who just joined the Map.
    if (isProtected) {
      neighbour.attackpermitted = AttackPermission.DAMAGE_PROTECTION;
    } else if (isUnderAttack && lastAttack) {
      neighbour.attackpermitted = AttackPermission.UNDER_ATTACK;
      neighbour.attacker = lastAttack.name;
    } else {
      neighbour.attackpermitted = AttackPermission.ATTACKABLE;
    }

    neighbour.level = calculateBaseLevel(neighbourSave.points, neighbourSave.basevalue);
    neighbour.saved = lastSeens.get(neighbour.userid) ?? 0;

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
