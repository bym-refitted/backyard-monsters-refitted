import { Migration } from '@mikro-orm/migrations';

export class Migration20230913115627 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add column `user_userid` integer not null constraint `save_user_userid_foreign` references `user` (`userid`) on update cascade;');
    this.addSql('create unique index `save_user_userid_unique` on `save` (`user_userid`);');
  }

}
