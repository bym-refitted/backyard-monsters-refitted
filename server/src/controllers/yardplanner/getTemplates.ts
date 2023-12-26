import { KoaController } from "../../utils/KoaController";

export const getTemplates: KoaController = async (ctx) => {
  // ToDo: Fetch the data from the DB and return it
  ctx.status = 200;
  ctx.body = {
    error: 0,
    h: "someHashValue",
  };
};
