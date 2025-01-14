/**
 * The champion data object.
 */
interface ChampionData {
  log: string;
  ft: number;
  fd: number;
  l: number;
  hp: number;
  status: number;
  fb: number;
  t: number;
  pl: number;
}

/**
 * Parses the champion data from the user's save.
 *
 * The function ensures compatibility with different formats of the `champion` field:
 * - If the `champion` field is a string, it parses it into an object/array.
 * - If the `champion` field is already an object/array, it is returned as-is.
 * - Defaults to an empty array if the `champion` field is null or undefined.
 *
 * @param {string} rawChampionData - The raw champion data from the user's save.
 * @returns {ChampionData[] | null} The parsed champion data as an array of objects.
 */
export const parseChampionData = (rawChampionData: string): ChampionData[] | string | null => {
  
  if (typeof rawChampionData === "string") return JSON.parse(rawChampionData);

  return rawChampionData || [];
};
