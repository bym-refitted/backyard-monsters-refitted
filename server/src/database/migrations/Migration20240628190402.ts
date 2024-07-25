import { Migration } from '@mikro-orm/migrations';

export class Migration20240628190402 extends Migration {

  async up(): Promise<void> {
    this.addSql('create table `world` (`uuid` varchar(255) not null, `player_count` int not null default 0, `created_at` datetime not null, `lastupdate_at` datetime not null, primary key (`uuid`)) default character set utf8mb4 engine = InnoDB;');

    this.addSql('alter table `save` drop `worldsize`;');

    this.addSql('alter table `world_map_cell` add `terrain_height` int not null, add `world_uuid` varchar(255) not null;');
    this.addSql('alter table `world_map_cell` add constraint `world_map_cell_world_uuid_foreign` foreign key (`world_uuid`) references `world` (`uuid`) on update cascade;');
    this.addSql('alter table `world_map_cell` add index `world_map_cell_world_uuid_index`(`world_uuid`);');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` drop foreign key `world_map_cell_world_uuid_foreign`;');

    this.addSql('drop table if exists `world`;');

    this.addSql('alter table `save` add `worldsize` json null;');

    this.addSql('alter table `world_map_cell` drop index `world_map_cell_world_uuid_index`;');
    this.addSql('alter table `world_map_cell` drop `terrain_height`;');
    this.addSql('alter table `world_map_cell` drop `world_uuid`;');
  }

}
