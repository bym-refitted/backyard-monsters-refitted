package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_02_RadioTower extends BuildTreeMessage
   {
       
      
      public function BuildTree_02_RadioTower()
      {
         super("radiotower",113,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         var _loc1_:uint = GLOBAL.townHall._lvl.Get();
         return BASE.hasNumBuildings(_buildingType) <= 0 && _loc1_ >= 1 && _loc1_ <= 3 && Boolean(GLOBAL._flags.radio);
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(_buildingType);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
