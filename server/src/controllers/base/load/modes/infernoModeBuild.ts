import { inferoMonsters } from "../../../../data/monsterKeys";
import { BaseType } from "../../../../enums/Base";
import { IncidentReport } from "../../../../models/incidentreport";
import { Save } from "../../../../models/save.model";
import { User } from "../../../../models/user.model";
import { ORMContext } from "../../../../server";
import { logReport } from "../../../../utils/logReport";

// Inferno seems to always return baseid 0 for the current user from the client
export const infernoModeBuild = async (user: User, baseid: string) => {
  const userSave = user.save;

  let infernoSave = await ORMContext.em.findOne(Save, {
    userid: user.userid,
    type: BaseType.INFERNO,
  });

  if (!infernoSave)
    infernoSave = await Save.createInfernoSave(ORMContext.em, user);

  if (infernoSave.userid !== user.userid) {
    const message = `${user.username} attempted to access unauthorized inferno base: ${baseid}`;
    await logReport(user, new IncidentReport(), message);
    throw new Error(message);
  }

  infernoSave.credits = userSave.credits;
  infernoSave.resources = userSave.iresources;
  userSave.stats["other"]["underhalLevel"] = infernoSave.stats["other"]["underhalLevel"];

  // Persist Inferno monster levels to overworld only if the values differ
  inferoMonsters.forEach((key) => {
    const acdemyLevel = infernoSave.academy[key];

    if (acdemyLevel && userSave.academy[key] !== acdemyLevel)
      userSave.academy[key] = acdemyLevel;
  });

  await ORMContext.em.flush();
  return infernoSave;
};
