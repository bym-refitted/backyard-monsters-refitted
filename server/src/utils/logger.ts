const logger = require("pino")(require("pino-pretty")());

export const logging = (message: string, vars: unknown = "") => logger.info(`${message} ${vars}`);
