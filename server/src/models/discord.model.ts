import { Entity, Property, PrimaryKey, Index } from "@mikro-orm/core";

@Entity()
export class DiscordVerified {
  @PrimaryKey({ autoincrement: true })
  userid!: number;

  @Property()
  username!: string;

  @Index()
  @Property({ unique: true })
  email!: string;

  @Property({ unique: true })
  discord_id!: string;

  @Property()
  discord_tag!: string;
}
