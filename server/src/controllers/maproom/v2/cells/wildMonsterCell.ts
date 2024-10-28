const tribes = ["Kozu", "Legionnaire", "Dreadnaut", "Abunakki"];

export const wildMonsterCell = async () => {
  const randomIndex = Math.floor(Math.random() * tribes.length);
  const tribeName = tribes[randomIndex];

  return {
    uid: 0,
    b: 1,
    bid: 1234,
    aid: 0,
    i: 109,
    n: tribeName,
    r: {},
    m: {
      hcc: [],
      h: [],
      housed: {},
      overdrivepower: 1,
      overdrivetime: 0,
      saved: 0,
      space: 0,
    },
    l: 34,
    d: 0,
    lo: 0,
    dm: 0,
    pic_square: "",
    im: "",
  };
};
