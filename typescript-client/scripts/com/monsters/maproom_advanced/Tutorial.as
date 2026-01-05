package com.monsters.maproom_advanced
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   internal class Tutorial
   {
      
      private static var _instance:Tutorial;
       
      
      private var _tutStep:int = 0;
      
      private var _currImageUrl:String;
      
      private var _bigPopup:popup_mr2tutorial;
      
      public function Tutorial()
      {
         super();
         this.Update();
      }
      
      public static function ShowIfNeeded() : void
      {
         if(GLOBAL._mr2TutorialId < 2)
         {
            Hide();
            _instance = new Tutorial();
         }
      }
      
      public static function ForceShowAll() : void
      {
         GLOBAL._mr2TutorialId = 0;
         ShowIfNeeded();
      }
      
      public static function Hide() : void
      {
         if(_instance)
         {
            _instance.HideBigDialog();
            _instance = null;
         }
      }
      
      public function Update() : void
      {
         while(this._tutStep <= 7)
         {
            if(GLOBAL._mr2TutorialId <= (this._tutStep == 1 || this._tutStep == 5) ? Boolean(1) : Boolean(0))
            {
               break;
            }
            ++this._tutStep;
         }
         if(this._tutStep < 7)
         {
            this.ShowBigDialog(KEYS.Get("newmap_g" + (this._tutStep + 1)),"ui/mr2_tutorial_" + (this._tutStep + 1) + ".png");
         }
         else if(this._tutStep == 7)
         {
            this.ShowSmallDialog(KEYS.Get("newmap_g" + (this._tutStep + 1)));
         }
         else
         {
            this.FinishTutorial();
         }
      }
      
      private function AdvanceTutorial(param1:Event = null) : void
      {
         ++this._tutStep;
         this.Update();
      }
      
      private function FinishTutorial(param1:Event = null) : void
      {
         Hide();
         GLOBAL._mr2TutorialId = 2;
         BASE.Save();
      }
      
      private function ShowBigDialog(param1:String, param2:String) : void
      {
         this.HideBigDialog();
         GLOBAL.BlockerAdd();
         SOUNDS.Play("click1");
         this._bigPopup = new popup_mr2tutorial();
         this._bigPopup.tBody.htmlText = param1;
         this._bigPopup.bAction.SetupKey("btn_continue");
         this._bigPopup.bAction.addEventListener(MouseEvent.CLICK,this.AdvanceTutorial,false,0,true);
         this._bigPopup.bAction.Highlight = true;
         this._bigPopup.mcFrame.Setup(true,this.FinishTutorial);
         this._currImageUrl = param2;
         ImageCache.GetImageWithCallBack(this._currImageUrl,this.ImageLoaded);
         GLOBAL._layerTop.addChild(this._bigPopup);
         POPUPSETTINGS.AlignToCenter(this._bigPopup);
         POPUPSETTINGS.ScaleUp(this._bigPopup);
      }
      
      private function ImageLoaded(param1:String, param2:BitmapData) : void
      {
         if(this._currImageUrl == param1)
         {
            this._bigPopup.mcImageContainer.addChild(new Bitmap(param2));
         }
      }
      
      private function ShowSmallDialog(param1:String) : void
      {
         this.HideBigDialog();
         this._currImageUrl = "";
         GLOBAL.Message(param1,KEYS.Get("btn_continue"),this.AdvanceTutorial);
      }
      
      private function HideBigDialog() : void
      {
         if(this._bigPopup)
         {
            GLOBAL.BlockerRemove();
            GLOBAL._layerTop.removeChild(this._bigPopup);
            this._bigPopup = null;
         }
      }
   }
}
