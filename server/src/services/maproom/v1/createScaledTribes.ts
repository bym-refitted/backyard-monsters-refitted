enum TribeConfig {
  TRIBE_ID = 214,
  TOTAL_TRIBES = 7,
  MAX_TRIBE_LEVEL = 26,
}

export const createScaledTribes = (level: number) => {
  const playerLevel = Math.max(1, level);

  const levelPattern = [0, -1, 0, 0, 3, -1, 2];

  return Array.from({ length: TribeConfig.TOTAL_TRIBES }, (_, i) => {
    const tribeId = TribeConfig.TRIBE_ID + i;

    let tribeLevel = playerLevel + levelPattern[i];
    tribeLevel = Math.max(1, Math.min(tribeLevel, TribeConfig.MAX_TRIBE_LEVEL));

    return [tribeId, tribeLevel, 0];
  });
};
