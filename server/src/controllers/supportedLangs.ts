import { Status } from "../enums/StatusCodes";
import { KoaController } from "../utils/KoaController";

export const supportedLangs: KoaController = async (ctx) => {
  const languages = ["English", "French", "Spanish", "Portuguese"];

  ctx.status = Status.OK;
  ctx.body = languages;
};
