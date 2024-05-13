package com.monsters.maproom_inferno
{
   import com.monsters.maproom_inferno.model.BaseObject;
   import com.monsters.maproom_inferno.views.DescentBasePopup;
   import com.monsters.maproom_inferno.views.DescentView;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DescentMonsterBase extends DescentMonsterBase_CLIP
   {
       
      
      public var mapX:int;
      
      public var mapY:int;
      
      public var attackBtn:Button;
      
      public var helpBtn:Button;
      
      private var loadingImage:Boolean = false;
      
      public var offState:Sprite;
      
      public var overState:Sprite;
      
      private var nameMargin:uint = 10;
      
      private var _state:String;
      
      private var mouseTimer:Timer;
      
      private var pin:Sprite;
      
      private var currentHitArea:SimpleButton;
      
      public var data:BaseObject;
      
      public var colorCode:uint;
      
      public var image:Sprite;
      
      public var nameBox:Sprite;
      
      public var popUp:DescentBasePopup;
      
      public var handler:PlayerHandler;
      
      public var loader:Loader;
      
      public var imageLoadState:uint = 0;
      
      public var info_mc:DescentBaseInfo;
      
      public const popupCoordMap:Array = [[15,-230],[-145,-215],[15,-225],[15,-225],[40,-215],[-170,-210],[-170,-215],[40,-200],[-170,-225],[30,-230],[50,-240],[-170,-220],[-60,-280]];
      
      public function DescentMonsterBase()
      {
         super();
         this.popUp = new DescentBasePopup();
         this.popUp.tDepth.htmlText = "<b>" + KEYS.Get("descent_depthBar") + "</b>";
         this.popUp.x = 20;
         this.popUp.y = -250;
         this.addChild(this.popUp);
         this.info_mc = new DescentBaseInfo();
         this.info_mc.x = 22;
         this.info_mc.y = 10;
         this.addChild(this.info_mc);
      }
      
      public function Setup(param1:BaseObject) : void
      {
         var dataObj:BaseObject = param1;
         this.data = dataObj;
         this.colorCode = PushPin.RED;
         this.loader = new Loader();
         removeChild(this.popUp);
         this.attackBtn = this.popUp.attackBtn;
         this.helpBtn = this.popUp.helpBtn;
         this.popUp.setHeightForButtons(2);
         this.popUp.removeChild(this.popUp.truceBtn);
         this.popUp.removeChild(this.popUp.msgBtn);
         this.offState = new Sprite();
         this.offState.mouseChildren = false;
         this.offState.addChild(mcBase);
         this.overState = new Sprite();
         this.overState.mouseChildren = false;
         this.overState.addChild(this.info_mc);
         removeChild(smallhit);
         removeChild(largehit);
         this.attackBtn.SetupKey("map_attack_btn");
         this.helpBtn.SetupKey("map_view_btn");
         removeChild(mediumhit);
         this.setState("off");
         try
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
            if(this.data.level.Get() == DescentView.getInstance().players.targetLvl)
            {
               addEventListener(MouseEvent.MOUSE_DOWN,this.thisDown);
            }
         }
         catch(e:Error)
         {
         }
         this.mouseTimer = new Timer(400);
         this.mouseTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.mouseTimer.start();
         new PlayerHandler().configure(this);
         stop();
         this.SetLevelArt();
      }
      
      public function InitTargetListener() : void
      {
         try
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
            if(this.data.level.Get() == DescentView.getInstance().players.targetLvl + 1)
            {
               addEventListener(MouseEvent.MOUSE_DOWN,this.thisDown);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function SetLevelArt() : void
      {
         var _loc3_:* = null;
         var _loc1_:int = this.data.level.Get();
         var _loc2_:int = 0;
         if(DescentMapRoom.BRIDGE.MAPROOM)
         {
            _loc2_ = int(DescentMapRoom.BRIDGE.MAPROOM.DescentLevel);
         }
         //setting the base sprites for each base on the descent map.
         switch(_loc1_)
         {
            case 1:
            case 2:
               _loc3_ = "base1";
               break;
            case 3:
            case 4:
               _loc3_ = "base2";
               break;
            case 5:
            case 6:
               _loc3_ = "base3";
               break;
            case 7:
            case 8:
               _loc3_ = "base4";
               break;
            case 9:
            case 10:
               _loc3_ = "base5";
               break;
            case 11:
            case 12:
               _loc3_ = "base6";
               break;
            case 13:
               _loc3_ = "base7";
               break;
            default:
               _loc3_ = "base1";
         }
         if(_loc1_ > _loc2_)
         {
            _loc3_ += "_dark";
         }
         if(this.data.destroyed)
         {
            _loc3_ += "_destroyed";
            mcBase.visible = false;
            removeEventListener(MouseEvent.MOUSE_OVER,this.thisOver);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.thisDown);
         }
         mcBase.gotoAndStop(_loc3_);
      }
      
      public function setState(param1:String) : void
      {
         var _loc2_:int = 0;
         if(param1 == "off")
         {
            if(this.contains(this.overState))
            {
               removeChild(this.overState);
            }
            addChildAt(this.offState,0);
            this.currentHitArea = smallhit;
            if(this.contains(this.popUp))
            {
               removeChild(this.popUp);
            }
         }
         else if(param1 == "down")
         {
            if(this.contains(this.overState))
            {
               removeChild(this.overState);
            }
            this.currentHitArea = largehit;
            addChild(this.popUp);
            addChild(this.offState);
            _loc2_ = this.data.level.Get() - 1;
            if(this.data)
            {
               this.popUp.Show(this.data.level.Get(),this.popupCoordMap[_loc2_][0],this.popupCoordMap[_loc2_][1]);
            }
            else
            {
               this.popUp.Show();
            }
         }
         else if(param1 == "over")
         {
            addChild(this.offState);
         }
         this._state = param1;
         dispatchEvent(new Event(param1));
      }
      
      private function onPortraitComplete(param1:String, param2:BitmapData) : void
      {
         this.imageLoadState = 2;
         var _loc3_:Bitmap = new Bitmap(param2);
         _loc3_.width = _loc3_.height = 44;
         this.image.addChildAt(_loc3_,this.image.numChildren - 1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         if(this._state != "off")
         {
            if(mouseX < this.currentHitArea.x || mouseX > this.currentHitArea.x + this.currentHitArea.width || mouseY < this.currentHitArea.y || mouseY > this.currentHitArea.y + this.currentHitArea.height)
            {
               this.setState("off");
            }
         }
      }
      
      private function thisOver(param1:MouseEvent) : void
      {
         if(this._state == "off")
         {
            this.setState("over");
         }
      }
      
      private function thisDown(param1:MouseEvent) : void
      {
         if(this._state == "off" || this._state == "over")
         {
            this.setState("down");
         }
      }
   }
}
