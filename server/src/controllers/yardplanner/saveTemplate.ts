import { KoaController } from "../../utils/KoaController";

export const saveTemplate: KoaController = async ctx => {
  // ToDo: Save the data to the DB
    ctx.status = 200;
    ctx.body = {
      error: 0,
      h: "someHashValue"
    };
}