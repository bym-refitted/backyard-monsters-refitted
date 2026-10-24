package com.monsters.replayableEvents.looting.wotc {
    import com.monsters.frontPage.messages.Message;
    import com.monsters.maproom_manager.MapRoomManager;
    import com.monsters.replayableEvents.*;
    import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
    import com.monsters.replayableEvents.looting.wotc.messages.*;
    import com.monsters.replayableEvents.looting.wotc.quotas.WOTCQuota;

    public class WrathOfTheChampion extends ReplayableEvent {

        public static const EVENT_PAGE_URL:String = "http://www.kixeye.com/monster-madness";

        protected var m_lastKnownScore:Number;

        public function WrathOfTheChampion() {
            _name = "Wrath of the Champion";
            _progress = -1;
            _priority = 400;
            _id = 6;
            _messages = Vector.<Message>([new WOTCPromoMessage1(), new WOTCPromoMessage2(), new WOTCPromoMessage3(), new WOTCStartMessage(), new WOTCEndMessage()]);
            super();
            _maxScore = MonsterMadness.POINTS_GOAL3;
            _originalStartDate = 1345143600;
            _duration = _DEFAULT_EVENT_DURATION;
            this.m_lastKnownScore = MonsterMadness.points;
            getServerScore();
            _quotas.push(new WOTCQuota(MonsterMadness.POINTS_GOAL1, "events/wotc/wotc_reward1.png", 1, new WOTCRewardMessage1()));
            _quotas.push(new WOTCQuota(MonsterMadness.POINTS_GOAL2, "events/wotc/wotc_reward2.png", 2, new WOTCRewardMessage2()));
            _quotas.push(new WOTCQuota(_maxScore, "events/wotc/wotc_reward3.png", 3, new WOTCRewardMessage3()));
        }

        override public function get imageURL():String {
            return hasEventStarted ? "events/wotc/mm_timer.png" : "events/wotc/mm_magma_champ_art.png";
        }

        override public function get titleImage():String {
            return hasEventStarted ? "events/wotc/mm_logo_meter.png" : "events/wotc/mm_logo_timer.v2.png";
        }

        /**
         * The score is fetched again on every base load as well as on construction, which only
         * happens once a session: the server scores each takeover, so coming home from the
         * World Map shows the new score without reloading the game.
         */
        override protected function onInitialize():void {
            this.removeOwnedRewardQuotas();
            getServerScore();
        }

        private function removeOwnedRewardQuotas():void {
            var _loc1_:Number = this.m_lastKnownScore;
            var _loc2_:* = int(_quotas.length - 1);
            while (_loc2_ >= 0) {
                if (_loc1_ >= _quotas[_loc2_].quota) {
                    _quotas.splice(_loc2_, 1);
                }
                _loc2_--;
            }
        }

        override public function createNewUI():IReplayableEventUI {
            if (hasEventStarted) {
                return new MultiRewardReplayableEventUI();
            }
            return new ReplayableEventCountdown();
        }

        override public function getCurrentMessage():Message {
            return super.getCurrentMessage();
        }

        override public function pressedHelpButton():Message {
            var _loc1_:ReplayableEventQuota = getLatestMetQuota(_score);
            if (Boolean(_loc1_) && Boolean(_loc1_.message)) {
                return _loc1_.message;
            }
            return super.getCurrentMessage();
        }

        override public function get hasCompletedEvent():Boolean {
            return this.m_lastKnownScore >= _maxScore || _score >= _maxScore;
        }

        override protected function setScoreFromServer(param1:Object):void {
            super.setScoreFromServer(param1);
            setMetQuotas();
            if (this.hasCompletedEvent) {
                return;
            }
            progress = _score / _maxScore;
        }

        /**
         * At home, for every Map Room but Map Room 3, which came after the event. Players without
         * Map Room 2 still see it: its start message offers them the Map Room upgrade.
         */
        override public function doesQualify():Boolean {
            // return false;
            var isAtHome:Boolean = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard;

            return isAtHome && !MapRoomManager.instance.isInMapRoom3;
        }
    }
}
