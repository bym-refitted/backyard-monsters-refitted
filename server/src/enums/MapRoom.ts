/**
 * Enum representing the size and player capacity of the Map Room.
 * 
 * @enum {number}
 */
export enum MapRoom {
  WIDTH = 800,
  HEIGHT = 800,
  MAX_PLAYERS = 85,
}

/**
 * Enum representing the different versions of the Map Room.
 * 
 * @enum {string}
 */
export enum MapRoomVersion {
  V1 = "1",
  V2 = "2",
  V3 = "3",
}

/**
 * Enum representing different types of terrain in the Map Room.
 * 
 * @enum {number}
 */
export enum Terrain {
  WATER1 = 79,
  WATER2 = 89,
  WATER3 = 99,
  SAND1 = 104,
  SAND2 = 109,
  LAND1 = 119,
  LAND2 = 139,
  LAND3 = 159,
  LAND4 = 169,
  ROCK = 174,
  LAND6 = 176,
}
