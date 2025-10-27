import {
  Entity,
  Index,
  ManyToOne,
  OneToOne,
  PrimaryKey,
  Property,
} from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { World } from "./world.model";
import { Save } from "./save.model";

@Index({ properties: ["world_id", "map_version", "x", "y"] })
@Entity({ tableName: "world_map_cell" })
export class WorldMapCell {
  
  constructor(world?: World, x?: number, y?: number, terrainHeight?: number) {
    this.world = world;
    this.world_id = world?.uuid;
    this.x = x;
    this.y = y;
    this.terrainHeight = terrainHeight;
  }

  @FrontendKey
  @PrimaryKey()
  cellid!: number;

  @Index()
  @FrontendKey
  @Property()
  baseid!: string;

  @Property({ default: 2 })
  map_version!: number;

  @FrontendKey
  @Property()
  world_id!: string;

  @FrontendKey
  @Property()
  uid!: number;

  @FrontendKey
  @Property()
  x!: number;

  @FrontendKey
  @Property()
  y!: number;

  @FrontendKey
  @Property()
  base_type!: number;

  @FrontendKey
  @Property()
  terrainHeight!: number;

  @ManyToOne(() => World)
  world!: World;

  @OneToOne({ mappedBy: "cell", nullable: true, entity: () => Save })
  save: Save;
}
