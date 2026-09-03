import { BigIntType } from "@mikro-orm/core";
import { Entity, Index, ManyToOne, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { AllianceMessageType } from "../enums/AllianceMessage.js";
import { User } from "./user.model.js";

@Entity({ tableName: "alliance_message" })
@Index({ properties: ["alliance_id", "id"] })
export class AllianceMessage {
  @PrimaryKey({ type: new BigIntType("number"), autoincrement: true })
  id!: number;

  @Property({ type: "number" })
  alliance_id!: number;

  @ManyToOne(() => User, { fieldName: "user_id" })
  author!: User;

  @Property({ type: "string" })
  type: AllianceMessageType = AllianceMessageType.MESSAGE;

  @Property({ type: "string" })
  body: string = "";

  @Property({ type: Date })
  created_at: Date = new Date();
}
