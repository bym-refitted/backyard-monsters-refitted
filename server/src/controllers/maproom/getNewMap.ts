import { MapRoom2, MapRoomVersion } from "../../enums/MapRoom";
import { Status } from "../../enums/StatusCodes";
import { BASE_URL, PORT } from "../../server";
import { KoaController } from "../../utils/KoaController";
import { CURRENT_MAPROOM_VERSION } from "./setMapVersion";

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
  const cellX = MapRoom2.WIDTH;
  const cellY = MapRoom2.HEIGHT;

  if (CURRENT_MAPROOM_VERSION === MapRoomVersion.V3) {
    // TODO: What is the purpose of this?
    
    // for (let x = 0; x < cellX; x++) {
    //   for (let y = 0; y < cellY; y++) {
    //     cells.push({ h: 0, t: 100 });
    //   }
    // }

    ctx.body = {
      newmap: true,
      mapheaderurl: `${BASE_URL}:${PORT}/api/bm/getnewmap`,
      width: MapRoom2.WIDTH,
      height: MapRoom2.HEIGHT,
      // data: cells,
    };
  } else {
    ctx.body = { newmap: false };
  }

  ctx.status = Status.OK;
};
