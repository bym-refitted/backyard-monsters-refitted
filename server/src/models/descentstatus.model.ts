import { Entity, PrimaryKey, Property } from "@mikro-orm/core";
import { FrontendKey } from "../utils/FrontendKey";
import { json } from "body-parser";


@Entity()
export class DescentStatus {
    @FrontendKey
    @PrimaryKey()
    userid!: number

    @FrontendKey
    @Property({type: "json", nullable: true})
    wmstatus!: number[][]
}