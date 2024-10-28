import { Context } from "koa";

// Implement: All data should come from db to populate these properties
// Currently the majority of this data is hardcoded to emulate a player
export const outpostCell = async (ctx: Context) => {
  const userId = ctx.session.userid || 0;

  return {
    uid: userId,
    b: 3,
    fbid: "0",
    pi: 0,
    bid: 1,
    aid: 0,
    i: 139,
    mine: 1,
    f: 4,
    c: 4,
    t: 0,
    n: "My Outpost",
    fr: 0,
    on: 0,
    p: 0,
    r: {},
    m: {
      hcc: {},
      h: [],
      housed: { C12: 1000, C14: 100 },
      overdrivepower: 1,
      overdrivetime: 0,
      saved: 0,
      space: 0,
    },
    l: 56,
    d: 0,
    lo: 0,
    dm: 0,
    pic_square: "",
    im: "",
  };
};
