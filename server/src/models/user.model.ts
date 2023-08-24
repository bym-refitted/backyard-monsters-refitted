import { Entity, Property, PrimaryKey } from "@mikro-orm/core";
import { FieldData } from "./save.model";
import { FrontendKey } from "../utils/FrontendKey";

@Entity()
export class User {
  @FrontendKey
  @PrimaryKey()
  userid!: number;

  @Property({unique:true})
  @FrontendKey
  username!: string;

  @Property()
  @FrontendKey
  last_name!: string;

  @FrontendKey
  @Property({unique:true})
  email!: string;

  @Property()
  password!: string;

  @FrontendKey
  @Property({ nullable: true })
  pic_square?: string;

  @FrontendKey
  @Property({ default: 0 })
  timeplayed?: number;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  stats?: FieldData;

  @FrontendKey
  @Property({ default: 0 })
  friendcount?: number;

  @FrontendKey
  @Property({ default: 0 })
  sessioncount?: number;

  @FrontendKey
  @Property({ default: 100 })
  addtime?: number;

  @FrontendKey
  @Property({ type: "json", nullable: true })
  bookmarks?: FieldData;

  @FrontendKey
  @Property({ default: 0 })
  _isFan?: number;

  @FrontendKey
  @Property({ default: 0 })
  sendgift?: number;
  
  @FrontendKey
  @Property({ default: 0 })
  sendinvite?: number;
}
