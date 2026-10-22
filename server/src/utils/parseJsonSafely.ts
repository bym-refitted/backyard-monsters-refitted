/**
 * Reads a stringified payload from the client without throwing, so a malformed
 * field can never take the entire base save down with it.
 *
 * @param {string | undefined} data - The raw value sent by the client
 * @returns {unknown} The parsed payload, or undefined if it was unreadable
 */
export const parseJsonSafely = (data: string | undefined): unknown => {
  if (!data) return undefined;

  try {
    return JSON.parse(data);
  } catch (_) {
    return undefined;
  }
};
