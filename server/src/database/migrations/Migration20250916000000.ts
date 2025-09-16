import { Migration } from "@mikro-orm/migrations";

export class Migration20250916000000 extends Migration {
  async up(): Promise<void> {
    // Add blocked_users JSONB column to user table
    this.addSql(
      'alter table "bym"."user" add column "blocked_users" jsonb not null default \'[]\'::jsonb;'
    );

    // Set default value for reportid column on message table
    this.addSql(
      'alter table "bym"."message" alter column "reportid" set default \'0\';'
    );

    // Update existing NULL reportid values to '0'
    this.addSql(
      'update "bym"."message" set "reportid" = \'0\' where "reportid" is null;'
    );

    // Add GIN index on blocked_users for efficient JSONB queries
    this.addSql(
      'create index "idx_user_blocked_users" on "bym"."user" using gin ("blocked_users");'
    );
  }

  async down(): Promise<void> {
    // Remove the GIN index
    this.addSql('drop index "bym"."idx_user_blocked_users";');

    // Remove default value from reportid column
    this.addSql(
      'alter table "bym"."message" alter column "reportid" drop default;'
    );

    // Remove blocked_users column from user table
    this.addSql('alter table "bym"."user" drop column "blocked_users";');
  }
}
