package com.monsters.replayableEvents
{
   import com.monsters.frontPage.FrontPageGraphic;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.interfaces.IExportable;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.rewarding.RewardLibrary;
   
   public class ReplayableEventQuota implements IExportable
   {
       
      
      public var rewardID:String;
      
      public var imageURL:String;
      
      public var quota:Number;
      
      public var message:Message;
      
      protected var _dateAwarded:int;
      
      public function ReplayableEventQuota(param1:Number, param2:String = null, param3:String = null, param4:Message = null)
      {
         super();
         this.rewardID = param3;
         this.imageURL = param2;
         this.quota = param1;
         this.message = param4;
      }
      
      public function get hasBeenAwarded() : Boolean
      {
         return this._dateAwarded > 0;
      }
      
      public function metQuota() : void
      {
         if(this.rewardID)
         {
            RewardHandler.instance.addAndApplyReward(RewardLibrary.getRewardByID(this.rewardID));
         }
         if(this.message)
         {
            POPUPS.Push(new FrontPageGraphic(this.message));
         }
         this._dateAwarded = GLOBAL.Timestamp();
      }
      
      public function exportData() : Object
      {
         if(!this._dateAwarded)
         {
            return null;
         }
         return {"dateAwarded":this._dateAwarded};
      }
      
      public function importData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this._dateAwarded = param1["dateAwarded"];
      }
   }
}
