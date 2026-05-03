import z from "zod";
import { devConfig } from "../config/GameConfig.js";
import { Status } from "../enums/StatusCodes.js";
import type { KoaController } from "../utils/KoaController.js";
import { getAndroidVersion, getGameVersion } from "../config/VersionManifestConfig.js";

export const InitSchema = z.object({
  apiVersion: z.string().optional().default(""),
});

export const init: KoaController = async (ctx) => {
  const { apiVersion } = InitSchema.parse(ctx.request.body);
  const validVersions = [getGameVersion(), getAndroidVersion()].filter(Boolean);

  if (validVersions.length > 0 && !validVersions.includes(apiVersion)) {
    ctx.status = Status.INTERNAL_SERVER_ERROR;
    ctx.body = { error: `Please update to the latest version. Visit our downloads page to get the latest client.`, versionMismatch: true };
    return;
  }

  ctx.status = Status.OK;
  ctx.body = { debugMode: devConfig.debugMode };
};
