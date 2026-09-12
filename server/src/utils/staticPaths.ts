import { readdirSync } from "fs";
import { logger } from "./logger.js";

type StaticPaths = {
  prefixes: string[];
  files: Set<string>;
};

const PUBLIC_DIR = "public";

/**
 * Reads the top level of public/ once at boot.
 *
 * koa-static is mounted at the root, so its files are requested as /assets/...
 * rather than /public/assets/... Deriving the list from the directory keeps it
 * from drifting: a new folder in public/ is served without a code change, and
 * nothing here can claim a path that no longer exists.
 *
 * @returns {StaticPaths} Directory prefixes and exact filenames.
 */
const readPublicDir = (): StaticPaths => {
  const prefixes: string[] = [];

  const files = new Set(["/"]);

  try {
    for (const entry of readdirSync(PUBLIC_DIR, { withFileTypes: true })) {
      if (entry.isDirectory()) prefixes.push(`/${entry.name}/`);
      else files.add(`/${entry.name}`);
    }
  } catch (error) {
    logger.error(`Could not read ${PUBLIC_DIR}, no static files will be served: ${error}`);
  }

  return { prefixes, files };
};

const { prefixes, files } = readPublicDir();

/**
 * Whether a request is for a file in public/ rather than an API route.
 *
 * @param {string} path - The request path.
 * @returns {boolean} True when koa-static should handle the request.
 */
export const isStaticPath = (path: string) => files.has(path) || prefixes.some((prefix) => path.startsWith(prefix));
