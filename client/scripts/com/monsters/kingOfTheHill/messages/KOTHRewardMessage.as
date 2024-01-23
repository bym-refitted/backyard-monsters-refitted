package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KOTHRewardMessage extends KeywordMessage
   {
       
      
      public function KOTHRewardMessage(param1:Boolean)
      {
         var _loc2_:int = 1;
         if(CREEPS.krallen)
         {
            _loc2_ = CREEPS.krallen._level.Get();
         }
         super(param1 ? "kothendkeep" : "kothendwin","btn_brag");
         this.body = KEYS.Get(PREFIX + _keyword,{"v1":_loc2_});
         imageURL = getImageURLFromKeyword("event_kothwin");
      }
      
      override protected function onButtonClick() : void
      {
         GLOBAL.CallJS("sendFeed",["event4-reward",KEYS.Get("fb_kothstream_title"),KEYS.Get("fb_kothstream_desc"),"fb_kothstream.png"]);
         POPUPS.Next();
      }
   }
}
