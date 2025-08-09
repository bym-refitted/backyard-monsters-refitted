import { InfernoMaproom } from "../../../models/infernomaproom.model";
import { User } from "../../../models/user.model";
import { ORMContext } from "../../../server";
import { calculateBaseLevel } from "../../base/calculateBaseLevel";
import { createNeighbourData } from "./createNeighbourData";

/**
 * Adds the attacker to the defender's neighbor list for retaliation purposes.
 * 
 * When a player attacks another player's inferno base, the attacker is automatically
 * added to the defender's neighbor list (if not already present). This allows the
 * defender to see who attacked them and enables potential retaliation.
 *
 * @param {User} attacker - The user who initiated the attack
 * @param {number} userid - The userid of the player who was attacked
 */
export const addAttackerAsNeighbor = async (attacker: User, userid: number) => {
  let defender = await ORMContext.em.findOne(InfernoMaproom, { userid });

  if (!defender) throw new Error("Defender's inferno save not found.");

  const { neighbors } = defender;

  const existingNeighbor = neighbors.find(
    (neighbor) => neighbor.userid === attacker.userid
  );

  if (existingNeighbor) return;

  const attackerLevel = calculateBaseLevel(
    attacker.infernosave.points,
    attacker.infernosave.basevalue
  );

  const neighborData = createNeighbourData(
    attacker.infernosave,
    attacker,
    attackerLevel
  );

  neighbors.unshift(neighborData);

  if (neighbors.length > 25) defender.neighbors = neighbors.slice(0, 25);

  await ORMContext.em.persistAndFlush(defender);
};
