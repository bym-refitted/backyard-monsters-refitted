import { Migration } from "@mikro-orm/migrations";

/**
 * Migration to create the "truce" table in the database.
 * This table will store information about truces between users, including the initiator, recipient, status, expiration time, and creation time.
 */
export class Migration20260427_CreateTruceTable extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      CREATE TABLE bym.truce (
        id SERIAL PRIMARY KEY,
        initiator_userid INTEGER NOT NULL,
        recipient_userid INTEGER NOT NULL,
        status VARCHAR(10) NOT NULL DEFAULT 'requested',
        expires_at BIGINT,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);

    await this.execute(`
      CREATE INDEX truce_initiator_userid_status_idx ON bym.truce (initiator_userid, status)
    `);

    await this.execute(`
      CREATE INDEX truce_recipient_userid_status_idx ON bym.truce (recipient_userid, status)
    `);
  }
}
