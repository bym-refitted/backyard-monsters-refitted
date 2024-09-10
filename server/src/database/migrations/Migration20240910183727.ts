import { Migration } from '@mikro-orm/migrations';

export class Migration20240910183727 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` modify `tutorialstage` int not null default 0;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` modify `tutorialstage` int null default 0;');
  }

}
