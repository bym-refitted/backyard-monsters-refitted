package com.monsters.frontPage.messages.events.monsterBlitzkrieg
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class MonsterBlitzkriegEndMessage extends KeywordMessage
   {
       
      
      public function MonsterBlitzkriegEndMessage()
      {
         super("event2end");
         this.imageURL = _IMAGE_DIRECTORY + "fp_event2start.v2.jpg";
      }
   }
}
