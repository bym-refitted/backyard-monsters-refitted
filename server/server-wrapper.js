#!/usr/bin/env bun

/**
 * PM2 wrapper for Bun + ESM compatibility
 *
 * Workaround for PM2's require() issue with ESM modules. Uses dynamic import()
 * to load the server while preserving PM2's monitoring features.
 *
 * @see https://github.com/oven-sh/bun/issues/19942#issuecomment-3297830230
 */
import("./src/server.ts").catch((err) => {
  console.error(err);
  process.exit(1);
});
