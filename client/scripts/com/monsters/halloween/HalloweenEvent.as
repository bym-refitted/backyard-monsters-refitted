package com.monsters.halloween {
    import flash.geom.Point;

    public class HalloweenEvent {

        public static const GIANT_PUMPKIN_TYPE:int = 54;

        private static const OFFSET_FROM_TOP_CORNER:Point = new Point(-225, 95);

        public static const SHINY_REWARD:int = 100;

        private static var s_pumpkin:GiantPumpkin;

        public static function initialize():void {
            s_pumpkin = null;

            var isAtHome:Boolean = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard;

            if (!isAtHome || !TUTORIAL.hasFinished)
                return;

            addGiantPumpkin();
            HalloweenExplosion.preload();

            s_pumpkin.dare();
        }

        public static function pumpkinExploded():void {
            if (s_pumpkin) {
                s_pumpkin.remove();
                s_pumpkin = null;
            }

            SOUNDS.PlayMusic("musicbuild");
            new HalloweenKiddingPopup().Show(null, showGoodieBag);
        }

        private static function showGoodieBag():void {
            new HalloweenGoodiePopup().Show(HalloweenGoodiePopup.showGoodies);
        }

        public static function get pumpkinPosition():Point {
            var topCorner:Point = new Point(-GLOBAL._mapWidth / 2, -GLOBAL._mapHeight / 2);

            return topCorner.add(OFFSET_FROM_TOP_CORNER);
        }

        private static function addGiantPumpkin():void {
            var props:Object = GLOBAL._buildingProps[GIANT_PUMPKIN_TYPE - 1];
            props.cls = GiantPumpkin;

            var position:Point = pumpkinPosition;

            s_pumpkin = BASE.addBuildingC(GIANT_PUMPKIN_TYPE) as GiantPumpkin;
            ++BASE._buildingCount;
            s_pumpkin.Setup({
                        "X": position.x,
                        "Y": position.y,
                        "t": GIANT_PUMPKIN_TYPE,
                        "id": BASE._buildingCount,
                        "l": 1
                    });
        }
    }
}
