package com.monsters.frontPage.messages.events.kingOfTheHill
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KOTHPromoMessage3 extends KOTHPromoMessage
   {
       
      
      public function KOTHPromoMessage3()
      {
         super("event_kothpromo3");
         imageURL = KeywordMessage.getImageURLFromKeyword("event_kothpromo2");
      }
   }
}
