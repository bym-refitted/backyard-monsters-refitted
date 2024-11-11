import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";

export const getMapRoomCells: KoaController = async (ctx) => {
  const user : User = ctx.authUser;
  const uid = user.userid;

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [
      {
        n: "Anonymous",
        uid,
        bid: 1234, // base ID
        tid: 0, // wild monster tribe ID
        x: 50, // base x-coord
        y: 50, // base y-coord
        aid: 0,
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
        // Investigate 'b' and 'i' called in MapRoom3Cell - Setup()
        b: 50,
        i: 50,
      },
    ],
  };
};
