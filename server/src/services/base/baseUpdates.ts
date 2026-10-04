import { BaseUpdate } from "../../database/models/baseupdate.model.js";
import { postgres } from "../../server.js";
import { registerHelp } from "./registerHelp.js";
import type { User } from "../../database/models/user.model.js";

const HELP_OPCODE = "BH";

export type BaseUpdateEvent = [timestamp: number, opcode: string, ...args: unknown[]];

export interface BaseUpdateEntry {
  id: number;
  fbid: number;
  name: string;
  data: string;
}

const DELIVERY_FIELDS = ["id", "data", "sender.userid", "sender.username"] as const;

/**
 * Stores an event posted against someone else's base, for its owner to replay.
 *
 * A help is checked against the target's save first and dropped if it does not count, so
 * the same player cannot speed up one building more than once. See registerHelp.
 *
 * @param {User} sender - The player who was standing in the base.
 * @param {string} baseid - The base the event happened on.
 * @param {BaseUpdateEvent[]} events - The events as posted.
 */
export const recordBaseUpdates = async (sender: User, baseid: string, events: BaseUpdateEvent[]) => {
  for (const event of events) {
    const isHelp = event[1] === HELP_OPCODE;
    const counted = isHelp ? await registerHelp(baseid, Number(event[2]), sender.userid) : true;

    if (!counted) continue;

    const update = new BaseUpdate();

    update.baseid = baseid;
    update.sender = sender;
    update.opcode = event[1];
    update.data = [event];

    postgres.em.persist(update);
  }

  await postgres.em.flush();
};

/**
 * Hands the base's pending events to its owner, once.
 *
 * Marked delivered rather than filtered by the client's `lastupdate`, because the owner
 * also receives these on base load, where no such marker is sent. Replaying one twice
 * would apply its effect twice.
 *
 * @param {string} baseid - The owner's base.
 * @returns {Promise<BaseUpdateEntry[]>} The events, in the shape UPDATES.Process expects.
 */
export const takeBaseUpdates = async (baseid: string): Promise<BaseUpdateEntry[]> => {
  const pending = await postgres.em.find(
    BaseUpdate,
    { baseid, delivered_at: null },
    { fields: DELIVERY_FIELDS, orderBy: { id: "ASC" } }
  );

  if (pending.length === 0) return [];

  await postgres.em.nativeUpdate(
    BaseUpdate,
    { baseid, delivered_at: null, id: { $lte: pending[pending.length - 1]!.id } },
    { delivered_at: new Date() }
  );

  return pending.map((update) => ({
    id: update.id,
    fbid: update.sender.userid,
    name: update.sender.username,
    data: JSON.stringify(update.data),
  }));
};
