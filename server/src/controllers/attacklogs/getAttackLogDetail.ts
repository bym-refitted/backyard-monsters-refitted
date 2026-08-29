import { Status } from "../../enums/StatusCodes.js";
import { loadFailureErr, permissionErr } from "../../errors/errors.js";
import { AttackLogs } from "../../models/attacklogs.model.js";
import { postgres, redis } from "../../server.js";
import { decodeAttackReport } from "../../services/attacklogs/attackReportCodec.js";
import { CompactAttackReportSchema } from "../../schemas/AttackReportSchema.js";
import type { KoaController } from "../../utils/KoaController.js";
import type { User } from "../../models/user.model.js";

/** 30 minutes, matching getAttackLogs. */
const DETAIL_CACHE_TTL = 1800;

/**
 * GET /api/:apiVersion/attacklogs/:id
 *
 * Returns the decoded battle report for one attack_logs row, for the attacker or
 * the defender only. Rows with no stored report return { report: null } so the
 * launcher can show a "no report available" state.
 */
export const getAttackLogDetail: KoaController = async (ctx) => {
  const { userid }: User = ctx.authUser;
  const id = Number((ctx.params as { id?: string }).id);

  if (!Number.isInteger(id) || id <= 0) throw loadFailureErr();

  const cacheKey = `attackLogDetail:${id}`;
  const cached = await redis.get(cacheKey);
  if (cached) {
    const payload = JSON.parse(cached);
    if (payload.attacker === userid || payload.defender === userid) {
      ctx.status = Status.OK;
      ctx.body = { report: payload.report };
      return;
    }
  }

  const row = await postgres.em.findOne(AttackLogs, { id });
  if (!row) throw loadFailureErr();

  if (row.attacker_userid !== userid && row.defender_userid !== userid) {
    throw permissionErr();
  }

  const stored = row.attackreport;
  const hasReport =
    stored && typeof stored === "object" && Object.keys(stored).length > 0;

  let report = null;
  if (hasReport) {
    const parsed = CompactAttackReportSchema.safeParse(stored);
    report = parsed.success ? decodeAttackReport(parsed.data) : null;
  }

  await redis.setex(
    cacheKey,
    DETAIL_CACHE_TTL,
    JSON.stringify({
      attacker: row.attacker_userid,
      defender: row.defender_userid,
      report,
    })
  );

  ctx.status = Status.OK;
  ctx.body = { report };
};
