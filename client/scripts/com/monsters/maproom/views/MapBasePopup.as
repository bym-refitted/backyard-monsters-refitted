package com.monsters.maproom.views
{
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class MapBasePopup extends MapBasePopup_CLIP
   {
       
      
      public function MapBasePopup()
      {
         super();
      }
      
      public function initWithTitleAndButtons(param1:String, param2:Array, param3:Array) : void
      {
         title_txt.htmlText = "<b>" + KEYS.Get("map_options") + "</b>";
      }
      
      public function setHeightForButtons(param1:int) : void
      {
         if(param1 == 2)
         {
            bg_mc.height = 98;
            bg_mc.y = 19;
         }
         else if(param1 == 3)
         {
            bg_mc.height = 131;
            bg_mc.y = 35;
         }
         else
         {
            bg_mc.height = 163;
            bg_mc.y = 51;
         }
      }
      
      public function Show() : void
      {
         var _loc1_:int = this.x;
         this.x -= 15;
         TweenLite.to(this,0.6,{
            "x":_loc1_,
            "ease":Elastic.easeOut
         });
      }
   }
}
