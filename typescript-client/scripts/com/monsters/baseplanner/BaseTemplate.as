package com.monsters.baseplanner
{
   import com.monsters.interfaces.IExportable;
   
   public class BaseTemplate implements IExportable
   {
       
      
      public var name:String;
      
      public var nodes:Vector.<BaseTemplateNode>;
      
      public var slot:uint;
      
      public function BaseTemplate(param1:String = null, param2:Vector.<BaseTemplateNode> = null)
      {
         super();
         this.name = !!param1 ? param1 : "";
         if(param2)
         {
            this.nodes = param2;
         }
         else
         {
            this.nodes = new Vector.<BaseTemplateNode>();
         }
      }
      
      public function addNode(param1:BaseTemplateNode) : void
      {
         this.nodes.push(param1);
      }
      
      public function exportData() : Object
      {
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < this.nodes.length)
         {
            _loc1_[_loc2_] = this.nodes[_loc2_].exportData();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function importData(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:BaseTemplateNode = null;
         for each(_loc2_ in param1)
         {
            if(!(_loc2_ is Number))
            {
               _loc3_ = new BaseTemplateNode();
               _loc3_.importData(_loc2_);
               this.nodes.push(_loc3_);
            }
         }
      }
      
      public function toString() : String
      {
         return this.name + "(" + this.slot + ")";
      }
      
      public function getNodeFromBuildingID(param1:uint) : Boolean
      {
         var _loc3_:BaseTemplateNode = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.nodes.length)
         {
            _loc3_ = this.nodes[_loc2_];
            if(_loc3_.id == param1)
            {
               return Boolean(_loc3_);
            }
            _loc2_++;
         }
         return false;
      }
   }
}
