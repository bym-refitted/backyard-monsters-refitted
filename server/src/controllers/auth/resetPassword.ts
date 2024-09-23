import z from "zod";
import JWT from "jsonwebtoken";
import bcrypt from "bcrypt";

import { Status } from "../../enums/StatusCodes";
import { KoaController } from "../../utils/KoaController";
import { authFailureErr } from "../../errors/errors";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { errorLog } from "../../utils/logger";

const ResetPasswordSchema = z.object({
  password: z.string(),
  token: z.string(),
});

export const resetPassword: KoaController = async (ctx) => {
  try {
    const { password, token } = ResetPasswordSchema.parse(ctx.request.body);

    // Verify the token
    const { email } = JWT.verify(
      token,
      process.env.SECRET_KEY || "MISSING_SECRET"
    ) as { email: string };

    const user = await ORMContext.em.findOne(User, { email });
    if (!user || user.resetToken !== token) throw authFailureErr();

    const hashedPassword = await bcrypt.hash(password, 10);

    // Update the user's password
    user.password = hashedPassword;
    user.resetToken = null;
    await ORMContext.em.persistAndFlush(user);

    ctx.status = Status.OK;
    ctx.body = {
      message: "Password has been reset successfully.",
    };
  } catch (error) {
    errorLog(`Error resetting password: ${error}`);
    throw authFailureErr();
  }
};
