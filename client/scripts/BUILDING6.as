package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING6 extends BSTORAGE
   {
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animTickTarget:int;
      
      public var _animBitmap:BitmapData;
      
      public function BUILDING6()
      {
         super();
         this._frameNumber = 0;
         _type = 6;
         _footprint = [new Rectangle(0,0,80,80)];
         _gridCost = [[new Rectangle(0,0,80,80),10],[new Rectangle(10,10,60,60),200]];
         _spoutPoint = new Point(0,-48);
         _spoutHeight = 82;
         SetProps();
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(GLOBAL._render || param1)
         {
            _loc4_ = 1;
            while(_loc4_ < 5)
            {
               _loc2_ += BASE._resources["r" + _loc4_ + "max"];
               _loc3_ += BASE._resources["r" + _loc4_].Get();
               _loc4_++;
            }
            this._animTickTarget = int(26 / _loc2_ * _loc3_);
         }
         super.Update(param1);
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(_animLoaded && _countdownBuild.Get() == 0 && this._frameNumber % 3 == 0)
         {
            if(_animTick != this._animTickTarget)
            {
               _animTick = this._animTickTarget;
               this.AnimFrame();
            }
         }
         ++this._frameNumber;
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animContainerBMD)
         {
            _animContainerBMD.copyPixels(_animBMD,new Rectangle(74 * _animTick,0,74,121),new Point(0,0));
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
               GLOBAL.CallJS("sendFeed",["upgrade-st-" + _lvl.Get(),KEYS.Get("pop_siloupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_siloupgraded_streambody"),"upgrade-storage.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_siloupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_siloupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
      }
      
      override public function Click(param1:MouseEvent = null) : void
      {
         super.Click(param1);
      }
      
      override public function Description() : void
      {
         super.Description();
         _specialDescription = KEYS.Get("building_silo_upgrade_desc1",{"v1":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get() - 1])});
         _buildingDescription = _specialDescription;
         if(_upgradeCosts != "")
         {
            _upgradeDescription = KEYS.Get("building_silo_upgrade_desc2",{"v1":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get()] - _buildingProps.capacity[_lvl.Get() - 1])});
         }
      }
   }
}
