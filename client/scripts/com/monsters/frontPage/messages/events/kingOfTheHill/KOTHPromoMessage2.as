package com.monsters.frontPage.messages.events.kingOfTheHill
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KOTHPromoMessage2 extends KOTHPromoMessage
   {
       
      
      public function KOTHPromoMessage2()
      {
         super("event_kothpromo2");
         imageURL = KeywordMessage.getImageURLFromKeyword("event_kothpromo3");
      }
   }
}
