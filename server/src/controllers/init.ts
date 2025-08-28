import z from "zod";
import { devConfig } from "../config/DevSettings";
import { Status } from "../enums/StatusCodes";
import { KoaController } from "../utils/KoaController";
import { getApiVersion } from "../server";

export const InitSchema = z.object({
  apiVersion: z.string().optional(),
});

export const init: KoaController = async (ctx) => {
  const { apiVersion } = InitSchema.parse(ctx.request.body);
  const expectedVersion = getApiVersion();

  const invalidVersion = !apiVersion || apiVersion !== expectedVersion;

  if (invalidVersion) {
    const error = `Please update to the latest version. Visit our downloads page to get the latest client.`;
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error, versionMismatch: true };
    return;
  }

  ctx.status = Status.OK;
  ctx.body = { debugMode: devConfig.debugMode };
};
