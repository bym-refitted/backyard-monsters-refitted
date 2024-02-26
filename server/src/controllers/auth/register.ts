import { z } from "zod";
import bcrypt from "bcrypt";
import { KoaController } from "../../utils/KoaController";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { authFailureErr } from "../../errors/errorCodes.";
import { logging } from "../../utils/logger";

const UserRegisterSchema = z.object({
  username: z.string(),
  password: z.string(),
  email: z.string().email().toLowerCase(),
  last_name: z.string(),
  pic_square: z.string(),
});

export const register: KoaController = async (ctx) => {
  try {
    const userInput = UserRegisterSchema.parse(ctx.request.body);
    const hash = await bcrypt.hash(userInput.password, 10);

    const user = ORMContext.em.create(User, {
      ...userInput,
      password: hash,
    });
    await ORMContext.em.persistAndFlush(user);
    const filteredUser = FilterFrontendKeys(user);
    logging(
      `User ${filteredUser.username} registered successfully | ID: ${filteredUser.userid} | Email: ${filteredUser.email} | IP Address: ${ctx.ip}`
    );

    ctx.status = 200;
    ctx.body = { user: filteredUser };
  } catch (err) {
    throw authFailureErr;
  }
};
