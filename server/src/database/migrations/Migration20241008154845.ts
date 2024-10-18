import { Migration } from '@mikro-orm/migrations';

export class Migration20241008154845 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` modify `basename` varchar(255) not null default 0;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` modify `basename` varchar(255) not null;');
  }

}
