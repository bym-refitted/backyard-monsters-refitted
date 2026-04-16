import type { User } from "../models/user.model.js";

declare module "koa" {
  interface DefaultContext {
    authUser: User;
    meetsDiscordAgeCheck: boolean;
  }
}

export {};
