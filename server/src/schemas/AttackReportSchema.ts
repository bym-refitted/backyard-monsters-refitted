import { z } from "zod";

/**
 * Compact attack battle report — the exact shape the AS3 client uploads as
 * `saveData.battlereport` and that is stored verbatim in attack_logs.attackreport.
 *
 * Lenient on presence (the report is best-effort), strict on magnitude (a tampered
 * client must not be able to bloat the table). Unknown keys are stripped, not
 * rejected, so a future additive client field never breaks an older server.
 *
 * See docs/superpowers/specs/2026-08-29-attack-battle-reports-design.md.
 */

const int = (min: number, max: number) => z.number().int().min(min).max(max);

const pair = z.tuple([int(0, 100_000), int(0, 1_000_000)]);

const building = z
  .object({
    t: int(0, 100_000),
    x: int(-100_000, 100_000),
    y: int(-100_000, 100_000),
    hp: int(0, 2_000_000_000),
    mhp: int(0, 2_000_000_000),
    l: int(0, 2_000_000_000).optional(),
    dd: int(0, 2_000_000_000).optional(),
    k: int(0, 1_000_000).optional(),
    ml: z.array(pair).max(30).optional(),
  })
  .strip();

export const CompactAttackReportSchema = z
  .object({
    v: z.literal(1),
    d: int(0, 100),
    dur: int(0, 86_400),
    o: int(0, 2),
    loot: z.tuple([
      int(0, 2_000_000_000),
      int(0, 2_000_000_000),
      int(0, 2_000_000_000),
      int(0, 2_000_000_000),
    ]),
    b: z.array(building).max(600),
    atk: z
      .object({
        m: z.array(pair).max(60),
        c: int(-1, 1_000),
        ml: z.array(pair).max(60).optional(),
      })
      .strip(),
    s: z.array(pair).max(10).optional(),
    cat: z.array(pair).max(20).optional(),
  })
  .strip();

export type CompactAttackReport = z.infer<typeof CompactAttackReportSchema>;
