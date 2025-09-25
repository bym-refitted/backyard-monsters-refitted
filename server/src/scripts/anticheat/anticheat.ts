import { Context, Next } from "koa";

/**
 * We do not provide the source for our anti-cheat module on this repository.
 * You can create your own anti-cheat system here if you wish for your own server.
 * 
 * @param {Context} _ctx - The Koa context object.
 * @param {Next} _next - The next middleware function.
 */
export const validateSave = async (_ctx: Context, _next: Next) => {}