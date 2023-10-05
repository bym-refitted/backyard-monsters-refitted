package com.monsters.subscriptions.rewards
{
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import com.monsters.rewarding.Reward;
   
   public class DAVEStatueReward extends Reward
   {
      
      public static const ID:String = "daveStatue";
      
      public static const DAVE_STATUE_TYPE_ID:int = 135;
      
      private static const DAVE_STATUE_BUILDING_PROPS_INDEX:int = DAVE_STATUE_TYPE_ID - 1;
       
      
      public function DAVEStatueReward()
      {
         super();
      }
      
      public static function unlockTeaserInformation(param1:Function) : void
      {
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].block = false;
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].locked = true;
         BUILDINGBUTTON.setOnClickedWhenLockedCallback(DAVE_STATUE_TYPE_ID,param1);
      }
      
      public static function doesStatueRewardExistsInInventory() : Boolean
      {
         return InventoryManager.buildingStorageCount(DAVE_STATUE_TYPE_ID) > 0;
      }
      
      public static function findStatueRewardInWorld() : BFOUNDATION
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].cls);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._type == DAVE_STATUE_TYPE_ID)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      override public function canBeApplied() : Boolean
      {
         return GLOBAL.isAtHome();
      }
      
      override protected function onApplication() : void
      {
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].block = true;
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].locked = false;
         var _loc1_:Boolean = doesStatueRewardExistsInInventory();
         var _loc2_:* = findStatueRewardInWorld() != null;
         if(!_loc1_ && !_loc2_)
         {
            InventoryManager.buildingStorageAdd(DAVE_STATUE_TYPE_ID,1);
         }
      }
      
      override public function removed() : void
      {
         var _loc2_:BFOUNDATION = null;
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].block = false;
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].locked = true;
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].cls);
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_._type == DAVE_STATUE_TYPE_ID)
            {
               _loc2_.RecycleC();
            }
         }
         InventoryManager.buildingStorageRemove(DAVE_STATUE_TYPE_ID);
      }
      
      override public function reset() : void
      {
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].block = false;
         GLOBAL._buildingProps[DAVE_STATUE_BUILDING_PROPS_INDEX].locked = true;
      }
   }
}
