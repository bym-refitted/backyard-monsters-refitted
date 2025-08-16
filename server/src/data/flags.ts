import { devConfig } from "../config/DevSettings";

/**
 * Configuration flags for game settings.
 * These flags are used to enable/disable features in game.
 */
export const flags = {
  // Platforms:
  viximo: 0,
  kongregate: 0,
  discordOldEnough: 0,

  // Settings:
  maproom: 1,
  maproom2: devConfig.maproom ? 1 : 0,
  inferno: devConfig.inferno ? 1 : 0,
  infernoMapBlocked: devConfig.infernoMaproom ? 1 : 0,
  showProgressBar: 0,
  gamestats: 0,
  logfps: 0,
  templog: 0,
  gamestatsb: 1,
  split_loadtime: 1,
  split2: 0,
  splituserid2: 15151832,
  split: 0,
  splituserid: 14619212,
  efl: 200,
  sal: 0,
  numchatrooms: 0,
  savedelay: 3,
  fb_api_curl_timeout: 2,
  pageinterval: 25,
  empire_value_limit: 831186222,
  nwm_relocate: 1,
  attacking: 1,
  gifts: 1,
  attacklog: 1,
  messaging: devConfig.allowedMessageType.message ? 1: 0,
  sroverlay: 0,
  leaderboard: 1,
  fanfriendbookmarkquests: 1,
  ticker: 0,
  chat: 0, // Disable chat
  event1: 1,
  event2: 0,
  // Wild Monster Invasion event phase control flags
  // invasionpop: Controls WMI v2 (SPECIALEVENT.as) event timing phases:
  //   -1: Event not started (no popup)
  //    0: Pre-event phase 1 (7 days before start) 
  //    1: Pre-event phase 2 (4 days before start)
  //    2: Pre-event phase 3 (1 day before start) 
  //    3: Event starting (at start time)
  //    4: Event active (after start time)
  //    5+: Post-event phase (7 days after start)
  // Note: WMI v2 calculates phases automatically based on TIME_OFFSETS and event start time
  invasionpop: 6,
  // invasionpop2: Controls WMI v1 (SPECIALEVENT_WM1.as) event state:
  //   -1: Event disabled/not available
  //   Other values: Combined with invasionpop using Math.max() to determine final state
  // Note: WMI v1 uses server-controlled flags rather than time-based calculation
  invasionpop2: 6,
  iframestart_override: 0,
  mushrooms: 1,
  chatwhitelist: "2,3,23",
  chatblacklist: 0,
  welcome_email: 1,
  email_reengagement: 1,
  countrycodeblacklist: "",
  radio: 1,
  plinko: 0,
  midgameIncentive: 0,
  showFBCEarn: 1,
  trialpayDealspot: 1,
  showFBCDaily: 1,
  validate_percent: 0,
  autoban_validate_fail: 0,
  autoban_client: 0,
  yp_version: 2,
  ers: 0, // Used for enabling canScheduleNewEvent() in ReplayableEventHandler.as on client
  krallen: 1,
  subscriptions: 1,
  krallen_duration: 7,
  subscriptions_ab: 0,
  subscriptions_ab_admin: 0,
  krallen_award_threshold: 250000000,
  krallen_special1_award_threshold: 750000000,
  krallen_special2_award_threshold: 7000000000,
  saveicon: 1,
  event3start: 1364313600,
  event3end: 1364832000,
  currencystart: 1362168000,
  currencyend: 1362340800,
  updating: 0,
  topups: 1,
  topup_gifts: 1,
  gamedebug: 1,
};
