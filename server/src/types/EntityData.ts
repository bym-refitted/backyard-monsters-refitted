import type { EntityData } from "@mikro-orm/core";
import type { Save } from "../database/models/save.model.js";

/**
 * Plain data representation of a Save entity, used for pre-defined save templates.
 * Extends EntityData<Save> with Record<string, unknown> to allow transient fields.
 */
export type SaveData = EntityData<Save> & Record<string, unknown>;
