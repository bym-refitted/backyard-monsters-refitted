import { Context, Next } from "koa";

/**
 * We do not provide the source for our anti-cheat module on this repository.
 * You can create your own anti-cheat system here if you wish for your own server.
 * 
 * @param {Context} ctx - The Koa context object.
 * @param {Next} next - The next middleware function.
 */
export const anticheat = async (ctx: Context, next: Next) => {}