import { ORMContext } from "../../../server";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { getBounds, getFreeCell } from "./world";
import { logging } from "../../../utils/logger";
import { World } from "../../../models/world.model";
import { generateFullMap } from "../../../controllers/maproom/v2/getArea";
import { Terrain } from "../../../controllers/maproom/v2/terrain/Terrain";
import { MAPROOM } from "../../../enums/MapRoom";

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
      $lte: MAPROOM.MAX_PLAYERS,
    },
  });

  if (!world) {
    logging("All worlds full, creating new world");
    world = ORMContext.em.create(World, {});
    world = await generateFullMap(world, ORMContext);
  } else {
    logging(`World found with ${world.playerCount} players`);
  }
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

  // getArea()

  const homebaseCell = await ORMContext.em.findOne(WorldMapCell, {
    terrainHeight: {
      $gte: Terrain.SAND1,
    },
    uid: 0,
    base_type: 0,
  });

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

export const deleteWorldMapBase = async (user: User) => {
  const fork = ORMContext.em.fork();
  const homeBase = await fork.findOne(WorldMapCell, {
    uid: user.userid,
  });

  if (homeBase) {
    ORMContext.em.remove(homeBase);
  }
};

export const deleteOutposts = async (user: User) => {
  const fork = ORMContext.em.fork();

  const cells = await fork.find(WorldMapCell, {
    uid: user.userid,
  });

  const outposts = await fork.find(Save, {
    saveuserid: user.userid,
    type: "outpost",
  });

  await fork.removeAndFlush(cells);
  await fork.removeAndFlush(outposts);
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
