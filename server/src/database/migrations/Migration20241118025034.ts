import { Migration } from '@mikro-orm/migrations';

export class Migration20241118025034 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `world_map_cell` add index `world_map_cell_world_id_x_y_index`(`world_id`, `x`, `y`);');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` drop index `world_map_cell_world_id_x_y_index`;');
  }

}
