package com.monsters.baseplanner
{
   import com.monsters.interfaces.IExportable;
   
   public class BaseTemplateNode implements IExportable
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var id:uint;
      
      public var type:uint;
      
      public function BaseTemplateNode(param1:int = 0, param2:int = 0, param3:uint = 0, param4:uint = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.id = param3;
         this.type = param4;
      }
      
      public function exportData() : Object
      {
         return {
            "x":this.x,
            "y":this.y,
            "id":this.id,
            "type":this.type
         };
      }
      
      public function importData(param1:Object) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.id = param1.id;
         this.type = param1.type;
      }
   }
}
