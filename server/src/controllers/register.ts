import { z } from "zod";
import bcrypt from "bcrypt";
import { ORMContext } from "../server";
import { User } from "../models/user.model";
import { FilterFrontendKeys } from "../utils/FrontendKey";
import { Controller } from "../utils/Controller";
import { ClientSafeError } from "../middleware/clientSafeError";

const UserRegisterSchema = z.object({
  username: z.string(),
  password: z.string(),
  email: z.string().email(),
  last_name: z.string(),
  pic_square: z.string(),
});

export const register: Controller = async (req, res, next) => {
  const userInput = UserRegisterSchema.parse(req.body);
  const hash = await bcrypt.hash(userInput.password, 10);
  try {
    const user = ORMContext.em.create(User, {
      ...userInput,
      password: hash,
    });
    await ORMContext.em.persistAndFlush(user);
    const filteredUser = FilterFrontendKeys(user);
    return res.status(200).json({ user: filteredUser });
  } catch (err) {
    next(
      new ClientSafeError({
        message: "Sorry, it appears an account with that email already exists",
        status: 400,
        data: err,
      })
    );
  }
};
