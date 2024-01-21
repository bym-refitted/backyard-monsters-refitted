import { KoaController } from "../../utils/KoaController";

export const mapRoomVersion: KoaController = async (ctx) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    version: 3
  };
};

export const initMapRoom: KoaController = async (ctx) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    celldata: [
      {
        x: 500,
        y: 500,
      },
    ]
  };
};
