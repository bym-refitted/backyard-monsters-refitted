import { z } from "zod";
import bcrypt from "bcrypt";
import { KoaController } from "../../utils/KoaController";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { authFailureErr } from "../../errors/errorCodes.";
import { logging } from "../../utils/logger";
import { STATUS } from "../../enums/StatusCodes";

const UserRegistrationSchema = z.object({
  username: z.string().min(2).max(12),
  email: z.string().email().toLowerCase(),
  password: z.string().min(8)
});

export const register: KoaController = async (ctx) => {
  try {
    const registeredUser = UserRegistrationSchema.parse(ctx.request.body);
    const hash = await bcrypt.hash(registeredUser.password, 10);

    const user = ORMContext.em.create(User, {
      ...registeredUser,
      password: hash,
    });
    await ORMContext.em.persistAndFlush(user);
    const filteredUser = FilterFrontendKeys(user);
    logging(
      `User ${filteredUser.username} registered successfully | ID: ${filteredUser.userid} | Email: ${filteredUser.email} | IP Address: ${ctx.ip}`
    );

    ctx.status = STATUS.OK;
    ctx.body = { user: filteredUser };
  } catch (err) {
    throw authFailureErr();
  }
};
