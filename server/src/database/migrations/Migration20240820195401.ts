import { Migration } from '@mikro-orm/migrations';

export class Migration20240820195401 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `world_map_cell` modify `uid` int not null default 0, modify `base_type` int not null default 0, modify `base_id` int not null default 0;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` modify `uid` int not null, modify `base_type` int not null, modify `base_id` int not null;');
  }

}
