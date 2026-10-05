import { BaseType } from "../../../enums/Base.js";
import { MapRoomCell, MapRoomVersion } from "../../../enums/MapRoom.js";
import { MigrateStatus } from "../../../enums/MigrateStatus.js";
import { Save } from "../../../database/models/save.model.js";
import { Thread } from "../../../database/models/thread.model.js";
import { User } from "../../../database/models/user.model.js";
import { World } from "../../../database/models/world.model.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { areFriends } from "../../friends/friendList.js";
import { getCurrentDateTime } from "../../../utils/getCurrentDateTime.js";
import { Operation, RESOURCE_KEYS, updateResources } from "../../base/updateResources.js";
import { loadFailureErr, notEnoughShinyErr, permissionErr, shinyLockedErr } from "../../../errors/errors.js";
import { isShinyLocked } from "../../user/shinyLock.js";
import { leaveWorld } from "./leaveWorld.js";
import { postgres } from "../../../server.js";

export type MigrateOutcome =
  | { coords: [number, number] }
  | { cantMoveTill: number; currenttime: number };

type OutpostGiver = Partial<Pick<Save, "outposts" | "buildingresources">>;

const COOLDOWN_PERIOD = 24 * 60 * 60;

const SHINY_COST = 1200;
const RESOURCE_COST = 10_000_000;

/**
 * Finds an invitation that is still open and still answerable by this player.
 *
 * @param {number} userid - The player answering.
 * @param {string} baseid - The outpost the answer is about.
 * @param {number} threadid - The thread the invitation was sent on.
 * @returns {Promise<Thread>} The thread carrying the invitation.
 * @throws {ClientSafeError} If there is no such open invitation, or it is not theirs to answer.
 */
const findOpenInvite = async (userid: number, baseid: string, threadid: number): Promise<Thread> => {
  const thread = await postgres.em.findOne(Thread, { threadid });

  if (!thread || thread.migratestate !== MigrateStatus.REQUESTED) throw permissionErr();
  if (thread.migrate_baseid !== baseid) throw permissionErr();
  if (thread.userid !== userid && thread.targetid !== userid) throw permissionErr();

  return thread;
};

/**
 * Charges the player for the move, taking whichever of the two prices they chose.
 *
 * The client sends the amount it quoted, but the constants here are what is actually
 * taken, so a client that quotes itself a discount does not get one.
 *
 * @param {User} user - The player moving.
 * @param {Save} save - Their main save.
 * @param {boolean} useShiny - Whether they chose to pay with shiny rather than resources.
 * @returns {void}
 * @throws {ClientSafeError} If they cannot afford what they chose.
 */
const chargeForMove = (user: User, save: Save, useShiny: boolean) => {
  if (!useShiny) {
    const held = save.resources ?? {};

    if (RESOURCE_KEYS.some((key) => Number(held[key] ?? 0) < RESOURCE_COST)) throw permissionErr();

    const cost = Object.fromEntries(RESOURCE_KEYS.map((key) => [key, RESOURCE_COST]));

    save.resources = updateResources(cost, { ...held }, Operation.SUBTRACT);
    return;
  }

  if (isShinyLocked(user)) throw shinyLockedErr();
  if (save.credits < SHINY_COST) throw notEnoughShinyErr();

  save.credits -= SHINY_COST;
};

/**
 * Takes an outpost out of the save that owned it, with the resources stored in it.
 *
 * @param {OutpostGiver} save - The main save losing the outpost.
 * @param {string} baseid - The outpost being given up.
 * @returns {void}
 */
const handOverOutpost = (save: OutpostGiver, baseid: string) => {
  save.outposts = (save.outposts ?? []).filter((outpost) => outpost[2] !== baseid);

  const kept = { ...(save.buildingresources ?? {}) };

  delete kept[`b${baseid}`];

  save.buildingresources = kept;
};

