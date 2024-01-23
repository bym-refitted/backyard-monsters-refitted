package com.monsters.rewarding
{
   import com.monsters.interfaces.IHandler;
   
   public class RewardHandler implements IHandler
   {
      
      public static const k_UPDATE_ADD:String = "RA";
      
      public static const k_UPDATE_REMOVE:String = "RR";
      
      public static const k_UPDATE_VALUE:String = "RV";
      
      private static var _instance:RewardHandler;
       
      
      public var rewards:Vector.<Reward>;
      
      public function RewardHandler()
      {
         this.rewards = new Vector.<Reward>();
         super();
      }
      
      public static function get instance() : RewardHandler
      {
         if(!_instance)
         {
            _instance = new RewardHandler();
         }
         return _instance;
      }
      
      public function get name() : String
      {
         return "rewards";
      }
      
      public function addReward(param1:Reward) : Boolean
      {
         if(this.getRewardByID(param1.id))
         {
            return false;
         }
         this.rewards.push(param1);
         return true;
      }
      
      public function addAndApplyReward(param1:Reward, param2:Boolean = false) : void
      {
         if(this.addReward(param1) || param2)
         {
            this.applyReward(param1);
         }
      }
      
      public function applyReward(param1:Reward) : void
      {
         param1.applyReward();
      }
      
      private function applyRewards() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.rewards.length)
         {
            this.applyReward(this.rewards[_loc1_]);
            _loc1_++;
         }
      }
      
      public function getRewardByID(param1:String) : Reward
      {
         var _loc3_:Reward = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.rewards.length)
         {
            _loc3_ = this.rewards[_loc2_];
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removeRewardByID(param1:String) : void
      {
         var _loc2_:Reward = this.getRewardByID(param1);
         if(_loc2_)
         {
            this.removeReward(_loc2_);
         }
      }
      
      public function removeReward(param1:Reward) : void
      {
         var _loc2_:int = this.rewards.indexOf(param1);
         if(_loc2_ >= 0)
         {
            param1.removed();
            this.rewards.splice(_loc2_,1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.rewards.length)
         {
            this.rewards[_loc1_].reset();
            _loc1_++;
         }
         this.rewards.length = 0;
      }
      
      public function initialize(param1:Object = null) : void
      {
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || BASE.isInfernoMainYardOrOutpost)
         {
            return;
         }
         UPDATES.addAction(this.processUpdate,this.name);
         if(!RewardLibrary.rewardTypes)
         {
            RewardLibrary.initialize();
         }
         if(param1)
         {
            this.importData(param1);
         }
         this.applyRewards();
      }
      
      public function exportData() : Object
      {
         var _loc3_:Reward = null;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || BASE.isInfernoMainYardOrOutpost)
         {
            return null;
         }
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < this.rewards.length)
         {
            _loc3_ = this.rewards[_loc2_];
            _loc1_[_loc3_.id] = _loc3_.exportData();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function importData(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Reward = null;
         for(_loc2_ in param1)
         {
            _loc3_ = RewardLibrary.getRewardByID(_loc2_);
            if(Boolean(_loc3_) && Boolean(param1[_loc2_]))
            {
               _loc3_.importData(param1[_loc2_]);
               this.addReward(_loc3_);
            }
         }
      }
      
      public function updateExistingOrAddNewReward(param1:String, param2:* = null) : Reward
      {
         var _loc3_:Reward = this.getRewardByID(param1);
         if(!_loc3_)
         {
            _loc3_ = RewardLibrary.getRewardByID(param1);
         }
         if(_loc3_)
         {
            this.addReward(_loc3_);
            if(param2)
            {
               _loc3_.value = param2;
            }
         }
         return _loc3_;
      }
      
      public function processUpdate(param1:Object) : Boolean
      {
         var _loc2_:Reward = null;
         switch(param1.data[1])
         {
            case k_UPDATE_ADD:
               _loc2_ = RewardLibrary.getRewardByID(param1.data[2]);
               if(_loc2_)
               {
                  RewardHandler.instance.addAndApplyReward(_loc2_);
               }
               break;
            case k_UPDATE_REMOVE:
               RewardHandler.instance.removeRewardByID(param1.data[2]);
               break;
            case k_UPDATE_VALUE:
               _loc2_ = RewardHandler.instance.getRewardByID(param1.data[2]);
               if(_loc2_)
               {
                  _loc2_.value = param1.data[3];
                  RewardHandler.instance.addAndApplyReward(_loc2_,true);
               }
               BASE.Save(0,false,true);
               break;
            case k_UPDATE_VALUE:
               _loc2_ = RewardHandler.instance.getRewardByID(param1.data[2]);
               if(_loc2_)
               {
                  _loc2_.value = param1.data[3];
                  RewardHandler.instance.addAndApplyReward(_loc2_,true);
               }
               BASE.Save(0,false,true);
         }
         return true;
      }
   }
}
