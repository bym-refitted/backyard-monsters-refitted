package com.monsters.frontPage.messages.buildtree
{
   import com.monsters.frontPage.FrontPageHandler;
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class BuildTree_07_StoneBlocks extends KeywordMessage
   {
       
      
      public function BuildTree_07_StoneBlocks()
      {
         super("blocks2","btn_upgrade");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(BASE.hasNumBuildings(17,2) != 0 && BASE.hasNumBuildings(17,1) > 0)
         {
            return false;
         }
         return Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= 3 && BASE.hasNumBuildings(17,1) > 0;
      }
      
      override protected function onButtonClick() : void
      {
         FrontPageHandler.closeAll();
         if(BASE.isInfernoMainYardOrOutpost)
         {
            STORE.ShowB(1,0,["BLK2I","BLK3I"]);
         }
         else
         {
            STORE.ShowB(1,0,["BLK2","BLK3","BLK4","BLK5"]);
         }
      }
   }
}
