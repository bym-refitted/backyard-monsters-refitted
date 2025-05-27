import { Migration } from '@mikro-orm/migrations';

export class Migration20250519110900 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `attack_logs` change `resources` `loot` json null;');
    this.addSql('alter table `attack_logs` add index `attack_logs_defender_userid_attacktime_index`(`defender_userid`, `attacktime`);');
    this.addSql('alter table `attack_logs` add index `attack_logs_attacker_userid_attacktime_index`(`attacker_userid`, `attacktime`);');
  }

  async down(): Promise<void> {
    this.addSql('alter table `attack_logs` drop index `attack_logs_defender_userid_attacktime_index`;');
    this.addSql('alter table `attack_logs` drop index `attack_logs_attacker_userid_attacktime_index`;');
    this.addSql('alter table `attack_logs` change `loot` `resources` json null;');
  }

}
