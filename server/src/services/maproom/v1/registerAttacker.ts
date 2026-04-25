import { Maproom } from "../../../models/maproom.model.js";
import { User } from "../../../models/user.model.js";
import { postgres } from "../../../server.js";
import { calculateBaseLevel } from "../../base/calculateBaseLevel.js";
import { createNeighbourData } from "../createNeighbourData.js";

/**
 * Adds the attacker to the defender's neighbor list for retaliation purposes.
 *
 * When a player attacks another player's MR1 base, the attacker is automatically
 * added to the defender's neighbor list (if not already present). This allows the
 * defender to see who attacked them and enables potential retaliation.
 *
 * @notes the client has a maximum of 180 neighbors that can theoretically be displayed
 *
 * @param {User} attacker - The user who initiated the attack
 * @param {User} defender - The user who was attacked
 */
export const registerAttacker = async (attacker: User, defender: User) => {
  let [defenderMaproom, attackerMaproom] = await Promise.all([
    postgres.em.findOne(Maproom, { userid: defender.userid }),
    postgres.em.findOne(Maproom, { userid: attacker.userid }),
  ]);

  if (!defenderMaproom) defenderMaproom = await Maproom.setupMapRoomData(postgres.em, defender);
  if (!attackerMaproom) attackerMaproom = await Maproom.setupMapRoomData(postgres.em, attacker);

  if (!attacker.save) throw new Error("Attacker save not found.");

  const { neighbors: defenderNeighbor } = defenderMaproom;

  // Check if attacker already exists in the defender's neighbors
  const existingAttacker = defenderNeighbor.find(
    (neighbor) => neighbor.userid === attacker.userid
  );

  if (!existingAttacker) {
    const attackerLevel = calculateBaseLevel(
      attacker.save.points,
      attacker.save.basevalue
    );

    const attackerNeighbour = createNeighbourData(
      attacker.save,
      attacker,
      attackerLevel
    );

    attackerNeighbour.attacksfrom = 1;

    defenderNeighbor.unshift(attackerNeighbour);

    if (defenderNeighbor.length > 25) {
      defenderMaproom.neighbors = defenderNeighbor.slice(0, 25);
    }
  } else {
    existingAttacker.attacksfrom = (existingAttacker.attacksfrom ?? 0) + 1;
  }

  // Update attacker's neighbor list, defender should already exist from initial seeding.
  const existingDefender = attackerMaproom.neighbors.find(
    (neighbor) => neighbor.userid === defender.userid
  );

  if (existingDefender) {
    existingDefender.attacksto = (existingDefender.attacksto ?? 0) + 1;

    const todayStart = new Date().setHours(0, 0, 0, 0) / 1000;

    if (existingDefender.attacksTodayDate < todayStart) {
      existingDefender.attacksTodayCount = 0;
      existingDefender.attacksTodayDate = todayStart;
    }

    existingDefender.attacksTodayCount++;

    if (existingDefender.attacksTodayCount >= 10) {
      attackerMaproom.neighbors = attackerMaproom.neighbors.filter(
        (neighbor) => neighbor.userid !== defender.userid
      );

      defenderMaproom.neighbors = defenderMaproom.neighbors.filter(
        (neighbor) => neighbor.userid !== attacker.userid
      );
    }
  }

  postgres.em.persist(defenderMaproom);
  postgres.em.persist(attackerMaproom);
  await postgres.em.flush();
};
