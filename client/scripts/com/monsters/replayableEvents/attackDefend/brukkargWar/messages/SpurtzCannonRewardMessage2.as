package com.monsters.replayableEvents.attackDefend.brukkargWar.messages
{
   import com.monsters.events.BuildingEvent;
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class SpurtzCannonRewardMessage2 extends KeywordMessage
   {
       
      
      public function SpurtzCannonRewardMessage2()
      {
         super("event_bruwarreward2","btn_buildnow");
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         if(YARD_PROPS._yardProps[SpurtzCannon.TYPE - 1].blocked)
         {
            return;
         }
         BASE.addBuildingB(SpurtzCannon.TYPE,true);
         GLOBAL.eventDispatcher.addEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,this.constructedBuilding);
      }
      
      protected function constructedBuilding(param1:BuildingEvent) : void
      {
         LOGGER.StatB({
            "st1":"ERS",
            "st2":"Brukkarg War",
            "st3":"cannon_placed"
         },"Cannon_Placed");
         GLOBAL.eventDispatcher.removeEventListener(BuildingEvent.PLACED_FOR_CONSTRUCTION,this.constructedBuilding);
         if(param1.building is SpurtzCannon)
         {
            GLOBAL.Brag("event5-reward","event_bruwarreward2_streamtitle","event_bruwarreward2_streamdesc","event_bruwarreward2_stream.png");
         }
      }
   }
}
