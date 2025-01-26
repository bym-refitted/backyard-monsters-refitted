import { MapRoom } from "../../../enums/MapRoom";
import { IncidentReport } from "../../../models/incidentreport";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { logReport } from "../../../utils/logReport";

/**
 * Validates if the target is within the attack range of the user's main base or any of their outposts.
 * Wiki: https://backyardmonsters.fandom.com/wiki/Flinger
 *
 * Invalidates an attack if:
 * 1| No attack cell is found
 * 2| No outpost save is found
 * 3| The target is out of attack range
 * 4| No outposts are owned and the main base is out of range
 *
 * @param {User} user - The user object containing the save data
 * @param {Save} save - The save object containing the user's base and outposts
 * @param {string} baseid - The baseid of the target
 * @throws {Error} - attack invalidation error
 * @returns {Promise<Save>} - The save object if the attack is valid
 */
export const validateRange = async (user: User, save: Save, baseid: string) => {
  const { homebase, outposts, flinger } = user.save;

  // Retrieve the cell under attack
  const attackCell = await ORMContext.em.findOne(WorldMapCell, {
    base_id: BigInt(baseid),
  });

  if (!attackCell) throw new Error("Attack cell not found.");

  const [cellX, cellY] = [attackCell.x, attackCell.y];
  const [homeX, homeY] = homebase.map(Number);

  // First, we determine if the main yard is within range
  const mainYardRange = getMainYardRange(flinger);
  const distanceFromMain = calculateDistance(cellX, cellY, homeX, homeY);

  if (distanceFromMain <= mainYardRange) return save;

  // Otherwise, we check if any outposts are within a 4-cell square area around the attack cell
  if (outposts.length > 0) {
    for (let dx = -4; dx <= 4; dx++) {
      for (let dy = -4; dy <= 4; dy++) {
        const neighborX = (cellX + dx + MapRoom.WIDTH) % MapRoom.WIDTH;
        const neighborY = (cellY + dy + MapRoom.HEIGHT) % MapRoom.HEIGHT;

        // Check if the outpost is owned by the user
        const outpost = outposts.find(
          ([outpostX, outpostY]) =>
            outpostX === neighborX && outpostY === neighborY
        );

        if (outpost) {
          // Retrieve the outpost's save and validate its flinger range
          const outpostSave = await ORMContext.em.findOne(Save, {
            baseid: BigInt(outpost[2]),
          });

          if (!outpostSave) throw new Error("Outpost save not found.");

          const outpostRange = getOutpostRange(outpostSave.flinger);

          if (Math.abs(dx) <= outpostRange && Math.abs(dy) <= outpostRange)
            return save;
        }
      }
    }

    throw new Error("Target is out of attack range.");
  } else {
    throw new Error("No outposts owned, and main base is out of range.");
  }
};

const calculateDistance = (
  cellX: number,
  cellY: number,
  baseX: number,
  baseY: number
) => {
  // Calculate the straight-line distances
  const deltaX = Math.abs(baseX - cellX);
  const deltaY = Math.abs(baseY - cellY);

  // Wrap-around distances (for toroidal map)
  const wrappedDeltaX = Math.min(deltaX, MapRoom.WIDTH - deltaX);
  const wrappedDeltaY = Math.min(deltaY, MapRoom.HEIGHT - deltaY);

  // Use the smaller wrapped distances to calculate true distance
  return Math.round(Math.sqrt(wrappedDeltaX ** 2 + wrappedDeltaY ** 2));
};

const getMainYardRange = (flinger: number) => {
  switch (flinger) {
    case 0:
      return 0;
    case 1:
      return 4;
    case 2:
      return 6;
    case 3:
      return 8;
    case 4:
      return 10;
    default:
      return 10;
  }
};

const getOutpostRange = (flinger: number) => {
  switch (flinger) {
    case 0:
      return 0;
    case 1:
      return 1;
    case 2:
      return 2;
    case 3:
      return 3;
    case 4:
      return 4;
    default:
      return 4;
  }
};
