package com.monsters.baseplanner
{
   import com.monsters.baseplanner.events.BasePlannerServiceEvent;
   import flash.events.EventDispatcher;
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   
   public class BasePlannerService extends EventDispatcher
   {
       
      
      public function BasePlannerService()
      {
         super();
      }
      
      public function callServerMethod(param1:String, param2:Array, param3:Function = null) : void
      {
         var _loc4_:URLLoaderApi;
         (_loc4_ = new URLLoaderApi()).load(GLOBAL._apiURL + "bm/yardplanner/" + param1,param2,param3);
      }
      
      public function saveTemplate(param1:BaseTemplate, param2:uint) : void
      {
         var _loc3_:Object = encodeJson(param1.exportData());
         this.callServerMethod("savetemplate",[["slotid",param2],["name",param1.name],["data",_loc3_]],this.savedTemplate);
         print("saving \'" + param1.name + "\' in slot " + param2);
      }
      
      private function savedTemplate(param1:Object) : void
      {
         if(param1.error)
         {
            print(param1.error);
            return;
         }
         this.loadedTemplates(param1);
      }
      
      public function loadTemplates() : void
      {
         this.callServerMethod("gettemplates",null,this.loadedTemplates);
         print("loading template list from the server");
      }
      
      private function loadedTemplates(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:BaseTemplate = null;
         var _loc6_:uint = 0;
         var _loc2_:Vector.<BaseTemplate> = new Vector.<BaseTemplate>(BasePlanner.slots,true);
         for each(_loc3_ in param1)
         {
            if(!(_loc3_ is Number))
            {
               _loc5_ = new BaseTemplate();
               _loc6_ = uint(_loc3_.slotid);
               _loc5_.name = _loc3_.name;
               _loc5_.slot = _loc6_;
               _loc5_.importData(decodeJson(_loc3_.data));
               if(_loc6_ < _loc2_.length)
               {
                  _loc2_[_loc6_] = _loc5_;
               }
            }
         }
         _loc4_ = int(_loc2_.length - 1);
         while(_loc4_ >= 0)
         {
            if(!_loc2_[_loc4_])
            {
               _loc2_[_loc4_] = new BaseTemplate("Slot" + (_loc4_ + 1).toString());
            }
            _loc4_--;
         }
         print("new template list is " + _loc2_);
         dispatchEvent(new BasePlannerServiceEvent(BasePlannerServiceEvent.LOADED_TEMPLATES_LIST,_loc2_));
      }
      
      public function clearSlot(param1:uint) : void
      {
         this.callServerMethod("deletetemplate",[["slotid",param1]]);
         print("deleting \'blah\' at slot index of " + param1);
      }
   }
}
