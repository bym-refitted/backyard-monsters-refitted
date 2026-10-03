import { Entity, Index, ManyToOne, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { User } from "./user.model.js";

@Entity({ tableName: "base_update" })
@Index({ properties: ["baseid", "delivered_at"] })
export class BaseUpdate {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "string" })
  baseid!: string;

  @ManyToOne(() => User, { fieldName: "sender_id", deleteRule: "cascade" })
  sender!: User;

  @Property({ type: "string" })
  opcode!: string;

  @Property({ type: "json", columnType: "jsonb" })
  data!: unknown[];

  @Property({ type: Date })
  created_at: Date = new Date();

  @Property({ type: Date, nullable: true })
  delivered_at?: Date | null;
}
