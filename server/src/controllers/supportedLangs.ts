import { Status } from "../enums/StatusCodes";
import { KoaController } from "../utils/KoaController";

/**
 * Controller to handle the retrieval of supported languages.
 * 
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 */
export const supportedLangs: KoaController = async (ctx) => {
  const languages = ["English", "French", "Spanish", "Portuguese"];

  ctx.status = Status.OK;
  ctx.body = languages;
};
