import { Status } from "../../../../enums/StatusCodes.js";
import {
  ALLIANCE_SNAPSHOT_MAX_AGE_SECONDS,
  getAllianceSnapshot,
} from "../../../../services/maproom/v2/allianceSnapshot.js";
import type { KoaController } from "../../../../utils/KoaController.js";

/**
 * THIS ENDPOINT IS FOR API CONSUMERS ONLY.
 * ____________________________________________________________
 *
 * Serves every MR2 alliance, across all worlds, in a single request.
 *
 * Auth
 *   X-API-Key   An active key from bym.api_consumer (see `bun run consumer:create`). Required.
 *
 * Query
 *   none. Filter on `world` client-side.
 *
 * Body
 *   application/json
 *   {
 *     "generatedAt": <unix seconds the snapshot was built>,
 *     "alliances": {
 *       "<alliance id>": {
 *         "world":         "<world uuid>",
 *         "name":          "<name>",
 *         "image":         <icon index>,
 *         "description":   "<text>",
 *         "leader":        <uid>,
 *         "createdAt":     <unix seconds>,
 *         "members":       [ <uid>, ... ],
 *         "relationships": { "<alliance id>": -1 | 1 }
 *       }
 *     }
 *   }
 *
 *   members lists uids, leader included; names and avatars are in
 *   /worldmapv2/snapshot players. Member count is the length of members.
 *
 *   relationships are the flags this alliance has set on others, keyed by
 *   target id: -1 hostile, 1 friendly, absent neutral.
 *
 * Not included
 *   Invites, messages and powerups.
 *
 * Encoding
 *   brotli, gzip or identity, selected from Accept-Encoding, preferring brotli.
 *   A request that sends no Accept-Encoding receives identity. Responses carry
 *   Vary: Accept-Encoding.
 *
 * Caching
 *   Rebuilt at most once every five minutes and served with a matching max-age
 *   and a strong ETag derived from the payload. Send the ETag back as
 *   If-None-Match to get a 304 with no body while nothing has changed.
 *
 * Status
 *   200   the snapshot
 *   304   the cached copy is current
 *   429   rate limited
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getAlliances: KoaController = async (ctx) => {
  const snapshot = await getAllianceSnapshot();

  ctx.set("Cache-Control", `public, max-age=${ALLIANCE_SNAPSHOT_MAX_AGE_SECONDS}`);
  ctx.set("Vary", "Accept-Encoding");
  ctx.set("ETag", snapshot.etag);
  ctx.set("Access-Control-Expose-Headers", "ETag");
  ctx.type = "application/json";

  // ctx.fresh only reports true once the status is 2xx.
  ctx.status = Status.OK;

  if (ctx.fresh) {
    ctx.status = Status.NOT_MODIFIED;
    return;
  }

  const acceptEncoding = ctx.headers["accept-encoding"];

  if (acceptEncoding && ctx.acceptsEncodings("br") === "br") {
    ctx.set("Content-Encoding", "br");
    ctx.body = snapshot.brotli;
    return;
  }

  if (acceptEncoding && ctx.acceptsEncodings("gzip") === "gzip") {
    ctx.set("Content-Encoding", "gzip");
    ctx.body = snapshot.gzip;
    return;
  }

  ctx.body = snapshot.raw;
};
