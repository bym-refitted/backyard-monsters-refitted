package com.monsters.halloween {
    import com.monsters.display.ImageCache;
    import com.monsters.effects.ResourceBombs;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class HalloweenPumpkinPatch {

        private static const SPAWN_DAY_STAT:String = "hwnPumpkinDay";

        private static const MIN_PUMPKINS:int = 4;

        private static const MAX_PUMPKINS:int = 5;

        private static const LIFETIME_SECONDS:int = 86400;

        private static const SPOT_TRIES:int = 5000;

        private static const SPOT_FOOTPRINT:Rectangle = new Rectangle(0, 0, 30, 30);

        private static const TRICK_BOMB:String = "tw0";

        private static const TWIGS_IMAGE:String = "effects/twigs.png";

        private static const YARD_MIDDLE:Point = new Point(0, 0);

        /**
         * Grows today's pumpkins, once a day, topping the yard up to between 4 and 5, then saves them.
         */
        public static function growToday():void {
            ImageCache.GetImageWithCallBack(TWIGS_IMAGE, ResourceBombs.onAssetLoaded);

            var today:int = int(GLOBAL.Timestamp() / LIFETIME_SECONDS);

            if (GLOBAL.StatGet(SPAWN_DAY_STAT) == today)
                return;

            GLOBAL.StatSet(SPAWN_DAY_STAT, today);

            var wanted:int = MIN_PUMPKINS + int(Math.random() * (MAX_PUMPKINS - MIN_PUMPKINS + 1));
            var toGrow:int = wanted - countGrowing();

            for (var i:int = 0; i < toGrow; i++)
                growOne();

            BASE.Save();
        }

        private static function countGrowing():int {
            var count:int = 0;

            for each (var building:BFOUNDATION in BASE._buildingsAll) {
                if (building is HalloweenMiniPumpkin && !HalloweenMiniPumpkin(building).isSpoiled)
                    count++;
            }
            return count;
        }

        /**
         * Grows a pumpkin at a free spot inside the yard, found as MUSHROOMS.Spawn finds one for a mushroom.
         */
        private static function growOne():void {
            var halfWidth:Number = GLOBAL._mapWidth * 0.5;
            var halfHeight:Number = GLOBAL._mapHeight * 0.5;

            for (var tries:int = 0; tries < SPOT_TRIES; tries++) {
                var x:int = int(halfWidth - Math.random() * GLOBAL._mapWidth);
                var y:int = int(halfHeight - Math.random() * GLOBAL._mapHeight);

                if (GRID.FootprintBlocked([SPOT_FOOTPRINT], GRID.ToISO(x, y, 0), true))
                    continue;

                var pumpkin:BFOUNDATION = BASE.addBuildingC(HalloweenMiniPumpkin.TYPE);
                ++BASE._buildingCount;
                pumpkin.Setup({
                            "X": x,
                            "Y": y,
                            "t": HalloweenMiniPumpkin.TYPE,
                            "id": BASE._buildingCount,
                            "l": 1,
                            "e": GLOBAL.Timestamp() + LIFETIME_SECONDS
                        });
                return;
            }
        }

        /**
         * A worker has picked a pumpkin: it's gone, and it's a Trick or a Treat.
         */
        public static function pick(pumpkin:HalloweenMiniPumpkin):void {
            QUEUE.Remove(pumpkin.queueKey, true);
            pumpkin.remove();

            if (Math.random() < 0.5 && ResourceBombs.bmd_twigs)
                trick();
            else
                treat();
        }

        /**
         * Drops the smallest Catapult twig bomb on the middle of the yard. In the player's own yard,
         * ResourceBombs.Tick repairs whatever it damaged once it has landed.
         */
        private static function trick():void {
            var bomb:Object = {};

            for (var key:String in ResourceBombs._bombs[TRICK_BOMB])
                bomb[key] = ResourceBombs._bombs[TRICK_BOMB][key];

            ResourceBombs.Trigger(MAP._BUILDINGBASES, YARD_MIDDLE, bomb, 2);
        }

        /**
         * Gives one random resource, sized as a gift is (GIFTS.Process): usually 2-4% of what the player can store of
         * it, and one time in four 7-12%.
         */
        private static function treat():void {
            var share:Number = Math.random() * 100 > 75 ? 0.07 + Math.random() * 0.05 : 0.02 + Math.random() * 0.02;
            var resource:int = 1 + int(Math.random() * 4);
            var amount:int = int(BASE._resources["r" + resource + "max"] * share);

            BASE.Fund(resource, amount);
            BASE.Save();
        }
    }
}
