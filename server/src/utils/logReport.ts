import { IncidentReport } from "../models/incidentreport";
import { User } from "../models/user.model";
import { ORMContext } from "../server";

export const logReport = async (
  user: User,
  incidentReport: IncidentReport,
  message: string
) => {
  incidentReport.userid = user.userid;
  incidentReport.username = user.username;
  incidentReport.discord_tag = user.discord_tag;
  incidentReport.report = {
    message,
    timestamp: new Date().toISOString(),
  };

  await ORMContext.em.upsert(incidentReport);
};
