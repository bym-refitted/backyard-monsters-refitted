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
  "QINVITE1":  25,    // Quest Invite 1 Friend
  "QINVITE5":  45,    // Quest Invite 5 Friends
  "QINVITE10": 65,    // Quest Invite 10 Friends
};
