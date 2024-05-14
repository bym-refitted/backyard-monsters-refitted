import abunaki from "./abunaki";
import kozu from "./kozu";
import legionnaire from "./legionnaire";
import dreadnaught from "./dreadnaught";
import descent from "./descent";

/**
 * Implement more base save and levels
 */

export default [legionnaire, kozu, abunaki, dreadnaught, descent];

export const getWMDefaultBase = (wmid: number, level: number) => {
  const tribes = [legionnaire, kozu, abunaki, dreadnaught];
  const saves = tribes[wmid];
  // ToDo: add level randomness base on auth save level
  // ToDo: add randomness on resources base on level and cell x,y
  const s_lvl = level < 20 ? 10 : level < 30 ? 20 : 30;
  const res = {
    level: s_lvl,
    save: null,
  };
  if (saves.hasOwnProperty(s_lvl)) {
    res.save = saves[s_lvl];
  } else {
    const last = Object.keys(saves).pop();
    res.save = saves[last];
  }

  return res;
};

export const getIWMDescentBase = (iwmid: number) => {
  let save = null;
  switch (iwmid) {
    case 201:
      save = descent[1];
      break;
    case 202:
      save = descent[2];
      break;
    case 213:
      save = descent[13];
      break;
    default:
      save = descent[1];
      break;
  }
  return save;
};
