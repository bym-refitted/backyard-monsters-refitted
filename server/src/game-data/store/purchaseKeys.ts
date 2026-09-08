/**
 * Purchase keys are items which are not explicitly store items, but are still considered purchases.
 */
export const purchaseKeys = new Set([
  "IU",         // Instant Upgrade
  "IF",         // Instant Finish
  "IFD",        // Instant Champion Feed
  "ITR",        // Instant Train
  "IUN",        // Instant Unlock
  "IPU",        // Instant Monster Lab Ability
  "IEV",        // Instant Champion Evolution
  "IHE",        // Instant Heal
  "BRTOPUP",    // Topoff Build, Upgrade or Fortify
  "MHTOPUP",    // Topoff Monster Heal
  "HSM",        // Instant Heal Single Monster
  "BUNK",       // Monster Bunker Instant Monsters
  "KIT",        // Outpost Kit
  "QWM1",       // Quest Wild Monster 1
  "HAM",        // Heal All Monsters
]);

/**
 * Reward keys map items that grant shiny (credits) to the player, keyed by item ID with their shiny reward amount.
 */
export const rewardCredits: Record<string, number> = {
  "QFAN":      50,    // Quest Fan-Tastic
  "QINVITE1":  25,    // Quest Invite 1 Friend
  "QINVITE5":  45,    // Quest Invite 5 Friends
  "QINVITE10": 65,    // Quest Invite 10 Friends
};

/**
 * Mushroom pickups, keyed by item ID with the shiny each one grants.
 */
export const mushroomCredits: Record<string, number> = {
  "MUSHROOM1": 3,
  "MUSHROOM2": 8,
  "MUSHROOM3": 3,
};

/**
 * Whether an item adds shiny rather than costing it.
 *
 * Mushroom pickups and quest rewards are the only two categories that credit the player -
 * everything else debits. No-shiny mode uses this to let earnings through while still
 * refusing every spend.
 *
 * @param {string} item - The item identifier from the purchase
 * @returns {boolean} True if the item pays the player rather than charging them
 */
export const isShinyGain = (item: string): boolean => item in mushroomCredits || item in rewardCredits;
