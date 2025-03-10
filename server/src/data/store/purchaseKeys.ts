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
  "QINVITE1",   // Quest Invite 1 Friend
  "QINVITE5",   // Quest Invite 5 Friends
  "QINVITE10",  // Quest Invite 10 Friends
  "QWM1",       // Quest Wild Monster 1
]);
