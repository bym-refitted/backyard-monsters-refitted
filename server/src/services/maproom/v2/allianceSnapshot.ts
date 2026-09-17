import { createHash } from "crypto";
import { brotliCompress, constants, gzip } from "zlib";
import { promisify } from "util";

import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { AllianceStance } from "../../../enums/Alliance.js";
import { Alliance } from "../../../database/models/alliance.model.js";
import { AllianceRelationship } from "../../../database/models/alliancerelationship.model.js";
import { User } from "../../../database/models/user.model.js";
import { postgres } from "../../../server.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";

/**
 * Builds and caches the MR2 alliance snapshot served by /worldmapv2/alliances.
 *
 * One payload covers every MR2 alliance across all worlds: the alliance row,
 * its member uids, and the relationship flags it has set on other alliances.
 * Kept as JSON alongside brotli and gzip copies and an ETag, rebuilt at most
 * once every five minutes.
 */

export interface AllianceSnapshot {
  raw: Buffer;
  brotli: Buffer;
  gzip: Buffer;
  etag: string;
  generatedAt: number;
}

interface CachedSnapshot {
  builtAt: number;
  snapshot: Promise<AllianceSnapshot>;
}

export interface SnapshotAlliance {
  world: string;
  name: string;
  image: number;
  description: string;
  leader: number;
  createdAt: number;
  members: number[];
  relationships: Record<number, AllianceStance>;
}

interface AllianceRow {
  id: number;
  name: string;
  image: number;
  description: string;
  leader_userid: number;
  world_id: string;
  created_at: Date | string;
}

interface MemberRow {
  userid: number;
  alliance_id: number;
}

interface RelationshipRow {
  alliance: number;
  targetAlliance: number;
  relationship: AllianceStance;
}

const compressBrotli = promisify(brotliCompress);
const compressGzip = promisify(gzip);

const SNAPSHOT_TTL_MS = 300000;

export const ALLIANCE_SNAPSHOT_MAX_AGE_SECONDS = SNAPSHOT_TTL_MS / 1000;

let snapshotCache: CachedSnapshot | undefined;

/**
 * Builds the alliance snapshot from the database.
 *
 * @returns {Promise<AllianceSnapshot>} Serialised payload, compressed copies and an ETag.
 */
const buildSnapshot = async (): Promise<AllianceSnapshot> => {
  const rows = await postgres.em
    .createQueryBuilder(Alliance, "a")
    .select([
      "a.id", 
      "a.name", 
      "a.image", 
      "a.description", 
      "a.leader_userid", 
      "a.world_id", 
      "a.created_at"
    ])
    .where({ map_version: MapRoomVersion.V2 })
    .execute<AllianceRow[]>("all");

  const allianceIds = rows.map((row) => row.id);

  const members = await postgres.em
    .createQueryBuilder(User, "u")
    .select(["u.userid", "u.alliance_id"])
    .where({ alliance_id: { $in: allianceIds } })
    .orderBy({ alliance_id: "asc", userid: "asc" })
    .execute<MemberRow[]>("all");

  const relationships = await postgres.em
    .createQueryBuilder(AllianceRelationship, "r")
    .select(["r.alliance", "r.targetAlliance", "r.relationship"])
    .where({ alliance: { $in: allianceIds } })
    .execute<RelationshipRow[]>("all");

  const alliances: Record<number, SnapshotAlliance> = {};

  for (const row of rows) {
    alliances[row.id] = {
      world: row.world_id,
      name: row.name,
      image: row.image,
      description: row.description,
      leader: row.leader_userid,
      createdAt: Math.floor(new Date(row.created_at).getTime() / 1000),
      members: [],
      relationships: {},
    };
  }

  for (const member of members) {
    alliances[member.alliance_id]?.members.push(member.userid);
  }

  for (const flag of relationships) {
    const alliance = alliances[flag.alliance];
    if (alliance) alliance.relationships[flag.targetAlliance] = flag.relationship;
  }

  const generatedAt = getCurrentDateTime();

  const content = JSON.stringify(alliances);
  const etag = `"alliances-${createHash("sha1").update(content).digest("hex").slice(0, 16)}"`;

  const raw = Buffer.from(`{"generatedAt":${generatedAt},"alliances":${content}}`);

  const [brotli, gzipped] = await Promise.all([
    compressBrotli(raw, { params: { [constants.BROTLI_PARAM_QUALITY]: 5 } }),
    compressGzip(raw, { level: 6 }),
  ]);

  return { raw, brotli, gzip: gzipped, etag, generatedAt };
};

/**
 * Returns the alliance snapshot, rebuilding it if the cached one has expired.
 *
 * @returns {Promise<AllianceSnapshot>} The cached or freshly built snapshot.
 */
export const getAllianceSnapshot = (): Promise<AllianceSnapshot> => {
  if (snapshotCache && Date.now() - snapshotCache.builtAt < SNAPSHOT_TTL_MS) return snapshotCache.snapshot;

  const fresh: CachedSnapshot = { builtAt: Date.now(), snapshot: buildSnapshot() };

  fresh.snapshot.catch(() => {
    if (snapshotCache === fresh) snapshotCache = undefined;
  });
  snapshotCache = fresh;

  return fresh.snapshot;
};
