import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { User } from "../../../models/user.model";

interface Bookmark { bookmarks: string };

/**
 * Controller to save bookmarks on the Map Room for a user.
 */
export const saveBookmarks: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  const { bookmarks } = ctx.request.body as Bookmark;

  if (!bookmarks) throw new Error("Bookmarks not found");

  user.bookmarks = { bookmarks };
  await ORMContext.em.persistAndFlush(user);

  ctx.status = 200;
  ctx.body = { error: 0 };
};
