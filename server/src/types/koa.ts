import type { User } from "../models/user.model.js";

declare module "koa" {
  interface DefaultState {
    lastSeen: Map<number, number>;
  }

  interface DefaultContext {
    authUser: User;
    meetsDiscordAgeCheck: boolean;
  }
}

export {};
