import { devConfig } from "../../../config/DevSettings";
import { Invasion } from "../../../enums/Invasion";

/**
 * Determines which invasion type is currently active based on dev overrides or month scheduling.
 * 
 * Checks dev configuration overrides first, then falls back to the standard monthly alternating schedule
 * where WMI1 runs in odd months and WMI2 runs in even months.
 * This ensures only one invasion type is active at any time.
 *
 * @returns {Invasion} The currently active invasion type (WMI1 or WMI2)
 */
export const getActiveInvasion = (): Invasion => {
  if (devConfig.wmi1StartNowOverride) return Invasion.WMI1;

  if (devConfig.wmi2StartNowOverride) return Invasion.WMI2;

  const currentMonth = new Date().getMonth() + 1;
  return currentMonth % 2 === 1 ? Invasion.WMI1 : Invasion.WMI2;
};
