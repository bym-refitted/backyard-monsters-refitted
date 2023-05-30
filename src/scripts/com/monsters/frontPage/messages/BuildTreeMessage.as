package com.monsters.frontPage.messages
{
   import com.monsters.events.BuildingEvent;
   
   public class BuildTreeMessage extends KeywordMessage
   {
       
      
      protected var _buildingType:int;
      
      public function BuildTreeMessage(param1:String, param2:int, param3:String = null)
      {
         this._buildingType = param2;
         super(param1,param3);
         name = _keyword;
      }
      
      protected function placedForConstruction(param1:BuildingEvent) : void
      {
         if(param1.building._type == this._buildingType)
         {
            GLOBAL.eventDispatcher.removeEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,this.placedForConstruction);
            LOGGER.StatB({
               "st1":"GTP",
               "st2":"Action",
               "value":1
            },_buttonCopy);
         }
      }
      
      protected function targetHasUpgraded(param1:BuildingEvent) : void
      {
         if(param1.building._type == this._buildingType)
         {
            GLOBAL.eventDispatcher.removeEventListener(BuildingEvent.UPGRADED,this.targetHasUpgraded);
            LOGGER.StatB({
               "st1":"GTP",
               "st2":"Action",
               "value":1
            },_buttonCopy);
         }
      }
   }
}
