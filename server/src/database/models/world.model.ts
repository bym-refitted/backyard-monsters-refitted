import {
  Entity,
  OneToMany,
  PrimaryKey,
  Property,
} from "@mikro-orm/decorators/es";
import { Collection } from "@mikro-orm/core";
import { v4 } from "uuid";
import { WorldMapCell } from "./worldmapcell.model.js";

@Entity({ tableName: "world" })
export class World {
  @PrimaryKey({ type: "string" })
  uuid: string = v4();

  @Property({ type: "string", default: "" })
  name: string = "";

  @Property({ type: "number", default: 0 })
  playerCount: number = 0;

  @Property({ type: "number", default: 2 })
  map_version: number = 2;

  @Property({ type: Date })
  createdAt: Date = new Date();

  @Property({ type: Date, onUpdate: () => new Date() })
  lastupdateAt: Date = new Date();

  @OneToMany(() => WorldMapCell, (cell) => cell.world, { orphanRemoval: true })
  cells = new Collection<WorldMapCell>(this);
}