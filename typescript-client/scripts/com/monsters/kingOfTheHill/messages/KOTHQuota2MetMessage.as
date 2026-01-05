package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KOTHQuota2MetMessage extends KeywordMessage
   {
       
      
      public function KOTHQuota2MetMessage()
      {
         super("kothquota2");
         imageURL = getImageURLFromKeyword("event_kothwin");
      }
   }
}
