/**
 * Represents the data for an Inferno Map Room neighbour.
 */
export interface NeighbourData {
  userid: number;
  baseid: string;
  level: number;
  username: string;
  attacksto?: number;
  attacksfrom?: number;
  attacksTodayCount: number;
  attacksTodayDate: number;
  helpsto?: number;
  helpsfrom?: number;
  retaliatecount?: number;
  seentime?: number;
  baseseed?: number;
  attacker?: string;
  friend?: number;
  saved?: number;
  attackpermitted?: number;
  basename?: string;
  ownerName?: string;
  pic?: string;
  trucestate?: string;
  truceexpire?: number;
  destroyed?: number;
  online?: boolean;
  description?: string;
  type?: number;
  wm?: number;
}
