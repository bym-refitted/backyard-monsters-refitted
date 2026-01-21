import z from "zod";

import { KoaController } from "../../../utils/KoaController.js";
import { postgres } from "../../../server.js";
import { Save } from "../../../models/save.model.js";
import { Status } from "../../../enums/StatusCodes.js";

interface Monster {
  hid: number[];
  saved: number;
  housed: Record<string, number>;
  hstage: number[];
}

type MonstersTransfer = [Monster[], Monster[]];

const TransferMonstersScema = z.object({
  frombaseid: z.string(),
  tobaseid: z.string(),
  monsters: z.string().transform((monsters) => JSON.parse(monsters)),
});

/**
 * Controller to handle the transfer of monsters between outposts and main yards.
 *
 * @param {Object} ctx - The Koa context object.
 * @returns {Promise<void>}
 */
export const transferMonsters: KoaController = async (ctx) => {
  const { frombaseid, tobaseid, monsters } = TransferMonstersScema.parse(
    ctx.request.body
  );

  const [fromMonsters, toMonsters]: MonstersTransfer = monsters;

  // Determine the order so the query always makes the source base the first result.
  const orderBy = frombaseid > tobaseid ? { baseid: 'DESC' } : { baseid: 'ASC' };

  // Fetch the bases to transfer the monsters between
  const [fromBase, toBase] = await postgres.em.find(Save, {
    baseid: { $in: [frombaseid, tobaseid] },
  }, { orderBy });

  if (!fromBase || !toBase) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    throw new Error(`One or both bases not found. From: ${frombaseid}, To: ${tobaseid}`);
  }

  // Verify that both bases belong to the same user
  if (fromBase.saveuserid !== toBase.saveuserid) {
    ctx.status = Status.FORBIDDEN;
    ctx.body = { error: 1 };
    throw new Error(`Bases belong to different users. From: ${frombaseid} with SaveId: ${fromBase.saveuserid}, To: ${tobaseid} with SaveId: ${toBase.saveuserid}`);
  }

  fromBase.monsters = fromMonsters;
  toBase.monsters = toMonsters;

  await postgres.em.persistAndFlush([fromBase, toBase]);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
