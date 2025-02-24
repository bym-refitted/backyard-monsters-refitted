import { devConfig } from "../config/DevSettings";
import { User } from "../models/user.model";
import { devSandbox } from "../dev/devSandbox";
import { getCurrentDateTime } from "../utils/getCurrentDateTime";
import { Reward } from "../enums/Rewards";
import { BaseType } from "../enums/Base";
import { infernoSandbox } from "../dev/infernoSandbox";

/**
 * Generates the default base data object for a new save.
 *
 * @param {User} [user] - The user for whom the base data is being generated.
 * @returns {object} - The default base data object.
 */
export const getDefaultBaseData = (user: User, baseType: BaseType) => {
  // Inserts a sandbox test base into the database if enabled.
  if (baseType === BaseType.MAIN && devConfig.devSandbox)
    return devSandbox(user);

  if (baseType === BaseType.INFERNO && devConfig.infernoSandbox)
    return infernoSandbox(user);

  return {
    saveuserid: user.userid,
    userid: user.userid,
    cellid: -1,
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
    krallen: {},
    rewards: devConfig.unlockAllEventRewards
      ? {
          // Unique event reward unlockables
          unlockRezghul: { id: Reward.REZGHUL },
          unblockSlimeattikus: { id: Reward.SLIMEATTIKUS },
          unblockVorg: { id: Reward.VORG },
        }
      : {},
  };
};
