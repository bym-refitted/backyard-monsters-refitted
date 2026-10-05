/** How many levels apart two players can be and still be made neighbours. */
export const NEIGHBOUR_LEVEL_RANGE = 7;

/**
 * How far apart in level two neighbours may drift before they stop being
 * neighbours. Wider than the range neighbours are found in, so a level up
 * either side does not cost a neighbour straight away.
 */
export const NEIGHBOUR_DROP_LEVEL_RANGE = NEIGHBOUR_LEVEL_RANGE + 3;

/** How many neighbours a refresh tops a player's map up to. */
export const NEIGHBOUR_TARGET = 40;

/** Neighbours a player may have before searches stop offering them to anyone else. */
export const NEIGHBOUR_SOFT_CAP = 60;

/** The most neighbours the client can display. */
export const MAX_CLIENT_NEIGHBOURS = 180;

/** The most friends a player is made neighbours with for being friends. */
export const MAX_FRIEND_NEIGHBOURS = 10;

/** How many recently active players one neighbour search looks through. */
export const NEIGHBOUR_SEARCH_POOL_SIZE = 150;

/** How long since a player last saved before they stop counting as active. */
export const NEIGHBOUR_INACTIVE_DAYS = 30;

/** How often a healthy map is tidied and topped up. */
export const NEIGHBOUR_REFRESH_HOURS = 24;

/** Attacks on one player in a day before the pair stop seeing each other. */
export const DAILY_ATTACK_LIMIT = 10;

/** How long a pair stay hidden from each other once the daily limit is reached. */
export const ATTACK_LIMIT_EXCLUSION_DAYS = 14;

/** How long an attack keeps a pair on each other's maps, whatever their levels. */
export const REVENGE_WINDOW_DAYS = 14;
