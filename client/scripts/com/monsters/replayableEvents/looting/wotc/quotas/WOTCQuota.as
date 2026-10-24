package com.monsters.replayableEvents.looting.wotc.quotas {
    import com.monsters.frontPage.FrontPageGraphic;
    import com.monsters.frontPage.messages.Message;
    import com.monsters.replayableEvents.ReplayableEventQuota;
    import com.monsters.replayableEvents.attacking.monsterMadness.MonsterMadness;
    import com.monsters.replayableEvents.looting.wotc.rewards.KorathReward;

    public class WOTCQuota extends ReplayableEventQuota {

        private var _rewardLevel:uint;

        public function WOTCQuota(param1:Number, param2:String = null, param3:uint = 0, param4:Message = null) {
            super(param1, param2, KorathReward.k_REWARD_ID, param4);
            this._rewardLevel = param3;
        }

        override public function metQuota():void {
            this.updateReward();
            if (hasBeenAwarded) {
                return;
            }
            _dateAwarded = GLOBAL.Timestamp();
            if (message) {
                POPUPS.Push(new FrontPageGraphic(message));
            }
        }

        public function updateReward():void {
            MonsterMadness.setKorathPowerLevel(this._rewardLevel);
        }
    }
}
