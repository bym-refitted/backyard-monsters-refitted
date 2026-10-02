import { Entity, Index, ManyToOne, PrimaryKey, Property, Unique } from "@mikro-orm/decorators/es";

import { FriendshipStatus } from "../../enums/Friend.js";
import { User } from "./user.model.js";

const FRIENDSHIP_PAIR_UNIQUE = `
  CREATE UNIQUE INDEX IF NOT EXISTS friendship_pair_unique
  ON bym.friendship (LEAST(requester_id, recipient_id), GREATEST(requester_id, recipient_id))
`;

@Entity({ tableName: "friendship" })
@Index({ properties: ["requester", "status"] })
@Index({ properties: ["recipient", "status"] })
@Unique({ name: "friendship_pair_unique", expression: FRIENDSHIP_PAIR_UNIQUE })
export class Friendship {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @ManyToOne(() => User, { fieldName: "requester_id", deleteRule: "cascade" })
  requester!: User;

  @ManyToOne(() => User, { fieldName: "recipient_id", deleteRule: "cascade" })
  recipient!: User;

  @Property({ type: "string" })
  status: FriendshipStatus = FriendshipStatus.PENDING;

  @Property({ type: Date })
  created_at: Date = new Date();

  @Property({ type: Date, nullable: true })
  responded_at?: Date | null;
}
