import { AsyncLocalStorage } from "node:async_hooks";
import {
  configure,
  getConsoleSink,
  getLogger,
  jsonLinesFormatter,
} from "@logtape/logtape";

import { getPrettyFormatter } from "@logtape/pretty";
import { Env } from "../enums/Env.js";

/**
 * Configure LogTape logging for the application.
 *
 * - Uses a console sink for all logs.
 * - Switches formatter based on environment:
 *   - LOCAL → human-readable pretty output, including structured properties
 *   - non-LOCAL → JSON Lines (machine/production friendly), properties under
 *     "properties" for querying with jq
 * - Enables implicit contexts through AsyncLocalStorage, which the request
 *   logging middleware uses to attach requestId, remoteAddr and userAgent to
 *   every record emitted while a request is handled.
 *
 * This configuration is executed eagerly at startup and must
 * complete before any logger is used.
 */
await configure({
  contextLocalStorage: new AsyncLocalStorage(),
  sinks: {
    console: getConsoleSink({
      formatter:
        process.env.ENV === Env.LOCAL ? getPrettyFormatter({ properties: true }) : jsonLinesFormatter,
    }),
  },
  loggers: [
    {
      /**
       * Primary application logger.
       *
       * Category hierarchy: ["bymr", ...], including ["bymr", "http"] for
       * request logs. Logs everything from debug and above.
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
