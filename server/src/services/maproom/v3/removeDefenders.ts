import { BaseType } from "../../../enums/Base.js";
import { EnumYardType } from "../../../enums/EnumYardType.js";
import { MapRoomVersion } from "../../../enums/MapRoom.js";
import { Save } from "../../../database/models/save.model.js";
import { WorldMapCell } from "../../../database/models/worldmapcell.model.js";
import { getDefenderCoords } from "./getDefenderCoords.js";
import type { PostgresEM } from "../../../types/PostgresEM.js";

/**
 * Deletes every fortification standing in a home cell's six defender slots.
 *
 * Those slots only hold defenders because the yard is there, so they cannot survive the
 * yard leaving. Foreign defenders captured by other players are torn down the same way,
 * which means their saves go and their owners' outpost lists are pruned to match.
 *
 * The leaving player's own defenders are deleted as cells but their saves are left alone,
 * since callers differ on what should happen to them: leaving the world discards every
 * outpost anyway, while moving inside one world deletes only these.
 *
 * @param {PostgresEM} em - The entity manager running the surrounding transaction.
 * @param {string} worldid - The world the home cell sits in.
 * @param {WorldMapCell} homeCell - The player's home cell, whose defender ring is cleared.
 * @param {number} userid - The player the home cell belongs to.
 * @returns {Promise<string[]>} The baseids of that player's own defenders, now cell-less.
 */
export const removeDefenders = async (em: PostgresEM, worldid: string, homeCell: WorldMapCell, userid: number) => {
  const defenderCoords = getDefenderCoords(homeCell.x, homeCell.y);

  const atDefenderSlots = {
    $and: [
      { $or: defenderCoords.map(([x, y]) => ({ x, y })) },
      { world: worldid },
      { map_version: MapRoomVersion.V3 },
      { base_type: EnumYardType.FORTIFICATION },
    ],
  };

  const defenders = await em.find(WorldMapCell, atDefenderSlots);

  if (defenders.length === 0) return [];

  const foreign = defenders.filter((cell) => cell.uid !== userid && cell.uid > 0);

  if (foreign.length > 0) {
    const foreignBaseids = foreign.map((cell) => cell.baseid);

    for (const ownerUid of new Set(foreign.map((cell) => cell.uid))) {
      const ownerSave = await em.findOneOrFail(Save, { userid: ownerUid, type: BaseType.MAIN });

      ownerSave.outposts = ownerSave.outposts.filter(
        (outpost) => !foreignBaseids.includes(outpost[2])
      );

      em.persist(ownerSave);
    }

    await em.nativeDelete(Save, { baseid: { $in: foreignBaseids } });
  }

  await em.nativeDelete(WorldMapCell, atDefenderSlots);

  return defenders.filter((cell) => cell.uid === userid).map((cell) => cell.baseid);
};
