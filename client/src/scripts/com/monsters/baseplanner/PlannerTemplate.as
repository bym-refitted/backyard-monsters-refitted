package com.monsters.baseplanner
{
   import com.monsters.managers.InstanceManager;
   import flash.geom.Point;
   
   public class PlannerTemplate
   {
      
      public static const _DECORATION_ID:int = 1000000;
       
      
      public var slot:uint;
      
      public var name:String;
      
      public var inventoryData:Vector.<com.monsters.baseplanner.PlannerNode>;
      
      public var displayData:Vector.<com.monsters.baseplanner.PlannerNode>;
      
      private var _savableData:com.monsters.baseplanner.BaseTemplate;
      
      public function PlannerTemplate(param1:com.monsters.baseplanner.BaseTemplate = null)
      {
         this.inventoryData = new Vector.<com.monsters.baseplanner.PlannerNode>();
         this.displayData = new Vector.<com.monsters.baseplanner.PlannerNode>();
         super();
         if(param1)
         {
            this.importData(param1);
         }
      }
      
      public function exportData() : com.monsters.baseplanner.BaseTemplate
      {
         var _loc4_:com.monsters.baseplanner.PlannerNode = null;
         var _loc1_:com.monsters.baseplanner.BaseTemplate = new com.monsters.baseplanner.BaseTemplate(this.name);
         var _loc2_:Vector.<BaseTemplateNode> = new Vector.<BaseTemplateNode>();
         var _loc3_:int = 0;
         while(_loc3_ < this.displayData.length)
         {
            _loc4_ = this.displayData[_loc3_];
            if(!BASE.isBuildingIgnoredInYardPlannerSave(_loc4_.building))
            {
               _loc2_.push(new BaseTemplateNode(_loc4_.x,_loc4_.y,_loc4_.id,_loc4_.type));
            }
            _loc3_++;
         }
         _loc1_.nodes = _loc2_;
         _loc1_.slot = this.slot;
         return _loc1_;
      }
      
      public function importData(param1:com.monsters.baseplanner.BaseTemplate) : void
      {
         this._savableData = param1;
         this.name = this._savableData.name;
         this.slot = this._savableData.slot;
         this.getPlannerDataFromTemplate(param1);
      }
      
      private function getPlannerDataFromTemplate(param1:com.monsters.baseplanner.BaseTemplate) : void
      {
         var _loc6_:BaseTemplateNode = null;
         var _loc7_:BFOUNDATION = null;
         var _loc8_:com.monsters.baseplanner.PlannerNode = null;
         var _loc9_:com.monsters.baseplanner.PlannerNode = null;
         var _loc10_:Point = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:uint = 0;
         this.displayData.length = 0;
         this.inventoryData.length = 0;
         var _loc2_:Vector.<BaseTemplateNode> = new Vector.<BaseTemplateNode>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.nodes.length)
         {
            _loc6_ = param1.nodes[_loc3_];
            if(!(_loc7_ = this.getBuildingFromNode(_loc6_)))
            {
               _loc2_.push(_loc6_);
            }
            else
            {
               _loc8_ = new com.monsters.baseplanner.PlannerNode(_loc7_,_loc6_.x,_loc6_.y);
               this.displayData.push(_loc8_);
            }
            _loc3_++;
         }
         var _loc4_:Vector.<com.monsters.baseplanner.PlannerNode> = this.getNodesFromUnusedBuildings(param1);
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            if((_loc9_ = _loc4_[_loc3_]).category == "misc")
            {
               _loc10_ = GRID.FromISO(_loc9_.building.x,_loc9_.building.y);
               _loc9_.x = _loc10_.x;
               _loc9_.y = _loc10_.y;
               this.displayData.push(_loc9_);
            }
            else
            {
               this.inventoryData.push(_loc9_);
            }
            _loc3_++;
         }
         var _loc5_:Vector.<com.monsters.baseplanner.PlannerNode> = this.getNodesFromStoredBuildings();
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc11_ = 0;
            _loc12_ = false;
            _loc13_ = _loc2_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc13_)
            {
               if(_loc5_[_loc3_].type == _loc2_[_loc11_].type)
               {
                  _loc5_[_loc3_].x = _loc2_[_loc11_].x;
                  _loc5_[_loc3_].y = _loc2_[_loc11_].y;
                  _loc2_.splice(_loc11_,1);
                  _loc12_ = true;
                  break;
               }
               _loc11_++;
            }
            if(_loc12_)
            {
               this.displayData.push(_loc5_[_loc3_]);
            }
            else
            {
               this.inventoryData.push(_loc5_[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      private function getBuildingFromNode(param1:BaseTemplateNode) : BFOUNDATION
      {
         return BASE.getBuildingByID(param1.id);
      }
      
      private function getNodesFromUnusedBuildings(param1:com.monsters.baseplanner.BaseTemplate) : Vector.<com.monsters.baseplanner.PlannerNode>
      {
         var _loc4_:BFOUNDATION = null;
         var _loc2_:Vector.<BFOUNDATION> = BASE.getYardPlannerBuildings();
         var _loc3_:Vector.<com.monsters.baseplanner.PlannerNode> = new Vector.<com.monsters.baseplanner.PlannerNode>();
         for each(_loc4_ in _loc2_)
         {
            if(!param1.getNodeFromBuildingID(_loc4_._id))
            {
               _loc3_.push(new com.monsters.baseplanner.PlannerNode(_loc4_));
            }
         }
         return _loc3_;
      }
      
      private function getNodesFromStoredBuildings() : Vector.<com.monsters.baseplanner.PlannerNode>
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:BFOUNDATION = null;
         var _loc1_:Vector.<com.monsters.baseplanner.PlannerNode> = new Vector.<com.monsters.baseplanner.PlannerNode>();
         if(BASE._buildingsStored)
         {
            _loc2_ = 0;
            _loc3_ = BASE._buildingsStored;
            for(_loc4_ in BASE._buildingsStored)
            {
               if(_loc4_.charAt(1) != "l")
               {
                  _loc5_ = int(_loc4_.substr(_loc4_.indexOf("b") + 1));
                  _loc6_ = int(BASE._buildingsStored[_loc4_].Get());
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     (_loc8_ = {}).t = _loc5_;
                     _loc8_.x = 0;
                     _loc8_.y = 0;
                     _loc8_.id = _DECORATION_ID;
                     _loc9_ = 1;
                     if(BASE._buildingsStored["bl" + _loc5_])
                     {
                        _loc9_ = int(BASE._buildingsStored["bl" + _loc5_].Get());
                     }
                     _loc8_.l = _loc9_;
                     _loc10_ = new BFOUNDATION();
                     InstanceManager.removeInstance(_loc10_);
                     _loc10_._id = _DECORATION_ID;
                     _loc10_._type = _loc5_;
                     _loc10_._lvl.Set(_loc9_);
                     _loc10_._fortification.Set(0);
                     _loc10_._range = 0;
                     _loc1_.push(new com.monsters.baseplanner.PlannerNode(_loc10_));
                     _loc7_++;
                  }
               }
            }
         }
         return _loc1_;
      }
   }
}
