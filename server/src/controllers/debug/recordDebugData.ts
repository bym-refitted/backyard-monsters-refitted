import { ClientSafeError } from "../../middleware/clientSafeError";
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

const debugClientErr = new ClientSafeError({
  message: "Sorry, it appears this cannot be found.",
  status: 404,
  code: "DEBUG_ERROR",
  data: null,
});

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
    ctx.body = { error: 0, h: "someHashValue" };
  } catch (err) {
    throw debugClientErr;
  }
};
