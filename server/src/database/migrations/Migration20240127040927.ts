import { Migration } from '@mikro-orm/migrations';

export class Migration20240127040927 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` modify `homebaseid` int not null;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` modify `homebaseid` bigint not null;');
  }

}
