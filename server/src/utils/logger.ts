import { AsyncLocalStorage } from "node:async_hooks";
import { mkdirSync } from "node:fs";
import { fileURLToPath } from "node:url";
import {
  configure,
  getConsoleSink,
  getJsonLinesFormatter,
  getLogger,
  type Sink,
} from "@logtape/logtape";
import { getRotatingFileSink } from "@logtape/file";
import { getPrettyFormatter } from "@logtape/pretty";
import { Env } from "../enums/Env.js";

/**
 * Directory for the JSON log files in production: server/logs, resolved from this
 * file rather than the working directory, so it doesn't depend on where pm2 was
 * started. The file sink does not create it.
 */
const LOG_DIR = fileURLToPath(new URL("../../logs", import.meta.url));

const isLocal = process.env.ENV === Env.LOCAL;

if (!isLocal) mkdirSync(LOG_DIR, { recursive: true });

/**
 * Sinks for the current environment.
 *
 * - console: @logtape/pretty everywhere. Locally it also prints each record's
 *   properties. In production it prints one line per record with no word wrap
 *   (pm2 is not a terminal), which is what `pm2 logs` shows. It stays blocking
 *   so a record logged just before process.exit() is never lost.
 * - file (production only): every record as JSON Lines, message kept as its
 *   template, in a rotating file for querying with jq. It rotates at 100 MB and
 *   keeps 9 rotated copies (.1 to .9) plus the live file, capping logs at 1 GB.
 *   It is non-blocking, so writes are buffered and flushed off the request path.
 */
const sinks: Record<string, Sink> = isLocal
  ? {
      console: getConsoleSink({ formatter: getPrettyFormatter({ properties: true }) }),
    }
  : {
      console: getConsoleSink({
        formatter: getPrettyFormatter({
          timestamp: "date-time",
          categorySeparator: ".",
          categoryWidth: 10,
          properties: false,
          wordWrap: false,
        }),
      }),
      file: getRotatingFileSink(`${LOG_DIR}/bymr.jsonl`, {
        formatter: getJsonLinesFormatter({ message: "template" }),
        maxSize: 100 * 1024 * 1024,
        maxFiles: 9,
        nonBlocking: true,
      }),
    };

/**
 * Configure LogTape logging for the application.
 *
 * Enables implicit contexts through AsyncLocalStorage, which the request
 * logging middleware uses to attach requestId, remoteAddr and userAgent to
 * every record emitted while a request is handled.
 *
 * This configuration is executed eagerly at startup and must
 * complete before any logger is used.
 */
await configure({
  contextLocalStorage: new AsyncLocalStorage(),
  sinks,
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
      sinks: Object.keys(sinks),
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
