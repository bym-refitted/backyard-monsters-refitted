import abunaki from "./abunaki";
import kozu from "./kozu";
import legionnaire from "./legionnaire";
import dreadnaught from "./dreadnaught";

/**
 * Implement more base save and levels
 */

export default [legionnaire, kozu, abunaki, dreadnaught]

export const getWMDefaultBase = (wmid: number, level: number) => {
    const tribes = [legionnaire, kozu, abunaki, dreadnaught];
    const saves = tribes[wmid];
    // ToDo: add level randomness base on auth save level
    // ToDo: add randomness on resources base on level and cell x,y
    const s_lvl = level < 30 ? 10 : (level < 38 ? 20 : 30);
    const res = {
        level: s_lvl,
        save: null
    }
    if (saves.hasOwnProperty(s_lvl)) {
        res.save = saves[s_lvl];
    } else {
        const last = Object.keys(saves).pop();
        res.save = saves[last];
    }

    return res;
}