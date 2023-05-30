package com.monsters.maproom_advanced
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class PopupInfoMonster extends MapRoomPopupInfoMonster_CLIP
   {
       
      
      private var _imageRequested:Boolean = false;
      
      public function PopupInfoMonster()
      {
         super();
      }
      
      public function Setup(param1:int, param2:int, param3:String, param4:int) : void
      {
         var ImageLoaded:Function = null;
         var name:String = null;
         var X:int = param1;
         var Y:int = param2;
         var monsterID:String = param3;
         var quantity:int = param4;
         ImageLoaded = function(param1:String, param2:BitmapData):void
         {
            mcImage.addChild(new Bitmap(param2));
            mcImage.width = 30;
            mcImage.height = 27;
         };
         x = X;
         y = Y;
         if(monsterID.substr(0,1) == "G")
         {
            tName.htmlText = "<b>" + CHAMPIONCAGE._guardians[monsterID.substr(0,2)].name + "</b>";
         }
         else
         {
            name = String(CREATURELOCKER._creatures[monsterID].name);
            if(monsterID == "IC8")
            {
               name = "#m_k_wormzer#";
            }
            if(quantity)
            {
               tName.htmlText = "<b>" + KEYS.Get(name) + ": " + GLOBAL.FormatNumber(quantity) + "</b>";
            }
            else
            {
               tName.htmlText = "<b>" + KEYS.Get(name) + "</b>";
            }
         }
         if(!this._imageRequested)
         {
            ImageCache.GetImageWithCallBack("monsters/" + monsterID + "-small.png",ImageLoaded);
            this._imageRequested = true;
         }
      }
   }
}
