// TODO: the way 'champion' data is handled on the client by the original game is absolutely ridiculous
// and we should consider changing it to a more standard format in the future. 
// For now, we need to be compatible with the original game and handle the champion data as it is stored in the database, 
// which can be either a string or an array.

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
 * Serializes the champion field for the Flash client response.
 *
 * Flash receives champion as a string and calls JSON.parse on it to get the array.
 * The champion `json` column is typed as `string` in the model but MikroORM may return
 * either a JS array (when the column contains a raw JSON array) or a JS string (when it was
 * stored double-encoded via a previous save). Both cases must produce the same HTTP output:
 * a JSON-string representation of the champion array.
 *
 * @param {unknown} raw - The champion value from filteredSave.
 * @returns {string} The champion value ready to embed in the response body.
 */
export const serializeChampion = (raw: unknown): string => {
  if (raw == null) return 'null';
  if (typeof raw === 'string') return raw;

  return JSON.stringify(raw);
};

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
export const parseChampionData = (rawChampionData: string): ChampionData[] | null => {
  try {
    const parsedChampionData = JSON.parse(rawChampionData);

    if (Array.isArray(parsedChampionData)) return parsedChampionData;

    return null;
  } catch (_) {
    return null;
  }
};