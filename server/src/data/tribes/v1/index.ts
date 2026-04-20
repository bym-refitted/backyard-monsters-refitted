import { legionnaire } from "./legionnaire.js";
import { kozu } from "./kozu.js";
import { abunaki } from "./abunaki.js";
import { dreadnaught } from "./dreadnaught.js";
import { tutorial } from "./tutorial.js";

export { legionnaire, kozu, abunaki, dreadnaught, tutorial };

const tribes = [legionnaire, kozu, abunaki, dreadnaught];

const allTribes = tribes.flatMap((tribe) => Object.values(tribe));

/**
 * Set of all MR1 tribe base IDs across all tribes and scaling tiers.
 * Used to identify MR1 tribe saves.
 * @type {Set<string | RawQueryFragment<string> | null | undefined>}
 */
export const MR1_TRIBE_IDS = new Set([
  ...allTribes.map((tribe) => tribe.baseid),
  tutorial.baseid,
]);

/**
 * Map of MR1 tribe base ID to its static template data.
 * Used to construct synthetic Save objects for tribe load and attack-save callbacks.
 * @type {Map<string | RawQueryFragment<string> | null | undefined, SaveData>}
 */
export const MR1_TRIBES_MAP = new Map([
  ...allTribes.map((tribe) => [tribe.baseid, tribe] as const),
  [tutorial.baseid, tutorial] as const,
]);
