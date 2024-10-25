import { Migration } from '@mikro-orm/migrations';

export class Migration20241025210540 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add `first_week_protection_applied` tinyint(1) not null default false;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` drop `first_week_protection_applied`;');
  }

}
