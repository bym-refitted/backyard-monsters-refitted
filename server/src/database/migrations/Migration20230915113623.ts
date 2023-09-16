import { Migration } from '@mikro-orm/migrations';

export class Migration20230915113623 extends Migration {

  async up(): Promise<void> {
    this.addSql('drop index `save_user_userid_unique`;');

    this.addSql('alter table `user` add column `save_basesaveid` integer not null constraint `user_save_basesaveid_foreign` references `save` (`basesaveid`) on update cascade;');
    this.addSql('create unique index `user_save_basesaveid_unique` on `user` (`save_basesaveid`);');
  }

}
