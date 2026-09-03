import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceMessageType } from "../../enums/AllianceMessage.js";
import { AllianceMessage } from "../../models/alliancemessage.model.js";
import type { HistoryEntry } from "../../chat/chatProtocol.js";
import { postgres } from "../../server.js";
import { SHOUT_TEXT } from "../../config/AllianceConfig.js";

interface AllianceMessageDraft {
  allianceId: number;
  userId: number;
  body: string;
  type?: AllianceMessageType;
}

type EntityManagerType = EntityManager<PostgreSqlDriver>;
type AllianceFeed = Promise<HistoryEntry[]>;

const FEED_FIELDS = [
  "type", 
  "body", 
  "created_at", 
  "author.userid", 
  "author.username", 
  "author.pic_square"
] as const;

export const ALLIANCE_MESSAGE_LIMIT = 50;

/**
 * Builds a shout's text.
 *
 * @param {string} username - The subject of the shout.
 * @param {AllianceMessageType} type - Which shout to build.
 * @returns {string} The finished sentence, or empty if this type has no text.
 */
export const createShoutText = (username: string, type: AllianceMessageType): string => {
  const sentence = SHOUT_TEXT[type];

  if (!sentence) return "";

  return `${username} ${sentence}`;
};

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
  const { allianceId, userId, body, type } = draft;

  const row = {
    alliance_id: allianceId,
    author: userId,
    type: type ?? AllianceMessageType.MESSAGE,
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

  const entries = rows.toReversed().map(({ author, type, body, created_at }) => {
    const { userid, username, pic_square } = author;

    const isShout = type !== AllianceMessageType.MESSAGE;
    const text = isShout ? createShoutText(username, type) : body;

    return {
      userId: userid,
      displayName: username,
      picSquare: pic_square ?? null,
      body: text,
      ts: created_at.getTime(),
      type,
    };
  });

  return entries;
};

