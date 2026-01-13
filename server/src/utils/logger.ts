import {
  configure,
  getConsoleSink,
  getLogger,
  jsonLinesFormatter,
} from "@logtape/logtape";

import { prettyFormatter } from "@logtape/pretty";
import { Env } from "../enums/Env.js";

/**
 * Configure LogTape logging for the application.
 *
 * - Uses a console sink for all logs.
 * - Switches formatter based on environment:
 *   - LOCAL → human-readable pretty output
 *   - non-LOCAL → JSON Lines (machine/production friendly)
 *
 * This configuration is executed eagerly at startup and must
 * complete before any logger is used.
 */
await configure({
  sinks: {
    console: getConsoleSink({
      formatter:
        process.env.ENV === Env.LOCAL ? prettyFormatter : jsonLinesFormatter,
    }),
  },
  loggers: [
    {
      /**
       * Primary application logger.
       *
       * Category hierarchy: ["bymr", ...]
       * Logs everything from debug and above.
       */
      category: ["bymr"],
      lowestLevel: "debug",
      sinks: ["console"],
    },
    {
      /**
       * Internal LogTape meta-logging.
       *
       * Reduced verbosity to avoid noise unless warnings
       * or errors occur within the logging system itself.
       */
      category: ["logtape", "meta"],
      lowestLevel: "warning",
      sinks: ["console"],
    },
  ],
});

/**
 * Root application logger.
 */
export const logger = getLogger(["bymr"]);
