import * as jwt from "jsonwebtoken";
import { ClientSafeError } from "../middleware/clientSafeError";
import JWT, { JwtPayload } from "jsonwebtoken";

declare module "jsonwebtoken" {
  export interface UserIDJwtPayload extends jwt.JwtPayload {
    userId: number;
  }
}
// Move to designated folder for errors?
export const authFailureError = new ClientSafeError({
  message: "Could not authenticate",
  status: 403,
  code: "AUTH_ERROR",
  data: null,
});

export const verifyJwtToken = (token: string): JwtPayload => {
  try {
    return JWT.verify(
      token,
      process.env.SECRET_KEY || "MISSING_SECRET"
    ) as JwtPayload;
  } catch (err) {
    throw authFailureError;
  }
};
