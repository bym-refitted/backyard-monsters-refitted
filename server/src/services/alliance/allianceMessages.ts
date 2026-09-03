import { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";

import { AllianceMessageType } from "../../enums/AllianceMessage.js";
import { AllianceMessage } from "../../models/alliancemessage.model.js";
import { postgres } from "../../server.js";

interface AllianceFeedEntry {
  userId: number | null;
  displayName: string;
  picSquare: string | null;
  body: string;
  ts: number;
}

interface AllianceMessageDraft {
  allianceId: number;
  userId: number | null;
  body: string;
  type?: AllianceMessageType;
}

type EntityManagerType = EntityManager<PostgreSqlDriver>;
type AllianceFeed = Promise<AllianceFeedEntry[]>;

const FEED_FIELDS = [
  "body", 
  "created_at", 
  "author.userid", 
  "author.username", 
  "author.pic_square"
] as const;

export const ALLIANCE_MESSAGE_LIMIT = 50;

/**
 * Writes one entry to an alliance's feed and returns it in the shape the chat
 * protocol sends. The author's name and picture are passed back from the caller
 * rather than re-read, since the gateway already holds both.
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
  return message;
};

/**
 * Reads an alliance's feed, oldest to newest, ready to render. Authors come
 * back on the same query, so the feed costs one round trip.
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

  const entries = rows.toReversed().map(({ author, body, created_at }) => ({
    userId: author?.userid ?? null,
    displayName: author?.username ?? "",
    picSquare: author?.pic_square ?? null,
    body,
    ts: created_at.getTime(),
  }));

  return entries;
};

/**
 * Drops an alliance's oldest entries once it holds more than
 * ALLIANCE_MESSAGE_LIMIT, so the feed rolls forward one message at a time.
 *
 * @param {number} alliance_id - The alliance to trim.
 * @param {EntityManager} em - EntityManager to write through, defaulting to the request's.
 * @returns {Promise<number>} How many entries were removed.
 */
export const cutAllianceMessages = async (alliance_id: number, em: EntityManagerType = postgres.em) => {
  const findOptions = {
    fields: ["id"],
    orderBy: { id: "DESC" },
    offset: ALLIANCE_MESSAGE_LIMIT,
  } as const;

  const cutoff = await em.findOne(AllianceMessage, { alliance_id }, findOptions);

  if (!cutoff) return 0;
  
  return await em.nativeDelete(AllianceMessage, { alliance_id, id: { $lte: cutoff.id } });
};
