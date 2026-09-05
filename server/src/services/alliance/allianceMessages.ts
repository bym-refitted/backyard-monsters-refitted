import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceMessageType } from "../../enums/AllianceMessage.js";
import { AllianceMessage } from "../../models/alliancemessage.model.js";
import type { Alliance } from "../../models/alliance.model.js";
import type { User } from "../../models/user.model.js";
import type { HistoryEntry } from "../../chat/chatProtocol.js";
import { publishAllianceShout } from "../../chat/chatShouts.js";
import { postgres } from "../../server.js";
import { composeShout } from "./shoutText.js";

interface AllianceMessageDraft {
  allianceId: number;
  targetAllianceId?: number;
  userId: number;
  body: string;
  type?: AllianceMessageType;
}

export interface ShoutDraft extends Omit<AllianceMessageDraft, "userId" | "targetAllianceId"> {
  author: User;
  type: AllianceMessageType;
  target?: Alliance | null;
  em?: EntityManagerType;
}

type EntityManagerType = EntityManager<PostgreSqlDriver>;
type AllianceFeed = Promise<HistoryEntry[]>;

const FEED_FIELDS = [
  "messageType", 
  "body", 
  "created_at", 
  "author.userid", 
  "author.username", 
  "author.pic_square",
  "targetAlliance.id",
  "targetAlliance.name",
  "targetAlliance.image"
] as const;

export const ALLIANCE_MESSAGE_LIMIT = 50;

/**
 * Drops an alliance's oldest entries once it holds more than
 * ALLIANCE_MESSAGE_LIMIT, so the feed rolls forward one message at a time.
 *
 * Private on purpose: the window is an invariant of the table, not a decision
 * each writer makes, so it runs from addAllianceMessage rather than being
 * something every caller has to remember.
 *
 * @param {number} alliance_id - The alliance to trim.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 * @returns {Promise<number>} How many entries were removed.
 */
const cutAllianceMessages = async (alliance_id: number, em: EntityManagerType = postgres.em) => {
  const findOptions = {
    fields: ["id"],
    orderBy: { id: "DESC" },
    offset: ALLIANCE_MESSAGE_LIMIT,
  } as const;

  const cutoff = await em.findOne(AllianceMessage, { alliance_id }, findOptions);

  if (!cutoff) return 0;

  return await em.nativeDelete(AllianceMessage, { alliance_id, id: { $lte: cutoff.id } });
};

/**
 * Writes one entry to an alliance's feed and returns it in the shape the chat
 * protocol sends. The author's name and picture are passed back from the caller
 * rather than re-read, since the gateway already holds both.
 *
 * Trimming happens here too, so no caller has to remember it. A failure is not
 * caught: the caller may hold an open transaction, and swallowing it there would
 * poison the transaction and silently roll back whatever prompted the write.
 *
 * @param {AllianceMessageDraft} draft - The entry to store.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 * @returns {Promise<AllianceMessage>} The stored row, carrying its id and timestamp.
 */
export const addAllianceMessage = async (draft: AllianceMessageDraft, em: EntityManagerType = postgres.em) => {
  const { allianceId, userId, body, type, targetAllianceId } = draft;

  const row = {
    alliance_id: allianceId,
    author: userId,
    targetAlliance: targetAllianceId ?? null,
    messageType: type ?? AllianceMessageType.MESSAGE,
    body,
    created_at: new Date(),
  };

  const message = em.create(AllianceMessage, row);

  em.persist(message);
  await em.flush();

  await cutAllianceMessages(allianceId, em);

  return message;
};

/**
 * Stores a shout and delivers it live to the alliance's channel.
 *
 * The sentence is built by composeShout, the same function the feed read uses,
 * so a shout reads identically whether a member received it over the socket or
 * scrolled back to it later. Emitting through anything else would leave two
 * renderings of one message free to drift apart.
 *
 * Nothing is caught here: the write may be running inside the caller's open
 * transaction, where swallowing a failure would poison it.
 *
 * @param {ShoutDraft} draft - The shout to raise.
 */
export const emitShout = async (shout: ShoutDraft) => {
  const { author, target = null, em = postgres.em, ...message } = shout;

  const draft: AllianceMessageDraft = { ...message, userId: author.userid, targetAllianceId: target?.id };

  const stored = await addAllianceMessage(draft, em);
  const shoutText = composeShout(message.type, author.username, message.body, target);

  const entry: HistoryEntry = {
    userId: author.userid,
    displayName: author.username,
    picSquare: author.pic_square ?? null,
    allianceImage: target?.image ?? null,
    body: shoutText,
    ts: stored.created_at.getTime(),
    messageType: message.type,
  };

  publishAllianceShout(message.allianceId, entry);
};

/**
 * Reads an alliance's feed, oldest to newest.
 *
 * @param {number} allianceId - The alliance whose feed to read.
 * @param {EntityManager} em - EntityManager to read through, defaulting to the request's.
 * @returns {AllianceFeed} Entries ordered oldest to newest.
 */
export const getAllianceMessages = async (allianceId: number, em: EntityManagerType = postgres.em): AllianceFeed => {
  const rows = await em.find(
    AllianceMessage,
    { alliance_id: allianceId },
    { orderBy: { id: "DESC" }, limit: ALLIANCE_MESSAGE_LIMIT, fields: FEED_FIELDS }
  );

  const entries = rows.toReversed().map(({ author, targetAlliance, messageType, body, created_at }) => {
    const { userid, username, pic_square } = author;

    const isShout = messageType !== AllianceMessageType.MESSAGE;
    const text = isShout ? composeShout(messageType, username, body, targetAlliance) : body;

    return {
      userId: userid,
      displayName: username,
      picSquare: pic_square ?? null,
      allianceImage: targetAlliance?.image ?? null,
      body: text,
      ts: created_at.getTime(),
      messageType,
    };
  });

  return entries;
};

