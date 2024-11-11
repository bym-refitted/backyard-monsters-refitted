import { Context, Next } from "koa";

/**
 * A type representing a Koa controller function.
 *
 * @param {Context} ctx - The Koa context object.
 * @param {Next} [next] - The Koa next middleware function.
 * @returns {Promise<void>} A promise that resolves when the controller has finished processing.
 */
export type KoaController = (ctx: Context, next?: Next) => Promise<void>;
