import { Migration } from '@mikro-orm/migrations';

export class Migration20230913121808 extends Migration {

  async up(): Promise<void> {
    this.addSql('drop index `save_user_userid_unique`;');
    this.addSql('alter table `save` rename column `user_userid` to `userid`;');
  }

}
