import { MapRoomVersion } from "../../../../enums/MapRoom.js";
import { Status } from "../../../../enums/StatusCodes.js";
import { isKnownWorld } from "../../../../services/maproom/knownWorlds.js";
import { getWorldSnapshot } from "../../../../services/maproom/v2/worldSnapshot.js";
import type { KoaController } from "../../../../utils/KoaController.js";

/**
 * THIS ENDPOINT IS FOR API CONSUMERS ONLY.
 * ____________________________________________________________
 *
 * Serves every occupied cell in an MR2 world in a single request.
 *
 * Covers the part of the map that is not derivable: player main yards, their
 * outposts, and wild monster camps that have been attacked. Terrain comes from
 * /worldmapv2/terrain, and wild monster tribes and levels are pure functions of
 * the coordinates.
 *
 * Query
 *   worldid   The uuid of an existing MR2 world. Required.
 *
 * Body
 *   application/json
 *   {
 *     "worldid":     "<uuid>",
 *     "generatedAt": <unix seconds the snapshot was built>,
 *     "players":     { "<uid>": { "name": "<username>", "avatar": "<url|null>" } },
 *     "cells":       [ [x, y, base_type, uid, baseid, empirevalue,
 *                       flinger, catapult, damage, protected, destroyed], ... ]
 *   }
 *
 *   Cells are positional arrays to avoid repeating key names across six figures
 *   of rows, and reference their owner by uid rather than inlining it.
 *   base_type is 1 for an attacked wild monster camp, 2 for a main yard and 3
 *   for an outpost.
 *
 *   Wild monster cells carry uid 0 and have no entry in players; their
 *   empirevalue, flinger, catapult and protected are always 0, so only damage
 *   and destroyed carry meaning.
 *
 * Not included
 *   Resources and monsters change every tick and would make the response
 *   uncacheable and different for every caller; they stay on getarea. Truce and
 *   protection state relative to the caller is likewise per-viewer.
 *
 * Encoding
 *   brotli, gzip or identity, selected from Accept-Encoding, preferring brotli.
 *   A request that sends no Accept-Encoding receives identity. Responses carry
 *   Vary: Accept-Encoding.
 *
 * Caching
 *   Rebuilt at most once a minute per world and served with a matching max-age
 *   and a strong ETag derived from the payload. Send the ETag back as
 *   If-None-Match to get a 304 with no body while nothing has changed.
 *
 * Status
 *   200   the snapshot
 *   304   the cached copy is current
 *   400   worldid missing, unknown, or not an MR2 world
 *   429   rate limited
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getSnapshot: KoaController = async (ctx) => {
  const { worldid } = ctx.query;

  if (!worldid) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "Missing worldid" };
    return;
  }

  const worldExists = await isKnownWorld(worldid, MapRoomVersion.V2);

  if (!worldExists) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: "Unknown worldid" };
    return;
  }

  const snapshot = await getWorldSnapshot(worldid.toString());

  ctx.set("Cache-Control", "public, max-age=60");
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
