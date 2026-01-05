package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_03_MonsterLocker extends BuildTreeMessage
   {
       
      
      public function BuildTree_03_MonsterLocker()
      {
         super("locker",8,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(8) != 0)
         {
            return false;
         }
         return GLOBAL.townHall._lvl.Get() >= 2;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(8);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
