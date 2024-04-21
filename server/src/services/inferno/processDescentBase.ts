import { logging } from "../../utils/logger";
import { ORMContext } from "../../server";
import { DescentStatus } from "../../models/descentstatus.model";
import { Save, FieldData } from "../../models/save.model";
import { Resources, updateResources } from "../../data/updateResources";


export const descentBases: number[] = [201,202,203,204,205,206,207];

export const ProcessDescentBase = async (ctx, basesaveid: number, baseid:string, userid:number, iresources:{}) => {
    //logging("basesaveid: " + parseInt(basesaveid));
    //logging("baseid: " + ctx.request.body["baseid"]);
    try {
        if (parseInt(ctx.request.body["destroyed"]) === 1) {
            let baseIndex = 0;
            if (basesaveid === 0) {
              logging("using baseID as baseIndex");
              baseIndex = descentBases.indexOf(parseInt(JSON.parse(ctx.request.body["baseid"])))
            } else {
              logging("using baseSaveID as baseIndex");
              baseIndex = descentBases.indexOf(basesaveid);
            }
        
            let userDescentBases = await ORMContext.em.findOne(DescentStatus, {
              userid: userid,
            });
            if (userDescentBases) {
              logging("Base is destroyed:");
              // find the corresponding WM status descent base
              let stored_base = userDescentBases.wmstatus[baseIndex];
              // set it to be destroyed
              stored_base[2] = 1;
              // insert back into database
              userDescentBases[baseIndex] = stored_base;
              logging("Base entry: " + stored_base);
              await ORMContext.em.persistAndFlush(userDescentBases);
            }
            try {
              let iloot = JSON.parse(ctx.request.body["lootreport"]);
              let lootIResources: Resources = {
                r1: iloot["r1"],
                r2: iloot["r2"],
                r3: iloot["r3"],
                r4: iloot["r4"],
              }
              const savedLootIResources: FieldData = updateResources(
                lootIResources,
                iresources || {}
              );
              iresources = savedLootIResources;
            } catch (error) {
              logging("something went wrong saving Descent Attack Data: " + error)
            }
        }
        logging("Saving Champion Data")
        let champion = ctx.request.body["attackerchampion"];
        let monsters = JSON.parse(ctx.request.body["attackcreatures"])
        return [iresources, champion, monsters];
    } catch (error) {
      logging("WTF Happened: " + error);
    }
}