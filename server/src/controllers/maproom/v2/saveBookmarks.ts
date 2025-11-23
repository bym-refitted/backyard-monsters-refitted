import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { postgres } from "../../../server";
import { User } from "../../../models/user.model";

interface Bookmark { bookmarks: string };

/**
 * Controller to save bookmarks on the Map Room for a user.
 * Updates the user's bookmarks in the database and returns a success response.
 * 
 * @param {Context} ctx - The Koa context object
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if bookmarks are not found in the request body.
 */
export const saveBookmarks: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { bookmarks } = ctx.request.body as Bookmark;

  if (!bookmarks) throw new Error("Bookmarks not found");

  user.bookmarks = JSON.parse(bookmarks);
  await postgres.em.persistAndFlush(user);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
