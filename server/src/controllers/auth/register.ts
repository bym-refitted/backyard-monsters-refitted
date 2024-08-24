import { z } from "zod";
import bcrypt from "bcrypt";
import { KoaController } from "../../utils/KoaController";
import { ORMContext } from "../../server";
import { User } from "../../models/user.model";
import { FilterFrontendKeys } from "../../utils/FrontendKey";
import { authFailureErr } from "../../errors/errorCodes.";
import { logging } from "../../utils/logger";
import { Status } from "../../enums/StatusCodes";

const UserRegisterSchema = z.object({
  username: z.string(),
  password: z.string(),
  email: z.string().email().toLowerCase(),
  last_name: z.string(),
  pic_square: z.string(), // TODO: WHYYYYYY?? Should not be from user input thats fucking mental
});

/**
 * Controller to handle user registration.
 *
 * This controller registers a new user based on the provided input. It hashes the user's
 * password, saves the user to the database, and returns the filtered user information.
 * If registration fails, it throws an authentication failure error.
 *
 * @param {Context} ctx - The Koa context object.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if registration fails or if the request body is invalid.
 */
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

    ctx.status = Status.OK;
    ctx.body = { user: filteredUser };
  } catch (err) {
    throw authFailureErr();
  }
};
