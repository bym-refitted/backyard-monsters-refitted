import { Migration } from '@mikro-orm/migrations';

export class Migration20240908214124 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `user` modify `last_name` varchar(255) not null default \'\';');
  }

  async down(): Promise<void> {
    this.addSql('alter table `user` modify `last_name` varchar(255) not null;');
  }

}
