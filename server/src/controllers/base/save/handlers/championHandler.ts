import { Save } from "../../../../models/save.model.js";
import type { ChampionData } from "../../../../schemas/ChampionSchema.js";

/**
 * Persists champion damage dealt to the defender during an attack.
 *
 * hp is the only thing an attack can legitimately change, so it's the only
 * field taken from the client, and only when it's lower than the stored value.
 *
 * @param {ChampionData[]} reported - The defender's champions as reported by the attacker
 * @param {Save} save - The defender's save record
 */
export const championHandler = (reported: ChampionData[], save: Save) => {
  const { champion } = save;

  const champions: ChampionData[] = champion.map((champion) => {
    const match = reported.find(({ t }) => t === champion.t);

    if (!match) return champion;

    return { ...champion, hp: Math.min(champion.hp, match.hp) };
  });

  save.champion = champions;
};
