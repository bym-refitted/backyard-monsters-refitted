import { BaseType } from "../../../enums/Base.js";
import { Save } from "../../../database/models/save.model.js";
import { postgres } from "../../../server.js";

/**
 * Reads the monster housing of a set of players' bases for /worldmapv2/players.
 *
 * Not cached: cost is bounded by the uids requested, and the data is per-tick.
 */

export const MAX_PLAYER_LOOKUP = 25;

const SECONDS_PER_DAY = 86400;

export interface PlayerBase {
  baseid: number;
  housed: Record<string, number>;
  space: number;
}

export interface Production {
  r1: number;
  r2: number;
  r3: number;
  r4: number;
}

export interface PlayerOutpost extends PlayerBase {
  finishtime: number;
  production: Production;
}

export interface PlayerBases {
  world: string | null;
  createdAt: number;
  savedate: number;
  main: PlayerBase | null;
  outposts: PlayerOutpost[];
}

interface MainRow {
  baseid: number;
  saveuserid: number;
  worldid: string | null;
  savetime: number;
  createdAt: Date | string;
  monsters: Record<string, unknown> | null;
  buildingresources: Record<string, unknown> | null;
}

interface OutpostRow {
  baseid: number;
  saveuserid: number;
  monsters: Record<string, unknown> | null;
}

interface Housing {
  housed: Record<string, number>;
  space: number;
  finishtime: number;
}

const EMPTY_HOUSING: Housing = { housed: {}, space: 0, finishtime: 0 };

const EMPTY_PRODUCTION: Production = { r1: 0, r2: 0, r3: 0, r4: 0 };

/** Harvesters produce once per 10-second cycle; the client stores output per cycle. */
const CYCLES_PER_HOUR = 360;

/**
 * Extracts housing from the save's monsters blob.
 *
 * MR1 and inferno attack saves replace the attacker's main-save monsters with a
 * bare { code: count } map (attackcreatures) that has no housed, space or
 * finishtime; that form is reported as empty.
 */
const readHousing = (monsters: MainRow["monsters"]): Housing => {
  if (!monsters || typeof monsters.housed !== "object" || monsters.housed === null) return EMPTY_HOUSING;

  return {
    housed: monsters.housed as Record<string, number>,
    space: Number(monsters.space ?? 0),
    finishtime: Number(monsters.finishtime ?? 0),
  };
};

/**
 * Reads an outpost's hourly production from the main save's buildingresources.
 *
 * The client stores each outpost's harvester output per cycle under "b<baseid>",
 * summed over harvesters with health > 0 and adjusted for altitude, as of that
 * outpost's last save. Main-yard harvesters are not recorded.
 */
const readProduction = (buildingresources: MainRow["buildingresources"], baseid: number): Production => {
  const entry = buildingresources?.[`b${baseid}`] as Partial<Production> | undefined;
  if (!entry || typeof entry !== "object") return EMPTY_PRODUCTION;

  return {
    r1: Number(entry.r1 ?? 0) * CYCLES_PER_HOUR,
    r2: Number(entry.r2 ?? 0) * CYCLES_PER_HOUR,
    r3: Number(entry.r3 ?? 0) * CYCLES_PER_HOUR,
    r4: Number(entry.r4 ?? 0) * CYCLES_PER_HOUR,
  };
};

/**
 * Loads the main and outpost saves of the given players.
 *
 * @param {number[]} uids - Player ids to look up.
 * @returns {Promise<Record<number, PlayerBases>>} Bases keyed by uid; uids with no main save are omitted.
 */
export const getPlayerBases = async (uids: number[]): Promise<Record<number, PlayerBases>> => {
  const [mains, outposts] = await Promise.all([
    postgres.em
      .createQueryBuilder(Save, "s")
      .select(["s.baseid", "s.saveuserid", "s.worldid", "s.savetime", "s.createdAt", "s.monsters", "s.buildingresources"])
      .where({ saveuserid: { $in: uids }, type: BaseType.MAIN })
      .execute<MainRow[]>("all"),
    postgres.em
      .createQueryBuilder(Save, "s")
      .select(["s.baseid", "s.saveuserid", "s.monsters"])
      .where({ saveuserid: { $in: uids }, type: BaseType.OUTPOST })
      .execute<OutpostRow[]>("all"),
  ]);

  const players: Record<number, PlayerBases> = {};
  const productionByUser: Record<number, MainRow["buildingresources"]> = {};

  for (const row of mains) {
    productionByUser[row.saveuserid] = row.buildingresources;

    const { housed, space } = readHousing(row.monsters);

    players[row.saveuserid] = {
      world: row.worldid,
      createdAt: Math.floor(new Date(row.createdAt).getTime() / 1000),
      savedate: row.savetime ? Math.floor(row.savetime / SECONDS_PER_DAY) * SECONDS_PER_DAY : 0,
      main: { baseid: row.baseid, housed, space },
      outposts: [],
    };
  }

  for (const row of outposts) {
    const player = players[row.saveuserid];
    if (!player) continue;

    const { housed, space, finishtime } = readHousing(row.monsters);
    const production = readProduction(productionByUser[row.saveuserid], row.baseid);

    player.outposts.push({ baseid: row.baseid, housed, space, finishtime, production });
  }

  return players;
};
