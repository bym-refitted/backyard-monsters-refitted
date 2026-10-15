import { MapRoomVersion } from "../enums/MapRoom.js";

export const KRALLEN_TIME_ZONE = "UTC";

export const KRALLEN_ROUND_END_WEEKDAY = 1;

export const KRALLEN_ROUND_DAYS = 7;

export const KRALLEN_MIN_TOWN_HALL = 6;

export const KRALLEN_MAP_ROOMS = [MapRoomVersion.V2, MapRoomVersion.V3];

export const KRALLEN_AWARD_THRESHOLD = 250_000_000;

export const KRALLEN_UPGRADE_THRESHOLD = 750_000_000;

export const KRALLEN_KEPT_UPGRADE_THRESHOLD = KRALLEN_UPGRADE_THRESHOLD - KRALLEN_AWARD_THRESHOLD;

export const KRALLEN_SPECIAL2_THRESHOLD = 7_000_000_000;

export const KRALLEN_WINS_TO_KEEP = 5;

export const KRALLEN_CHAMPION_TYPE = 5;
