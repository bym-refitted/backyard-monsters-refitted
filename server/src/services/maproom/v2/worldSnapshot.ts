import { createHash } from "crypto";
import { brotliCompress, constants, gzip } from "zlib";
import { promisify } from "util";

import { MapRoomCell, MapRoomVersion } from "../../../enums/MapRoom.js";
import { User } from "../../../models/user.model.js";
import { WorldMapCell } from "../../../models/worldmapcell.model.js";
import { postgres } from "../../../server.js";

/**
 * Builds and caches the MR2 occupancy snapshot served by /worldmapv2/snapshot.
 *
 * A snapshot is every cell in one world holding state a client cannot derive -
 * player main yards, their outposts, and wild monster camps that have been
 * attacked - with the owners emitted once in a sidecar and the cells as
 * positional arrays referencing them by uid. It is serialised to JSON and kept
 * alongside brotli and gzip copies and an ETag, so the controller only has to
 * pick an encoding.
 *
 * Rebuilt at most once a minute per world, so cost stays at one pair of queries
 * per world per minute however many consumers are polling.
 */

export interface WorldSnapshot {
  raw: Buffer;
  brotli: Buffer;
  gzip: Buffer;
  etag: string;
  generatedAt: number;
}

interface CachedSnapshot {
  builtAt: number;
  snapshot: Promise<WorldSnapshot>;
}

export interface SnapshotPlayer {
  name: string;
  avatar: string | null;
}

export type SnapshotCell = [
  x: number,
  y: number,
  baseType: number,
  uid: number,
  baseid: string,
  empireValue: number,
  flinger: number,
  catapult: number,
  damage: number,
  protectedUntil: number,
  destroyed: number,
];

interface CellRow {
  x: number;
  y: number;
  base_type: number;
  uid: number;
  baseid: string;
  empirevalue: number;
  flinger: number;
  catapult: number;
  damage: number;
  protected: number;
  destroyed: number;
}

interface OwnerRow {
  userid: number;
  username: string;
  pic_square: string | null;
}

const compressBrotli = promisify(brotliCompress);
const compressGzip = promisify(gzip);

const SNAPSHOT_TTL_MS = 60000;
const snapshotCache = new Map<string, CachedSnapshot>();

/**
 * Builds a world's occupancy snapshot from the database.
 *
 * Reads every player main yard, outpost and attacked wild monster cell in the
 * world, then the distinct owners of those cells, and serialises them to
 * { worldid, generatedAt, players, cells }. Wild monster cells have no owner, so
 * their uid of 0 is dropped before the owner query and gets no players entry.
 *
 * @param {string} worldid - The world to snapshot.
 * @returns {Promise<WorldSnapshot>} Serialised payload, compressed copies and an ETag.
 */
const buildSnapshot = async (worldid: string): Promise<WorldSnapshot> => {
  const rows = await postgres.em
    .createQueryBuilder(WorldMapCell, "c")
    .join("c.save", "s")
    .select([
      "c.x",
      "c.y",
      "c.base_type",
      "c.uid",
      "c.baseid",
      "s.empirevalue",
      "s.flinger",
      "s.catapult",
      "s.damage",
      "s.protected",
      "s.destroyed",
    ])
    .where({
      world: worldid,
      map_version: MapRoomVersion.V2,
      base_type: { $gte: MapRoomCell.WM },
      destroyed_at: null,
    })
    .execute<CellRow[]>("all");

  const ownerIds = [...new Set(rows.map((row) => row.uid).filter(Boolean))];

  const owners = await postgres.em
    .createQueryBuilder(User, "u")
    .select(["u.userid", "u.username", "u.pic_square"])
    .where({ userid: { $in: ownerIds } })
    .execute<OwnerRow[]>("all");

  const players: Record<number, SnapshotPlayer> = {};
  const cells: SnapshotCell[] = [];

  for (const owner of owners) {
    players[owner.userid] = { name: owner.username, avatar: owner.pic_square };
  }

  for (const row of rows) {
    cells.push([
      row.x,
      row.y,
      row.base_type,
      row.uid,
      row.baseid,
      row.empirevalue,
      row.flinger,
      row.catapult,
      row.damage,
      row.protected,
      row.destroyed,
    ]);
  }

  const generatedAt = Math.floor(Date.now() / 1000);
  const raw = Buffer.from(JSON.stringify({ worldid, generatedAt, players, cells }));

  const [brotli, gzip] = await Promise.all([
    compressBrotli(raw, { params: { [constants.BROTLI_PARAM_QUALITY]: 5 } }),
    compressGzip(raw, { level: 6 }),
  ]);

  const etag = `"snapshot-${createHash("sha1").update(raw).digest("hex").slice(0, 16)}"`;

  return { raw, brotli, gzip, etag, generatedAt };
};

/**
 * Returns a world's snapshot, rebuilding it if the cached one has expired.
 *
 * @param {string} worldid - The world to fetch a snapshot for.
 * @returns {Promise<WorldSnapshot>} The cached or freshly built snapshot.
 */
export const getWorldSnapshot = (worldid: string): Promise<WorldSnapshot> => {
  const cached = snapshotCache.get(worldid);

  if (cached && Date.now() - cached.builtAt < SNAPSHOT_TTL_MS) return cached.snapshot;

  const fresh: CachedSnapshot = { builtAt: Date.now(), snapshot: buildSnapshot(worldid) };

  fresh.snapshot.catch(() => snapshotCache.delete(worldid));
  snapshotCache.set(worldid, fresh);

  return fresh.snapshot;
};
