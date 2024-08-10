import { Context } from "koa";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { calculateBaseLevel } from "../../../../services/base/calculateBaseLevel";

export const homeCell = async (ctx: Context, cell: WorldMapCell) => {
  const currentUser: User = ctx.authUser;
  const mine = currentUser.userid === cell.uid;

  const cellOwner = mine
    ? currentUser
    : await ORMContext.em.findOne(User, {
        userid: cell.uid,
      });

  await ORMContext.em.populate(cellOwner, ["save"]);
  if (!cellOwner.save) throw new Error("User save not found");

  // if home base
  // - do waht we are already doing, populate user save
  // Otherwise - get the outpost save 

  const save = cellOwner.save;

  const online = isOnline(cellOwner.save.savetime);
  const locked = online ? 1 : cellOwner.save.locked;
  let isCellProtected = cellOwner.save.protected;

  if (cellOwner.save.type === "main" && cellOwner.save.damage > 69) {
    isCellProtected = 1;
  }

  return {
    uid: cellOwner.userid,
    b: cell.base_type,
    fbid: save.fbid,
    pi: 0,
    bid: cell.base_id,
    aid: 0,
    i: cell.terrainHeight,
    mine: mine ? 1 : 0,
    f: save.flinger,
    c: save.catapult,
    t: 0,
    n: cellOwner.username,
    fr: 0,
    on: online,
    p: isCellProtected,
    r: save.resources,
    m: save.monsters,
    l: calculateBaseLevel(save.points, save.basevalue),
    d: save.damage > 90,
    lo: locked,
    dm: save.damage,
    pic_square: `https://api.dicebear.com/7.x/adventurer/png?backgroundType=solid&backgroundColor=b6e3f4,c0aede,d1d4f9&seed=${cellOwner.username}`,
    im: `https://api.dicebear.com/7.x/adventurer/png?backgroundType=solid&backgroundColor=b6e3f4,c0aede,d1d4f9&seed=${cellOwner.username}`,
  };
};

const isOnline = (timestamp = 0) => Date.now() / 1000 - timestamp < 30;
