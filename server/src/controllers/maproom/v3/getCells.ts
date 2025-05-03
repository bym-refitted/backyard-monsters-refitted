import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";

// This function is called when the client requests the map room cells data
export const getMapRoomCells: KoaController = async (ctx) => {
  const currentUser: User = ctx.authUser;
  await ORMContext.em.populate(currentUser, ["save"]);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [
      {
        uid: currentUser.userid,
        b: 1,
        bid: currentUser.save.baseid,
        aid: 0,
        i: 50,
        n: "Name",
        tid: 0,
        x: 50,
        y: 50,
        l: 0,
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
