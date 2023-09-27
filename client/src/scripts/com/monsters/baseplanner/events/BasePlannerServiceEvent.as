package com.monsters.baseplanner.events
{
   import com.monsters.baseplanner.BaseTemplate;
   import flash.events.Event;
   
   public class BasePlannerServiceEvent extends Event
   {
      
      public static const LOADED_TEMPLATES_LIST:String = "loadedTemplateList";
       
      
      private var _templatesList:Vector.<BaseTemplate>;
      
      public function BasePlannerServiceEvent(param1:String, param2:Vector.<BaseTemplate>)
      {
         super(param1);
         this._templatesList = param2;
      }
      
      public function get templatesList() : Vector.<BaseTemplate>
      {
         return this._templatesList;
      }
   }
}
