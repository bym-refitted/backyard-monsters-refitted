package com.monsters.inventory
{
   import com.cc.utils.SecNum;
   import com.monsters.baseplanner.BaseTemplateNode;
   import com.monsters.baseplanner.PlannerTemplate;
   import flash.geom.Point;
   
   public class InventoryManager
   {
       
      
      public function InventoryManager(param1:InstanceEnforcer)
      {
         super();
      }
      
      public static function buildingStorageAdd(param1:int, param2:int = 0) : void
      {
         if(!BASE._buildingsStored["b" + param1])
         {
            BASE._buildingsStored["b" + param1] = new SecNum(0);
         }
         BASE._buildingsStored["b" + param1].Add(1);
         if(BTOTEM.IsTotem2(param1))
         {
            BASE._buildingsStored["bl" + param1] = new SecNum(param2);
         }
      }
      
      public static function buildingStorageRemove(param1:int) : int
      {
         var _loc2_:int = 0;
         if(BASE._buildingsStored["b" + param1])
         {
            if(BASE._buildingsStored["b" + param1].Get() >= 1)
            {
               BASE._buildingsStored["b" + param1].Add(-1);
               _loc2_ = 1;
               if(BASE._buildingsStored["bl" + param1])
               {
                  _loc2_ = int(BASE._buildingsStored["bl" + param1].Get());
                  delete BASE._buildingsStored["bl" + param1];
               }
               return _loc2_;
            }
         }
         return 0;
      }
      
      public static function buildingStorageCount(param1:int) : int
      {
         if(BASE._buildingsStored["b" + param1])
         {
            return BASE._buildingsStored["b" + param1].Get();
         }
         return 0;
      }
      
      public static function getBuildingFromNode(param1:BaseTemplateNode) : BFOUNDATION
      {
         var _loc3_:BFOUNDATION = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc2_:Point = GRID.ToISO(param1.x,param1.y,0);
         if(param1.id == PlannerTemplate._DECORATION_ID)
         {
            _loc4_ = int(param1.type);
            _loc3_ = BASE.addBuildingC(_loc4_);
            _loc5_ = {
               "X":param1.x,
               "Y":param1.y,
               "t":_loc4_,
               "id":BASE._buildingCount++
            };
            if(BASE._buildingsStored["bl" + _loc4_])
            {
               _loc5_.l = BASE._buildingsStored["bl" + _loc4_].Get();
            }
            _loc3_.Setup(_loc5_);
            param1.id = _loc3_._id;
            BASE._buildingsStored["b" + _loc4_].Set(BASE._buildingsStored["b" + _loc4_].Get() - 1);
         }
         else
         {
            _loc3_ = BASE.getBuildingByID(param1.id);
         }
         return _loc3_;
      }
   }
}

final class InstanceEnforcer
{
    
   
   public function InstanceEnforcer()
   {
      super();
   }
}
