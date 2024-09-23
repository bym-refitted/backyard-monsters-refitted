import { Migration } from '@mikro-orm/migrations';

export class Migration20240923011902 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `user` add `reset_token` varchar(255) not null default \'\';');
  }

  async down(): Promise<void> {
    this.addSql('alter table `user` drop `reset_token`;');
  }

}
