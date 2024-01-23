package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING26 extends BFOUNDATION
   {
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public function BUILDING26()
      {
         super();
         _type = 26;
         _footprint = BASE.isInfernoMainYardOrOutpost ? [new Rectangle(0,0,80,80)] : [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         SetProps();
      }
      
      override public function Click(param1:MouseEvent = null) : void
      {
         if(_upgrading && GLOBAL.player.m_upgrades[_upgrading] && GLOBAL.player.m_upgrades[_upgrading].time == null)
         {
            _upgrading = null;
         }
         ACADEMY._monsterID = _upgrading;
         super.Click(param1);
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(_upgrading && GLOBAL._render && _countdownBuild.Get() + _countdownUpgrade.Get() == 0)
         {
            if(GLOBAL._render && _animLoaded && _countdownBuild.Get() + _countdownUpgrade.Get() == 0)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && (this._frameNumber % 3 == 0 || GLOBAL._lockerOverdrive > 0) && CREEPS._creepCount == 0)
               {
                  AnimFrame();
               }
               else if(this._frameNumber % 10 == 0 || GLOBAL._lockerOverdrive > 0 && this._frameNumber % 4 == 0)
               {
                  AnimFrame();
               }
            }
         }
         ++this._frameNumber;
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bAcademy = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function():void
            {
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  GLOBAL.CallJS("sendFeed",["iacademy-construct",KEYS.Get("q_build_infernalacademy_streamtitle"),KEYS.Get("q_build_infernalacademy_streambody"),"build-iacademy.png"]);
               }
               else
               {
                  GLOBAL.CallJS("sendFeed",["academy-construct",KEYS.Get("pop_acadbuilt_streamtitle"),KEYS.Get("pop_acadbuilt_streambody"),"build-academy.png"]);
               }
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_acadbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_acadbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Description() : void
      {
         super.Description();
         if(_upgrading != null && Boolean(GLOBAL.player.m_upgrades[_upgrading].time))
         {
            _specialDescription = KEYS.Get("building_academy_training",{
               "v1":CREATURELOCKER._creatures[_upgrading].name,
               "v2":GLOBAL.ToTime(GLOBAL.player.m_upgrades[_upgrading].time.Get() - GLOBAL.Timestamp())
            });
         }
      }
      
      override public function Upgrade() : Boolean
      {
         if(_upgrading)
         {
            GLOBAL.Message(KEYS.Get("acad_err_cantupgrade"));
            return false;
         }
         return super.Upgrade();
      }
      
      override public function Recycle() : void
      {
         if(_upgrading)
         {
            GLOBAL.Message(KEYS.Get("acad_err_cantrecycle"));
         }
         else
         {
            GLOBAL._bAcademy = null;
            super.Recycle();
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(param1.upg)
         {
            _upgrading = param1.upg;
         }
         if(_upgrading == "C100")
         {
            _upgrading = "C12";
         }
         if(_countdownBuild.Get() <= 0)
         {
            GLOBAL._bAcademy = this;
         }
      }
      
      override public function Export() : Object
      {
         var _loc1_:Object = super.Export();
         if(_upgrading)
         {
            _loc1_.upg = _upgrading;
         }
         return _loc1_;
      }
   }
}