/**
 * Accepts a friend's invitation to move onto one of their outposts.
 *
 * Accepting means leaving an empire behind, which is what the client warns about: the
 * player gives up every outpost they hold, their bookmarks and their stored building
 * resources, and starts again with their main yard alone on the offered cell. That holds
 * whether the outpost is in their own world or another one, so leaveWorld does the
 * teardown either way and the yard is rebuilt where the outpost stood.
 *
 * The outpost itself - cell, save, and its place in the inviter's outpost list and
 * building resources - is gone.
 *
 * Everything is re-checked here rather than trusted from when the invitation was sent:
 * friendships end and outposts get taken between the offer and the answer.
 *
 * @param {User} user - The player accepting.
 * @param {string} baseid - The outpost being moved onto.
 * @param {number} threadid - The thread the invitation was sent on.
 * @param {boolean} useShiny - Whether they chose to pay with shiny rather than resources.
 * @returns {Promise<MigrateOutcome>} Their new position, or their remaining cooldown.
 * @throws {ClientSafeError} If the invitation is no longer answerable, or they cannot pay.
 */
export const acceptMigrateInvite = async (user: User, baseid: string, threadid: number, useShiny: boolean): Promise<MigrateOutcome> => {
  await postgres.em.populate(user, ["save"]);

  const save = user.save!;
  const currenttime = getCurrentDateTime();

  if (save.cantmovetill && save.cantmovetill > currenttime) {
    return { cantMoveTill: save.cantmovetill, currenttime };
  }

  const thread = await findOpenInvite(user.userid, baseid, threadid);

  const outpostCell = await postgres.em.findOne(
    WorldMapCell,
    { baseid, base_type: MapRoomCell.OUTPOST, map_version: MapRoomVersion.V2 },
    { fields: ["*", "save.baseid"] }
  );

  if (!outpostCell?.save) throw loadFailureErr();

  const inviterId = outpostCell.uid;

  if (inviterId === user.userid) throw permissionErr();

  const isFriend = await areFriends(user.userid, inviterId);
  if (!isFriend) throw permissionErr();

  const [world, inviterSave] = await Promise.all([
    postgres.em.findOne(World, { uuid: outpostCell.world.uuid }),

    postgres.em.findOne(
      Save,
      { userid: inviterId, type: BaseType.MAIN },
      { fields: ["userid", "outposts", "buildingresources"] }
    ),
  ]);

  if (!world || !inviterSave) throw loadFailureErr();

  chargeForMove(user, save, useShiny);

  const { x, y, terrainHeight } = outpostCell;

  await leaveWorld(user, save);
  await postgres.em.refresh(world);

  world.playerCount += 1;

  const homeCell = new WorldMapCell(world, x, y, terrainHeight);

  homeCell.uid = user.userid;
  homeCell.base_type = MapRoomCell.HOMECELL;
  homeCell.baseid = save.baseid;

  save.usemap = 1;
  save.worldid = world.uuid;
  save.cell = homeCell;
  save.homebase = [x.toString(), y.toString()];
  save.cantmovetill = currenttime + COOLDOWN_PERIOD;

  handOverOutpost(inviterSave, baseid);

  thread.migratestate = MigrateStatus.ACCEPTED;

  await postgres.em.transactional(async (em) => {
    em.persist([world, homeCell, save, inviterSave, thread]);
    em.remove([outpostCell.save!, outpostCell]);

    await em.flush();
  });

  return { coords: [x, y] };
};

/**
 * Turns down a friend's invitation to move onto one of their outposts.
 *
 * Closing the invitation is the whole job - the outpost stays with the inviter, who is
 * free to offer it to somebody else once this one is answered.
 *
 * @param {number} userid - The player declining.
 * @param {string} baseid - The outpost they were offered.
 * @param {number} threadid - The thread the invitation was sent on.
 * @returns {Promise<void>}
 */
export const rejectMigrateInvite = async (userid: number, baseid: string, threadid: number) => {
  const thread = await findOpenInvite(userid, baseid, threadid);

  thread.migratestate = MigrateStatus.REJECTED;

  await postgres.em.flush();
};
