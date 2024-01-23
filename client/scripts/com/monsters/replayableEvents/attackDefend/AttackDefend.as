package com.monsters.replayableEvents.attackDefend
{
   import com.monsters.ai.TRIBES;
   import com.monsters.events.AttackEvent;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.ReplayableEventQuota;
   import com.monsters.replayableEvents.monsterInvasion.MonsterInvasion;
   
   public class AttackDefend extends MonsterInvasion
   {
      
      public static const SCORE_PER_WAVE:int = 1;
      
      public static const SCORE_PER_YARD:int = 1000;
       
      
      protected var _yardsToDestroy:uint;
      
      protected var _yardsDestroyed:uint = 0;
      
      protected var _intactBaseList:Vector.<Object>;
      
      protected var _wavesBeforeAttack:uint;
      
      protected var _maxWaves:uint;
      
      public function AttackDefend(param1:uint = 0)
      {
         super(param1);
      }
      
      override protected function set wavesDestroyed(param1:uint) : void
      {
      }
      
      protected function set yardsDestroyed(param1:uint) : void
      {
      }
      
      override public function set score(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ReplayableEventQuota = null;
         if(_score >= 0 && param1 - _score > 0)
         {
            ReplayableEventHandler.callServerMethod("updatescore",[["eventid",_id],["delta",param1 - _score]],this.verifyScoreFromServer);
         }
         _score = param1;
         if(!m_mustBeInsideBase || m_mustBeInsideBase && GLOBAL.isAtHome() === true)
         {
            _loc2_ = int(_quotas.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = _quotas[_loc3_];
               if(_score >= _loc4_.quota && !_loc4_.hasBeenAwarded)
               {
                  _loc4_.metQuota();
               }
               _loc3_++;
            }
         }
         this._yardsDestroyed = Math.floor(Math.max(_score,0) / SCORE_PER_YARD);
         _wavesDestroyed = Math.max(_score,0) % SCORE_PER_YARD;
         progress = (_wavesDestroyed + this._yardsDestroyed) / (_wavesTotal + this._yardsToDestroy);
      }
      
      override protected function onInitialize() : void
      {
         super.onInitialize();
         ReplayableEventHandler.callServerMethod("loadbases",[["eventid",_id]],this.loadedBaseList);
      }
      
      override public function pressedActionButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         if(!this.readyToAttackNextYard())
         {
            setupNextWave();
            ++_numAttempts;
            LOGGER.StatB({
               "st1":"ERS",
               "st2":_name,
               "st3":"Wave_Num_" + _wavesDestroyed,
               "value":_numAttempts
            },"Attack_Start");
         }
         else if(Boolean(this._intactBaseList) && this._intactBaseList.length > 0)
         {
            _loc1_ = HOUSING._housingUsed.Get() > 0 || CREATURES._guardian != null;
            if(!GLOBAL._bMap || !GLOBAL._bFlinger || !GLOBAL._bFlinger._canFunction || !GLOBAL._bHousing || !_loc1_)
            {
               GLOBAL.Message("You need a working Maproom, Flinger, Housing and some monsters to participate in this next phase.");
               return;
            }
            if(MapRoomManager.instance.isInMapRoom2or3)
            {
               MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
               _loc2_ = GLOBAL._infBaseURL;
            }
            _loc3_ = uint(this._intactBaseList[this._yardsDestroyed].id);
            if(this._intactBaseList[this._yardsDestroyed].destroyed == true)
            {
            }
            LOGGER.StatB({
               "st1":"ERS",
               "st2":_name,
               "st3":"Attack_Num_" + _loc3_,
               "value":_loc3_
            },"Attack_Start");
            GLOBAL.eventDispatcher.addEventListener(AttackEvent.ATTACK_OVER,this.finishedAttack);
            BASE.LoadBase(_loc2_,LOGIN._playerID,_loc3_,"wmattack");
         }
         else if(_wavesDestroyed >= this._maxWaves && this._yardsDestroyed >= this._yardsToDestroy)
         {
            progress = 1;
         }
      }
      
      protected function finishedAttack(param1:AttackEvent) : void
      {
         GLOBAL.eventDispatcher.removeEventListener(AttackEvent.ATTACK_OVER,this.finishedAttack);
         if(param1.wasBaseDestroyed)
         {
            this.score = _score + SCORE_PER_YARD;
         }
      }
      
      override protected function onEventComplete() : void
      {
      }
      
      override public function importData(param1:Object) : void
      {
         super.importData(param1);
         this.yardsDestroyed = param1["_yardsDestroyed"];
         if(_isActive)
         {
            ReplayableEventHandler.callServerMethod("geteventscore",[["eventid",_id]],this.serverScoreCallback);
         }
      }
      
      override public function exportData() : Object
      {
         var _loc1_:Object = super.exportData();
         _loc1_["_yardsDestroyed"] = this._yardsDestroyed;
         return _loc1_;
      }
      
      protected function serverScoreCallback(param1:Object) : void
      {
         var _loc2_:int = int(param1.score);
         if(_loc2_)
         {
            _score = _loc2_;
            this.score = _loc2_;
         }
      }
      
      override public function reset() : void
      {
         super.reset();
         _numAttempts = 0;
         _wavesDestroyed = 0;
      }
      
      protected function loadedBaseList(param1:Object) : void
      {
         var _loc2_:Object = null;
         this._intactBaseList = new Vector.<Object>();
         for each(_loc2_ in param1)
         {
            if(!(_loc2_ is Number))
            {
               this._intactBaseList.push(_loc2_);
               BASE.addEventBaseException(_loc2_.id);
               TRIBES.B_IDS.push(_loc2_.id);
            }
         }
      }
      
      override protected function verifyScoreFromServer(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super.verifyScoreFromServer(param1);
         var _loc2_:Number = param1.score as Number;
         if(_score != _loc2_ && (param1.score is Number || param1.score is int))
         {
            _loc3_ = 0;
            _loc4_ = Math.floor(_loc2_ / SCORE_PER_YARD);
            _loc5_ = Math.floor(_score / SCORE_PER_YARD);
            _loc6_ = Math.floor(_wavesDestroyed / this._wavesBeforeAttack);
            if(_loc4_ < this._yardsDestroyed && _loc5_ == this._yardsDestroyed && _loc5_ >= _loc6_ - 1)
            {
               _loc3_ += SCORE_PER_YARD * (_loc5_ - _loc4_);
            }
            _loc7_ = _loc2_ % SCORE_PER_YARD;
            if((_loc8_ = _score % SCORE_PER_YARD) > _loc7_)
            {
               _loc3_ += _loc8_ - _loc7_;
            }
            if(_loc3_ > 0)
            {
               ReplayableEventHandler.callServerMethod("updatescore",[["eventid",_id],["delta",_loc3_]],this.verifyScoreFromServer);
            }
         }
      }
      
      protected function readyToAttackNextYard() : Boolean
      {
         return Math.floor(_wavesDestroyed / this._wavesBeforeAttack) > this._yardsDestroyed;
      }
   }
}
