import { KoaController } from "../utils/KoaController";

export const updateSaved: KoaController = async ctx => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    baseid: 1234,
    version: 128,
    lastupdate: 0,
    type: "build",
    flags: {
      viximo: 0,
      kongregate: 1,
      showProgressBar: 0,
      midgameIncentive: 0,
      plinko: 0,
      fanfriendbookmarkquests: 0,
    },
    h: "someHashValue",
  };
};
