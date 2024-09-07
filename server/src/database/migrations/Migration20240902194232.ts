import { Migration } from '@mikro-orm/migrations';

export class Migration20240902194232 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `world_map_cell` drop primary key;');
    this.addSql('alter table `world_map_cell` change `cell_id` `cellid` int unsigned auto_increment not null;');
    this.addSql('alter table `world_map_cell` add primary key `world_map_cell_pkey`(`cellid`);');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` drop primary key;');
    this.addSql('alter table `world_map_cell` change `cellid` `cell_id` int unsigned auto_increment not null;');
    this.addSql('alter table `world_map_cell` add primary key `world_map_cell_pkey`(`cell_id`);');
  }

}
