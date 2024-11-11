import { Migration } from '@mikro-orm/migrations';

export class Migration20241025215137 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add `initial_outpost_protection_over` tinyint(1) not null default false;');
    this.addSql('alter table `save` change `first_week_protection_applied` `initial_protection_over` tinyint(1) not null default false;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` drop `initial_outpost_protection_over`;');
    this.addSql('alter table `save` change `initial_protection_over` `first_week_protection_applied` tinyint(1) not null default false;');
  }

}
