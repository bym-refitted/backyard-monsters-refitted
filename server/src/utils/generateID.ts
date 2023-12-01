/**
 * Function to generate a simple numeric ID of a specific length
 * from a numeric range of 0-9, based on input.
 *
 * @param {number} length - The desired length of the generated ID.
 * @param {number} [prefix] - Optional prefix to be added to the ID.
 * @returns {number} The generated numeric ID.
 */
export const generateID = (length: number, prefix?: number): number => {
  let numericID = 0;

  for (let i = 0; i < length; i++) {
    const randomNumber = Math.floor(Math.random() * 10);
    numericID = numericID * 10 + randomNumber;
  }
  return prefix != undefined ? prefix * Math.pow(10, length) + numericID : numericID;
};