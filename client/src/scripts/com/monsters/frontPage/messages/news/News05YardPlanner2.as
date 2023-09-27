package com.monsters.frontPage.messages.news
{
   import com.monsters.frontPage.messages.KeywordMessage;
   import flash.events.MouseEvent;
   
   public class News05YardPlanner2 extends KeywordMessage
   {
       
      
      public function News05YardPlanner2()
      {
         super("yp2");
      }
      
      override public function setupButton(param1:Button) : Button
      {
         param1.Highlight = true;
         if(GLOBAL._bYardPlanner)
         {
            param1.SetupKey("btn_open");
            param1.addEventListener(MouseEvent.CLICK,this.openYardPlanner,false,0,true);
         }
         else
         {
            param1.SetupKey("btn_buildnow");
            param1.addEventListener(MouseEvent.CLICK,this.buildYardPlanner,false,0,true);
         }
         return param1;
      }
      
      protected function buildYardPlanner(param1:MouseEvent) : void
      {
         buyBuilding(PLANNER.TYPE);
      }
      
      protected function openYardPlanner(param1:MouseEvent) : void
      {
         POPUPS.Next();
         PLANNER.Show();
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         if(GLOBAL._flags.yp_version == 2)
         {
            return true;
         }
         return false;
      }
   }
}
