import { KoaController } from "../../../utils/KoaController";
import { Status } from "../../../enums/StatusCodes";

// bases = real players
// wmbases = inferno wild monsters
export const getNeighbours: KoaController = async (ctx) => {
  const wmbases = [
    {
      baseid: 1,
      level: 10,
      type: "iwm",
      description: "Inferno Base",
      wm: 1,
      friend: 0,
      pic: "",
      basename: "Moloch's Minions",
    },
  ];

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
    wmbases,
    bases,
  };
};