import { Invasion } from "../../../enums/Invasion.js";
import { GameEvent } from "../../../enums/GameEvent.js";
import { getScheduledEvent, getEventOverride } from "../calendar/eventCalendar.js";

/**
 * Determines which invasion type is currently active.
 *
 * An invasion with a start override wins. Otherwise it is whichever invasion the
 * event calendar has under way, or the one that comes next.
 * This ensures only one invasion type is active at any time.
 *
 * @returns {Invasion} The currently active invasion type (WMI1 or WMI2)
 */
export const getActiveInvasion = (): Invasion => {
  const wmi1Override = getEventOverride(GameEvent.WMI1);
  const wmi2Override = getEventOverride(GameEvent.WMI2);

  if (wmi1Override) return Invasion.WMI1;
  if (wmi2Override) return Invasion.WMI2;

  const wmi1Scheduled = getScheduledEvent(GameEvent.WMI1);
  const wmi2Scheduled = getScheduledEvent(GameEvent.WMI2);

  if (!wmi2Scheduled) return Invasion.WMI1;
  if (!wmi1Scheduled) return Invasion.WMI2;

  return wmi2Scheduled.start < wmi1Scheduled.start ? Invasion.WMI2 : Invasion.WMI1;
};
