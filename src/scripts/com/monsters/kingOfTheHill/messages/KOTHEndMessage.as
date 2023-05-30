package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KOTHEndMessage extends KeywordMessage
   {
       
      
      public function KOTHEndMessage(param1:Boolean)
      {
         super(param1 ? "kothendlosekrallen" : "kothendlose");
         imageURL = getImageURLFromKeyword("event_kothlose");
      }
   }
}
