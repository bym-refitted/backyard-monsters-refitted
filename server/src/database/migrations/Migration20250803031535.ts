import { Migration } from "@mikro-orm/migrations";

export class Migration20250803031535 extends Migration {
  async up(): Promise<void> {
    // Drop the existing composite index with suboptimal column order
    this.addSql('drop index "bym"."save_worldid_type_userid_index";');

    // Create new composite index with optimized column order for neighbor queries
    this.addSql(
      'create index "save_type_worldid_userid_index" on "bym"."save" ("type", "worldid", "userid");'
    );

    // Set worldid on all inferno saves to match their user's main save worldid
    this.addSql(
      'update "bym"."save" as inferno_save set worldid = (select main_save.worldid from "bym"."save" as main_save where main_save.userid = inferno_save.userid and main_save.type = \'main\') where inferno_save.type = \'inferno\';'
    );

    // Add neighbors cache column and timestamp column to inferno_maproom
    this.addSql(
      'alter table "bym"."inferno_maproom" add column "neighbors" jsonb not null default (\'[]\'), add column "neighbors_last_calculated" timestamptz(0) null;'
    );

    // Make x and y in attack logs nullable for Inferno attacks
    this.addSql(
      'alter table "bym"."attack_logs" alter column "x" drop not null, alter column "y" drop not null;'
    );

    this.addSql(
      'alter table "bym"."save" add constraint save_credits_check check(credits >= 0);'
    );
  }

  async down(): Promise<void> {
    // Reverse the attack_logs column changes
    this.addSql(
      'alter table "bym"."attack_logs" alter column "x" set not null, alter column "y" set not null;'
    );

    // Drop the inferno_maproom columns
    this.addSql('alter table "bym"."inferno_maproom" drop column "neighbors";');
    this.addSql(
      'alter table "bym"."inferno_maproom" drop column "neighbors_last_calculated";'
    );

    // Note: Cannot easily reverse the UPDATE query that set worldid on inferno saves
    // This would require storing the original worldid values before the update

    // Reverse the index changes
    this.addSql('drop index "bym"."save_type_worldid_userid_index";');
    this.addSql(
      'create index "save_worldid_type_userid_index" on "bym"."save" ("worldid", "type", "userid");'
    );

    this.addSql('alter table "bym"."save" drop constraint save_credits_check;');
  }
}
