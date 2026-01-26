import { MapRoom, MapRoomVersion } from "../../enums/MapRoom.js";
import { Status } from "../../enums/StatusCodes.js";
import { BASE_URL, PORT } from "../../server.js";
import type { KoaController } from "../../utils/KoaController.js";
import { CURRENT_MAPROOM_VERSION } from "./setMapVersion.js";

/**
 * Controller to get Map Room details.
 *
 * This controller is called when the application is first loaded.
 * It generates cells with additional data if the current map version is V3.
 * Otherwise, it returns newmap as false.
 *
 * @param {Object} ctx - Koa context object.
 */
export const getNewMap: KoaController = async (ctx) => {
  const cells = [];
  const cellX = MapRoom.WIDTH;
  const cellY = MapRoom.HEIGHT;

  if (CURRENT_MAPROOM_VERSION === MapRoomVersion.V3) {
    for (let x = 0; x < cellX; x++) {
      for (let y = 0; y < cellY; y++) {
        cells.push({ h: 0, t: 100 });
      }
    }

    ctx.body = {
      newmap: true,
      mapheaderurl: `${BASE_URL}:${PORT}/api/bm/getnewmap`,
      width: MapRoom.WIDTH,
      height: MapRoom.HEIGHT,
      data: cells,
    };
  } else {
    ctx.body = { newmap: false };
  }

  ctx.status = Status.OK;
};
