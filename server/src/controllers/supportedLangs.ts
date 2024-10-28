import { STATUS } from "../enums/StatusCodes";
import { KoaController } from "../utils/KoaController";

export const supportedLangs: KoaController = async (ctx) => {
  const languages = ["English", "French", "Spanish", "Portuguese"];

  ctx.status = STATUS.OK;
  ctx.body = languages;
};
