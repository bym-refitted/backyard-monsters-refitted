package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_12_MonsterBunker extends BuildTreeMessage
   {
       
      
      public function BuildTree_12_MonsterBunker()
      {
         super("bunker",MONSTERBUNKER.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return GLOBAL.townHall._lvl.Get() >= 3 && BASE.hasNumBuildings(MONSTERBUNKER.TYPE) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(MONSTERBUNKER.TYPE);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
