import { Router, Request } from "express";
import { errorLog, logging } from "../utils/logger.js";
import { randomUUID } from "crypto";

interface LogProps {
  logMessage: string;
  debugVars: Object;
}

const router = Router();

// Logging routes
router.post("/api/player/recorddebugdata/", (req: Request) => {
  logging(`=========== NEW RUN ${randomUUID()} ===========`);
  JSON.parse(req.body.message).forEach((element: LogProps) => {
    logging(`${element.logMessage}`, element.debugVars);
  });
});

export default router;