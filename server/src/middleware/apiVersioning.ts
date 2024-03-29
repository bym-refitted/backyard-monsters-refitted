import { Context, Next } from "koa";


export const apiVersioningMiddleware = async (ctx: Context, next: Next) => {
    // Write me a middleware that will check the version of the API from :apiVersion in the URL
    const apiVersion = ctx.params.apiVersion;
    // console.log("apiVersion from params",apiVersion);
    // console.log("apiVersion from ctx",ctx.globalApiVersion);

    // Check if the apiVersion is valid
    if (process.env.USE_VERSION_MANAGEMENT === "enabled" && apiVersion !== ctx.globalApiVersion) {
        ctx.status = 400;
        ctx.body = { error: `Invalid API version. Expected: ${ctx.globalApiVersion}, Recieved: ${apiVersion}` };
        return;
    }

    // If the apiVersion is valid, continue to the next middleware
    return next();
}