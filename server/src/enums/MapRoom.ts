/**
 * Enum representing the size and player capacity of the Map Room.
 *
 * @enum {number}
 */
export enum MapRoom {
  WIDTH = 800,
  HEIGHT = 800,
  MAX_PLAYERS = 2500,
}

/**
 * Enum representing the different types of cells in the Map Room.
 * @enum {number}
 */
export enum MapRoomCell {
  WM = 1,
  HOMECELL = 2,
  OUTPOST = 3,
}

/**
 * Enum representing the different versions of the Map Room.
 *
 * @enum {number}
 */
export enum MapRoomVersion {
  V1 = 1,
  V2 = 2,
  V3 = 3,
}

/**
 * Enum representing different types of terrain in the Map Room.
 *
 * @enum {number}
 */
export enum Terrain {
  WATER1 = 80,
  WATER2 = 90,
  WATER3 = 99,
  RESERVED = 100,
  SAND1 = 105,
  SAND2 = 110,
  LAND1 = 120,
  LAND2 = 140,
  LAND3 = 160,
  LAND4 = 170,
  ROCK = 175,
  LAND6 = 176,
}

/**
 * Attack permission codes used by the client for different protection states
 * Map Room 1 specific
 *
 * @enum {number}
 */
export enum AttackPermission {
  ATTACKABLE = 1,
  LEVEL_RESTRICTION = 3,
  VENGEANCE_MODE = 4,
  DAMAGE_PROTECTION = 5,
  SPECIAL_PROTECTION = 6,
  UNDER_ATTACK = 7,
}
