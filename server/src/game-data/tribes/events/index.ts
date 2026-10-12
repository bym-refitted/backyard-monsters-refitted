import { GameEvent } from "../../../enums/GameEvent.js";
import type { SaveData } from "../../../types/EntityData.js";
import { brukkargBases, brukkargCopyBase } from "./brukkarg.js";

/**
 * The bases the player attacks during each event, in attack order.
 */
export const EVENT_BASES: Partial<Record<GameEvent, SaveData[]>> = {
  [GameEvent.BRUKKARG_WAR]: brukkargBases,
};

/**
 * The base of each event that is a copy of the player's own base, attacked last.
 */
export const EVENT_COPY_BASES: Partial<Record<GameEvent, SaveData>> = {
  [GameEvent.BRUKKARG_WAR]: brukkargCopyBase,
};

/**
 * Map of event base ID to its static template data.
 * Used to identify event bases and to construct their synthetic Save objects.
 */
export const EVENT_BASES_MAP = new Map<string, SaveData>();

/**
 * Map of event base ID to the event it belongs to.
 */
export const EVENT_BY_BASE = new Map<string, GameEvent>();

for (const event of Object.values(GameEvent)) {
  const bases = EVENT_BASES[event];
  const copyBase = EVENT_COPY_BASES[event];

  if (!bases) continue;

  const allBases = copyBase ? [...bases, copyBase] : bases;

  for (const base of allBases) {
    const baseid = String(base.baseid);

    EVENT_BASES_MAP.set(baseid, base);
    EVENT_BY_BASE.set(baseid, event);
  }
}
