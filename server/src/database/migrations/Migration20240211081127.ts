import { Migration } from '@mikro-orm/migrations';

export class Migration20240211081127 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `save` (`basesaveid` int unsigned not null auto_increment primary key, `baseid` varchar(255) not null, `type` varchar(255) not null, `userid` int not null, `wmid` int not null, `createtime` int not null, `savetime` int not null, `seed` int not null, `saveuserid` int not null, `bookmarked` int not null, `fan` int not null, `emailshared` int not null, `unreadmessages` int not null, `giftsentcount` int not null, `id` int not null, `canattack` tinyint(1) not null, `cellid` int not null, `baseid_inferno` int not null, `fbid` varchar(255) not null, `fortifycellid` int not null, `name` varchar(255) not null, `level` int not null, `catapult` int not null, `flinger` int not null, `destroyed` int not null, `damage` int not null, `locked` int not null, `points` int not null, `basevalue` int not null, `protected` int not null, `lastupdate` int not null, `usemap` int not null, `homebaseid` int not null, `credits` int not null, `champion` varchar(255) not null, `empiredestroyed` int not null, `worldid` varchar(255) not null, `event_score` int not null, `chatenabled` int not null, `relationship` int not null, `timeplayed` int not null, `version` int not null, `clienttime` int not null, `baseseed` int not null, `healtime` int not null, `empirevalue` int not null, `basename` varchar(255) not null, `attackreport` varchar(255) not null, `over` int not null, `protect` int not null, `attackid` int not null, `purchasecomplete` int not null, `buildingdata` json null, `buildingkeydata` json null, `researchdata` json null, `stats` json null, `academy` json null, `rewards` json null, `aiattacks` json null, `monsters` json null, `resources` json null, `lockerdata` json null, `events` json null, `inventory` json null, `monsterbaiter` json null, `loot` json null, `storedata` json null, `coords` json null, `quests` json null, `player` json null, `krallen` json null, `siege` json null, `buildingresources` json null, `mushrooms` json null, `iresources` json null, `monsterupdate` json null, `buildinghealthdata` json null, `frontpage` json null, `created_at` datetime not null, `lastupdate_at` datetime not null, `attackcreatures` json null, `attackloot` json null, `lootreport` json null, `attackersiege` json null, `savetemplate` json null, `updates` json null, `effects` json null, `homebase` json null, `outposts` json null, `worldsize` json null, `wmstatus` json null, `chatservers` json null, `achieved` json null, `attacks` json null, `gifts` json null, `sentinvites` json null, `sentgifts` json null, `attackerchampion` json null, `fbpromos` json null) default character set utf8mb4 engine = InnoDB;');

    this.addSql('create table `user` (`userid` int unsigned not null auto_increment primary key, `save_basesaveid` int unsigned null, `username` varchar(255) not null, `last_name` varchar(255) not null, `email` varchar(255) not null, `password` varchar(255) not null, `pic_square` varchar(255) null, `timeplayed` int not null default 0, `stats` json null, `friendcount` int not null default 0, `sessioncount` int not null default 0, `addtime` int not null default 100, `bookmarks` json null, `_is_fan` int not null default 0, `sendgift` int not null default 0, `sendinvite` int not null default 0) default character set utf8mb4 engine = InnoDB;');
    this.addSql('alter table `user` add unique `user_save_basesaveid_unique`(`save_basesaveid`);');
    this.addSql('alter table `user` add unique `user_username_unique`(`username`);');
    this.addSql('alter table `user` add unique `user_email_unique`(`email`);');

    this.addSql('create table `world_map_cell` (`cellid` int unsigned not null auto_increment primary key, `world_id` varchar(255) not null, `x` int not null, `y` int not null, `uid` int not null, `base_type` int not null, `base_id` int not null) default character set utf8mb4 engine = InnoDB;');

    this.addSql('alter table `user` add constraint `user_save_basesaveid_foreign` foreign key (`save_basesaveid`) references `save` (`basesaveid`) on update cascade on delete set null;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `user` drop foreign key `user_save_basesaveid_foreign`;');

    this.addSql('drop table if exists `save`;');

    this.addSql('drop table if exists `user`;');

    this.addSql('drop table if exists `world_map_cell`;');
  }

}
