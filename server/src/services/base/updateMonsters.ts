import { Monster } from "../../controllers/base/save/zod/BaseSaveSchema";
import { Save } from "../../models/save.model";
import { ORMContext } from "../../server";

// TODO: This needs to be tested, how do we trigger this?
// export const updateMonsters = async (monsterupdates: Monster) => {
//   console.log("Monster Update Bases", monsterupdates);
  
//   // Fetch all bases that match the provided base IDs in one go
//   const baseIds = monsterupdates.map((update) => update.baseid);
//   const saves = await ORMContext.em.find(Save, { baseid: { $in: baseIds } });

//   // Iterate over the saves and apply the updates
//   for (const save of saves) {
//     const monsterUpdate = monsterupdates.find(
//       (update) => update.baseid === save.baseid
//     );

//     if (monsterUpdate) {
//       save.protected = 0;
//       save.monsters = monsterUpdate.m;
//     }
//   }

//   await ORMContext.em.flush();
// };
