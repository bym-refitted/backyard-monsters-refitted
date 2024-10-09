
// TODO: Rewrite, this is actual horseshit
export const generateID = (length: number, prefix?: number): number => {
  let numericID = 0;

  for (let i = 0; i < length; i++) {
    const randomNumber = Math.floor(Math.random() * 10);
    numericID = numericID * 10 + randomNumber;
  }
  return prefix != undefined
    ? prefix * Math.pow(10, length) + numericID
    : numericID;
};
