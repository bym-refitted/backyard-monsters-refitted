import { Context, Next } from "koa";
import {getApiVersion} from "../server";
import { STATUS } from "../enums/StatusCodes";

export const apiVersion = async (ctx: Context, next: Next) => {
    const apiVersion = ctx.params.apiVersion;
    const expectedApiVersion = getApiVersion();
    // console.log("apiVersion from ctx", expectedApiVersion);
    // Check if the apiVersion is valid
    if (process.env.USE_VERSION_MANAGEMENT === "enabled" && apiVersion !== expectedApiVersion) {
        ctx.status = STATUS.BAD_REQUEST;
        ctx.body = { error: `Invalid API version. Expected: ${expectedApiVersion}, Recieved: ${apiVersion}` };
        return;
    }

    // If the apiVersion is valid, continue to the next middleware
    await next();
}