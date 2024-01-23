package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_04_BoobyTraps extends BuildTreeMessage
   {
       
      
      public function BuildTree_04_BoobyTraps()
      {
         super("booby",24,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(24) != 0 || Boolean(BASE.hasNumBuildings(117)))
         {
            return false;
         }
         return GLOBAL.townHall._lvl.Get() >= 2;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(24);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
