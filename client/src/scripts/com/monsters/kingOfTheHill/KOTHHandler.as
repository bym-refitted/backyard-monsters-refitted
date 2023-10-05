package com.monsters.kingOfTheHill
{
   import com.monsters.events.AttackEvent;
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.interfaces.IHandler;
   import com.monsters.kingOfTheHill.graphics.KOTHHUDGraphic;
   import com.monsters.kingOfTheHill.messages.KOTHEndMessage;
   import com.monsters.kingOfTheHill.messages.KOTHQuota1MetMessage;
   import com.monsters.kingOfTheHill.messages.KOTHQuota2MetMessage;
   import com.monsters.kingOfTheHill.messages.KOTHRewardMessage;
   import com.monsters.kingOfTheHill.messages.KrallenAtRiskMessage;
   import com.monsters.kingOfTheHill.messages.KrallenWinSoonMessage;
   import com.monsters.kingOfTheHill.rewards.KrallenBuffReward;
   import com.monsters.kingOfTheHill.rewards.KrallenReward;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.looting.KingOfTheHill;
   import com.monsters.rewarding.Reward;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.rewarding.RewardLibrary;
   import flash.events.MouseEvent;
   
   public class KOTHHandler implements IHandler
   {
      
      private static var _instance:com.monsters.kingOfTheHill.KOTHHandler;
       
      
      private const k_CONSECUTIVE_WINS_TO_PERMAKRALLEN:int = 5;
      
      private const _WARNING_DURATION:uint = 86400;
      
      private const _LAST_LOOT_SCORE_LABEL:String = "lastKOTHScore";
      
      private const _LAST_TIER_LABEL:String = "lastKOTHTier";
      
      private var _lootingDuration:uint = 604800;
      
      private var _lootThresholds:Vector.<uint>;
      
      private var _tierChangeMessages:Vector.<Class>;
      
      private var _lootChangeMessages:Vector.<Class>;
      
      private var _wins:uint;
      
      private var _totalLoot:Number;
      
      private var _timeToReset:uint;
      
      private var _tier:uint;
      
      private var _hudGraphic:KOTHHUDGraphic;
      
      public function KOTHHandler()
      {
         this._lootThresholds = new Vector.<uint>();
         this._tierChangeMessages = Vector.<Class>([KOTHQuota1MetMessage,KOTHQuota2MetMessage]);
         this._lootChangeMessages = Vector.<Class>([KOTHQuota1MetMessage,KOTHQuota2MetMessage]);
         super();
      }
      
      public static function get instance() : com.monsters.kingOfTheHill.KOTHHandler
      {
         if(!_instance)
         {
            _instance = new com.monsters.kingOfTheHill.KOTHHandler();
         }
         return _instance;
      }
      
      public function initialize(param1:Object = null) : void
      {
         if(!GLOBAL._flags[this.name] || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || !BASE.isMainYard)
         {
            return;
         }
         if(param1)
         {
            this.importData(param1);
         }
         if(this.doesQualify)
         {
            CHAMPIONCAGEPOPUP._kothEnabled = true;
         }
         GLOBAL.eventDispatcher.addEventListener(AttackEvent.ATTACK_OVER,this.endedAttack);
         this.updtateEvent();
         this.checkWarnings();
         this.checkEventReset();
         this.checkQuotaPopups();
         this.updateRewards();
         this.addHUDGraphic();
      }
      
      private function checkEventReset() : void
      {
         var _loc2_:Message = null;
         var _loc1_:Number = GLOBAL.StatGet(this._LAST_LOOT_SCORE_LABEL);
         if(this._totalLoot < _loc1_)
         {
            if(this._wins)
            {
               if(!this.hasWonPermanantly)
               {
                  _loc2_ = new KOTHRewardMessage(this._wins > 1);
               }
            }
            else
            {
               _loc2_ = new KOTHEndMessage(GLOBAL.StatGet(this._LAST_TIER_LABEL) >= 1);
            }
            if(_loc2_)
            {
               POPUPS.Push(new FrontPageGraphic(_loc2_));
            }
         }
      }
      
      private function checkQuotaPopups() : void
      {
         var _loc3_:Message = null;
         var _loc1_:uint = this.getTier(GLOBAL.StatGet(this._LAST_LOOT_SCORE_LABEL));
         var _loc2_:uint = this.getTier(this._totalLoot);
         if(_loc2_ > _loc1_ && _loc2_ <= this._lootChangeMessages.length)
         {
            _loc3_ = new this._lootChangeMessages[_loc2_ - 1]();
            POPUPS.Push(new FrontPageGraphic(_loc3_));
         }
      }
      
      protected function endedAttack(param1:AttackEvent) : void
      {
         var _loc2_:Object = param1.loot;
         var _loc3_:uint = _loc2_.r1.Get() + _loc2_.r2.Get() + _loc2_.r3.Get() + _loc2_.r4.Get();
         LOGGER.StatB({
            "st1":"KOTH",
            "value":_loc3_.toString()
         },"Loot");
      }
      
      protected function destroyedMaproom(param1:BuildingEvent) : void
      {
         CHAMPIONCAGEPOPUP._kothEnabled = false;
         var _loc2_:Object = {};
         _loc2_.tier = 0;
         _loc2_.wins = 0;
         _loc2_.loot = 0;
         _loc2_.countdown = 0;
         this.initialize(_loc2_);
      }
      
      private function checkWarnings() : void
      {
         if(this._timeToReset <= this._WARNING_DURATION)
         {
            if(this._tier && this._totalLoot < this.minimumLootRequiredToUnlockKrallen() && !this.hasWonPermanantly)
            {
               POPUPS.Push(new FrontPageGraphic(new KrallenAtRiskMessage()));
            }
            else if(!this._tier && this._totalLoot >= this.minimumLootRequiredToUnlockKrallen() * 0.9)
            {
               POPUPS.Push(new FrontPageGraphic(new KrallenWinSoonMessage()));
            }
         }
      }
      
      private function updtateEvent() : void
      {
         var _loc1_:KingOfTheHill = null;
         if(Boolean(ReplayableEventHandler.activeEvent) && ReplayableEventHandler.activeEvent is KingOfTheHill)
         {
            _loc1_ = ReplayableEventHandler.activeEvent as KingOfTheHill;
            _loc1_.score = this._totalLoot;
         }
      }
      
      private function updateRewards() : void
      {
         this.updateReward(KrallenReward.ID,this.tier,true);
         this.updateReward(KrallenBuffReward.ID,this._wins);
      }
      
      private function updateReward(param1:String, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:Reward;
         if(_loc4_ = RewardHandler.instance.getRewardByID(param1))
         {
            if(!param2)
            {
               RewardHandler.instance.removeReward(_loc4_);
               _loc4_ = null;
               if(param3)
               {
                  LOGGER.StatB({
                     "st1":"KOTH",
                     "st2":"Champion",
                     "st3":"Removed"
                  },this.tier + "_" + (this.wins - 1));
               }
            }
         }
         else if(param2)
         {
            _loc4_ = RewardLibrary.getRewardByID(param1);
            if(param3)
            {
               LOGGER.StatB({
                  "st1":"KOTH",
                  "st2":"Champion",
                  "st3":"Awarded"
               },this.tier + "_" + (this.wins - 1));
            }
         }
         if(_loc4_)
         {
            RewardHandler.instance.addReward(_loc4_);
            _loc4_.value = param2;
            RewardHandler.instance.applyReward(_loc4_);
         }
      }
      
      private function addHUDGraphic() : void
      {
         var _loc1_:uint = 0;
         if(!this.doesQualify || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || !BASE.isMainYard)
         {
            return;
         }
         if(CREATURES._krallen)
         {
            _loc1_ = CREATURES._krallen._level.Get();
         }
         this._hudGraphic = new KOTHHUDGraphic(Boolean(this.tier),_loc1_);
         UI2._top.addIcon(this._hudGraphic);
         this._hudGraphic.addEventListener(MouseEvent.CLICK,this.clickedHUDGraphic);
      }
      
      private function removeHUDGraphic() : void
      {
         if(!this._hudGraphic)
         {
            return;
         }
         UI2._top.removeIcon(this._hudGraphic);
         this._hudGraphic.removeEventListener(MouseEvent.CLICK,this.clickedHUDGraphic);
      }
      
      protected function clickedHUDGraphic(param1:MouseEvent) : void
      {
         CHAMPIONCAGE.ShowKrallenTab();
      }
      
      public function get name() : String
      {
         return "krallen";
      }
      
      public function importData(param1:Object) : void
      {
         this._tier = param1.tier;
         this._wins = param1.wins;
         this._totalLoot = param1.loot;
         this._timeToReset = param1.countdown;
         if(this.hasWonPermanantly)
         {
            this._lootThresholds.push(GLOBAL._flags["krallen_special1_award_threshold"] - GLOBAL._flags["krallen_award_threshold"]);
         }
         else
         {
            this._lootThresholds.push(GLOBAL._flags["krallen_special1_award_threshold"]);
         }
         this._lootThresholds.push(GLOBAL._flags["krallen_award_threshold"]);
         this._lootThresholds.push(0);
         this._lootingDuration = GLOBAL._flags["krallen_duration"] * 86400;
      }
      
      public function minimumLootRequiredToUnlockKrallen() : uint
      {
         if(this._lootThresholds.length >= 2)
         {
            return this._lootThresholds[this._lootThresholds.length - 2];
         }
         return uint.MAX_VALUE;
      }
      
      public function setDebugTimeToReset(param1:uint) : void
      {
         this._timeToReset = param1;
         this.checkWarnings();
      }
      
      public function get timePerRound() : uint
      {
         return this._lootingDuration;
      }
      
      public function get timeEnd() : uint
      {
         return ReplayableEventHandler.currentTime + this._timeToReset;
      }
      
      public function get timeStart() : uint
      {
         return this.timeEnd - this._lootingDuration;
      }
      
      public function get doesQualify() : Boolean
      {
         return TUTORIAL.hasFinished && Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= 6;
      }
      
      public function exportData() : Object
      {
         GLOBAL.StatSet(this._LAST_LOOT_SCORE_LABEL,this._totalLoot,false);
         GLOBAL.StatSet(this._LAST_TIER_LABEL,this._tier,false);
         return null;
      }
      
      public function get totalLoot() : Number
      {
         return this._totalLoot;
      }
      
      public function get timeToReset() : uint
      {
         return this._timeToReset;
      }
      
      public function get wins() : uint
      {
         return this._wins;
      }
      
      public function get hasWonPermanantly() : Boolean
      {
         return this._wins >= this.k_CONSECUTIVE_WINS_TO_PERMAKRALLEN;
      }
      
      public function get lootThresholds() : Vector.<uint>
      {
         return this._lootThresholds;
      }
      
      public function get tier() : uint
      {
         return this._tier;
      }
      
      public function getTier(param1:Number) : uint
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._lootThresholds.length)
         {
            if(param1 >= this._lootThresholds[_loc2_])
            {
               return this._lootThresholds.length - 1 - _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
   }
}
