import bcrypt from "bcrypt";
import ormConfig from "../../mikro-orm.config.js";

import { v4 as uuidv4 } from "uuid";
import { MikroORM, type RequiredEntityData } from "@mikro-orm/core";
import { getDefaultBaseData } from "../../game-data/getDefaultBaseData.js";
import { AllianceRole } from "../../enums/AllianceRole.js";
import { BaseType } from "../../enums/Base.js";
import { Alliance } from "../../models/alliance.model.js";
import { Save } from "../../models/save.model.js";
import { User } from "../../models/user.model.js";
import { World } from "../../models/world.model.js";
import { addAllianceMember } from "../../services/alliance/membership.js";
import { logger } from "../../utils/logger.js";
import type { EntityManager, PostgreSqlDriver } from "@mikro-orm/postgresql";
import type { UserData } from "../../types/EntityData.js";

const NEXT_USER_BASEID = `SELECT nextval('bym.user_baseid_seq') AS baseid`;

const SEED_PASSWORD = "Dev12345!";

interface AllianceSpec {
  name: string;
  image: number;
  members: number;
  empire_points: number;
}

/**
 * The alliances to seed, ordered as they will rank by empire points.
 * 25 alliances gives three pages at the tab's PAGE_SIZE of 10.
 */
const ALLIANCE_SPECS: AllianceSpec[] = [
  { name: "VENDETTA", image: 1, members: 8, empire_points: 167_880_178_107 },
  { name: "VENDETTA Warriors", image: 2, members: 7, empire_points: 113_926_937_744 },
  { name: "VENDETTA ASSASSINS", image: 3, members: 7, empire_points: 73_787_416_124 },
  { name: "VENDETTA NORTH", image: 4, members: 6, empire_points: 35_491_719_566 },
  { name: "VENDETTA II", image: 5, members: 6, empire_points: 27_786_251_042 },
  { name: "VENDETTA Fire", image: 6, members: 5, empire_points: 3_601_840_764 },
  { name: "Vendetta CATS", image: 7, members: 4, empire_points: 1_104_151_282 },
  { name: "vendetta VS me", image: 8, members: 1, empire_points: 870_836_236 },
  { name: "DESTROY VENDETTA", image: 9, members: 4, empire_points: 461_837_177 },
  { name: "DESTROY VENDETTA II", image: 10, members: 3, empire_points: 216_302_898 },
  { name: "Iron Legion", image: 11, members: 6, empire_points: 198_442_010 },
  { name: "Iron Legion II", image: 12, members: 5, empire_points: 176_003_551 },
  { name: "DARK_KNIGHTS", image: 13, members: 5, empire_points: 154_887_320 },
  { name: "100% PURE", image: 14, members: 3, empire_points: 131_220_984 },
  { name: "Shadow Pact", image: 15, members: 4, empire_points: 118_774_663 },
  { name: "Monster Mash", image: 16, members: 4, empire_points: 96_551_207 },
  { name: "Backyard Bandits", image: 17, members: 3, empire_points: 74_338_119 },
  { name: "The Wormhole", image: 18, members: 3, empire_points: 61_920_447 },
  { name: "Gorgo Squad", image: 19, members: 2, empire_points: 48_113_806 },
  { name: "Drull Nation", image: 20, members: 2, empire_points: 33_602_915 },
  { name: "Fomor Empire", image: 21, members: 2, empire_points: 21_447_338 },
  { name: "Teratorn Flight", image: 25, members: 2, empire_points: 14_009_662 },
  { name: "Bunker Boys", image: 30, members: 1, empire_points: 7_755_401 },
  { name: "Crabatron Crew", image: 35, members: 1, empire_points: 2_318_970 },
  { name: "Pokey Patrol", image: 41, members: 1, empire_points: 604_233 },
];

/**
 * Creates a throwaway account with a default main base in the given world.
 *
 * @param {EntityManager} em - The seed's EntityManager.
 * @param {string} passwordHash - Pre-hashed shared password, hashed once for the whole run.
 * @param {string} worldid - The world the account's base sits in.
 * @returns {Promise<User>} The created user, with their save attached.
 */
const createSeedUser = async (em: EntityManager<PostgreSqlDriver>, passwordHash: string, worldid: string): Promise<User> => {
  const uniqueId = uuidv4().replace(/-/g, "").slice(0, 12);

  const user = em.create(User, {
    username: uniqueId,
    email: `${uniqueId}@test.com`,
    password: passwordHash,
  } as unknown as UserData);

  em.persist(user);
  await em.flush();

  const save = em.create(Save, {
    ...getDefaultBaseData(user, BaseType.MAIN),
    saveuserid: user.userid,
  } as unknown as RequiredEntityData<Save>);

  const [{ baseid }] = await em.execute<[{ baseid: string }]>(NEXT_USER_BASEID);

  save.baseid = baseid;
  save.homebaseid = parseInt(baseid, 10);
  save.worldid = worldid;

  user.save = save;
  em.persist(save);
  await em.flush();

  return user;
};

/**
 * Seeds dummy alliances so the Browse tab has something to page, search and
 * filter against. Each alliance gets its own freshly created leader and members,
 * because a user can only ever belong to one alliance.
 *
 * Alliances are spread round-robin across the worlds that already exist, so the
 * tab's "This World" filter returns a real subset rather than everything. No
 * worlds are created; seed a map room first if the database has none.
 *
 * Usage:
 * - bun run db:seed:alliances
 *
 * @async
 * @function
 * @returns {Promise<void>}
 */
(async () => {
  try {
    const orm = await MikroORM.init(ormConfig);
    const em = orm.em.fork();

    const worlds = await em.find(World, {});

    if (worlds.length === 0) {
      logger.error("No worlds found - run db:seed:mr2 or db:seed:mr3 first.");
      process.exit(1);
    }

    const existing = await em.find(Alliance, {});
    const takenNames = new Set(existing.map((alliance) => alliance.name.toLowerCase()));

    const pending = ALLIANCE_SPECS.filter((spec) => !takenNames.has(spec.name.toLowerCase()));

    if (pending.length === 0) {
      logger.info("All seed alliances already exist - nothing to do.");
      await orm.close(true);
      return;
    }

    const totalMembers = pending.reduce((sum, spec) => sum + spec.members, 0);

    logger.info(
      `Seeding ${pending.length} alliances (${totalMembers} users) across ${worlds.length} worlds`
    );

    const passwordHash = await bcrypt.hash(SEED_PASSWORD, 10);

    for (const [index, spec] of pending.entries()) {
      const world = worlds[index % worlds.length];

      const leader = await createSeedUser(em, passwordHash, world.uuid);

      const alliance = em.create(Alliance, {
        name: spec.name,
        image: spec.image,
        description: `${spec.name} - seeded for local testing.`,
        leader_userid: leader.userid,
        leader_name: leader.username,
        world_id: world.uuid,
        empire_points: spec.empire_points,
      } as unknown as RequiredEntityData<Alliance>);

      em.persist(alliance);
      await em.flush();

      await addAllianceMember(leader, alliance, AllianceRole.LEADER, em);

      for (let i = 1; i < spec.members; i++) {
        const member = await createSeedUser(em, passwordHash, world.uuid);
        await addAllianceMember(member, alliance, AllianceRole.MEMBER, em);
      }

      logger.info(`  ${spec.name} - ${spec.members} members in ${world.name}`);
    }

    logger.info(`Seeding completed successfully! 🌱`);

    await orm.close(true);
  } catch (err) {
    logger.error(`Failed to seed alliances: ${err}`);
    process.exit(1);
  }
})();
