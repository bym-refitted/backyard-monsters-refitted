import { Migration } from "@mikro-orm/migrations";

export class AddDiscordAvatarCheckedAtToUser extends Migration {
  async up(): Promise<void> {
    this.addSql(`
      ALTER TABLE "bym"."user"
        ADD COLUMN IF NOT EXISTS "discord_avatar_checked_at" timestamptz NULL;
    `);
  }
}
