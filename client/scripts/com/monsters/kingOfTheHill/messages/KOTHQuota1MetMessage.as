package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import com.monsters.kingOfTheHill.KOTHHandler;
   
   public class KOTHQuota1MetMessage extends KeywordMessage
   {
       
      
      public function KOTHQuota1MetMessage()
      {
         super(KOTHHandler.instance.tier >= 1 ? "kothquota1_havekrallen" : "kothquota1_nokrallen");
         this.body = KEYS.Get(PREFIX + _keyword,{"v1":KOTHHandler.instance.wins + 1});
         imageURL = getImageURLFromKeyword("event_kothwin");
      }
   }
}
