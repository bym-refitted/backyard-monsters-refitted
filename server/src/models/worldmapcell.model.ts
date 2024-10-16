import {
  Entity,
  ManyToOne,
  OneToOne,
  PrimaryKey,
  Property,
} from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { World } from "./world.model";
import { Save } from "./save.model";

@Entity()
export class WorldMapCell {
  constructor(
    world?: World,
    x?: number,
    y?: number,
    terrainHeight?: number,
    optional = { base_id: BigInt(0), uid: 0, base_type: 0 }
  ) {
    this.world = world;
    this.world_id = world?.uuid;
    this.x = x;
    this.y = y;
    this.terrainHeight = terrainHeight;
    this.base_type = optional.base_type;
    this.base_id = optional.base_id;
    this.uid = optional.uid;
  }

  @FrontendKey
  @PrimaryKey()
  cellid!: number;

  @FrontendKey
  @Property()
  base_id!: bigint;

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
