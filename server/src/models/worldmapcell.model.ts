import {
  Entity,
  Index,
  ManyToOne,
  OneToOne,
  PrimaryKey,
  Property,
} from "@mikro-orm/decorators/es";
import { FrontendKey } from "../utils/FrontendKey.js";
import { World } from "./world.model.js";
import { Save } from "./save.model.js";

@Index({ properties: ["world_id", "map_version", "x", "y"] })
@Entity({ tableName: "world_map_cell" })
export class WorldMapCell {

  constructor(world: World | undefined, x: number, y: number, terrainHeight: number | undefined) {
    this.world = world!;
    this.world_id = world?.uuid ?? "";
    this.x = x;
    this.y = y;
    this.terrainHeight = terrainHeight ?? 0;
  }

  @FrontendKey
  @PrimaryKey({ type: 'number' })
  cellid!: number;

  @Index()
  @FrontendKey
  @Property({ type: 'string' })
  baseid!: string;

  @Property({ type: 'number', default: 2 })
  map_version!: number;

  @FrontendKey
  @Property({ type: 'string' })
  world_id!: string;

  @Index()
  @FrontendKey
  @Property({ type: 'number' })
  uid!: number;

  @FrontendKey
  @Property({ type: 'number' })
  x!: number;

  @FrontendKey
  @Property({ type: 'number' })
  y!: number;

  @FrontendKey
  @Property({ type: 'number' })
  base_type!: number;

  @FrontendKey
  @Property({ type: 'number' })
  terrainHeight!: number;

  @Property({ type: Date, nullable: true })
  destroyed_at?: Date | null;

  @ManyToOne(() => World)
  world!: World;

  @OneToOne({ mappedBy: "cell", nullable: true, entity: () => Save })
  save?: Save | undefined;
}
