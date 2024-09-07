import { Collection, Entity, OneToMany, PrimaryKey, Property } from "@mikro-orm/core";
import { v4 } from "uuid";
import { WorldMapCell } from "./worldmapcell.model";

@Entity()
export class World {
  @PrimaryKey()
  uuid = v4();

  @Property()
  playerCount: number = 0;

  @Property()
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  @OneToMany(() => WorldMapCell, cell => cell.world, { orphanRemoval: true })
  cells = new Collection<WorldMapCell>(this);
}