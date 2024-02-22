import { User } from "@sentry/node";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";

export const saveBookmarks: KoaController = async (ctx) => {
  const user: User = ctx.authUser;
  let bookmarks = ctx.request.body["bookmarks"] || null;
  if (bookmarks) {
    bookmarks = JSON.parse(bookmarks);
  }
  user.bookmarks = bookmarks;

  await ORMContext.em.persistAndFlush(user);

  ctx.status = 200;
  ctx.body = {
    error: 0,
    mapversion: 2,
  };
};
