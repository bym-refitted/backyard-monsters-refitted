import { Migration } from '@mikro-orm/migrations';

export class Migration20230717204930 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `save` (`basesaveid` integer not null primary key autoincrement, `basevalue` integer not null, `timeplayed` integer not null, `flinger` integer not null, `baseid` integer not null, `catapult` integer not null, `version` integer not null, `clienttime` integer not null, `baseseed` integer not null, `damage` integer not null, `healtime` integer not null, `points` integer not null, `empirevalue` integer not null, `created_at` datetime not null, `lastupdate` datetime not null, `buildingdata` json null);');
  }

}
