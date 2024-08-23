import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { getBounds } from "./world";
import { logging } from "../../../utils/logger";
import { World } from "../../../models/world.model";
import { MapRoom } from "../../../enums/MapRoom";

export const joinOrCreateWorld = async (
  user: User,
  save: Save,
  isMigratingWorlds: Boolean = false
): Promise<void> => {
  //   if (migrate) {
  //     const cell = await getFreeCell(homeBase.world_id, true)
  //     homeBase.x = cell.x;
  //     homeBase.y = cell.y;
  //     await fork.persistAndFlush(homeBase)
  //     save.homebase = [cell.x.toString(), cell.y.toString()]
  //     await fork.persistAndFlush(save)
  // }

  // Find if there is a world already
  let world = await ORMContext.em.findOne(World, {
    playerCount: {
      $lte: MapRoom.MAX_PLAYERS,
    },
  });

  if (!world) {
    logging("All worlds full, creating new world");
    world = ORMContext.em.create(World, {});
  } else {
    logging(`World found with ${world.playerCount} players`);
  }

  // Make sure in future that we clear the save id when you leave a world
  // or I will be leaving my sanity
  if (save.worldid === world.uuid) return;

  save.usemap = 1;
  save.worldid = world.uuid;
  world.playerCount += 1;

  ORMContext.em.persist(world);
  ORMContext.em.persist(save);

  await ORMContext.em.flush();

  // We need to put the base on the map?
  //   if (world.playerCount === 1) {
  //     // Put the base on 0,0
  //     // Edge case - what if 0,0 is water?

  //   }
  // const cell = await getFreeCell(world.uuid, true);

  const homebaseCell = new WorldMapCell(
    world,
    world.playerCount - 1,
    world.playerCount - 1,
    159
  );

  homebaseCell.uid = user.userid;
  homebaseCell.base_type = 2;
  homebaseCell.base_id = parseInt(save.baseid);
  ORMContext.em.persist(homebaseCell);

  save.cellid = homebaseCell.cell_id;
  save.worldid = world.uuid;
  save.homebase = [homebaseCell.x.toString(), homebaseCell.y.toString()];
  ORMContext.em.persist(save);
  return ORMContext.em.flush();
};

export const removeBaseProtection = async (
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
