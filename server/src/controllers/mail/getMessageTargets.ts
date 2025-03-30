import { Status } from "../../enums/StatusCodes";
import { debugClientErr } from "../../errors/errors";
import { User } from "../../models/user.model";
import { KoaController } from "../../utils/KoaController";
import { errorLog, logging } from "../../utils/logger";

const LOG_LEVEL = {
  INFO: "info",
  ERROR: "err",
};
interface DebugData {
  key: string;
  saveid: string;
  value: string;
}

/**
 * Controller to get message targets for MailBox/FriendPicker.
 *
 * This controller get message targets
 *
 * @param {Context} ctx - The Koa context object, which includes the request body.
 * @returns {Promise<void>} - A promise that resolves when the controller is complete.
 * @throws {Error} - Throws an error if the request body is missing required fields or if logging fails.
 */
export const getMessageTargets: KoaController = async (ctx) => {
  try {
    const user: User = ctx.authUser;
    console.log(user);

    ctx.status = Status.OK;
    ctx.body = { 
      targets: {
        "67890": { 
          friend: 0,
          mapver: 2, 
          first_name: "alpha",
          last_name: "",
          pic_square: "https://api.dicebear.com/9.x/bottts-neutral/jpg?seed=alpha&size=50"
        },
        "67891": { 
          friend: 0, mapver: 2,
          first_name: "beta",
          last_name: "",
          pic_square: "https://api.dicebear.com/9.x/bottts-neutral/jpg?seed=beta&size=50"
        },
        "67892": { 
          friend: 1, mapver: 2,
          first_name: "charlie",
          last_name: "",
          pic_square: "https://api.dicebear.com/9.x/bottts-neutral/jpg?seed=charlie&size=50"
        },
        "12345": { 
          friend: 1, mapver: 2,
          first_name: "delta",
          last_name: "",
          pic_square: "https://api.dicebear.com/9.x/bottts-neutral/jpg?seed=delta&size=50"
        }
      }
    };
  } catch (err) {
    throw debugClientErr();
  }
};
