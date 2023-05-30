const logger = require("pino")(require("pino-pretty")());

export const logging = (message: string, vars: unknown = "") => logger.info(`${message} ${vars}`);
export const errorLog = (message: string, vars: unknown = "") => logger.error(`${message} ${vars}`);
