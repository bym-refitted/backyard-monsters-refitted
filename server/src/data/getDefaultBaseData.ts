import { devConfig } from "../config/DevSettings.js";
import { User } from "../models/user.model.js";
import { devSandbox } from "../dev/devSandbox.js";
import { getCurrentDateTime } from "../utils/getCurrentDateTime.js";
import { Reward } from "../enums/Rewards.js";
import { BaseType } from "../enums/Base.js";
import { infernoSandbox } from "../dev/infernoSandbox.js";

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

  const currentTime = getCurrentDateTime();
  const sevenDays = 7 * 24 * 60 * 60;

  return {
    saveuserid: user.userid,
    userid: user.userid,
    cellid: -1,
    name: user.username,
    credits: devConfig.shiny || 1000,
    createtime: currentTime,
    protected: currentTime + sevenDays,

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
          // Default event rewards
          unblockSlimeattikus: { id: Reward.SLIMEATTIKUS },
          unblockVorg: { id: Reward.VORG },
          goldenDAVE: { id: Reward.GOLDEN_DAVE },
          improvedHCC: { id: Reward.IMPROVED_HCC },
          extraTiles: { id: Reward.EXTRA_TILES },
          yardPlannerExtraSlots: { id: Reward.YARD_PLANNER_EXTRA_SLOTS },
          daveStatue: { id: Reward.DAVE_STATUE }
        }
      : {},
  };
};
