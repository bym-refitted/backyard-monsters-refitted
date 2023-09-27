package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_05_Blocks extends BuildTreeMessage
   {
       
      
      public function BuildTree_05_Blocks()
      {
         super("blocks1",17,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(17) != 0)
         {
            return false;
         }
         return GLOBAL.townHall._lvl.Get() >= 2;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(17);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
