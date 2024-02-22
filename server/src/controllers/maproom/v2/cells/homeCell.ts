import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { Save } from "../../../../models/save.model";

export const homeCell = async (ctx: Context, cell: WorldMapCell) => {
  let user: User = ctx.authUser;


  let save: Save;
  let mine = user.userid === cell.uid;
  user = await ORMContext.em.findOne(User, {
    userid: cell.uid
  })
  save = await ORMContext.em.findOne(Save, {
    baseid: cell.base_id.toString(),
  })

  /**
   * For additional details about each of the following properties
   * visit the Wiki page: 'World Map v2: Cell Object'
   */

  const online = isOnline(save.savetime);
  let bProtect = save.damage > 69 // noice
  if (save.type === "outpost" && bProtect) {
    bProtect = false;
  }

  let base = null;
  if (save && user) {
    base = {
      uid: user.userid, // ToDo: Why do we have a userId for both user and save table? Fix
      b: cell.base_type,
      fbid: save.fbid,
      pi: 0,
      bid: save.baseid,
      aid: 0,
      i: 139,
      mine: mine,
      f: save.flinger,
      c: save.catapult,
      t: 0,
      n: user.username,
      fr: 0,
      on: online, // ToDo
      p: bProtect,
      r: save.resources,
      m: save.monsters,
      l: 1, // ToDo
      d: save.damage > 90,
      lo: save.locked,
      dm: save.damage,
      pic_square: `https://api.dicebear.com/7.x/adventurer/png?backgroundType=solid&backgroundColor=b6e3f4,c0aede,d1d4f9&seed=${user.username}`,
      im: `https://api.dicebear.com/7.x/adventurer/png?backgroundType=solid&backgroundColor=b6e3f4,c0aede,d1d4f9&seed=${user.username}`,
    }
  }

  return base;
};

function isOnline(timestamp: number) {
  // Get the current timestamp in seconds
  const currentTimestamp = Math.floor(Date.now() / 1000);

  // Calculate the difference in seconds
  const difference = currentTimestamp - timestamp;

  // Check if the difference is 30 seconds or more
  return difference < 30;
}
