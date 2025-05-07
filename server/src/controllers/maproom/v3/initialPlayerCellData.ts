import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { calculateBaseLevel } from "../../../services/base/calculateBaseLevel";

// Used to get the data of the current player cell
export const initialPlayerCellData: KoaController = async (ctx) => {
  const currentUser: User = ctx.authUser;
  await ORMContext.em.populate(currentUser, ["save"]);

  const points = currentUser.save.points;
  const basevalue = currentUser.save.basevalue;
  const baseLevel = calculateBaseLevel(points, basevalue);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [
      {
        uid: currentUser.userid,
        b: 3,
        bid: currentUser.save.baseid,
        x: 10,
        y: 10,
        aid: 0,
        i: 0,
        n: "Me",
        tid: 0,
        l: baseLevel,
        pl: 0,
        r: 0,
        dm: 0,
        rel: 7,
        lo: 0,
        fr: 0,
        p: 0,
        d: 0,
        t: 0,
        fbid: "",
      },
    ],
  };
};
