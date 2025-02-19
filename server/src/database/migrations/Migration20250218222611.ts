import { Migration } from '@mikro-orm/migrations';

export class Migration20250218222611 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `world_map_cell` add `baseid` varchar(255) not null;');
    this.addSql('alter table `world_map_cell` drop `base_id`;');

    this.addSql('alter table `save` modify `baseid` varchar(255) not null default \'0\';');
  }

  async down(): Promise<void> {
    this.addSql('alter table `world_map_cell` add `base_id` bigint not null;');
    this.addSql('alter table `world_map_cell` drop `baseid`;');

    this.addSql('alter table `save` modify `baseid` bigint not null default 0;');
  }

}
