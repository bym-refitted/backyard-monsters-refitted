import Pino from "pino";
import PinoPretty from "pino-pretty";

const logger = Pino(PinoPretty());

/**
 * Logs an informational message.
 *
 * @param {string} message - The message to log.
 * @param {unknown} [vars=""] - Additional variables to log.
 */
export const logging = (message: string, vars: unknown = "") =>
  logger.info(`${message} ${vars}`);

/**
 * Logs an error message.
 *
 * @param {string} message - The message to log.
 * @param {unknown} [vars=""] - Additional variables to log.
 */
export const errorLog = (message: string, vars: unknown = "") =>
  logger.error(`${message} ${vars}`);
