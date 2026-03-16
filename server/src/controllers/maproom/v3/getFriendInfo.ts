import { Status } from "../../../enums/StatusCodes.js";
import type { KoaController } from "../../../utils/KoaController.js";

/**
 * Returns the list of friends currently in Map Room 3 for the relocation popup.
 * Friend-based relocation is not yet implemented — returns an empty list,
 * which the client handles gracefully by hiding the friend selection UI.
 */
export const getFriendInfo: KoaController = async (ctx) => {
  ctx.status = Status.OK;
  ctx.body = { error: 0, friends: [] };
};
