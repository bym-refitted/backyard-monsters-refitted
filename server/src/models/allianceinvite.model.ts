import { Entity, Index, PrimaryKey, Property } from "@mikro-orm/decorators/es";

import { AllianceInviteStatus, AllianceInviteType } from "../enums/Alliance.js";

@Entity({ tableName: "alliance_invite" })
@Index({ properties: ["alliance_id", "status"] })
@Index({ properties: ["user_id", "status"] })
export class AllianceInvite {
  @PrimaryKey({ autoincrement: true, type: "number" })
  id!: number;

  @Property({ type: "number" })
  alliance_id!: number;

  @Property({ type: "number" })
  user_id!: number;

  @Property({ type: "string" })
  type!: AllianceInviteType;

  @Property({ type: "string" })
  status: AllianceInviteStatus = AllianceInviteStatus.PENDING;

  @Property({ type: Date })
  created_at: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  updated_at: Date = new Date();
}
