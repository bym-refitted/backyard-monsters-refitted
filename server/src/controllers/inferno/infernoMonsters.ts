import { KoaController } from "../../utils/KoaController";

export const infernoMonsters: KoaController = async ctx => {
    ctx.status = 200;
    ctx.body = {
      error: 0,
      imonsters: {},
      
      h: "someHashValue"
    };
}