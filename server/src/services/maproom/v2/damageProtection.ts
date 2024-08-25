import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { ORMContext } from "../../../server";
import { getBounds } from "./world";

// TODO: Rewrite & optimize
export const removeDamageProtection = async (
  user: User,
  homebase: Array<string>
) => {
  const fork = ORMContext.em.fork();
  await fork.populate(user, ["save"]);
  const authSave = user.save;
  const [x, y] = homebase;

  const width = 3;
  const currentX = parseInt(x);
  const currentY = parseInt(y);
  const { minX, minY, maxX, maxY } = getBounds(currentX, currentY, width);

  const wCells = await fork.find(WorldMapCell, {
    x: {
      $gte: minX,
      $lte: maxX,
    },
    y: {
      $gte: minY,
      $lte: maxY,
    },
    world_id: "1", // ToDo: implement a world table?
    uid: user.userid,
  });

  const baseids = wCells.map((cell) => cell.base_id.toString(10));

  const bases = await fork.find(Save, {
    baseid: {
      $in: baseids,
    },
  });

  bases.map((base) => {
    base.protected = 0;
    return base;
  });

  authSave.protected = 0;
  await fork.persistAndFlush(bases);
  await fork.persistAndFlush(authSave);
};
