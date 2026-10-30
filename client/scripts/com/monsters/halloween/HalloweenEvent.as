package com.monsters.halloween {
    import com.monsters.inventory.InventoryManager;
    import flash.geom.Point;
    import gs.TweenLite;

    public class HalloweenEvent {

        public static const GIANT_PUMPKIN_TYPE:int = 54;

        private static const OFFSET_FROM_TOP_CORNER:Point = new Point(-225, 95);

        private static const OPEN_URL:String = "bm/event/halloween/open";

        private static const REWARD_WAIT_SECONDS:Number = 10;

        private static var s_pumpkin:GiantPumpkin;

        private static var s_reward:Object;

        private static var s_isWaitingForReward:Boolean;

        private static var s_isShowOver:Boolean;

        private static var s_isRevealed:Boolean;

        /**
         * Stands the Giant Pumpkin outside the main yard on Halloween, until this year's has been opened, as the base
         * load's "halloween" says.
         */
        public static function initialize():void {
            s_pumpkin = null;

            var isAtHome:Boolean = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard;
            var halloween:Object = BASE.loadObject["halloween"];

            if (!isAtHome || !TUTORIAL.hasFinished || !halloween || !halloween.active || halloween.opened)
                return;

            addGiantPumpkin();
            HalloweenExplosion.preload();

            s_pumpkin.dare();
        }

        /**
         * Asks the server for the Goodie Bag as the pumpkin is opened, so it's had even if the game is closed during
         * the show. The server gives it once a year, whatever the client asks.
         */
        public static function claimGoodieBag():void {
            s_reward = null;
            s_isWaitingForReward = true;
            s_isShowOver = false;
            s_isRevealed = false;

            new URLLoaderApi().load(GLOBAL._apiURL + OPEN_URL, [["open", 1]], claimedGoodieBag, failedGoodieBag);
        }

        private static function claimedGoodieBag(response:Object):void {
            if (response && response.error == 0 && response.granted == 1) {
                s_reward = response;
                applyReward(response);
            }

            gotReward();
        }

        private static function failedGoodieBag(error:Object = null):void {
            gotReward();
        }

        /**
         * The Shiny is the server's, so its new balance is shown as it is after a save. The decorations go into
         * storage here as well as on the server, as stored buildings are saved from the client.
         */
        private static function applyReward(reward:Object):void {
            var credits:int = int(reward.credits);

            BASE._credits.Set(credits);
            BASE._hpCredits = credits;
            GLOBAL._credits.Set(credits);

            for (var key:String in reward.decorations) {
                for (var i:int = 0; i < int(reward.decorations[key]); i++)
                    InventoryManager.buildingStorageAdd(int(key.substr(1)));
            }

            BASE.Save();
        }

        private static function gotReward():void {
            s_isWaitingForReward = false;

            if (s_isShowOver)
                showReveal();
        }

        public static function pumpkinExploded():void {
            if (s_pumpkin) {
                s_pumpkin.remove();
                s_pumpkin = null;
            }

            SOUNDS.PlayMusic("musicbuild");
            s_isShowOver = true;

            if (s_isWaitingForReward)
                TweenLite.delayedCall(REWARD_WAIT_SECONDS, showReveal);
            else
                showReveal();
        }

        /**
         * "Only kidding", then the Goodie Bag if the server gave one. Without it the reveal says so, and as nothing
         * was recorded, the pumpkin is back next time.
         */
        private static function showReveal():void {
            if (s_isRevealed)
                return;

            s_isRevealed = true;
            TweenLite.killDelayedCallsTo(showReveal);

            var reward:Object = s_reward;

            if (reward)
                new HalloweenKiddingPopup(int(reward.shiny)).Show(null, showGoodieBag);
            else
                new HalloweenKiddingPopup(0).Show();

            POPUPS.Release();
        }

        private static function showGoodieBag():void {
            new HalloweenGoodiePopup(int(s_reward.shiny)).Show(HalloweenGoodiePopup.showGoodies);
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
