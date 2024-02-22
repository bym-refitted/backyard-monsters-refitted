import { Entity, PrimaryKey, Property } from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";

@Entity()
export class WorldMapCell {
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
}