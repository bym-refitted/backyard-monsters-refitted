import { Migration } from '@mikro-orm/migrations';

export class Migration20250803031535 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table "bym"."inferno_maproom" add column "neighbors" jsonb null, add column "neighbors_last_calculated" timestamptz(0) null;');

    this.addSql('alter table "bym"."save" add constraint save_credits_check check(credits >= 0);');

    this.addSql('drop index "bym"."save_worldid_type_userid_index";');
    this.addSql('create index "save_type_worldid_userid_index" on "bym"."save" ("type", "worldid", "userid");');
  }

  async down(): Promise<void> {
    this.addSql('alter table "bym"."inferno_maproom" drop column "neighbors";');
    this.addSql('alter table "bym"."inferno_maproom" drop column "neighbors_last_calculated";');

    this.addSql('alter table "bym"."save" drop constraint save_credits_check;');

    this.addSql('drop index "bym"."save_type_worldid_userid_index";');
    this.addSql('create index "save_worldid_type_userid_index" on "bym"."save" ("worldid", "type", "userid");');
  }

}
