import { Migration } from '@mikro-orm/migrations';

export class Migration20230706233038 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `save` (`id` integer not null primary key autoincrement, `basevalue` integer not null, `timeplayed` integer not null, `flinger` integer not null, `basesaveid` integer not null, `baseid` integer not null, `catapult` integer not null, `h` text not null, `version` integer not null, `clienttime` integer not null, `baseseed` integer not null, `damage` integer not null, `healtime` integer not null, `points` integer not null, `lastupdate` integer not null, `empirevalue` integer not null, `hn` integer not null);');
  }

}
