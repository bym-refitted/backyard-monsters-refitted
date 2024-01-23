package com.monsters.frontPage.messages
{
   public class DebugMessage extends Message
   {
       
      
      public function DebugMessage()
      {
         super("debug","debug");
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return false;
      }
   }
}
