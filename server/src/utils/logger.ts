// const logger = require("pino")(require("pino-pretty")());
import Pino from 'pino'
import PinoPretty from 'pino-pretty';
const logger = Pino(PinoPretty());

export const logging = (message: string, vars: unknown = "") => logger.info(`${message} ${vars}`);
export const errorLog = (message: string, vars: unknown = "") => logger.error(`${message} ${vars}`);
