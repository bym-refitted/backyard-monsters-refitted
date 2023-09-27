package com.monsters.ai
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class INFERNO_EMERGENCE_ATTACKPOPUP extends popup_infernoemerge_aiattack
   {
       
      
      public var _type:int;
      
      public var _attackArray:Array;
      
      private var d1:bubblepopup3;
      
      private var d2:bubblepopup3;
      
      private var d3:bubblepopup3;
      
      private var d4:bubblepopup3;
      
      private var d5:bubblepopup3;
      
      private var bm:Bitmap;
      
      private var _clips:Array;
      
      private var _descriptions:Array;
      
      public function INFERNO_EMERGENCE_ATTACKPOPUP(param1:Array)
      {
         var imageComplete:Function = null;
         var attArr:Array = param1;
         super();
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            bm = new Bitmap(param2);
            mcImage.addChild(bm);
         };
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         bAction.addEventListener(MouseEvent.CLICK,this.sendDown);
         bAction.SetupKey("ai_engage_btn");
         ImageCache.GetImageWithCallBack("popups/" + "portrait_moloch.png",imageComplete);
         mcFrame.Setup(false);
         this.d1 = new bubblepopup3();
         this.d1.x = 50;
         this.d1.y = 20;
         this.d2 = new bubblepopup3();
         this.d2.x = 50;
         this.d2.y = 20;
         this.d3 = new bubblepopup3();
         this.d3.x = 50;
         this.d3.y = 20;
         this.d4 = new bubblepopup3();
         this.d4.x = 50;
         this.d4.y = 20;
         addChild(this.d4);
         this.d5 = new bubblepopup3();
         this.d5.x = 50;
         this.d5.y = 20;
         this._clips = [c1,c2,c3,c4,c5];
         this._descriptions = [this.d1,this.d2,this.d3,this.d4,this.d5];
         this._attackArray = attArr;
         tTitle.htmlText = KEYS.Get("ai_inferno_popupwarning_title");
         tName.htmlText = "";
         this.Resize();
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
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._attackArray.length)
         {
            _loc2_.push(this._attackArray[_loc3_][0]);
            _loc3_++;
         }
         switch(_loc2_.length)
         {
            case 1:
               removeChild(c2);
               removeChild(c3);
               removeChild(c4);
               removeChild(c5);
               break;
            case 2:
               removeChild(c3);
               removeChild(c4);
               removeChild(c5);
               break;
            case 3:
               removeChild(c4);
               removeChild(c5);
               break;
            case 4:
               removeChild(c5);
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            this._descriptions[_loc4_].Setup(50,20,KEYS.Get("emerge_mondesc_" + CREATURELOCKER._creatures[_loc2_[_loc4_]].description),3);
            _loc4_++;
         }
         c1.addChild(this.d1);
         c2.addChild(this.d2);
         c3.addChild(this.d3);
         c4.addChild(this.d4);
         c5.addChild(this.d5);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            ImageCache.GetImageWithCallBack("monsters/" + _loc2_[_loc5_] + "-medium.jpg",this.IconLoaded,true,1,"",[this._clips[_loc5_].mcIcon]);
            this._clips[_loc5_].tInfo.htmlText = "x" + this._attackArray[_loc5_][2];
            this._clips[_loc5_].tName.htmlText = "<b>" + KEYS.Get(CREATURELOCKER._creatures[_loc2_[_loc5_]].name) + "</b>";
            this._descriptions[_loc5_].visible = false;
            this._clips[_loc5_].mouseChildren = false;
            this._clips[_loc5_].addEventListener(MouseEvent.MOUSE_OVER,this.showDescription);
            this._clips[_loc5_].addEventListener(MouseEvent.MOUSE_OUT,this.hideDescription);
            _loc5_++;
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
         var _loc2_:int = 0;
         while(_loc2_ < this._clips.length)
         {
            if(param1.target == this._clips[_loc2_])
            {
               this._descriptions[_loc2_].visible = true;
               setChildIndex(this._clips[_loc2_],numChildren - 1);
            }
            _loc2_++;
         }
      }
      
      private function hideDescription(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._clips.length)
         {
            if(param1.target == this._clips[_loc2_])
            {
               this._descriptions[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function sendDown(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("click1");
         INFERNO_EMERGENCE_EVENT.TriggerAttack(param1);
         this.closeDown();
      }
      
      private function closeDown(param1:MouseEvent = null) : void
      {
         SOUNDS.Play("close");
         INFERNO_EMERGENCE_POPUPS.HideWarning();
      }
      
      public function Resize() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
   }
}
