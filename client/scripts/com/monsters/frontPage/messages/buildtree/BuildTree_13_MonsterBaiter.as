package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_13_MonsterBaiter extends BuildTreeMessage
   {
       
      
      public function BuildTree_13_MonsterBaiter()
      {
         super("baiter",MONSTERBAITER.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 4 && Boolean(BASE.hasNumBuildings(8,1)) && BASE.hasNumBuildings(MONSTERBAITER.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(MONSTERBAITER.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
