import type { SessionType } from "../enums/SessionType.js";
import type { User } from "../database/models/user.model.js";
import type { Truces } from "../services/maproom/getTruces.js";

declare module "koa" {
  interface DefaultState {
    lastSeen: Map<number, number>;
    truces: Truces;
    friends: Set<number>;
  }

  interface DefaultContext {
    authUser: User;
    meetsDiscordAgeCheck: boolean;
    sessionType: SessionType;
    sessionId: string;
  }
}

export {};
