import { postgres } from "../../server.js";

/** Most players who may speed up one building, matching the client's own limit. */
const MAX_HELPERS = 5;

/**
 * Appends the helper to one building's help list, in a single statement that also does
 * the checking.
 *
 * Written as one UPDATE rather than read-modify-write for two reasons. Postgres has no
 * partial write for jsonb, so sending the column back from memory would carry our copy of
 * every other building with it - and if the owner saved their base in the same moment, the
 * later write would win and one of the two saves would be lost. Doing it in SQL touches
 * only the hl path and leaves the rest of the column untouched, whoever else is writing.
 * It also makes the duplicate and cap checks atomic, so two helpers arriving together
 * cannot both pass a check the other invalidates.
 *
 * The 5% is deliberately not applied here. The owner's client takes it off when it replays
 * the event, and doing it in both places would take it twice.
 */
const APPEND_HELPER = `
  UPDATE bym.save s
  SET buildingdata = jsonb_set(
        s.buildingdata,
        ARRAY[p.key, 'hl'],
        COALESCE(s.buildingdata -> p.key -> 'hl', '[]'::jsonb) || to_jsonb(p.helper),
        true
      )
  FROM (VALUES (?::text, ?::int)) AS p(key, helper)
  WHERE s.baseid = ?
    AND s.buildingdata -> p.key IS NOT NULL
    AND COALESCE((s.buildingdata -> p.key ->> 'cB')::numeric, 0)
      + COALESCE((s.buildingdata -> p.key ->> 'cU')::numeric, 0)
      + COALESCE((s.buildingdata -> p.key ->> 'cF')::numeric, 0) > 0
    AND jsonb_array_length(COALESCE(s.buildingdata -> p.key -> 'hl', '[]'::jsonb)) < ${MAX_HELPERS}
    AND NOT COALESCE(s.buildingdata -> p.key -> 'hl', '[]'::jsonb) @> to_jsonb(p.helper)
  RETURNING s.basesaveid
`;

/**
 * Records a help against the base being visited.
 *
 * The help list lives in the owner's buildingdata, and a visitor can only push themselves
 * onto their local copy of it - nobody can save someone else's base. Until this ran, the
 * list only became real when the owner next logged in and replayed the event, so in the
 * meantime a helper could leave, re-enter on a freshly loaded base and help the same
 * building again, each repeat taking another 5% off and eating one of the five slots.
 *
 * @param {string} baseid - The base being helped.
 * @param {number} buildingId - The building the helper sped up.
 * @param {number} helperId - The visiting player, taken from their session rather than
 * from the payload, so a help cannot be filed under somebody else's name.
 * @returns {Promise<boolean>} Whether the help counted, and so whether it is worth storing.
 */
export const registerHelp = async (baseid: string, buildingId: number, helperId: number): Promise<boolean> => {
  const key = String(buildingId);

  const updated = await postgres.em.getConnection().execute(APPEND_HELPER, [key, helperId, baseid]);

  return updated.length > 0;
};
