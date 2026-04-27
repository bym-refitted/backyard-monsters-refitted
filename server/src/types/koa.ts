import type { User } from "../models/user.model.js";
import type { Truces } from "../services/maproom/getTruces.js";

declare module "koa" {
  interface DefaultState {
    lastSeen: Map<number, number>;
    truces: Truces;
  }

  interface DefaultContext {
    authUser: User;
    meetsDiscordAgeCheck: boolean;
  }
}

export {};
