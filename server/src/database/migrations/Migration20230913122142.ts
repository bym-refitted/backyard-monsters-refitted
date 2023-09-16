import { Migration } from '@mikro-orm/migrations';

export class Migration20230913122142 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` rename column `userid` to `user_userid`;');
    this.addSql('create unique index `save_user_userid_unique` on `save` (`user_userid`);');
  }

}
