import { MapRoom3, MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { User } from "../../models/user.model.js";
import { BASE_URL, PORT, postgres } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";

/**
 * Controller to get Map Room metadata and configuration.
 *
 * This controller is called when the application is first loaded to determine:
 * 1. Which map room version to use (V2 or V3)
 * 2. Map dimensions (width/height)
 * 3. URL for fetching additional map data (legacy field)
 *
 * For Map Room V3:
 * - The client creates a placeholder grid of 500x500 cells with h:0 (flat terrain)
 * - Actual terrain data is loaded on-demand via the /worldmapv3/getcells endpoint
 * - This approach is more performant than sending 250,000 cells upfront
 * - The mapheaderurl field is maintained for compatibility but points back to this endpoint
 *
 * For Map Room V2 and earlier:
 * - Returns newmap: false to use the legacy map room system
 *
 * @param {Object} ctx - Koa context object.
 */
export const getNewMap: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save", "save.cell"]);

  const { cell } = user.save;

  if (cell?.map_version === MapRoomVersion.V3) {
    ctx.body = {
      newmap: true,
      mapheaderurl: `${BASE_URL}:${PORT}/api/bm/getnewmap`,
      width: MapRoom3.WIDTH,
      height: MapRoom3.HEIGHT,
    };
  } else {
    ctx.body = { newmap: false };
  }

  ctx.status = Status.OK;
};
