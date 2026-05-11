import { z } from "zod";

import type { KoaController } from "../../../utils/KoaController.js";
import { User } from "../../../models/user.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { postgres } from "../../../server.js";
import { MapRoom2, MapRoomVersion } from "../../../enums/MapRoom.js";
import { Status } from "../../../enums/StatusCodes.js";
import { createCellData } from "../../../services/maproom/v2/createCellData.js";
import { generateNoise, getTerrainHeight } from "../../../services/maproom/v2/generateMap.js";
import { getTruces } from "../../../services/maproom/getTruces.js";
import { mapRoomDisabledErr } from "../../../errors/errors.js";
import { devConfig } from "../../../config/GameConfig.js";

const MAX_CELLS_PER_REQUEST = 20_000;

const schema = z.object({
  cellids: z.string().transform((s) => JSON.parse(s) as number[]),
});

const CELL_OWNER_FIELDS = [
  "userid",
  "username",
  "pic_square",
  "save.points",
  "save.basevalue",
] as const;

const CELL_SAVE_FIELDS = [
  "*",
  "save.basesaveid",
  "save.locked",
  "save.flinger",
  "save.protected",
  "save.resources",
  "save.damage",
  "save.destroyed",
  "save.points",
  "save.basevalue",
  "save.attackid",
  "save.attacks",
] as const;

/**
 * Bulk cell fetch for the MR2 map viewer.
 *
 * Accepts up to 20 000 1-based cell IDs (formula: y * 800 + x + 1), resolves
 * claimed cells from the DB in a single bounding-box query, and generates
 * terrain via Perlin noise for unclaimed cells.  Returns a flat celldata array
 * each element of which includes the (x, y) coordinates alongside the normal
 * cell fields so the viewer can ingest them without the old nested data[x][y]
 * structure.
 *
 * Viewer sends batches sorted from the centre of the map outward, so each
 * batch is roughly circular and the bounding box stays compact.
 */
export const getMapRoomCellsV2ForViewer: KoaController = async (ctx) => {
  if (!devConfig.maproom) throw mapRoomDisabledErr();

  const { cellids } = schema.parse(ctx.request.body);

  if (cellids.length > MAX_CELLS_PER_REQUEST) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: `Maximum ${MAX_CELLS_PER_REQUEST} cells per request.` };
    return;
  }

  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  const worldid = user.save?.worldid;

  if (!worldid || !cellids.length) {
    ctx.status = Status.OK;
    ctx.body = { celldata: [] };
    return;
  }

  // Convert 1-based cell IDs → (x, y).  id = y * WIDTH + x + 1.
  const coords = cellids.map((id) => {
    const zero = id - 1;
    return { x: zero % MapRoom2.WIDTH, y: Math.floor(zero / MapRoom2.WIDTH) };
  });

  // Bounding box for the DB query.  Because the viewer sends batches sorted
  // from centre outward each batch is approximately circular so the bounding
  // box is compact rather than spanning the whole map.
  let minX = MapRoom2.WIDTH,  maxX = 0;
  let minY = MapRoom2.HEIGHT, maxY = 0;

  for (const { x, y } of coords) {
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }

  const dbCells = await postgres.em.find(
    WorldMapCell,
    {
      world: worldid,
      map_version: MapRoomVersion.V2,
      x: { $gte: minX, $lte: maxX },
      y: { $gte: minY, $lte: maxY },
    },
    { populate: ["save"], fields: CELL_SAVE_FIELDS },
  );

  const dbByCoord = new Map(dbCells.map((c) => [`${c.x},${c.y}`, c]));
  const ownerIds  = [...new Set(dbCells.map((c) => c.uid).filter(Boolean))] as number[];

  const [ownersList, truces] = await Promise.all([
    postgres.em.find(User, { userid: { $in: ownerIds } }, {
      populate: ["save"],
      fields: CELL_OWNER_FIELDS,
    }),
    getTruces(user.userid, ownerIds),
  ]);

  ctx.state.lastSeen = new Map();
  ctx.state.truces   = truces;

  const cellOwners = new Map<number, User>(
    (ownersList as unknown as User[]).map((u) => [u.userid, u]),
  );

  const noise    = generateNoise(worldid);
  const celldata = [];

  for (const { x, y } of coords) {
    const db = dbByCoord.get(`${x},${y}`);

    let cell: WorldMapCell;
    if (db) {
      cell = db as unknown as WorldMapCell;
    } else {
      cell = new WorldMapCell(undefined, x, y, getTerrainHeight(noise, x, y));
    }

    const data = await createCellData(cell, worldid, ctx, cellOwners);
    if (data) celldata.push({ x, y, ...data });
  }

  ctx.status = Status.OK;
  ctx.body = { celldata };
};
