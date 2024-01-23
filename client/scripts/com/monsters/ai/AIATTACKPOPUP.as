package com.monsters.ai
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AIATTACKPOPUP extends AIATTACKPOPUP_CLIP
   {
       
      
      public var _type:int;
      
      private var d1:bubblepopup3;
      
      private var d2:bubblepopup3;
      
      private var d3:bubblepopup3;
      
      private var bm:Bitmap;
      
      public function AIATTACKPOPUP(param1:int = 3)
      {
         var imageComplete:Function = null;
         var attackerType:int = param1;
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            bm = new Bitmap(param2);
            mcImage.addChild(bm);
         };
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         sendNow.addEventListener(MouseEvent.CLICK,this.sendDown);
         sendNow.SetupKey("ai_engage_btn");
         waitBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onWaitDown);
         waitBtn.SetupKey("ai_preparedefenses_btn");
         ImageCache.GetImageWithCallBack(TRIBES.TribeForBaseID(WMATTACK._attackersBaseID).splash,imageComplete);
         mcFrame.Setup(false);
         this.d1 = new bubblepopup3();
         this.d1.x = 398;
         this.d1.y = 214;
         addChild(this.d1);
         this.d2 = new bubblepopup3();
         this.d2.x = 398;
         this.d2.y = 260;
         addChild(this.d2);
         this.d3 = new bubblepopup3();
         this.d3.x = 398;
         this.d3.y = 306;
         addChild(this.d3);
         this._type = attackerType;
         title_txt.htmlText = KEYS.Get("ai_popupwarning_title");
         x = GLOBAL._SCREENCENTER.x;
         y = GLOBAL._SCREENCENTER.y;
      }
      
      private function onWaitDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         WMATTACK._queued.warned = 1;
         BASE.Save(0,false,true);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function onAdd(param1:Event) : void
      {
         var _loc4_:String = null;
         var _loc2_:Object = WMATTACK._queued.attack;
         var _loc3_:Array = [];
         for(_loc4_ in _loc2_)
         {
            if(_loc2_[_loc4_] > 0)
            {
               _loc3_.push(_loc4_);
            }
         }
         switch(_loc3_.length)
         {
            case 1:
               removeChild(c2);
               removeChild(c3);
               break;
            case 2:
               removeChild(c3);
         }
         var _loc5_:Array = [this.d1,this.d2,this.d3];
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc5_[_loc6_].Setup(47,23,KEYS.Get(CREATURELOCKER._creatures[_loc3_[_loc6_]].description),3);
            _loc6_++;
         }
         c1.addChild(this.d1);
         c2.addChild(this.d2);
         c3.addChild(this.d3);
         var _loc7_:Array = [c1,c2,c3];
         var _loc8_:int = 0;
         while(_loc8_ < _loc3_.length)
         {
            ImageCache.GetImageWithCallBack("monsters/" + _loc3_[_loc8_] + "-medium.jpg",this.IconLoaded,true,1,"",[_loc7_[_loc8_].mcIcon]);
            _loc7_[_loc8_].tInfo.htmlText = "x" + _loc2_[_loc3_[_loc8_]];
            _loc7_[_loc8_].tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc3_[_loc8_]].name) + "</b>";
            _loc5_[_loc8_].visible = false;
            _loc7_[_loc8_].mouseChildren = false;
            _loc7_[_loc8_].addEventListener(MouseEvent.MOUSE_OVER,this.showDescription);
            _loc7_[_loc8_].addEventListener(MouseEvent.MOUSE_OUT,this.hideDescription);
            _loc8_++;
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            name_txt.htmlText = "<b>" + KEYS.Get("inf_ai_tribe_mapview",{"v1":TRIBES.TribeForBaseID(WMATTACK._attackersBaseID).name}) + "</b>";
         }
         else
         {
            name_txt.htmlText = "<b>" + KEYS.Get("ai_tribe",{"v1":TRIBES.TribeForBaseID(WMATTACK._attackersBaseID).name}) + "</b>";
         }
      }
      
      public function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap;
         (_loc4_ = new Bitmap(param2)).smoothing = true;
         param3[0].mcImage.addChild(_loc4_);
      }
      
      private function showDescription(param1:MouseEvent) : void
      {
         var _loc2_:Array = [c1,c2,c3];
         var _loc3_:Array = [this.d1,this.d2,this.d3];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1.target == _loc2_[_loc4_])
            {
               _loc3_[_loc4_].visible = true;
               setChildIndex(_loc2_[_loc4_],numChildren - 1);
            }
            _loc4_++;
         }
      }
      
      private function hideDescription(param1:MouseEvent) : void
      {
         var _loc2_:Array = [c1,c2,c3];
         var _loc3_:Array = [this.d1,this.d2,this.d3];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(param1.target == _loc2_[_loc4_])
            {
               _loc3_[_loc4_].visible = false;
            }
            _loc4_++;
         }
      }
      
      private function sendDown(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         WMATTACK.Attack();
         this.closeDown();
      }
      
      private function closeDown(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("close");
         WMATTACK.HideWarning();
      }
      
      public function Resize() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
         this.bm.x = GLOBAL._SCREENCENTER.x - 520 - this.bm.width * 0.5;
         this.bm.y = GLOBAL._SCREENCENTER.y - 250 - this.bm.height * 0.5;
      }
   }
}
