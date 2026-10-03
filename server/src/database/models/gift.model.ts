import { Entity, Index, ManyToOne, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { User } from "./user.model.js";

@Entity({ tableName: "gift" })
@Index({ properties: ["recipient", "claimed_at"] })
@Index({ properties: ["sender", "acknowledged_at"] })
@Index({ properties: ["sender", "recipient", "created_at"] })
export class Gift {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @ManyToOne(() => User, { fieldName: "sender_id", deleteRule: "cascade" })
  sender!: User;

  @ManyToOne(() => User, { fieldName: "recipient_id", deleteRule: "cascade" })
  recipient!: User;

  @Property({ type: Date })
  created_at: Date = new Date();

  @Property({ type: Date, nullable: true })
  claimed_at?: Date | null;

  @Property({ type: Date, nullable: true })
  acknowledged_at?: Date | null;
}
