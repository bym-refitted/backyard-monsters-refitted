import { Status } from "../../../enums/StatusCodes.js";
import { User } from "../../../models/user.model.js";
import { BASE_URL, PORT, postgres } from "../../../server.js";
import type { KoaController } from "../../../utils/KoaController.js";
import { joinNewWorldMap } from "../../../services/maproom/v3/joinNewWorldMap.js";
import { logger } from "../../../utils/logger.js";

export const relocate: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  await postgres.em.populate(user, ["save"]);

  try {
    await joinNewWorldMap(user, user.save);

    ctx.status = Status.OK;
    ctx.body = {
      error: 0,
      mapheaderurl: `${BASE_URL}:${PORT}/api/bm/getnewmap`,
    };
  } catch (err) {
    logger.error("Failed to relocate MR3 base", err);
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: "Failed to relocate base. Please try again." };
  }
};
