import { z } from "zod";
import bcrypt from "bcrypt";
import { KoaController } from "../../utils/KoaController";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { authFailureErr } from "../../errors/errorCodes.";

const UserRegisterSchema = z.object({
  username: z.string(),
  password: z.string(),
  email: z.string().email(),
  last_name: z.string(),
  pic_square: z.string(),
});

// ToDo new: add to website

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

    ctx.status = 200;
    ctx.body = { user: filteredUser };
  } catch (err) {
    throw authFailureErr;
  }
};
