import {logging} from "./logger";

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
export const preprocessChampionData = (rawChampionData) => {
    try {
        logging("Preprocessing champion data:", rawChampionData);
        if (typeof rawChampionData === "string") {
            return JSON.parse(rawChampionData);
        }
        if (rawChampionData === null || rawChampionData === undefined) {
            return [];
        }
        if (Array.isArray(rawChampionData) || typeof rawChampionData === "object") {
            return rawChampionData;
        }
        return [];
    } catch (_) {
        logging("Invalid champion data format:", rawChampionData);
        throw new Error("Invalid champion data format:" + rawChampionData);
    }
};