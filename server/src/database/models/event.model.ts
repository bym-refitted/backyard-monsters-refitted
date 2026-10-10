import { Entity, PrimaryKey, Property, Unique } from "@mikro-orm/decorators/es";
import type { Opt } from "@mikro-orm/core";

import { GameEvent } from "../../enums/GameEvent.js";

@Entity({ tableName: "event" })
@Unique({ properties: ["userid", "event", "start_time"] })
export class Event {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "number" })
  userid!: number;

  @Property({ type: "string" })
  event!: GameEvent;

  @Property({ type: "number" })
  start_time!: number;

  @Property({ type: "number" })
  score: Opt<number> = 0;

  @Property({ type: Date, onUpdate: () => new Date() })
  updated_at: Opt<Date> = new Date();
}
