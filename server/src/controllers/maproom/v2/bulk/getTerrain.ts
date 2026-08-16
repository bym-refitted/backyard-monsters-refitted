import { MapRoomVersion } from "../../../../enums/MapRoom.js";
import { Status } from "../../../../enums/StatusCodes.js";
import { isKnownWorld } from "../../../../services/maproom/knownWorlds.js";
import { getTerrainMap } from "../../../../services/maproom/v2/terrainMap.js";
import type { KoaController } from "../../../../utils/KoaController.js";

/**
 * THIS ENDPOINT IS FOR API CONSUMERS ONLY.
 * ____________________________________________________________
 * 
 * Serves the complete MR2 terrain height map for a world.
 *
 * Terrain is deterministic and fixed for the life of a world, so the entire map
 * is available in one request rather than through per-zone `getarea` calls.
 *
 * Query
 *   worldid   The uuid of an existing world. Required.
 *
 * Body
 *   640,000 bytes of application/octet-stream. One unsigned byte per cell,
 *   indexed x * height + y over the fixed 800 x 800 grid.
 *
 * Encoding
 *   brotli, gzip or identity, selected from Accept-Encoding and preferring
 *   brotli. A request sending no Accept-Encoding receives identity. Responses
 *   carry Vary: Accept-Encoding.
 *
 * Caching
 *   public, max-age=31536000, immutable, with a strong ETag. Send it back as
 *   If-None-Match to get a 304 with no body. The ETag covers the terrain
 *   generation parameters as well as the world id, so it changes if a map is
 *   ever regenerated differently.
 *
 * Status
 *   200   the map
 *   304   the cached copy is current
 *   400   worldid missing, unknown, or not an MR2 world
 *   429   rate limited, 2 requests per minute
 *
 * @param {Context} ctx - The Koa request/response context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const getTerrain: KoaController = async (ctx) => {
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

  const worldId = worldid.toString();
  const terrain = await getTerrainMap(worldId);

  ctx.set("Cache-Control", "public, max-age=31536000, immutable");
  ctx.set("Vary", "Accept-Encoding");
  ctx.set("ETag", terrain.etag);
  ctx.set("Access-Control-Expose-Headers", "ETag");

  // ctx.fresh only reports true once the status is 2xx.
  ctx.status = Status.OK;

  if (ctx.fresh) {
    ctx.status = Status.NOT_MODIFIED;
    return;
  }

  const acceptEncoding = ctx.headers["accept-encoding"];

  if (acceptEncoding && ctx.acceptsEncodings("br") === "br") {
    ctx.set("Content-Encoding", "br");
    ctx.body = terrain.brotli;
    return;
  }

  if (acceptEncoding && ctx.acceptsEncodings("gzip") === "gzip") {
    ctx.set("Content-Encoding", "gzip");
    ctx.body = terrain.gzip;
    return;
  }

  ctx.body = terrain.raw;
};
