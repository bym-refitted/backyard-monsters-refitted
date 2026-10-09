import { devConfig } from "../config/GameConfig.js";
import { getActiveInvasion } from "../services/events/wmi/getActiveInvasion.js";
import { setupInvasionEvent } from "../services/events/wmi/setupInvasionEvent.js";

/**
 * Gets the current invasion flags.
 * These flags are used to determine the state of Wild Monster Invasion events.
 */
const getInvasionFlags = () => {
  const activeInvasion = getActiveInvasion();
  const invasionPhases = setupInvasionEvent(activeInvasion).phases;
  return { ...invasionPhases, activeInvasion };
};

/**
 * Gets the flags for the replayable events.
 *
 * `ers` is the switch for the whole system: without it the client schedules no event.
 * Each event that the server schedules then has its own start date flag. `ers` is
 * only raised while one of them has a date, because with it raised the client also
 * schedules its other events (Battletoads, Monster Blitzkrieg, Hell Raisers) by itself.
 */
const getReplayableEventFlags = () => {
  const startDates = {
    brukkargstart: devConfig.brukkargWarStartOverride,
  };

  const ers = Object.values(startDates).some(Boolean) ? 1 : 0;
  return { ers, ...startDates };
};

/**
 * Configuration flags for game settings.
 * These flags are used to enable/disable features in game.
 */
export const getFlags = () => ({
  // Platforms:
  viximo: 0,
  kongregate: 0,
  discordOldEnough: 0,

  // Settings:
  maproom: 1,
  maproom2: 0, // controlled by baseLoad.ts based on town hall level
  mr2upgraded: 0,
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
  attacklog: 1,
  messaging: devConfig.allowedMessageType.message ? 1 : 0,
  sroverlay: 0,
  leaderboard: 1,
  fanfriendbookmarkquests: 1,
  ticker: 0,
  chat: 2, // Enable chat (0=disabled, 1=no display, 2=display)
  invites: 1,
  gifts: 1,
  event1: 1,
  event2: 0,
  ...getInvasionFlags(),
  ...getReplayableEventFlags(),
  iframestart_override: 0,
  mushrooms: 1,
  chatwhitelist: "",
  chatblacklist: 0,
  welcome_email: 1,
  email_reengagement: 1,
  countrycodeblacklist: "",
  radio: 1,
  plinko: 0,
  midgameIncentive: 0,
  showFBCEarn: 1,
  trialpayDealspot: 1,
  showFBCDaily: 0,
  validate_percent: 0,
  autoban_validate_fail: 0,
  autoban_client: 0,
  yp_version: 2,
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
});
