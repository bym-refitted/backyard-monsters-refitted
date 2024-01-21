import { KoaController } from "../../utils/KoaController";

export const relocate: KoaController = async (ctx) => {
  ctx.status = 200;
  ctx.body = {
    error: 0,
    mapheaderurl: "http://localhost:3001/api/bm/getnewmap" // Reminder: put in ENV
  };
};
