import { Env } from "../enums/Env";

/** Visit our Wiki to get more information on each flag.
 * Wiki: https://github.com/bym-refitted/backyard-monsters-refitted/wiki/Dev-Settings-%E2%80%90-Configuration
 */
export const devConfig = {
  logMissingAssets: false,
  skipTutorial: process.env.ENV !== Env.PROD,
  unlockAllEventRewards: true,
  maproom: true,
  inferno: false,
  shiny: 2500,
  devSandbox: false,
  debugSandbox: false,
};
