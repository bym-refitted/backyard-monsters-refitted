/**
 * The population an alliance's rank is measured against. The Browse tab picks
 * whichever matches the filter the player is on, so the rank column always reads
 * as a standing within the list in front of them.
 * 
 * @enum {string}
 */
export enum AllianceFilter {
  GLOBAL = "global",
  WORLD = "world",
}
