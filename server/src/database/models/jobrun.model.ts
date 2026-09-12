import { Entity, PrimaryKey, Property } from "@mikro-orm/decorators/es";
import { type Opt, PrimaryKeyProp } from "@mikro-orm/core";

@Entity({ tableName: "job_run" })
export class JobRun {
  [PrimaryKeyProp]?: ["job", "period"];

  @PrimaryKey({ type: "string" })
  job!: string;

  @PrimaryKey({ type: "string" })
  period!: string;

  @Property({ type: Date })
  ran_at: Opt<Date> = new Date();
}
