package com.monsters.baseplanner
{
   import com.monsters.baseplanner.events.BasePlannerServiceEvent;
   import flash.events.EventDispatcher;
   
   public class BasePlannerService extends EventDispatcher
   {
       
      
      public function BasePlannerService()
      {
         super();
      }
      
      public function callServerMethod(url:String, keyValue:Array, onComplete:Function = null) : void
      {
         var urlLoader:URLLoaderApi;
         (urlLoader = new URLLoaderApi()).load(GLOBAL._apiURL + "bm/yardplanner/" + url,keyValue,onComplete);
      }
      
      public function saveTemplate(baseTemplate:BaseTemplate, slotId:uint) : void
      {
         var _loc3_:Object = JSON.encode(baseTemplate.exportData());
         this.callServerMethod("savetemplate",[["slotid",slotId],["name",baseTemplate.name],["data",_loc3_]],this.savedTemplate);
         print("saving \'" + baseTemplate.name + "\' in slot " + slotId);
      }
      
      private function savedTemplate(serverData:Object) : void
      {
         if(serverData.error)
         {
            print(serverData.error);
            return;
         }
         this.loadedTemplates(serverData);
      }
      
      public function loadTemplates() : void
      {
         this.callServerMethod("gettemplates",null,this.loadedTemplates);
         print("loading template list from the server");
      }
      
      private function loadedTemplates(serverData:Object) : void
      {
         var template:Object = null;
         var slotIndex:int = 0;
         var slotId:uint = 0;
         var baseTemplate:BaseTemplate = null;
         var baseTemplateList:Vector.<BaseTemplate> = new Vector.<BaseTemplate>(BasePlanner.slots,true);
         for each(template in serverData)
         {
            if(!(template is Number))
            {
               baseTemplate = new BaseTemplate();
               slotId = uint(template.slotid);
               baseTemplate.name = template.name;
               baseTemplate.slot = slotId;
               baseTemplate.importData(JSON.decode(template.data));
               if(slotId < baseTemplateList.length)
               {
                  baseTemplateList[slotId] = baseTemplate;
               }
            }
         }
         slotIndex = int(baseTemplateList.length - 1);
         while(slotIndex >= 0)
         {
            if(!baseTemplateList[slotIndex])
            {
               baseTemplateList[slotIndex] = new BaseTemplate("Slot" + (slotIndex + 1).toString());
            }
            slotIndex--;
         }
         print("new template list is " + baseTemplateList);
         dispatchEvent(new BasePlannerServiceEvent(BasePlannerServiceEvent.LOADED_TEMPLATES_LIST,baseTemplateList));
      }
      
      public function clearSlot(slotIndex:uint) : void
      {
         this.callServerMethod("deletetemplate",[["slotid",slotIndex]]);
         print("deleting \'blah\' at slot index of " + slotIndex);
      }
   }
}
