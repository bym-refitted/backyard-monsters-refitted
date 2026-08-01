import { Save } from "../../../../models/save.model.js";
import type { Resources } from "../../../../services/base/updateResources.js";

const RESOURCE_KEYS = ["r1", "r2", "r3", "r4"] as const;

/**
 * The largest single-resource payout the client can produce from downing one building
 */
const MAX_LOOT_PER_RESOURCE = 10_000_000;

/**
 * Applies the resources looted from the defender during an attack.
 *
 * The delta is reported by the attacking client, so only losses are taken from it —
 * a positive delta would let an attacker top up the base they just hit. The client
 * also sends one on its own account: `fixNegativeResourceValues` funds the base back
 * up to zero when a save starts with a negative pool.
 *
 * The `rNmax` fields are ignored for the same reason; storage capacity is a property
 * of the defender's buildings, not of the attack.
 *
 * @param {Resources} reported - The defender's resource delta as reported by the attacker
 * @param {Save} save - The save holding the defender's pool. For an outpost this is the
 *   owner's main yard save, not the outpost itself
 */
export const defenderLootHandler = (reported: Resources, save: Save) => {
  const resources = save.resources ?? {};

  for (const key of RESOURCE_KEYS) {
    const delta = Number(reported[key]);

    if (!Number.isFinite(delta) || delta >= 0) continue;

    const loss = Math.min(-delta, MAX_LOOT_PER_RESOURCE);
    const stored = Number(resources[key]);

    resources[key] = Math.max(0, (Number.isFinite(stored) ? stored : 0) - loss);
  }

  save.resources = resources;
};
