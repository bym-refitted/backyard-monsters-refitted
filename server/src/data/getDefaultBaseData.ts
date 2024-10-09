import { devConfig } from "../config/DevSettings";
import { User } from "../models/user.model";
import { debugSandbox } from "../dev/debugSandbox";
import { devSandbox } from "../dev/devSandbox";
import { generateID } from "../utils/generateID";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { Reward } from "../enums/Rewards";

/**
 * Generates the default base data object for a new save.
 *
 * @param {User} [user] - The user for whom the base data is being generated.
 * @returns {object} - The default base data object.
 */
export const getDefaultBaseData = (user?: User) => {
  // Load sandbox data if dev flags are enabled. View DevSettings.ts for flags & Wiki details.
  if (devConfig.devSandbox) return devSandbox(user);
  if (devConfig.debugSandbox) return debugSandbox(user);

  const baseid = generateID(9);

  return {
    baseid: baseid.toString(10),
    saveuserid: user.userid,
    userid: user.userid,
    cellid: -1,
    homebaseid: baseid,
    baseid_inferno: 0,
    name: user.username,
    credits: devConfig.shiny || 1000,
    createtime: getCurrentDateTime(),

    // Pre-populated Objects
    resources: {
      r1: 0,
      r2: 0,
      r3: 0,
      r4: 0,
      r1max: 10000,
      r2max: 10000,
      r3max: 10000,
      r4max: 10000,
    },
    iresources: {
      r1: 0,
      r2: 0,
      r3: 0,
      r4: 0,
      r1max: 10000,
      r2max: 10000,
      r3max: 10000,
      r4max: 10000,
    },
    krallen: devConfig.unlockAllEventRewards
      ? {
          countdown: 443189,
          wins: 5,
          tier: 5,
          loot: 750000000000,
        }
      : {},
    rewards: devConfig.unlockAllEventRewards
      ? {
          // Unique event reward unlockables
          unlockRezghul: { id: Reward.REZGHUL },
          unblockSlimeattikus: { id: Reward.SLIMEATTIKUS },
          unblockVorg: { id: Reward.VORG },
          krallenReward: { id: Reward.KRALLEN, value: 1 },
        }
      : {}
  };
};
