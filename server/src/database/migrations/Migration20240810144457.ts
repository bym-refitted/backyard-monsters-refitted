import { Migration } from '@mikro-orm/migrations';

export class Migration20240810144457 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `world` (`uuid` varchar(255) not null, `player_count` int not null default 0, `created_at` datetime not null, `lastupdate_at` datetime not null, primary key (`uuid`)) default character set utf8mb4 engine = InnoDB;');

    this.addSql('create table `world_map_cell` (`cell_id` int unsigned not null auto_increment primary key, `world_id` varchar(255) not null, `x` int not null, `y` int not null, `uid` int not null, `base_type` int not null, `base_id` int not null, `terrain_height` int not null, `world_uuid` varchar(255) not null) default character set utf8mb4 engine = InnoDB;');
    this.addSql('alter table `world_map_cell` add index `world_map_cell_world_uuid_index`(`world_uuid`);');

    this.addSql('alter table `world_map_cell` add constraint `world_map_cell_world_uuid_foreign` foreign key (`world_uuid`) references `world` (`uuid`) on update cascade;');

    this.addSql('alter table `save` drop `worldsize`;');

    this.addSql('alter table `user` modify `last_name` varchar(255) not null;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` drop foreign key `world_map_cell_world_uuid_foreign`;');

    this.addSql('drop table if exists `world`;');

    this.addSql('drop table if exists `world_map_cell`;');

    this.addSql('alter table `save` add `worldsize` json null;');

    this.addSql('alter table `user` modify `last_name` varchar(255) not null default \'\';');
  }

}
