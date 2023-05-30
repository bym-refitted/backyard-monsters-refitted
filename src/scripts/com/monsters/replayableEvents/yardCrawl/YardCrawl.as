package com.monsters.replayableEvents.yardCrawl
{
   import com.monsters.events.AttackEvent;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.replayableEvents.ReplayableEvent;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   
   public class YardCrawl extends ReplayableEvent
   {
       
      
      protected var _yardsToDestroy:uint;
      
      protected var _yardsDestroyed:uint;
      
      protected var _intactBaseList:Vector.<Object>;
      
      public function YardCrawl()
      {
         super();
         _buttonCopy = KEYS.Get("btn_attack");
      }
      
      override public function set score(param1:Number) : void
      {
         super.score = param1;
         this._yardsDestroyed = param1;
         progress = this._yardsDestroyed / this._yardsToDestroy;
      }
      
      override protected function onInitialize() : void
      {
         ReplayableEventHandler.callServerMethod("loadbases",[["eventid",_id]],this.loadedBaseList);
      }
      
      private function loadedBaseList(param1:Object) : void
      {
         var _loc3_:Object = null;
         this._intactBaseList = new Vector.<Object>();
         var _loc2_:uint = 0;
         for each(_loc3_ in param1)
         {
            if(!(_loc3_ is Number))
            {
               _loc2_++;
               if(!_loc3_.destroyed)
               {
                  this._intactBaseList.push(_loc3_);
               }
            }
         }
         this._yardsToDestroy = _loc2_;
         this.score = this._yardsToDestroy - this._intactBaseList.length;
         this._intactBaseList.sort(this.compareBaseID);
      }
      
      private function compareBaseID(param1:Object, param2:Object) : Number
      {
         return param1.id - param2.id;
      }
      
      override public function pressedActionButton() : void
      {
         var _loc2_:String = null;
         if(!this._intactBaseList || this._intactBaseList.length == 0)
         {
            return;
         }
         var _loc1_:* = HOUSING._housingUsed.Get() > 0;
         if(!GLOBAL._bMap || !GLOBAL._bFlinger || !GLOBAL._bHousing || !_loc1_)
         {
            GLOBAL.Message("You need a working Maproom, Flinger, Housing and some monsters to participate in this event");
            return;
         }
         if(MapRoomManager.instance.isInMapRoom2or3)
         {
            MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
            _loc2_ = GLOBAL._infBaseURL;
         }
         var _loc3_:uint = uint(this._intactBaseList[0].id);
         LOGGER.StatB({
            "st1":"ERS",
            "st2":_name,
            "st3":"Attack_Num_" + _loc3_,
            "value":_loc3_
         },"Attack_Start");
         GLOBAL.eventDispatcher.addEventListener(AttackEvent.ATTACK_OVER,this.finishedAttack);
         BASE.LoadBase(_loc2_,0,_loc3_,"wmattack");
      }
      
      protected function finishedAttack(param1:AttackEvent) : void
      {
         var _loc2_:uint = uint(this._intactBaseList[0].id);
         LOGGER.StatB({
            "st1":"ERS",
            "st2":_name,
            "st3":"Attack_Num_" + _loc2_,
            "value":_loc2_
         },param1.wasBaseDestroyed ? "Attack_Success" : "Attack_Fail");
         GLOBAL.eventDispatcher.removeEventListener(AttackEvent.ATTACK_OVER,this.finishedAttack);
      }
   }
}
