import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";

// TODO: [WIP] Outpost range is fucked
export const validateRange = async (user: User, baseid: string) => {
  const { homebase, outposts, flinger } = user.save;

  // Get the target cell under attack
  const targetCell = await ORMContext.em.findOne(WorldMapCell, {
    base_id: BigInt(baseid),
  });

  if (!targetCell) throw new Error("Target cell not found.");

  const [cellX, cellY] = [targetCell.x, targetCell.y];

  // First, we check if the main yard is within range
  const [homeX, homeY] = homebase.map(Number);
  const mainDistance = calculateDistance(cellX, cellY, homeX, homeY);
  const mainYardRange = getMainYardRange(flinger) + 1;

  if (mainDistance <= mainYardRange) return;

  // Otherwise, we check if any outposts are within range
  if (outposts.length > 0) {
    let closestOutpost = null;
    let closestDistance = Infinity;

    for (const outpost of outposts) {
      const [outpostX, outpostY] = outpost;
      const distance = calculateDistance(cellX, cellY, outpostX, outpostY);

      if (distance < closestDistance) {
        closestDistance = distance;
        closestOutpost = outpost;
      }
    }

    if (!closestOutpost) throw new Error("Could not find the closest outpost.");

    // Validate the closest outpost's range
    const outpostSave = await ORMContext.em.findOne(Save, {
      baseid: BigInt(closestOutpost[2]),
    });

    if (!outpostSave) throw new Error("Outpost save not found.");

    const outpostRange = getOutpostRange(outpostSave.flinger) + 1;

    if (closestDistance > outpostRange)
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
) => Math.sqrt(Math.pow(baseX - cellX, 2) + Math.pow(baseY - cellY, 2));

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
