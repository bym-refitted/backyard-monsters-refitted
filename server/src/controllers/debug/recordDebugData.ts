import { debugClientErr } from "../../errors/errorCodes.";
import { KoaController } from "../../utils/KoaController";
import { errorLog, logging } from "../../utils/logger";

const LOG_LEVEL = {
  INFO: "info",
  ERROR: "err",
};
interface DebugData {
  key: string;
  saveid: string;
  value: string;
}

export const recordDebugData: KoaController = async (ctx) => {
  try {
    const body = ctx.request.body as DebugData;

    if (!body.key || !body.saveid || !body.value) throw debugClientErr;

    if (body.key === LOG_LEVEL.ERROR) {
      errorLog(
        `ERROR logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    } else {
      logging(
        `INFO logged for basesaveid '${body.saveid}'. Details: ${body.value}`
      );
    }

    ctx.status = 200;
    ctx.body = { error: 0 };
  } catch (err) {
    throw debugClientErr;
  }
};
