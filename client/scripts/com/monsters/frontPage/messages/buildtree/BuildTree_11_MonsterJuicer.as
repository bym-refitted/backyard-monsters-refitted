package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.BuildTreeMessage;
   
   public class BuildTree_11_MonsterJuicer extends BuildTreeMessage
   {
       
      
      public function BuildTree_11_MonsterJuicer()
      {
         super("juicer",BUILDING9.TYPE,"btn_buildnow");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         var _loc1_:uint = GLOBAL.townHall._lvl.Get();
         return _loc1_ >= 3 && _loc1_ <= 4 && BASE.hasNumBuildings(_buildingType) <= 0;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(_buildingType);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,placedForConstruction,false,0,true);
      }
   }
}
