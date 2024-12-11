import { Env } from "../enums/Env";

/** Visit our Wiki to get more information on each flag.
 * Wiki: https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Dev-Settings-%E2%80%90-Configuration
 */
export const devConfig = {
  maproom: true,
  inferno: false,
  shiny: 1000,
  debugMode: false,
  devSandbox: true,
  debugSandbox: false,
  logMissingAssets: false,
  unlockAllEventRewards: true,
  skipTutorial: process.env.ENV !== Env.PROD,
};
