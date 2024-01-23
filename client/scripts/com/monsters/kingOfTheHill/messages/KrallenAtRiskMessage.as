package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KrallenAtRiskMessage extends KeywordMessage
   {
       
      
      public function KrallenAtRiskMessage()
      {
         super("krallenrisk");
         imageURL = getImageURLFromKeyword("event_kothlose");
      }
   }
}
