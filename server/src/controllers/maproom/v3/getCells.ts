import { User } from "../../../models/user.model";
import { Status } from "../../../enums/StatusCodes";
import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { EnumYardType } from "../../../enums/EnumYardType";
import { EnumBaseRelationship } from "../../../enums/EnumBaseRelationship";

// Used to get all items on the map e.g. players, bushes, outposts, etc.
export const getMapRoomCells: KoaController = async (ctx) => {
  const currentUser: User = ctx.authUser;
  await ORMContext.em.populate(currentUser, ["save"]);

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    celldata: [
      {
        // Example of a tribe
        uid: 0,
        b: EnumYardType.EMPTY,
        bid: 1234,
        n: "Abunakki",
        tid: 0,
        x: 14,
        y: 14,
        l: 25,
        pl: 0,
        r: 0,
        dm: 0,
        rel: EnumBaseRelationship.ENEMY,
        lo: 0,
        fr: 0,
        p: 0,
        d: 0,
        t: 0,
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
        i: 90,
        x: 10,
        y: 14,
      },
    ],
  };
};
