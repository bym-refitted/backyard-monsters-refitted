package com.monsters.replayableEvents.monsterInvasion {
    import com.monsters.monsters.MonsterBase;

    public class InvasionMonsterStats {

        private static const ORIGINAL_HEALTH:Object = {
                "IC1": [400, 425, 450, 475, 510, 550],
                "IC2": [1500, 1620, 1760, 1900, 2150, 2300],
                "IC3": [450, 470, 500, 540, 580, 620],
                "IC4": [715, 730, 750, 765, 780, 800],
                "IC5": [800, 840, 880, 920, 965, 1125],
                "IC6": [1600, 1750, 1900, 2100, 2300, 2500],
                "IC7": [920, 960, 1000, 1050, 1100, 1200],
                "IC8": [2500, 2600, 2700, 2900, 3100, 3400]
            };

        private static const ORIGINAL_DAMAGE:Object = {
                "IC1": [120, 130, 140, 150, 160, 175],
                "IC2": [80, 85, 90, 95, 100, 110],
                "IC3": [100, 105, 110, 120, 130, 140],
                "IC4": [490, 530, 580, 645, 700, 775],
                "IC5": [400, 430, 460, 490, 520, 560],
                "IC6": [400, 425, 450, 475, 500, 550],
                "IC7": [500, 525, 550, 575, 600, 650],
                "IC8": [900, 960, 1030, 1120, 1220, 1350]
            };

        /**
         * Replaces a freshly spawned invasion monster's health and damage with the original
         * event values. Must run before any modifiers (enrage etc.) are attached.
         * Monsters without an override (all overworld monsters) are left untouched.
         *
         * @param {MonsterBase} monster - The monster WMATTACK.SpawnB just created
         * @param {int} level - Wave level (1-6) the monster was spawned at
         * @param {Number} progressMultiplier - The 0.4-0.9 base progress scaling SpawnB applied
         */
        public static function applyOriginalStats(monster:MonsterBase, level:int, progressMultiplier:Number):void {
            if (!monster || level <= 0)
                return;

            var healthByLevel:Array = ORIGINAL_HEALTH[monster._creatureID];
            var damageByLevel:Array = ORIGINAL_DAMAGE[monster._creatureID];

            if (!healthByLevel || !damageByLevel)
                return;

            var levelIndex:int = Math.min(level, healthByLevel.length) - 1;
            var health:int = int(healthByLevel[levelIndex] * progressMultiplier);

            monster.setHealth(health);
            monster.maxHealthProperty.value = health;
            monster.damageProperty.set (int(damageByLevel[levelIndex] * progressMultiplier));
        }
    }
}
