package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING8 extends BFOUNDATION
   {
       
      
      public var _animMC:MovieClip;
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public function BUILDING8()
      {
         this._frameNumber = Math.random() * 5;
         super();
         _type = 8;
         _footprint = [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         SetProps();
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(GLOBAL._render && _countdownBuild.Get() + _countdownUpgrade.Get() == 0 && CREATURELOCKER._unlocking != null)
         {
            if((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "help" || GLOBAL.mode == "view") && this._frameNumber % 3 == 0 && CREEPS._creepCount == 0)
            {
               AnimFrame();
            }
            else if(this._frameNumber % 10 == 0)
            {
               AnimFrame();
            }
         }
         ++this._frameNumber;
      }
      
      override public function Description() : void
      {
         super.Description();
         if(GLOBAL._lockerOverdrive > 0)
         {
            _buildingTitle += " <font color=\"#CC0000\">" + KEYS.Get("cloc_overdrive",{"v1":GLOBAL.ToTime(GLOBAL._lockerOverdrive)}) + "</font>";
         }
         if(CREATURELOCKER._unlocking != null && Boolean(CREATURELOCKER._lockerData[CREATURELOCKER._unlocking]))
         {
            _specialDescription = "Unlocking the " + CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name + " " + GLOBAL.ToTime(CREATURELOCKER._lockerData[CREATURELOCKER._unlocking].e - GLOBAL.Timestamp()) + " remaining<br>";
         }
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bLocker = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-ml",KEYS.Get("pop_clocbuilt_streamtitle"),KEYS.Get("pop_clocbuilt_streambody"),"build-monsterlocker.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_clocbuilt_title") + "</b>";
            mc.tB.htmlText = " ";
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Upgraded();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-ml-",KEYS.Get("cloc_upgrade_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("cloc_upgrade_streambody"),"upgrade-monsterlocker.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("cloc_popupgrade_ta") + "</b>";
            mc.tB.htmlText = KEYS.Get("cloc_popupgrade_tb",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bLocker = null;
         super.Cancel();
      }
      
      override public function Upgrade() : Boolean
      {
         if(CREATURELOCKER._unlocking != null)
         {
            GLOBAL.Message(KEYS.Get("cloc_err_cantupgrade",{"v1":KEYS.Get(CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name)}));
            return false;
         }
         return super.Upgrade();
      }
      
      override public function Recycle() : void
      {
         if(CREATURELOCKER._unlocking != null)
         {
            GLOBAL.Message(KEYS.Get("cloc_err_cantrecycle",{"v1":CREATURELOCKER._creatures[CREATURELOCKER._unlocking].name}),KEYS.Get("msg_recyclebuilding_btn"),this.RecycleB);
         }
         else
         {
            super.Recycle();
         }
      }
      
      override public function RecycleB(param1:MouseEvent = null) : void
      {
         if(CREATURELOCKER._unlocking != null)
         {
            CREATURELOCKER.Cancel();
         }
         super.RecycleB(param1);
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bLocker = null;
         super.RecycleC();
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_countdownBuild.Get() == 0)
         {
            GLOBAL._bLocker = this;
         }
      }
   }
}
