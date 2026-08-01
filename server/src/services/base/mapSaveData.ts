import { BaseType } from "../../enums/Base.js";
import { Save } from "../../models/save.model.js";
import { User } from "../../models/user.model.js";
import { FilterFrontendKeys } from "../../utils/FrontendKey.js";
import { getOutpostOwnerSave } from "./getOutpostOwnerSave.js";

/**
 * State that belongs to the player rather than to any one of their yards. Served from
 * the main save whenever a player looks at a base they own, so an outpost reports the
 * same credits, resources and progress as the main yard rather than a stale copy.
 *
 * @param {Save} userSave - The viewer's main yard save
 */
const mapOwnerState = (userSave: Save) => ({
  credits: userSave.credits,
  resources: userSave.resources,
  lockerdata: userSave.lockerdata,
  academy: userSave.academy,
  outposts: userSave.outposts,
  quests: userSave.quests,
  stats: userSave.stats,
  points: userSave.points,
  basevalue: userSave.basevalue,
  buildingresources: userSave.buildingresources,
  rewards: userSave.rewards,
  homebase: userSave.homebase,
});

/**
 * Resolves the outpost owner, then shapes the save for the client.
 *
 * @param {Save} save - The save being sent
 * @param {User} user - The requesting user, who may or may not own it
 * @returns {Promise<Partial<Save>>} The frontend-visible fields
 */
export const mapSaveData = async (save: Save, user: User): Promise<Partial<Save>> => {
  const ownerSave = await getOutpostOwnerSave(save, user);

  return buildSaveData(save, user, ownerSave);
};

/**
 * Shapes a save for the client.
 *
 * The single place a Save is shaped for the wire, so every rule about who sees what
 * lives here instead of being spread across the endpoints. The two branches are the
 * same rule seen from either side: player-level state lives on the main save, and an
 * outpost reports it rather than owning a copy. Owners read it off their own save,
 * everyone else reads it off the owner's.
 *
 * Call this directly only when the owner save is already in hand; otherwise use
 * mapSaveData, which resolves it first.
 *
 * @param {Save} save - The save being sent
 * @param {User} user - The requesting user, who may or may not own it
 * @param {Save | null} ownerSave - The owner's main save when `save` is an outpost, null otherwise
 * @returns {Partial<Save>} The frontend-visible fields
 */
export const buildSaveData = (save: Save, user: User, ownerSave: Save | null): Partial<Save> => {
  const filteredSave = FilterFrontendKeys(save);

  const isOwner = save.type !== BaseType.INFERNO && save.userid === user.userid;

  if (isOwner && user.save) return Object.assign(filteredSave, mapOwnerState(user.save));

  if (ownerSave) filteredSave.resources = ownerSave.resources;

  return filteredSave;
};
