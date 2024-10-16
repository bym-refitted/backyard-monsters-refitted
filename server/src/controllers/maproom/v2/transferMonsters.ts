import z from "zod";

import { KoaController } from "../../../utils/KoaController";
import { ORMContext } from "../../../server";
import { Save } from "../../../models/save.model";
import { Status } from "../../../enums/StatusCodes";

interface Monster {
  hid: number[];
  saved: number;
  housed: Record<string, number>;
  hstage: number[];
}

type MonstersTransfer = [Monster[], Monster[]];

const TransferMonstersScema = z.object({
  frombaseid: z.string().transform((id) => BigInt(id)),
  tobaseid: z.string().transform((id) => BigInt(id)),
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

  // Fetch the bases to transfer the monsters between
  const [fromBase, toBase] = await ORMContext.em.find(Save, {
    baseid: { $in: [frombaseid, tobaseid] },
  });

  if (!fromBase || !toBase) {
    ctx.status = Status.BAD_REQUEST;
    ctx.body = { error: 1 };
    throw new Error(`One or both bases not found. From: ${frombaseid}, To: ${tobaseid}`);
  }

  fromBase.monsters = fromMonsters;
  toBase.monsters = toMonsters;

  await ORMContext.em.persistAndFlush([fromBase, toBase]);

  ctx.status = Status.OK;
  ctx.body = { error: 0 };
};
