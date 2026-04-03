import type { EntityData, RequiredEntityData } from "@mikro-orm/core";
import type { Save } from "../models/save.model.js";
import type { User } from "../models/user.model.js";
import type { Message } from "../models/message.model.js";
import type { InfernoMaproom } from "../models/infernomaproom.model.js";
import type { World } from "../models/world.model.js";

/**
 * Plain data representation of a Save entity, used for pre-defined save templates.
 * Extends EntityData<Save> with Record<string, unknown> to allow transient fields.
 */
export type SaveData = EntityData<Save> & Record<string, unknown>;

/**
 * Plain data representation of a User entity, used for pre-defined user templates.
 */
export type UserData = RequiredEntityData<User>;

/**
 * Plain data representation of a Message entity, used for pre-defined message templates.
 */
export type MessageData = RequiredEntityData<Message>;

/**
 * Plain data representation of an InfernoMaproom entity, used for pre-defined inferno maproom templates.
 */
export type InfernoMaproomData = RequiredEntityData<InfernoMaproom>;

export type WorldData = RequiredEntityData<World>;
