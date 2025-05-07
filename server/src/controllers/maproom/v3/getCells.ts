import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";

// Used to get all items on the map e.g. players, bushes, outposts, etc.
export const getMapRoomCells: KoaController = async (ctx) => {
  const currentUser: User = ctx.authUser;
  await ORMContext.em.populate(currentUser, ["save"]);

  // Each object in the array represents an item on the map
  // For example if we set `i` to 80, it will be a spikey bush and so on.
  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [
      {
        // Example of a player cell
        uid: currentUser.userid,
        b: 1,
        bid: currentUser.save.baseid,
        aid: 0,
        i: 0,
        n: "Enemy Player",
        tid: 0,
        x: 20,
        y: 20,
        l: 25,
        pl: 0,
        r: 0,
        dm: 0,
        rel: 0,
        lo: 0,
        fr: 0,
        p: 0,
        d: 0,
        t: 0,
        fbid: "",
      },
      // Example of some bushes and overgrowth
      {
        i: 80,
        x: 12,
        y: 12,
      },
      {
        i: 75,
        x: 8,
        y: 8,
      },
      {
        i: 70,
        x: 9,
        y: 12,
      },
      {
        i: 90,
        x: 10,
        y: 14,
      },
    ],
  };
};
