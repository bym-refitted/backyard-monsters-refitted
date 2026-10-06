import { Migration } from "@mikro-orm/migrations";

/**
 * Adds retaliations_owed to bym.neighbour_attack: how many times the defender
 * on a row may still hit back at its attacker, who struck from too far below
 * for the defender to attack them otherwise.
 */
export class AddRetaliationsOwedToNeighbourAttack extends Migration {
  async up(): Promise<void> {
    await this.execute(`
      ALTER TABLE bym.neighbour_attack
      ADD COLUMN IF NOT EXISTS retaliations_owed INTEGER NOT NULL DEFAULT 0
    `);
  }
}
