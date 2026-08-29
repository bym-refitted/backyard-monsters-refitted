import { AttackLogs } from "../../models/attacklogs.model.js";
import { postgres, redis } from "../../server.js";
import { logger } from "../../utils/logger.js";
import { CompactAttackReportSchema } from "../../schemas/AttackReportSchema.js";

interface Args {
  attackerUserId: number;
  defenderUserId: number;
  attackId: number;
  rawReport: unknown;
}

/**
 * Validates an uploaded battle report and attaches it to the attack_logs row for
 * this attack. Best-effort: any problem (missing report, bad shape, no matching
 * row) is logged and swallowed — the caller's base save must still succeed.
 *
 * Correlates on (attacker, defender, attackid); newest row wins if somehow more
 * than one matches. Does not flush — the caller owns the unit of work.
 */
export const persistBattleReport = async (args: Args): Promise<void> => {
  const { attackerUserId, defenderUserId, attackId, rawReport } = args;

  try {
    if (rawReport === undefined || rawReport === null) return;

    const parsed = CompactAttackReportSchema.safeParse(rawReport);
    if (!parsed.success) {
      logger.debug(
        `Discarding malformed battle report from user ${attackerUserId}: ${parsed.error.message}`
      );
      return;
    }

    // attack_logs.attackid can theoretically be 0 (Save.attackid defaults to 0),
    // but baseModeAttack/infernoModeAttack always randomise it to 1–99999 before
    // createAttackLog, so a real row is always >= 1. Never correlate on 0.
    if (!Number.isFinite(attackId) || attackId <= 0) {
      logger.debug(
        `Battle report from user ${attackerUserId} had no usable attackid (${attackId})`
      );
      return;
    }

    const row = await postgres.em.findOne(
      AttackLogs,
      {
        attacker_userid: attackerUserId,
        defender_userid: defenderUserId,
        attackid: attackId,
      },
      { orderBy: { attacktime: "DESC" } }
    );

    if (!row) {
      logger.debug(
        `No attack_logs row for attacker ${attackerUserId} / defender ${defenderUserId} / attackid ${attackId}; battle report dropped`
      );
      return;
    }

    const [r1, r2, r3, r4] = parsed.data.loot;
    row.attackreport = parsed.data;
    row.loot = { r1, r2, r3, r4 };
    postgres.em.persist(row);

    await bustAttackLogCaches(attackerUserId, defenderUserId, row.id);
  } catch (err) {
    logger.warn(
      `persistBattleReport failed for user ${attackerUserId}: ${(err as Error).message}`
    );
  }
};

/**
 * getAttackLogs caches under attackLogs:<uid>:<filter> for filter in
 * {undefined, myattacks, peopleattackingme, both}; getAttackLogDetail caches
 * under attackLogDetail:<id>. Clear every key this report could have staled.
 */
const bustAttackLogCaches = async (
  attackerUserId: number,
  defenderUserId: number,
  logId: number
) => {
  const filters = ["undefined", "myattacks", "peopleattackingme", "both"];
  const keys: string[] = [`attackLogDetail:${logId}`];
  for (const uid of [attackerUserId, defenderUserId]) {
    for (const f of filters) keys.push(`attackLogs:${uid}:${f}`);
  }
  await Promise.all(keys.map((k) => redis.del(k)));
};
