import { Invasion } from "../../../enums/Invasion";
import { getActiveInvasion } from "./getActiveInvasion";
import { setupInvasionEvent } from "./setupInvasionEvent";

export interface Stats {
  other?: {
    wmi_wave?: number;
    wmi2_wave?: number;
    lastWmi1EventEnd?: number;
    lastWmi2EventEnd?: number;
    [key: string]: any;
  };
}

const waveKeyMap: Record<Invasion, keyof NonNullable<Stats["other"]>> = {
  [Invasion.WMI1]: "wmi_wave",
  [Invasion.WMI2]: "wmi2_wave",
};

const lastEventEndMap: Record<Invasion, keyof NonNullable<Stats["other"]>> = {
  [Invasion.WMI1]: "lastWmi1EventEnd",
  [Invasion.WMI2]: "lastWmi2EventEnd",
};

const waveResetValues: Record<Invasion, number> = {
  [Invasion.WMI1]: 0,
  [Invasion.WMI2]: 100,
};

/**
 * Resets the wave progress for a user based on the current active invasion event.
 *
 * This function ensures that:
 * 1. Waves are only reset once per event per user.
 * 2. Skipped events are handled correctly (user will start fresh for a new event).
 * 3. Mid-event logins do not reset waves unnecessarily.
 *
 * It relies on per-user tracking of the last event end (`lastEventEndKey`) and the
 * current event's start/end timestamps (`setupInvasionEvent`).
 *
 * @param {Stats["other"]} stats - The user's invasion-related stats object.
 * @param {Invasion} activeInvasion - The current active invasion type (e.g., WMI1, WMI2).
 */
export const resetInvasionWaves = (stats: Stats["other"]) => {
  if (!stats) return;

  const activeInvasion = getActiveInvasion();

  const waveKey = waveKeyMap[activeInvasion];
  const lastEventEndKey = lastEventEndMap[activeInvasion];

  if (!waveKey || !lastEventEndKey) return;

  const { dates } = setupInvasionEvent(activeInvasion);
  const currentEventEnd = dates.end;
  const currentEventStart = dates.start;

  const lastUserEventEnd = stats[lastEventEndKey] || 0;

  // Only reset waves if the user hasn't participated in this event yet
  if (lastUserEventEnd < currentEventStart) {
    stats[waveKey] = waveResetValues[activeInvasion];
  }

  // Update the user's last seen event end timestamp to mark participation
  stats[lastEventEndKey] = currentEventEnd;
};
