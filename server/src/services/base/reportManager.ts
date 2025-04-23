import { Report } from "../../models/report.model";
import { User } from "../../models/user.model";
import { ORMContext } from "../../server";

type ReportEntry = {
  message: string;
  timestamp: string;
};

/**
 * Logs a general report for a user with a message and timestamp.
 * Increments the user's violation count and appends the message to the report list.
 *
 * @param {User} user - The user being reported.
 * @param {string} message - The message describing the violation or report reason.
 * @returns {Promise<void>}
 */
export const logReport = async (user: User, message: string) => {
  const incident = await getOrCreateReport(user);

  const newReport: ReportEntry = {
    message,
    timestamp: new Date().toISOString(),
  };

  incident.report.push(newReport);
  await ORMContext.em.persistAndFlush(incident);
};

/**
 * Logs an attack validation violation for a user.
 * This is specifically used to track attack payload tampering from validateAttack.
 *
 * @param {User} user - The user with the attack violation.
 * @param {string} message - The detailed message about the attack violation.
 * @returns {Promise<void>}
 */
export const logAttackViolation = async (user: User, message: string) => {
  const incident = await getOrCreateReport(user);

  incident.attackViolations += 1;
  
  const newReport: ReportEntry = {
    message: `ATTACK VIOLATION: ${message}`,
    timestamp: new Date().toISOString(),
  };
  
  incident.report.push(newReport);
  await ORMContext.em.persistAndFlush(incident);
};

/**
 * Logs a ban report for a user with a message and timestamp.
 * Increments the user's violation count and sets the ban reason.
 *
 * @param {User} user - The user being banned.
 * @param {string} message - The message explaining the reason for the ban.
 * @returns {Promise<void>}
 */
export const logBanReport = async (user: User, message: string) => {
  const incident = await getOrCreateReport(user);

  const banReason: ReportEntry = {
    message,
    timestamp: new Date().toISOString(),
  };

  incident.banReason = banReason;
  user.banned = true;
  await ORMContext.em.persistAndFlush(incident);
};

/**
 * Fetches an existing report for the user or creates a new one if none exists.
 * Also increments the violation count.
 *
 * @param {User} user - The user object containing ID and identifying info.
 * @returns {Promise<Report>} - The existing or newly created report entity.
 */
const getOrCreateReport = async (user: User): Promise<Report> => {
  const { userid, username, discord_tag } = user;
  let incident = await ORMContext.em.findOne(Report, { userid });

  if (!incident) {
    incident = new Report();
    incident.userid = userid;
    incident.username = username;
    incident.discord_tag = discord_tag;
    incident.violations = 0;
    incident.attackViolations = 0;
    incident.report = [];
    incident.banReason = null;
  }

  incident.violations += 1;
  return incident;
};