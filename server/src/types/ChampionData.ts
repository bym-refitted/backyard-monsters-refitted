/**
 * The shape of a single champion entry as stored in the database and
 * exchanged with the Flash client.
 */
export interface ChampionData {
  t: number;        // champion type
  l: number;        // evolution level
  hp: number;       // health points
  ft: number;       // feed time
  fd: number;       // feed count
  fb: number;       // food bonus level
  pl: number;       // power level
  status: number;   // current status (0 = active/normal, 1 = frozen in champion chamber)
  nm?: string;      // optional custom name given to the champion by the player
}
