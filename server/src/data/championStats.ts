export interface ChampionProps {
  speed: number[];
  health: number[];
  healtime: number[];
  range: number[];
  damage: number[];
  feedShiny: number[];
  evolveShiny: number[];
  feedCount: number[];
  feedTime: number[];
  buffs: number[];
  movement: string[];
  attack: string[];
  bucket: number[];
  offset_x: number[];
  offset_y: number[];
  bonusSpeed: number[];
  bonusHealth: number[];
  bonusRange: number[];
  bonusDamage: number[];
  bonusBuffs: number[];
  bonusFeedShiny: number[];
  bonusFeedTime: number[];
  targetGroup: number[];
  buffRadius?: number[];
}

interface ChampionStat {
  t: number;
  name: string;
  props: ChampionProps;
}

interface ChampionStatsMap {
  [key: string]: ChampionStat;
}


export const championStats: ChampionStatsMap = {
  G1: {
    t: 1,
    name: "Gorgo",
    props: {
      speed: [1, 1.2, 1.4, 1.6, 1.8, 2],
      health: [40000, 80000, 120000, 140000, 160000, 200000],
      healtime: [3600, 7200, 14400, 28800, 57600, 115200],
      range: [35, 45, 55, 65, 70, 70],
      damage: [1000, 1200, 1500, 2000, 2500, 3000],
      feedShiny: [26, 44, 75, 111, 136],
      evolveShiny: [158, 530, 1358, 2664, 4076],
      feedCount: [3, 6, 9, 12, 15],
      feedTime: [3600 * 23],
      buffs: [0],
      movement: ["ground"],
      attack: ["melee"],
      bucket: [240],
      offset_x: [-48, -38, -42, -52, -54, -46],
      offset_y: [-38, -36, -52, -82, -98, -80],
      bonusSpeed: [0.1, 0.2, 0.4],
      bonusHealth: [12500, 27500, 50000],
      bonusRange: [0, 0, 0],
      bonusDamage: [150, 330, 600],
      bonusBuffs: [0, 0, 0],
      bonusFeedShiny: [136, 136, 136],
      bonusFeedTime: [3600 * 24],
      targetGroup: [0],
    },
  },
  G2: {
    t: 2,
    name: "Drull",
    props: {
      speed: [2, 2.2, 2.5, 2.8, 3.2, 3.6],
      health: [12000, 20000, 36000, 42000, 52000, 60000],
      healtime: [3600, 7200, 14400, 28800, 57600, 115200],
      range: [35, 45, 55, 65, 85, 90],
      damage: [3000, 3600, 4200, 5500, 6500, 8000],
      feedShiny: [26, 44, 75, 105, 131],
      evolveShiny: [158, 530, 1358, 2530, 3918],
      feedCount: [3, 6, 9, 12, 15],
      feedTime: [3600 * 23],
      buffs: [0],
      movement: ["ground"],
      attack: ["melee"],
      bucket: [180],
      offset_x: [-32, -38, -52, -56, -64, -70],
      offset_y: [-28, -36, -50, -52, -68, -76],
      bonusSpeed: [0.1, 0.2, 0.4],
      bonusHealth: [2500, 5500, 10000],
      bonusRange: [0, 0, 0],
      bonusDamage: [400, 880, 1600],
      bonusBuffs: [0, 0, 0],
      bonusFeedShiny: [131, 131, 131],
      bonusFeedTime: [3600 * 24],
      targetGroup: [0],
    },
  },
  G3: {
    t: 3,
    name: "Fomor",
    props: {
      speed: [1.2, 1.4, 2, 2.1, 2.2, 2.3],
      health: [15000, 17500, 20000, 22500, 25000, 40000],
      healtime: [3600, 7200, 14400, 28800, 57600, 115200],
      range: [140, 140, 180, 190, 200, 210],
      damage: [70, 80, 90, 100, 110, 120],
      feedShiny: [26, 45, 62, 76, 96],
      evolveShiny: [154, 537, 1116, 1822, 2891],
      feedCount: [3, 6, 9, 12, 15],
      feedTime: [3600 * 23],
      buffs: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6],
      movement: ["ground", "ground", "fly"],
      attack: ["ranged"],
      bucket: [200],
      offset_x: [-20, -38, -52, -56, -60, -58],
      offset_y: [-21, -36, -50, -52, -68, -98],
      bonusSpeed: [0.1, 0.2, 0.4],
      bonusHealth: [1000, 2200, 4000],
      bonusRange: [3, 6, 10],
      bonusDamage: [3, 6, 10],
      bonusBuffs: [0.03, 0.06, 0.15],
      bonusFeedShiny: [96, 96, 96],
      bonusFeedTime: [3600 * 24],
      targetGroup: [0],
    },
  },
  G4: {
    t: 4,
    name: "Korath",
    props: {
      speed: [1.4, 1.6, 1.8, 2, 2.3, 2.5],
      health: [28000, 62000, 96000, 120000, 144000, 175000],
      healtime: [3600, 7200, 14400, 28800, 57600, 115200],
      range: [35, 45, 55, 60, 65, 65],
      damage: [2000, 2400, 3000, 3800, 5000, 6500],
      feedShiny: [26, 44, 75, 111, 136],
      evolveShiny: [158, 530, 1358, 2664, 4076],
      feedCount: [3, 6, 9, 12, 15],
      feedTime: [3600 * 23],
      buffs: [0],
      movement: ["ground"],
      attack: ["melee"],
      bucket: [200],
      offset_x: [-36, -61, -52, -62, -81, -70],
      offset_y: [-35, -49, -70, -95, -126, -130],
      bonusSpeed: [0.1, 0.2, 0.4],
      bonusHealth: [1000, 2200, 4000],
      bonusRange: [0, 0, 0],
      bonusDamage: [300, 600, 1000],
      bonusBuffs: [0],
      bonusFeedShiny: [96, 96, 96],
      bonusFeedTime: [3600 * 24],
      targetGroup: [0],
    },
  },
  G5: {
    t: 5,
    name: "Krallen",
    props: {
      speed: [2.2, 2.3, 2.4, 2.5, 2.6],
      health: [50000, 52000, 54000, 58000, 62000],
      healtime: [7200, 14400, 28800, 57600, 115200],
      range: [35, 45, 55, 60, 65],
      damage: [800, 850, 900, 1000, 1200],
      feedShiny: [26, 44, 75, 111, 136],
      evolveShiny: [158, 530, 1358, 2664],
      feedCount: [3, 6, 9, 12, 15],
      feedTime: [3600 * 23],
      buffs: [0.2, 0.22, 0.24, 0.27, 0.3],
      buffRadius: [250, 275, 300, 325, 350],
      movement: ["ground"],
      attack: ["melee"],
      bucket: [200],
      offset_x: [-64, -61, -52, -52, -52],
      offset_y: [-50, -60, -72, -72, -72],
      bonusSpeed: [0, 0, 0],
      bonusHealth: [0, 0, 0],
      bonusRange: [0, 0, 0],
      bonusDamage: [0, 0, 0],
      bonusBuffs: [0],
      bonusFeedShiny: [96, 96, 96],
      bonusFeedTime: [3600 * 24],
      targetGroup: [0],
    },
  },
};
