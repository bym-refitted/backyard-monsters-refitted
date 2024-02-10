import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";

export const homeCell = async (ctx: Context) => {
  const user: User = ctx.authUser;
  await ORMContext.em.populate(user, ["save"]);

  let save = user.save;

  /**
   * For additional details about each of the following properties
   * visit the Wiki page: 'World Map v2: Cell Object'
   */
  return {
    uid: save.userid, // ToDo: Why do we have a userId for both user and save table? Fix
    b: 2,
    fbid: save.fbid,
    pi: 0,
    bid: save.homebaseid,
    aid: 0,
    i: 139,
    mine: 1,
    f: save.flinger,
    c: save.catapult,
    t: 0,
    n: user.username,
    fr: 0,
    on: 0, // ToDo
    p: save.protected,
    r: save.resources,
    m: save.monsters,
    l: 1, // ToDo
    d: save.destroyed,
    lo: save.locked,
    dm: save.damage,
    pic_square: user.pic_square,
    im: user.pic_square,
  };
};
