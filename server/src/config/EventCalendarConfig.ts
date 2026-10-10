import { EventSlot, GameEvent } from "../enums/GameEvent.js";

export interface EventDefinition {
  replayableId?: number;
  maxScore?: number;
  runDays: number;
  enabled: boolean;
}

/** The time zone the calendar's dates are in. Events start at midnight in this zone. */
export const EVENT_TIME_ZONE = "UTC";

/** How long before its start an event is announced. */
export const COUNTDOWN_DAYS = 7;

/** How long a replayable event stays on screen after it ends */
export const POST_EVENT_DAYS = 2;

/**
 * Epoch timestamps that force an event to start at a given time, or 0 to leave it
 * to the calendar. A forced event is announced from 7 days before, and runs even
 * when it is disabled below.
 */
export const EVENT_START_OVERRIDES: Record<GameEvent, number> = {
  [GameEvent.WMI1]: 0,
  [GameEvent.WMI2]: 0,
  [GameEvent.MONSTER_MADNESS]: 0,
  [GameEvent.BRUKKARG_WAR]: 1791643342,
  [GameEvent.CREATURE_CARNAGE]: 0,
  [GameEvent.MONSTER_BLITZKRIEG]: 0,
  [GameEvent.KING_OF_THE_HILL]: 0,
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
    runDays: 5,
    enabled: false,
  },
  [GameEvent.CREATURE_CARNAGE]: {
    replayableId: 1,
    runDays: 4,
    enabled: false,
  },
  [GameEvent.MONSTER_BLITZKRIEG]: {
    replayableId: 2,
    runDays: 4,
    enabled: false,
  },
  [GameEvent.KING_OF_THE_HILL]: {
    replayableId: 4,
    runDays: 7,
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
 * qualify for, and never more than one.
 */
export const EVENT_CYCLE: Record<EventSlot, GameEvent[]>[] = [
  {
    [EventSlot.A]: [GameEvent.WMI1],
    [EventSlot.B]: [GameEvent.KING_OF_THE_HILL, GameEvent.CREATURE_CARNAGE],
  },
  {
    [EventSlot.A]: [GameEvent.MONSTER_MADNESS],
    [EventSlot.B]: [GameEvent.WMI2],
  },
  {
    [EventSlot.A]: [GameEvent.HELL_RAISERS, GameEvent.MONSTER_BLITZKRIEG],
    [EventSlot.B]: [GameEvent.BRUKKARG_WAR],
  },
];
