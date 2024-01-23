package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class BuildTree_01_SniperCannonTowers extends KeywordMessage
   {
       
      
      public function BuildTree_01_SniperCannonTowers()
      {
         super("snipercannon","btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 1 && BASE.hasNumBuildings(BUILDING20.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyMenu(3,1,0);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,this.placedForConstruction,false,0,true);
      }
      
      protected function placedForConstruction(param1:BuildingEvent) : void
      {
         if(param1.building._type == BUILDING20.TYPE)
         {
            GLOBAL.eventDispatcher.removeEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,this.placedForConstruction);
            LOGGER.StatB({
               "st1":"GTP",
               "st2":"Action",
               "value":1
            },_buttonCopy);
         }
      }
   }
}
