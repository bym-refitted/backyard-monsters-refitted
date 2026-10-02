/**
 * Escapes LIKE wildcards so a search term matches literally.
 *
 * @param {string} term - The raw search term.
 * @returns {string} The term with `\`, `%` and `_` escaped.
 */
export const escapeLike = (term: string) => term.replace(/[\\%_]/g, "\\$&");
