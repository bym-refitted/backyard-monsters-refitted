import { Migration } from '@mikro-orm/migrations';

export class Migration20230910213750 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `save` (`basesaveid` integer not null primary key autoincrement, `basevalue` integer not null, `timeplayed` integer not null, `flinger` integer not null, `baseid` integer not null, `catapult` integer not null, `version` integer not null, `clienttime` integer not null, `baseseed` integer not null, `damage` integer not null, `healtime` integer not null, `points` integer not null, `empirevalue` integer not null, `buildingdata` json null, `researchdata` json null, `stats` json null, `rewards` json null, `aiattacks` json null, `monsters` json null, `resources` json null, `lockerdata` json null, `events` json null, `inventory` json null, `monsterbaiter` json null, `mushrooms` json null, `monsterupdate` json null, `buildinghealthdata` json null, `frontpage` json null, `created_at` datetime not null, `lastupdate` datetime not null);');

    this.addSql('create table `user` (`userid` integer not null primary key autoincrement, `username` text not null, `last_name` text not null, `email` text not null, `password` text not null, `pic_square` text null, `timeplayed` integer not null default 0, `stats` json null, `friendcount` integer not null default 0, `sessioncount` integer not null default 0, `addtime` integer not null default 100, `bookmarks` json null, `_is_fan` integer not null default 0, `sendgift` integer not null default 0, `sendinvite` integer not null default 0);');
    this.addSql('create unique index `user_username_unique` on `user` (`username`);');
    this.addSql('create unique index `user_email_unique` on `user` (`email`);');
  }

}
