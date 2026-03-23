import type { Loaded } from "@mikro-orm/core";
import { Save } from "../../../models/save.model.js";
import { User } from "../../../models/user.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { postgres } from "../../../server.js";
import { logReport } from "../../base/reportManager.js";
import { MapRoom2, MapRoomVersion } from "../../../enums/MapRoom.js";

type RangeOptions = { baseid?: string; attackCell?: Loaded<WorldMapCell, never> };

/**
 * Validates if the target is within the attack range of the user's base.
 * Delegates to the appropriate version-specific handler based on map version.
 *
 * @param {User} user - The user object containing the save data
 * @param {Save} save - The save object containing the user's base and outposts
 * @param {MapRoomVersion} mapversion - The map room version
 * @param {RangeOptions} options - The options object
 * @returns {Promise<Save>} - The save object if the attack is valid
 */
export const validateRange = async (user: User, save: Save, mapversion: MapRoomVersion, options: RangeOptions) => {
  switch (mapversion) {
    case MapRoomVersion.V2:
      return validateRangeV2(user, save, options);

    case MapRoomVersion.V3:
      return validateRangeV3(save);

    default:
      throw new Error(`validateRange: unhandled map version ${mapversion}`);
  }
};

/**
 * MR3 range validation.
 * Range is checked client-side before the attack request is sent.
 * TODO: Implement server-side validation for MR3 cost ranges. Right now we just return the save.
 *
 * @param {Save} save - The save being attacked
 * @returns {Save}
 */
const validateRangeV3 = (save: Save) => save;

/**
 * Validates if the target is within the attack range of the user's main base or any of their outposts.
 * Wiki: https://backyardmonsters.fandom.com/wiki/Flinger
 *
 * Invalidates an attack if:
 * 1| No attack cell is found
 * 2| No outposts are owned and the main base is out of range
 * 3| No outposts near attack cell
 * 4| No outposts are within attack range
 *
 * @param {User} user - The user object containing the save data
 * @param {Save} save - The save object containing the user's base and outposts
 * @param {RangeOptions} options - The options object
 *
 * @throws {Error} - attack invalidation error
 * @returns {Promise<Save>} - The save object if the attack is valid
 */
const validateRangeV2 = async (user: User, save: Save, options: RangeOptions) => {
  const { homebase, outposts, flinger } = user.save;
  let attackCell = options?.attackCell;

  // First, retrieve the cell under attack
  if (!attackCell && options?.baseid) {
    attackCell = await postgres.em.findOne(WorldMapCell, {
      baseid: options.baseid,
    });
  }

  if (!attackCell) throw new Error("Attack cell not found.");

  const [cellX, cellY] = [attackCell.x, attackCell.y];
  const [homeX, homeY] = homebase.map(Number);

  // Then, we determine if the main yard is within range
  const mainYardRange = getMainYardRange(flinger);
  const distanceFromMain = getDistanceFromMain(cellX, cellY, homeX, homeY);

  if (distanceFromMain <= mainYardRange) return save;

  if (outposts.length === 0)
    throw new Error("No outposts owned, and main base is out of range.");

  const userOutposts = new Map(outposts.map(([x, y, id]) => [`${x}${y}`, id]));
  const outpostsInRange: { baseid: string; dx: number; dy: number }[] = [];

  // Otherwise, we collect the baseid's of outposts within a 4-cell square area of the attack cell
  for (let dx = -4; dx <= 4; dx++) {
    for (let dy = -4; dy <= 4; dy++) {
      const neighborX = (cellX + dx + MapRoom2.WIDTH) % MapRoom2.WIDTH;
      const neighborY = (cellY + dy + MapRoom2.HEIGHT) % MapRoom2.HEIGHT;

      const outpostId = userOutposts.get(`${neighborX}${neighborY}`);
      if (outpostId) outpostsInRange.push({ baseid: outpostId, dx, dy });
    }
  }

  if (outpostsInRange.length === 0)
    throw new Error("No outposts near attack cell.");

  // Query the database for the in-range outposts
  const outpostSaves = await postgres.em.find(Save, {
    baseid: { $in: outpostsInRange.map((outpost) => outpost.baseid) },
  });

  for (const outpostSave of outpostSaves) {
    const outpostRange = getOutpostRange(outpostSave.flinger);

    for (const { dx, dy } of outpostsInRange) {
      if (Math.abs(dx) <= outpostRange && Math.abs(dy) <= outpostRange) {
        return save;
      }
    }
  }

  const message = `${user.username} attacked out of range base: ${attackCell.baseid}`;
  await logReport(user, message);

  throw new Error("No outposts are within attack range.");
};

// TODO: This is not perfect, it creates a square range instead of a diamond range.
// Using 'Manhattan distance' seems to also not be perfect,
// as it doesn't account for the diagonal distance.
const getDistanceFromMain = (
  cellX: number,
  cellY: number,
  baseX: number,
  baseY: number
) => {
  // Calculate the straight-line distances
  const deltaX = Math.abs(baseX - cellX);
  const deltaY = Math.abs(baseY - cellY);

  // Wrap-around distances (for toroidal map)
  const wrappedDeltaX = Math.min(deltaX, MapRoom2.WIDTH - deltaX);
  const wrappedDeltaY = Math.min(deltaY, MapRoom2.HEIGHT - deltaY);

  // Use the maximum wrapped distance to calculate square range distance
  return Math.max(wrappedDeltaX, wrappedDeltaY);
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
