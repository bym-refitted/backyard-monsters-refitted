import { BaseType } from "../../../enums/Base";
import { Save } from "../../../models/save.model";
import { User } from "../../../models/user.model";
import { WorldMapCell } from "../../../models/worldmapcell.model";
import { postgres } from "../../../server";

export const leaveWorld = async (user: User, save: Save) => {
  if (!save.worldid) return;

  const { userid } = user;
  const worldid = save.worldid;

  await postgres.em.transactional(async (em) => {
    await em
      .getConnection()
      .execute(
        "UPDATE bym.world SET player_count = player_count - 1 WHERE uuid = ?",
        [worldid]
      );

    await em.nativeDelete(Save, { userid, type: BaseType.OUTPOST });
    await em.nativeDelete(WorldMapCell, { uid: userid });

    save.worldid = null;
    save.usemap = 0;
    save.cell = null;
    save.homebase = null;
    save.outposts = [];
    save.buildingresources = {};

    user.bookmarks = {};

    await em.persistAndFlush([save, user]);
  });
};
