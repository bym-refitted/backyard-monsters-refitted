import { AllianceMessageType, AllianceStance } from "../../enums/Alliance.js";
import { Alliance } from "../../models/alliance.model.js";
import { AllianceRelationship } from "../../models/alliancerelationship.model.js";
import { User } from "../../models/user.model.js";
import { postgres } from "../../server.js";
import { logger } from "../../utils/logger.js";
import { emitShout } from "./allianceMessages.js";

export type Relationship = Record<number, AllianceStance>;
export type RelationshipLookup = Map<number, AllianceStance>;

type StoredStance = AllianceStance.HOSTILE | AllianceStance.FRIENDLY;

/**
 * The two alliances a flag sits between - the viewer's own, and the one it is
 * about. Together they are the row's primary key, so one pair addresses exactly
 * one flag.
 */
interface AlliancePair { alliance: number; targetAlliance: number; }

/**
 * Reads an alliance's flags, keyed by the alliance they are about.
 *
 * @param {number} allianceId - The alliance whose flags to read.
 * @returns {Promise<Relationship>} Target alliance id to flag value.
 */
export const getAllianceRelationships = async (allianceId: number): Promise<Relationship> => {
  const rows = await postgres.em.find(
    AllianceRelationship,
    { alliance: allianceId },
    { fields: ["targetAlliance", "relationship"] }
  );

  const relationships: Relationship = {};

  for (const row of rows) relationships[row.targetAlliance.id] = row.relationship;

  return relationships;
};

/**
 * Reads how one alliance has set relationship flags on a list of others.
 *
 * @param {User["alliance_id"]} allianceId - The viewer's alliance, absent when unaffiliated.
 * @param {number[]} targetIds - The alliances being listed.
 * @returns {Promise<RelationshipLookup>} Flags, missing entries meaning neutral.
 */
export const findRelationships = async (
  allianceId: User["alliance_id"],
  targetIds: number[]
): Promise<RelationshipLookup> => {
  if (!allianceId || !targetIds.length) return new Map();

  const rows = await postgres.em.find(
    AllianceRelationship,
    { alliance: allianceId, targetAlliance: { $in: targetIds } },
    { fields: ["targetAlliance", "relationship"] }
  );

  return new Map(rows.map(({ targetAlliance, relationship }) => [targetAlliance.id, relationship]));
};

/**
 * Clears a flag, reporting whether one was actually there.
 *
 * @param {AlliancePair} pair - The alliances the flag sits between.
 * @returns {Promise<boolean>} True if a flag was removed.
 */
const clearStance = async (pair: AlliancePair) => await postgres.em.nativeDelete(AllianceRelationship, pair) > 0;

/**
 * Applies a flag, reporting whether it differs from what was already stored.
 *
 * @param {AlliancePair} pair - The alliances the flag sits between.
 * @param {StoredStance} relationship - The flag to apply. Never NEUTRAL, which is stored as the absence of a row.
 * @returns {Promise<boolean>} True if the stored flag changed.
 */
const applyStance = async (pair: AlliancePair, relationship: StoredStance) => {
  const existing = await postgres.em.findOne(AllianceRelationship, pair, { fields: ["relationship"] });

  if (existing?.relationship === relationship) return false;

  await postgres.em.upsert(AllianceRelationship, { ...pair, relationship, updated_at: new Date() });

  return true;
};

/**
 * Flags another alliance as Foe, Neutral or Ally on behalf of the leader's own.
 *
 * Neutral deletes the row rather than storing a zero: it is the client's default
 * and the absence of a flag, so storing it would grow the table by a row for
 * every alliance a leader ever looked at.
 *
 * @param {User} leader - The leader making the change.
 * @param {Alliance} alliance - The leader's own alliance.
 * @param {Alliance} target - The alliance being flagged.
 * @param {AllianceStance} relationship - The flag to apply.
 * @returns {Promise<boolean>} True if the flag changed, false if it already matched.
 */
export const setAllianceRelationship = async (
  leader: User,
  alliance: Alliance,
  target: Alliance,
  relationship: AllianceStance
) => {
  const pair = { alliance: alliance.id, targetAlliance: target.id };
  const isNeutral = relationship === AllianceStance.NEUTRAL;

  const changed = isNeutral ? await clearStance(pair) : await applyStance(pair, relationship);

  if (!changed) return false;

  const shout = {
    allianceId: alliance.id,
    author: leader,
    type: AllianceMessageType.RELATIONSHIP,
    body: String(relationship),
    target,
  };

  await emitShout(shout).catch((err) =>
    logger.error(`Relationship shout failed for alliance ${alliance.id}: ${err}`));

  return true;
};
