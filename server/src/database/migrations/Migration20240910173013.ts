import { Migration } from '@mikro-orm/migrations';

export class Migration20240910173013 extends Migration {

  async up(): Promise<void> {
    this.addSql('alter table `save` add `tutorialstage` int not null;');
  }

  async down(): Promise<void> {
    this.addSql('alter table `save` drop `tutorialstage`;');
  }

}
