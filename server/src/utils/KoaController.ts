import { Context, Next } from 'koa';

export type KoaController = (ctx: Context, next?: Next) => Promise<void>;