import { Request, NextFunction } from "express";
import { logging } from "../utils/logger.js";

export const debugDataLog =
  (logMessage: string = "Request body") =>
  (req: Request, _, next: NextFunction) => {
    import("chalk").then((chalk) => {
      const highlight = chalk.default.yellow.bold;

      logging(`${highlight(`${logMessage.toUpperCase()}:`)} ${JSON.stringify(req.body)}`);
      next();
    });
  };
