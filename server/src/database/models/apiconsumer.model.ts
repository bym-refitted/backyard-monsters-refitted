import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import type { Opt } from "@mikro-orm/core";

@Entity({ tableName: "api_consumer" })
export class ApiConsumer {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "string" })
  name!: string;

  @Property({ type: "string", length: 32 })
  key_prefix!: string;

  @Property({ type: "string", length: 64, unique: true })
  key_hash!: string;

  @Property({ type: Date })
  created_at: Opt<Date> = new Date();

  @Property({ type: Date, nullable: true })
  last_used_at?: Date | null;

  @Property({ type: Date, nullable: true })
  revoked_at?: Date | null;
}
