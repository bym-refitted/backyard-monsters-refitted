import { devConfig } from "../config/DevSettings.js";
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
  attacklog: 1,
  messaging: devConfig.allowedMessageType.message ? 1 : 0,
  sroverlay: 0,
  leaderboard: 1,
  fanfriendbookmarkquests: 1,
  ticker: 0,
  chat: 0, // Disable chat
  invites: 0, // Diable friend invites
  gifts: 0, // Disable gifts
  event1: 1,
  event2: 0,
  ...getInvasionFlags(),
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
  showFBCDaily: 0,
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
});
