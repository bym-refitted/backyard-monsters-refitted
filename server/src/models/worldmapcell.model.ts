import { Entity, ManyToOne, PrimaryKey, Property } from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { World } from "./world.model";

@Entity()
export class WorldMapCell {
  // TODO: make not nullable
  constructor(world?: World, x?: number, y?: number, terrainHeight?: number) {
    this.world = world;
    this.world_id = world.uuid;
    this.x = x;
    this.y = y;
    this.terrainHeight = terrainHeight;
    this.base_type = 0;
    this.base_id = 0;
    this.uid = 0;
  }

  @FrontendKey
  @PrimaryKey()
  cell_id!: number;

  @FrontendKey
  @Property()
  world_id!: string;

  @FrontendKey
  @Property()
  x!: number;

  @FrontendKey
  @Property()
  y!: number;

  @FrontendKey
  @Property()
  uid!: number;

  @FrontendKey
  @Property()
  base_type!: number;

  @FrontendKey
  @Property()
  base_id!: number;

  @FrontendKey
  @Property()
  terrainHeight!: number;

  @ManyToOne(() => World)
  world!: World;
}
