import { Migration } from '@mikro-orm/migrations';

export class Migration20250520135801 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add `monthly_credits` int not null default 0;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` drop `monthly_credits`;');
  }

}
