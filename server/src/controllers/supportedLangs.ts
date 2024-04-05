import { KoaController } from "../utils/KoaController";

export const supportedLangs: KoaController = async (ctx) => {
  const languages = ["English", "Portuguese"];

  ctx.status = 200;
  ctx.body = languages;
};
