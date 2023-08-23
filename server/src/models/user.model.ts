import { Entity, Property, PrimaryKey } from "@mikro-orm/core";
import { FieldData } from "./save.model";

@Entity()
export class User {
  @PrimaryKey()
  userid!: number;

  @Property()
  username!: string;

  @Property()
  last_name!: string;

  @Property()
  email!: string;

  @Property()
  password!: string;

  @Property()
  pic_square!: string;

  @Property()
  app_id!: string;

  @Property()
  tpid!: string;

  @Property()
  timeplayed?: number;

  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @Property()
  friendcount?: number;

  @Property()
  sessioncount?: number;

  @Property()
  addtime?: number;

  @Property({ type: "json", nullable: true })
  bookmarks?: FieldData;

  @Property()
  _isFan?: number;

  @Property()
  sendgift?: number;

  @Property()
  sendinvite?: number;
}
