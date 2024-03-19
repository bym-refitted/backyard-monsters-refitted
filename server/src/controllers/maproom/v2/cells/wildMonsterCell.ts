import { WorldMapCell } from "../../../../models/worldmapcell.model";
import { ORMContext } from "../../../../server";
import { Save } from "../../../../models/save.model";
import { generateBaseID } from "../../../../services/maproom/v2/world";

const tribes = ["Legionnaire", "Kozu", "Abunakki", "Dreadnaut"];

export const wildMonsterCell = async (
  terrainType: number,
  cell: WorldMapCell,
  level: number = 32
) => {
  const tribe = (cell.x + cell.y) % tribes.length;
  const tribeName = tribes[tribe];

  let save: Save = null;
  if (cell.base_id !== 0) {
    save = await ORMContext.em.findOne(Save, {
      baseid: cell?.base_id.toString(),
      wmid: {
        $ne: 0,
      },
    });
  }

  return {
    uid: cell?.uid || 0, // ToDo: Why do we have a userId for both user and save table? Fix
    b: 1,
    fbid: save?.fbid,
    pi: 0,
    bid: generateBaseID(parseInt(cell.world_id), cell.x, cell.y),
    aid: 0,
    i: terrainType,
    mine: 0,
    f: save?.flinger || 0,
    c: save?.catapult || 0,
    t: 0,
    n: tribeName,
    fr: 0,
    on: 0, // ToDo
    p: 0,
    r: save?.resources || 0,
    m: save?.monsters || 0,
    l: save?.level || level, // ToDo
    d: save?.destroyed || 0,
    lo: save?.locked || 0,
    dm: save?.damage || 0,
    pic_square: "",
    im: "",
  };
};
