import { Migration } from '@mikro-orm/migrations';

export class Migration20240902195644 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add `cell_cellid` int unsigned null;');
    this.addSql('alter table `save` add constraint `save_cell_cellid_foreign` foreign key (`cell_cellid`) references `world_map_cell` (`cellid`) on update cascade on delete set null;');
    this.addSql('alter table `save` drop `cellid`;');
    this.addSql('alter table `save` add unique `save_cell_cellid_unique`(`cell_cellid`);');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` drop foreign key `save_cell_cellid_foreign`;');

    this.addSql('alter table `save` add `cellid` int not null;');
    this.addSql('alter table `save` drop index `save_cell_cellid_unique`;');
    this.addSql('alter table `save` drop `cell_cellid`;');
  }

}
