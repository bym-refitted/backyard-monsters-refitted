import { Migration } from '@mikro-orm/migrations';

export class Migration20241014235341 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` modify `points` bigint not null default 0, modify `basevalue` bigint not null default 0;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` modify `points` int not null default 0, modify `basevalue` int not null default 0;');
  }

}
