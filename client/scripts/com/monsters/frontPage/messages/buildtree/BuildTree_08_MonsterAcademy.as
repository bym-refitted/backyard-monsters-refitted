package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_08_MonsterAcademy extends BuildTreeMessage
   {
       
      
      public function BuildTree_08_MonsterAcademy()
      {
         super("academy",26,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(26) != 0)
         {
            return false;
         }
         return GLOBAL.townHall && GLOBAL.townHall._lvl.Get() >= 3 && Boolean(GLOBAL._bLocker) && GLOBAL._bLocker._lvl.Get() >= 2;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(26);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
