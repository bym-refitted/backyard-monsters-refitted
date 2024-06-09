import { User } from "../../models/user.model";
import { Save } from "../../models/save.model";
import { KoaController } from "../../utils/KoaController";
import { ORMContext } from "../../server";
import { logging } from "../../utils/logger";
import { saveFailureErr } from "../../errors/errorCodes.";
import { monsterUpdateBases } from "../../services/base/monster";

export const infernoMonsters: KoaController = async ctx => {
    const fork = ORMContext.em.fork();
    const user: User = ctx.authUser;
    await fork.populate(user, ["save"]);

    // We get our Inferno save using the AuthSave basesaveID
    const infSave: Save = await fork.findOne(Save, {
      saveuserid: user.userid,
      type: "inferno",
    })

    // if the request has an imonsters parameter, we use it, otherwise we set it to blank
    let imonsters = ctx.request.body.hasOwnProperty("imonsters") ? JSON.parse(ctx.request.body["imonsters"]) : {};
    const requestType = ctx.request.body["type"];

    if (requestType === "get") {
      logging("Getting Inferno Monster Data");
      // We set the imonsters variable to whatever is in our inferno base's compound.
      if (infSave) {
        imonsters = infSave.monsters;
      } else {
        throw saveFailureErr;
      }
    }

    if (requestType === "set") {
      /* The client does the calculations for us, and passes the correct field as a parameter
        which we can immediately assign to our inferno base and flush */
      if (infSave) {
        logging("Ascending monsters");
        infSave.monsters = imonsters;
        fork.persistAndFlush(infSave);
      }
    }

    ctx.status = 200;
    ctx.body = {
      error: 0,
      imonsters
    };
}