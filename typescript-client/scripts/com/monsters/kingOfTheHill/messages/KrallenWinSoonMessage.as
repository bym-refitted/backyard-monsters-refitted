package com.monsters.kingOfTheHill.messages
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class KrallenWinSoonMessage extends KeywordMessage
   {
       
      
      public function KrallenWinSoonMessage()
      {
         super("krallenwin");
         imageURL = getImageURLFromKeyword("event_kothwin");
      }
   }
}
