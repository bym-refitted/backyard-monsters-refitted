package com.monsters.kingOfTheHill.graphics
{
   public class KOTHHUDGraphic extends KrallenHUD_CLIP
   {
       
      
      public function KOTHHUDGraphic(param1:Boolean, param2:uint)
      {
         super();
         this.update(param1,param2);
         buttonMode = true;
      }
      
      public function update(param1:Boolean, param2:uint) : void
      {
         gotoAndStop(param1 ? "active" : "inactive");
         mcLevel.tLevel.text = param2.toString();
         mcLevel.visible = Boolean(param2);
      }
   }
}
