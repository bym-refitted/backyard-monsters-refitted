import { Migration } from '@mikro-orm/migrations';

export class Migration20250602222711 extends Migration {

  async up(): Promise<void> {
    this.addSql('create schema if not exists "bym";');

    this.addSql('create table "bym"."attack_logs" ("id" serial primary key, "attacker_userid" int not null, "attacker_username" varchar(255) not null, "attacker_pic_square" varchar(255) null, "defender_userid" int not null, "defender_username" varchar(255) not null, "defender_pic_square" varchar(255) null, "type" varchar(255) not null, "x" int not null, "y" int not null, "loot" jsonb null, "attackreport" jsonb null, "attacktime" timestamptz(0) not null);');
    this.addSql('create index "attack_logs_defender_userid_attacktime_index" on "bym"."attack_logs" ("defender_userid", "attacktime");');
    this.addSql('create index "attack_logs_attacker_userid_attacktime_index" on "bym"."attack_logs" ("attacker_userid", "attacktime");');

    this.addSql('create table "bym"."inferno_maproom" ("userid" serial primary key, "tribedata" jsonb null, "created_at" timestamptz(0) not null, "lastupdate_at" timestamptz(0) not null);');

    this.addSql('create table "bym"."message" ("id" varchar(255) not null, "threadid" int not null, "updatetime" int not null, "userid" int not null, "targetid" int not null, "messagetype" varchar(255) not null, "user_unread" int not null, "target_unread" int not null, "message" varchar(580) null, "subject" varchar(255) not null, "reportid" varchar(255) null, "truceid" varchar(255) null, "trucestate" varchar(255) null, "migratestate" varchar(255) null, "coords" jsonb null, "worldid" varchar(255) null, "baseid" varchar(255) null, "created_at" timestamptz(0) not null, constraint "message_pkey" primary key ("id"));');
    this.addSql('create index "message_threadid_index" on "bym"."message" ("threadid");');
    this.addSql('create index "message_targetid_created_at_index" on "bym"."message" ("targetid", "created_at");');
    this.addSql('create index "message_userid_created_at_index" on "bym"."message" ("userid", "created_at");');
    this.addSql('create index "message_targetid_target_unread_index" on "bym"."message" ("targetid", "target_unread");');
    this.addSql('create index "message_userid_user_unread_index" on "bym"."message" ("userid", "user_unread");');

    this.addSql('create table "bym"."report" ("userid" serial primary key, "username" varchar(255) not null, "discord_tag" varchar(255) null, "report" jsonb null, "ban_reason" jsonb null, "violations" int not null default 0, "attack_violations" int not null default 0, "created_at" timestamptz(0) not null, "lastupdate_at" timestamptz(0) not null);');
    this.addSql('alter table "bym"."report" add constraint "report_username_unique" unique ("username");');

    this.addSql('create table "bym"."thread" ("id" varchar(255) not null, "threadid" int not null, "userid" int not null, "targetid" int not null, "last_message_id" varchar(255) null, "messagecount" int not null, "created_at" timestamptz(0) not null, constraint "thread_pkey" primary key ("id"));');
    this.addSql('create index "thread_threadid_index" on "bym"."thread" ("threadid");');
    this.addSql('alter table "bym"."thread" add constraint "thread_threadid_unique" unique ("threadid");');
    this.addSql('alter table "bym"."thread" add constraint "thread_last_message_id_unique" unique ("last_message_id");');
    this.addSql('create index "thread_targetid_threadid_index" on "bym"."thread" ("targetid", "threadid");');
    this.addSql('create index "thread_userid_threadid_index" on "bym"."thread" ("userid", "threadid");');

    this.addSql('create table "bym"."world" ("uuid" varchar(255) not null, "name" varchar(255) not null default \'\', "player_count" int not null default 0, "created_at" timestamptz(0) not null, "lastupdate_at" timestamptz(0) not null, constraint "world_pkey" primary key ("uuid"));');

    this.addSql('create table "bym"."world_map_cell" ("cellid" serial primary key, "baseid" varchar(255) not null, "world_id" varchar(255) not null, "uid" int not null, "x" int not null, "y" int not null, "base_type" int not null, "terrain_height" int not null, "world_uuid" varchar(255) not null);');
    this.addSql('create index "world_map_cell_baseid_index" on "bym"."world_map_cell" ("baseid");');
    this.addSql('create index "world_map_cell_world_id_x_y_index" on "bym"."world_map_cell" ("world_id", "x", "y");');

    this.addSql('create table "bym"."save" ("basesaveid" serial primary key, "baseid" varchar(255) not null default \'0\', "cell_cellid" int null, "homebaseid" int not null default 0, "userid" int not null, "saveuserid" int not null, "attackid" int not null default 0, "id" int not null default 0, "baseid_inferno" int not null default 0, "wmid" int not null default 0, "main_protection_time" int null, "outpost_protection_time" int null, "initial_protection_over" boolean not null default false, "initial_outpost_protection_over" boolean not null default false, "type" varchar(255) not null default \'main\', "createtime" int not null, "savetime" int not null default 0, "seed" int not null default 0, "bookmarked" int not null default 0, "fan" int not null default 0, "emailshared" int not null default 0, "unreadmessages" int not null default 0, "giftsentcount" int not null default 0, "canattack" boolean not null default false, "fbid" varchar(255) null, "fortifycellid" int not null default 0, "name" varchar(255) not null, "level" int not null default 1, "catapult" int not null default 0, "flinger" int not null default 0, "destroyed" int not null default 0, "damage" int not null default 0, "locked" int not null default 0, "points" varchar(255) not null default \'0\', "basevalue" varchar(255) not null default \'0\', "tutorialstage" int not null default 0, "protected" int not null default 1, "lastupdate" int not null default 0, "usemap" int not null default 0, "credits" int not null, "monthly_credits" int not null default 0, "champion" jsonb null default \'null\', "empiredestroyed" int not null default 0, "worldid" varchar(255) null, "event_score" int not null default 0, "chatenabled" int not null default 0, "relationship" int not null default 0, "timeplayed" int not null default 0, "version" int not null default 128, "clienttime" int not null default 0, "baseseed" int not null default 0, "healtime" int not null default 0, "empirevalue" int not null default 0, "basename" varchar(255) not null default \'basename\', "over" int not null default 0, "protect" int not null default 0, "purchasecomplete" int not null default 0, "cantmovetill" int null, "attacks" jsonb not null, "buildingkeydata" jsonb null, "buildinghealthdata" jsonb null, "buildingdata" jsonb null, "researchdata" jsonb null, "stats" jsonb null, "academy" jsonb null, "rewards" jsonb null, "aiattacks" jsonb null, "monsters" jsonb null, "resources" jsonb null, "iresources" jsonb null, "lockerdata" jsonb null, "events" jsonb null, "inventory" jsonb null, "monsterbaiter" jsonb null, "loot" jsonb null, "attackreport" text null, "storedata" jsonb null, "coords" jsonb null, "quests" jsonb null, "player" jsonb null, "krallen" jsonb null, "siege" jsonb null, "buildingresources" jsonb null, "mushrooms" jsonb null, "frontpage" jsonb null, "takeover_date" timestamptz(0) not null, "created_at" timestamptz(0) not null, "lastupdate_at" timestamptz(0) not null, "attackloot" jsonb null, "lootreport" jsonb null, "attackersiege" jsonb null, "monsterupdate" jsonb null, "savetemplate" jsonb null, "updates" jsonb null, "effects" jsonb null, "homebase" jsonb null, "outposts" jsonb null, "wmstatus" jsonb null, "chatservers" jsonb null, "achieved" jsonb null, "gifts" jsonb null, "sentinvites" jsonb null, "sentgifts" jsonb null, "fbpromos" jsonb null, "powerups" jsonb null, "attpowerups" jsonb null);');
    this.addSql('create index "save_baseid_index" on "bym"."save" ("baseid");');
    this.addSql('alter table "bym"."save" add constraint "save_cell_cellid_unique" unique ("cell_cellid");');
    this.addSql('create index "save_userid_index" on "bym"."save" ("userid");');
    this.addSql('create index "save_saveuserid_index" on "bym"."save" ("saveuserid");');
    this.addSql('create index "save_type_index" on "bym"."save" ("type");');
    this.addSql('create index "save_worldid_type_userid_index" on "bym"."save" ("worldid", "type", "userid");');

    this.addSql('create table "bym"."user" ("userid" serial primary key, "save_basesaveid" int null, "infernosave_basesaveid" int null, "username" varchar(255) not null, "banned" boolean not null default false, "email" varchar(255) not null, "password" varchar(255) not null, "discord_verified" boolean not null default false, "discord_id" varchar(255) null, "discord_tag" varchar(255) null, "last_name" varchar(255) not null default \'\', "reset_token" varchar(255) not null default \'\', "pic_square" varchar(255) null, "timeplayed" int not null default 0, "stats" jsonb null, "friendcount" int not null default 0, "sessioncount" int not null default 0, "addtime" int not null default 100, "bookmarks" jsonb null, "_is_fan" int not null default 0, "sendgift" int not null default 0, "sendinvite" int not null default 0);');
    this.addSql('alter table "bym"."user" add constraint "user_save_basesaveid_unique" unique ("save_basesaveid");');
    this.addSql('alter table "bym"."user" add constraint "user_infernosave_basesaveid_unique" unique ("infernosave_basesaveid");');
    this.addSql('alter table "bym"."user" add constraint "user_username_unique" unique ("username");');
    this.addSql('create index "user_email_index" on "bym"."user" ("email");');
    this.addSql('alter table "bym"."user" add constraint "user_email_unique" unique ("email");');

    this.addSql('alter table "bym"."thread" add constraint "thread_last_message_id_foreign" foreign key ("last_message_id") references "bym"."message" ("id") on update cascade on delete set null;');

    this.addSql('alter table "bym"."world_map_cell" add constraint "world_map_cell_world_uuid_foreign" foreign key ("world_uuid") references "bym"."world" ("uuid") on update cascade;');

    this.addSql('alter table "bym"."save" add constraint "save_cell_cellid_foreign" foreign key ("cell_cellid") references "bym"."world_map_cell" ("cellid") on update cascade on delete set null;');

    this.addSql('alter table "bym"."user" add constraint "user_save_basesaveid_foreign" foreign key ("save_basesaveid") references "bym"."save" ("basesaveid") on update cascade on delete set null;');
    this.addSql('alter table "bym"."user" add constraint "user_infernosave_basesaveid_foreign" foreign key ("infernosave_basesaveid") references "bym"."save" ("basesaveid") on update cascade on delete set null;');
  }

  async down(): Promise<void> {
    this.addSql('alter table "bym"."thread" drop constraint "thread_last_message_id_foreign";');

    this.addSql('alter table "bym"."world_map_cell" drop constraint "world_map_cell_world_uuid_foreign";');

    this.addSql('alter table "bym"."save" drop constraint "save_cell_cellid_foreign";');

    this.addSql('alter table "bym"."user" drop constraint "user_save_basesaveid_foreign";');

    this.addSql('alter table "bym"."user" drop constraint "user_infernosave_basesaveid_foreign";');

    this.addSql('drop table if exists "bym"."attack_logs" cascade;');

    this.addSql('drop table if exists "bym"."inferno_maproom" cascade;');

    this.addSql('drop table if exists "bym"."message" cascade;');

    this.addSql('drop table if exists "bym"."report" cascade;');

    this.addSql('drop table if exists "bym"."thread" cascade;');

    this.addSql('drop table if exists "bym"."world" cascade;');

    this.addSql('drop table if exists "bym"."world_map_cell" cascade;');

    this.addSql('drop table if exists "bym"."save" cascade;');

    this.addSql('drop table if exists "bym"."user" cascade;');

    this.addSql('drop schema "bym";');
  }

}
