import { Request, NextFunction } from "express";
import { logging } from "../utils/logger.js";

export const debugDataLog = (req: Request, _: any, next: NextFunction) => {
    logging(`Request body: ${JSON.stringify(req.body)}`);
    next();
  };
  