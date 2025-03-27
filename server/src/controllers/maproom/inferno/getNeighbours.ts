import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";

// Tribes scale with the player's current level.
// The 'wmstatus' field on the inferno save is used to fetch the tribe data.
// TODO: Figure out the baseid for these tribes, due to conflicts with real player bases
export const getNeighbours: KoaController = async (ctx) => {
  // TODO: Create a system for getting a group of real player bases
  const bases = [
    {
      baseid: 2,
      level: 15,
      type: "inferno",
      description: "Inferno Base",
      wm: 0,
      friend: 0,
      pic: "",
      basename: "User",
      saved: Math.floor(Date.now() / 1000),
    },
  ];

  ctx.status = Status.OK;
  ctx.body = {
    error: 0,
    wmbases: [],
    bases: [],
  };
};
