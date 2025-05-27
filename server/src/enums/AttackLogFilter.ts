/**
 * Enum representing the filter options for attack logs.
 * These filters can be used to specify which type of attack logs to retrieve.
 * @enum {string}
 */
export enum AttackLogFilter {
  MY_ATTACKS = "myattacks",                  // Attacks made by me
  MY_DEFENCES = "peopleattackingme",         // Attacks made against me
  BOTH = "both",                             // Both attacks and defences
}
