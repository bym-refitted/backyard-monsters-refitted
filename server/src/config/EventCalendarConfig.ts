import { EventSlot, GameEvent } from "../enums/GameEvent.js";

export interface EventDefinition {
  runDays: number;
  enabled: boolean;
  replayableId?: number;
  maxScore?: number;
  copyBaseScore?: number;
  weekly?: boolean;
  countdownDays?: number;
  closingDays?: number;
}

export const EVENT_TIME_ZONE = "UTC";

export const COUNTDOWN_DAYS = 7;

export const POST_EVENT_DAYS = 2;

/**
 * Epoch timestamps that force an event to start at a given time, or 0 to leave it
 * to the calendar. A forced event is announced from 7 days before, and runs even
 * when it is disabled below.
 *
 * While any override is set, every event without one is hidden. Setting the overrides
 * back to 0 hands control back to the calendar, which carries on from wherever it is.
 */
export const EVENT_START_OVERRIDES: Record<GameEvent, number> = {
  [GameEvent.WMI1]: 0,
  [GameEvent.WMI2]: 0,
  [GameEvent.MONSTER_MADNESS]: 0,
  [GameEvent.BRUKKARG_WAR]: 0,
  [GameEvent.CREATURE_CARNAGE]: 0,
  [GameEvent.MONSTER_BLITZKRIEG]: 0,
  [GameEvent.KING_OF_THE_HILL]: 1792273252,
  [GameEvent.HELL_RAISERS]: 0,
};

/** The day of the month on which the event of each slot starts. */
export const SLOT_START_DAY: Record<EventSlot, number> = {
  [EventSlot.A]: 10,
  [EventSlot.B]: 24,
};


export const EVENTS: Record<GameEvent, EventDefinition> = {
  [GameEvent.WMI1]: { 
    runDays: 7, 
    enabled: true 
  },
  [GameEvent.WMI2]: { 
    runDays: 7, 
    enabled: true 
  },
  [GameEvent.MONSTER_MADNESS]: { 
    runDays: 4, 
    enabled: false 
  },
  [GameEvent.BRUKKARG_WAR]: {
    replayableId: 5,
    maxScore: 5025,
    copyBaseScore: 4024,
    runDays: 5,
    enabled: true,
  },
  [GameEvent.CREATURE_CARNAGE]: {
    replayableId: 1,
    maxScore: 10,
    weekly: true,
    countdownDays: 1,
    closingDays: 0,
    runDays: 6,
    enabled: true,
  },
  [GameEvent.MONSTER_BLITZKRIEG]: {
    replayableId: 2,
    maxScore: 10,
    weekly: true,
    countdownDays: 1,
    closingDays: 0,
    runDays: 6,
    enabled: true,
  },
  [GameEvent.KING_OF_THE_HILL]: {
    replayableId: 4,
    runDays: 7,
    // Launch announcement for Hunt for Krallen, which runs weekly on its own; not on the calendar, only ever run once, by override.
    enabled: false,
  },
  [GameEvent.HELL_RAISERS]: {
    replayableId: 7,
    runDays: 4,
    enabled: false,
  },
};

/**
 * The event calendar: one entry per month, repeating. An event open to every
 * player has its slot to itself. Events that share a slot are for separate players
 * (by Town Hall level or Map Room); the client shows each player the one they
 * qualify for, and never more than one. Weekly events are not on the calendar.
 */
export const EVENT_CYCLE: Record<EventSlot, GameEvent[]>[] = [
  {
    [EventSlot.A]: [GameEvent.WMI1],
    [EventSlot.B]: [GameEvent.BRUKKARG_WAR],
  },
  {
    [EventSlot.A]: [GameEvent.HELL_RAISERS],
    [EventSlot.B]: [GameEvent.MONSTER_MADNESS],
  },
  {
    [EventSlot.A]: [GameEvent.WMI2],
    [EventSlot.B]: [GameEvent.BRUKKARG_WAR],
  },
  {
    [EventSlot.A]: [GameEvent.HELL_RAISERS],
    [EventSlot.B]: [GameEvent.MONSTER_MADNESS],
  },
];
