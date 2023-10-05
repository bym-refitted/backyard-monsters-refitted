package com.monsters.replayableEvents.attackDefend.brukkargWar
{
   import com.monsters.ai.TRIBES;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.frontPage.messages.events.brukkargWar.*;
   import com.monsters.replayableEvents.IReplayableEventUI;
   import com.monsters.replayableEvents.MultiRewardReplayableEventUI;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.replayableEvents.ReplayableEventQuota;
   import com.monsters.replayableEvents.ReplayableEventUI;
   import com.monsters.replayableEvents.attackDefend.AttackDefend;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.BrukkargWarFinalAttackMessage;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.messages.BrukkargWarFirstAttackMessage;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.quotas.SpurtzCannonQuota1;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.quotas.SpurtzCannonQuota2;
   import com.monsters.replayableEvents.attackDefend.brukkargWar.quotas.SpurtzCannonQuota3;
   import com.monsters.replayableEvents.monsterInvasion.WaveObj;
   
   public class BrukkargWarEvent extends AttackDefend
   {
      
      private static const WAVES:Array = [[new WaveObj("C2","bounce",50,WaveObj.DIR.N,6,3,true),new WaveObj("C6","bounce",50,WaveObj.DIR.N,6,3)],[new WaveObj("IC1","bounce",20,WaveObj.DIR.N,6,3,true),3,new WaveObj("C5","bounce",10,WaveObj.DIR.N,6,3),new WaveObj("C5","bounce",10,WaveObj.DIR.S,6,3)],[new WaveObj("C10","bounce",30,WaveObj.DIR.N,6,3,true),new WaveObj("C17","bounce",30,WaveObj.DIR.N,6,3)],[new WaveObj("C6","bounce",40,WaveObj.DIR.N,6,3,true),new WaveObj("C2","bounce",40,WaveObj.DIR.N,6,3),new WaveObj("C9","bounce",40,WaveObj.DIR.N,6,3),new WaveObj("C3","bounce",40,WaveObj.DIR.N,6,3)],[new WaveObj("G1","bounce",1,WaveObj.DIR.N,6,3,true),new WaveObj("C16","bounce",10,WaveObj.DIR.N,6,3)],[new WaveObj("C8","bounce",40,WaveObj.DIR.N,6,3,true),new WaveObj("C16","bounce",10,WaveObj.DIR.N,6,3),2,new WaveObj("C8","bounce",40,WaveObj.DIR.N,6,3),new WaveObj("C16","bounce",10,WaveObj.DIR.N,6,3),4,new WaveObj("IC6","bounce",30,WaveObj.DIR.N,6,3),new WaveObj("C16","bounce",10,WaveObj.DIR.N,6,3)],[new WaveObj("C11","bounce",70,WaveObj.DIR.N,6,3,true)],[new WaveObj("C7","bounce",30,WaveObj.DIR.N,6,3,true),new WaveObj("C10","bounce",30,WaveObj.DIR.N,6,3),new WaveObj("IC4","bounce",20,WaveObj.DIR.N,6,3)],[new WaveObj("C12","bounce",5,WaveObj.DIR.N,6,3,true),new WaveObj("C6","bounce",10,WaveObj.DIR.N,6,3)],[new WaveObj("C5","bounce",8,WaveObj.DIR.N,6,3),new WaveObj("C5","bounce",8,WaveObj.DIR.S,6,3),new WaveObj("C5","bounce",8,WaveObj.DIR.E,6,3),new WaveObj("C5","bounce",8,WaveObj.DIR.W,6,3),5,new WaveObj("G5","bounce",3,WaveObj.DIR.N,6,3,true),new WaveObj("G5","bounce",3,WaveObj.DIR.S,6,3),new WaveObj("C5","bounce",5,WaveObj.DIR.E,6,3),new WaveObj("C5","bounce",5,WaveObj.DIR.W,6,3)],[new WaveObj("C17","bounce",25,WaveObj.DIR.N,6,3,true),new WaveObj("IC1","bounce",25,WaveObj.DIR.N,6,3),new WaveObj("C1","bounce",25,WaveObj.DIR.N,6,3),30,new WaveObj("C17","bounce",25,WaveObj.DIR.N,6,3),new WaveObj("IC1","bounce",25,WaveObj.DIR.N,6,3),new WaveObj("C1","bounce",25,WaveObj.DIR.N,6,3)],[new WaveObj("IC4","bounce",20,WaveObj.DIR.N,6,3,true),new WaveObj("C13","bounce",30,WaveObj.DIR.N,6,3)],[new WaveObj("C6","bounce",50,WaveObj.DIR.N,6,3,true),2,new WaveObj("C3","bounce",50,WaveObj.DIR.N,6,3),new WaveObj("IC7","bounce",50,WaveObj.DIR.N,6,3),new WaveObj("C16","bounce",20,WaveObj.DIR.N,6,3)],[new WaveObj("C5","bounce",6,WaveObj.DIR.N,6,3,true),1,new WaveObj("C9","bounce",50,WaveObj.DIR.N,6,3,true),new WaveObj("C15","bounce",1,WaveObj.DIR.N,6,3),1,new WaveObj("C5","bounce",6,WaveObj.DIR.N,6,3),1,new WaveObj("C3","bounce",50,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",1,WaveObj.DIR.N,6,3),1,new WaveObj("C5","bounce",6,WaveObj.DIR.N,6,3),1,new WaveObj("C12","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",1,WaveObj.DIR.N,6,3)],[new WaveObj("C5","bounce",6,WaveObj.DIR.N,6,3),1,new WaveObj("C5","bounce",6,WaveObj.DIR.S,6,3),1,new WaveObj("C5","bounce",6,WaveObj.DIR.E,6,3),1,new WaveObj("C5","bounce",6,WaveObj.DIR.W,6,3),1,new WaveObj("G2","bounce",1,WaveObj.DIR.N,6,3,true),new WaveObj("C15","bounce",5,WaveObj.DIR.N,6,3),new WaveObj("IC2","bounce",40,WaveObj.DIR.N,6,3)],[new WaveObj("C11","bounce",20,WaveObj.DIR.N,6,3,true),new WaveObj("C12","bounce",1,WaveObj.DIR.N,6,3),new WaveObj("C16","bounce",5,WaveObj.DIR.N,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.N,6,3),new WaveObj("C11","bounce",20,WaveObj.DIR.S,6,3),new WaveObj("C12","bounce",1,WaveObj.DIR.S,6,3),new WaveObj("C16","bounce",5,WaveObj.DIR.S,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.S,6,3),new WaveObj("C11","bounce",20,WaveObj.DIR.E,6,3),new WaveObj("C12","bounce",1,WaveObj.DIR.E,6,3),new WaveObj("C16","bounce",5,WaveObj.DIR.E,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.E,6,3),new WaveObj("C11","bounce",20,WaveObj.DIR.W,6,3),new WaveObj("C12","bounce",1,WaveObj.DIR.W,6,3),new WaveObj("C16","bounce",5,WaveObj.DIR.W,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.W,6,3)],[new WaveObj("C17","bounce",10,WaveObj.DIR.N,6,3,true),new WaveObj("C17","bounce",10,WaveObj.DIR.S,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.W,6,3),new WaveObj("C17","bounce",10,WaveObj.DIR.E,6,3),new WaveObj("C1","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C1","bounce",20,WaveObj.DIR.S,6,3),new WaveObj("C1","bounce",20,WaveObj.DIR.E,6,3),new WaveObj("C1","bounce",20,WaveObj.DIR.W,6,3),new WaveObj("IC1","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("IC1","bounce",20,WaveObj.DIR.S,6,3),new WaveObj("IC1","bounce",20,WaveObj.DIR.E,6,3),new WaveObj("IC1","bounce",20,WaveObj.DIR.W,6,3),new WaveObj("C12","bounce",6,WaveObj.DIR.N,6,3),new WaveObj("C12","bounce",6,WaveObj.DIR.S,6,3),new WaveObj("C12","bounce",6,WaveObj.DIR.E,6,3),new WaveObj("C12","bounce",6,WaveObj.DIR.W,6,3)],[new WaveObj("C5","bounce",20,WaveObj.DIR.N,6,3,true),new WaveObj("C7","bounce",50,WaveObj.DIR.N,6,3),new WaveObj("C8","bounce",50,WaveObj.DIR.N,6,3),new WaveObj("C10","bounce",60,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",5,WaveObj.DIR.N,6,3)],[new WaveObj("IC4","bounce",40,WaveObj.DIR.N,6,3,true),new WaveObj("C14","bounce",50,WaveObj.DIR.N,6,3),5,new WaveObj("C16","bounce",5,WaveObj.DIR.N,6,3)],[new WaveObj("G3","bounce",1,WaveObj.DIR.N,6,3,true),new WaveObj("C10","bounce",60,WaveObj.DIR.N,6,3),new WaveObj("C6","bounce",60,WaveObj.DIR.N,6,3),new WaveObj("C5","bounce",11,WaveObj.DIR.N,6,3)],[new WaveObj("C12","bounce",16,WaveObj.DIR.N,6,3,true),new WaveObj("C12","bounce",16,WaveObj.DIR.S,6,3),new WaveObj("C12","bounce",16,WaveObj.DIR.E,6,3),new WaveObj("C12","bounce",16,WaveObj.DIR.W,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.S,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.W,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.E,6,3)],[new WaveObj("C14","bounce",10,WaveObj.DIR.N,6,3,true),2,new WaveObj("IC5","bounce",10,WaveObj.DIR.N,6,3),new WaveObj("C14","bounce",10,WaveObj.DIR.N,6,3),2,new WaveObj("C14","bounce",10,WaveObj.DIR.N,6,3),2,new WaveObj("IC5","bounce",10,WaveObj.DIR.N,6,3),2,new WaveObj("C14","bounce",15,WaveObj.DIR.N,6,3),2,new WaveObj("IC5","bounce",15,WaveObj.DIR.N,6,3),2,new WaveObj("C14","bounce",20,WaveObj.DIR.N,6,3),2,new WaveObj("IC5","bounce",20,WaveObj.DIR.N,6,3)],[new WaveObj("IC4","bounce",15,WaveObj.DIR.N,6,3,true),new WaveObj("C13","bounce",15,WaveObj.DIR.N,6,3),new WaveObj("IC8","bounce",15,WaveObj.DIR.N,6,3),30,new WaveObj("IC4","bounce",15,WaveObj.DIR.N,6,3,true),new WaveObj("C13","bounce",15,WaveObj.DIR.N,6,3),new WaveObj("IC8","bounce",15,WaveObj.DIR.N,6,3)],[new WaveObj("C12","bounce",25,WaveObj.DIR.N,6,3,true),new WaveObj("C12","bounce",25,WaveObj.DIR.S,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.S,6,3),10,new WaveObj("C12","bounce",15,WaveObj.DIR.N,6,3),new WaveObj("C12","bounce",15,WaveObj.DIR.S,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",2,WaveObj.DIR.S,6,3)],[new WaveObj("C5","bounce",10,WaveObj.DIR.N,6,3,true),3,new WaveObj("C12","bounce",15,WaveObj.DIR.N,6,3),new WaveObj("C14","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",5,WaveObj.DIR.N,6,3),5,new WaveObj("G4","bounce",1,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",5,WaveObj.DIR.N,6,3),new WaveObj("C14","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C12","bounce",15,WaveObj.DIR.N,6,3),30,new WaveObj("G4","bounce",1,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",5,WaveObj.DIR.N,6,3),new WaveObj("C14","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C12","bounce",15,WaveObj.DIR.N,6,3),10,new WaveObj("C12","bounce",20,WaveObj.DIR.N,6,3),new WaveObj("C15","bounce",3,WaveObj.DIR.N,6,3)]];
       
      
      private const _BUILDING_REWARD_ID:String = "C17";
      
      private const _WAVES_TOTAL:uint = 25;
      
      public function BrukkargWarEvent()
      {
         _name = "Brukkarg War";
         _progress = -1;
         _priority = 500;
         _id = 5;
         _yardsToDestroy = 5;
         _wavesTotal = this._WAVES_TOTAL;
         _wavesBeforeAttack = 5;
         _maxWaves = 25;
         _titleImage = "events/brukkargWar/brukkarg_countdown_title_v2.png";
         _imageURL = "events/brukkargWar/brukkarg_countdown_image_v2.png";
         _messages = Vector.<Message>([new BrukkargWarPromoMessage1(),new BrukkargWarPromoMessage2(),new BrukkargWarPromoMessage3(),new BrukkargWarStartMessage(),new BrukkargWarEndMessage()]);
         _rewardMessage = new BrukkargWarRewardMessage();
         super(this._WAVES_TOTAL);
         _duration = 432000;
         _originalStartDate = 1342724400;
         m_mustBeInsideBase = true;
         _quotas.push(new SpurtzCannonQuota1());
         _quotas.push(new SpurtzCannonQuota2());
         _quotas.push(new SpurtzCannonQuota3());
         _quotas.push(new ReplayableEventQuota(SCORE_PER_WAVE * 5,null,null,new BrukkargWarFirstAttackMessage()));
         _quotas.push(new ReplayableEventQuota(SCORE_PER_YARD * 4 + SCORE_PER_WAVE * 25,null,null,new BrukkargWarFinalAttackMessage()));
      }
      
      override public function set score(param1:Number) : void
      {
         super.score = param1;
         if(_score == 4025 && _intactBaseList && _intactBaseList.length < 5)
         {
            ReplayableEventHandler.callServerMethod("copybase",[["eventid",5]],this.copyBaseCallback);
         }
      }
      
      override public function get imageURL() : String
      {
         return hasEventStarted ? "events/brukkargWar/brukkarg_running_image.png" : _imageURL;
      }
      
      override public function get titleImage() : String
      {
         return hasEventStarted ? "events/brukkargWar/brukkarg_logo.png" : _titleImage;
      }
      
      override public function get buttonCopy() : String
      {
         if(readyToAttackNextYard())
         {
            _buttonCopy = KEYS.Get("btn_attack");
         }
         else
         {
            _buttonCopy = KEYS.Get("btn_next");
         }
         return _buttonCopy;
      }
      
      override public function createNewUI() : IReplayableEventUI
      {
         if(hasEventStarted)
         {
            return new MultiRewardReplayableEventUI();
         }
         return new ReplayableEventUI();
      }
      
      override protected function onInitialize() : void
      {
         super.onInitialize();
      }
      
      override public function pressedActionButton() : void
      {
         super.pressedActionButton();
      }
      
      override protected function setupNextWave() : void
      {
         super.setupNextWave();
         if(_score >= 4024)
         {
            ReplayableEventHandler.callServerMethod("copybase",[["eventid",5]],this.copyBaseCallback);
         }
      }
      
      protected function copyBaseCallback(param1:Object) : void
      {
         if((param1.baseid is int || param1.baseid is Number) && _intactBaseList.length < 5)
         {
            _intactBaseList.push({
               "id":param1.baseid,
               "destroyed":false,
               "level":0
            });
            TRIBES.B_IDS.push(param1.baseid);
            BASE.addEventBaseException(param1.baseid);
         }
      }
      
      override protected function getWaveArray() : Array
      {
         return WAVES;
      }
      
      override public function doesQualify() : Boolean
      {
         return false;
      }
      
      override protected function loadedBaseList(param1:Object) : void
      {
         super.loadedBaseList(param1);
         if(_score == 4025 && _intactBaseList.length < 5)
         {
            ReplayableEventHandler.callServerMethod("copybase",[["eventid",5]],this.copyBaseCallback);
         }
      }
   }
}
