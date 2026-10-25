/**
 * The client's takeover prices (com/monsters/maproom_advanced/PopupTakeover.as): resources per type, rounded to
 * the nearest 250,000 and at least 1,000,000. A player's Outpost is priced by its empire value; a tribe yard by its
 * level alone.
 */
const ROUND_TO = 250_000;
const MINIMUM_PRICE = 1_000_000;
const OUTPOST_SLOPE = 15_820_570.7;
const OUTPOST_INTERCEPT = -227_080_916.9;
const TRIBE_SLOPE = 562_500;
const TRIBE_INTERCEPT = -14_750_000;

/**
 * The resources (of each type) the client charges to take over a tribe yard of a level, before the half price for
 * yards beside the player's own and alliance discounts.
 *
 * @param {number} level - The tribe yard's level
 * @returns {number} The price per resource type
 */
const getTribePrice = (level: number) => {
  const price = Math.round((level * TRIBE_SLOPE + TRIBE_INTERCEPT) / ROUND_TO) * ROUND_TO;

  return Math.max(price, MINIMUM_PRICE);
};

/**
 * The empire value a tribe yard is worth when taken over: the value of a player's Outpost the client would charge
 * the same price for. Kixeye priced tribe yards by level at the rate of player Outposts, so this puts tribe yards at
 * the rate of player Outposts too: from about 1.8M at the lowest levels to about 3.2M at level 44.
 *
 * @param {number} level - The tribe yard's level
 * @returns {number} The empire value to score
 */
export const getTribeTakeoverValue = (level: number) => {
  const price = getTribePrice(level);

  return Math.round(Math.exp((price - OUTPOST_INTERCEPT) / OUTPOST_SLOPE));
};
