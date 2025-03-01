import { Env } from "../enums/Env";

/** Visit our Wiki to get more information on each flag.
 * Wiki: https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Dev-Settings-%E2%80%90-Configuration
 */
export const devConfig = {
  /*
   * Enable or disable the MapRoom on the server.
   */
  maproom: true,

  /*
   * Enable or disable Inferno on the server.
   */
  inferno: true,
  
  /*
   * Set the default amount of shiny on the user's account.
   * Must be set before creating a new record.
   */
  shiny: 1500,

  /*
   * Enable or disable the debug console. Requires a client restart.
   * A list of all available commands can be found in `ConsoleCommands.as`
   */
  debugMode: false,

  /*
   * Inserts a sandbox test base into the database, with all buildings placed.
   * Must be set before creating a new record.
   */
  devSandbox: true,

    /*
   * Inserts an Inferno sandbox test base into the database, with all buildings placed.
   * Must be set before creating a new record.
   */
  infernoSandbox: true,

  /*
   * Logs all missing assets and their paths to the server console.
   */
  logMissingAssets: false,

  /*
   * Sets whether the user's account should receive all unlockable event rewards.
   * Must be set before creating a new record.
   */
  unlockAllEventRewards: true,

  /*
   * Sets whether the tutorial phase of the game is enabled or disabled.
   */
  skipTutorial: process.env.ENV !== Env.PROD
};
