import * as jwt from "jsonwebtoken";
import JWT, { JwtPayload } from "jsonwebtoken";
import { authFailureErr } from "../errors/errorCodes.";

declare module "jsonwebtoken" {
  export interface UserIDJwtPayload extends jwt.JwtPayload {
    userId: number;
  }
}

export const verifyJwtToken = (token: string): JwtPayload => {
  try {
    return JWT.verify(
      token,
      process.env.SECRET_KEY || "MISSING_SECRET"
    ) as JwtPayload;
  } catch (err) {
    throw authFailureErr;
  }
};
