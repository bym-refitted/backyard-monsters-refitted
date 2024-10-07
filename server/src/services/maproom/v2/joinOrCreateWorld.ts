import { WorldMapCell } from "../../../models/worldmapcell.model";
import { User } from "../../../models/user.model";
import { Save } from "../../../models/save.model";
import { logging } from "../../../utils/logger";
import { World } from "../../../models/world.model";
import { MapRoom, MapRoomCell } from "../../../enums/MapRoom";
import { EntityManager } from "@mikro-orm/core";
import { ORMContext } from "../../../server";
import { findFreeCell } from "./findFreeCell";

export const joinOrCreateWorld = async (
  user: User,
  save: Save,
  em: EntityManager = ORMContext.em,
  relocate: Boolean = false
) => {
  if (relocate) throw new Error("Relocation not implemented");

  // Fetch an existing world with available space
  let world = await em.findOne(World, {
    playerCount: {
      $lte: MapRoom.MAX_PLAYERS,
    },
  });

  if (!world) {
    logging("All worlds full, creating new world");
    world = em.create(World, {});
  } else {
    logging(`World found with ${world.playerCount} players`);
  }

  if (save.worldid === world.uuid) return;

  save.usemap = 1;
  save.worldid = world.uuid;
  world.playerCount += 1;

  // Find an available cell for the user
  const { x, y, terrainHeight } = await findFreeCell(world, em);

  // Create a new home cell for the user
  const homeCell = new WorldMapCell(world, x, y, terrainHeight);

  homeCell.uid = user.userid;
  homeCell.base_type = MapRoomCell.HOMECELL;
  homeCell.base_id = parseInt(save.baseid);

  save.cell = homeCell;
  save.worldid = world.uuid;
  save.homebase = [homeCell.x.toString(), homeCell.y.toString()];

  await em.persistAndFlush([world, homeCell, save]);
};