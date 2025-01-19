import { IncidentReport } from "../../../models/incidentreport";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { logReport } from "../../../utils/logReport";

interface OwnedOutpost {
  x: number;
  y: number;
  baseid: string;
}

/**
 * Validates if the target is within the attack range of the user's main base or any of their outposts.
 * Wiki: https://backyardmonsters.fandom.com/wiki/Flinger
 *
 * Invalidates an attack if:
 * 1| The target is not found
 * 2| The nearest outpost is not found
 * 3| The target is out of attack range
 * 4| No outpost save is found
 * 5| No outposts are owned and the main base is out of range
 *
 * @param {User} user - The user object containing the save data
 * @param {string} baseid - The baseid of the target
 * @throws {Error} - attack invalidation error
 */
export const validateRange = async (user: User, baseid: string) => {
  const { homebase, outposts, flinger } = user.save;
  const message = `${user.username} attempted to attack out of range target ${baseid}`;

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

  if (distanceFromMain <= mainYardRange) return;

  // Otherwise, we determine the nearest outpost to the target cell
  if (outposts.length > 0) {
    let nearestOutpost: OwnedOutpost | null = null;
    let nearestDistance = Infinity;

    for (const outpost of outposts) {
      const [outpostX, outpostY, baseid] = outpost;
      const distance = calculateDistance(cellX, cellY, outpostX, outpostY);

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestOutpost = { x: outpostX, y: outpostY, baseid };
      }
    }

    if (!nearestOutpost) throw new Error("Could not find the nearest outpost.");

    // Retrieve the outpost's save and validate it's range
    const outpostSave = await ORMContext.em.findOne(Save, {
      baseid: BigInt(nearestOutpost.baseid),
    });

    if (!outpostSave) throw new Error("Outpost save not found.");

    const outpostRange = getOutpostRange(outpostSave.flinger);

    if (nearestDistance > outpostRange) {
      await logReport(user, new IncidentReport(), message);
      throw new Error("Target is out of attack range.");
    }
  } else {
    await logReport(user, new IncidentReport(), message);
    throw new Error("No outposts owned, and main base is out of range.");
  }
};

const calculateDistance = (
  cellX: number,
  cellY: number,
  baseX: number,
  baseY: number
) =>
  Math.round(
    Math.sqrt(Math.pow(baseX - cellX, 2) + Math.pow(baseY - cellY, 2))
  );

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
