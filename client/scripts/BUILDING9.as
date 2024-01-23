package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING9 extends BFOUNDATION
   {
      
      public static const TYPE:uint = 9;
       
      
      public var _animMC:MovieClip;
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public var _blend:int;
      
      public var _blending:Boolean;
      
      private var _lastType:int;
      
      public var _guardian:int = 0;
      
      public function BUILDING9()
      {
         super();
         this._frameNumber = 0;
         _type = 9;
         this._blend = 0;
         _footprint = [new Rectangle(0,0,80,80)];
         _gridCost = [[new Rectangle(0,0,80,80),50]];
         _spoutPoint = new Point(0,12);
         _spoutHeight = 28;
         SetProps();
      }
      
      public function Prep(param1:String) : void
      {
         ++QUESTS._global.monstersblended;
         QUESTS._global.monstersblendedgoo += Math.ceil(CREATURES.GetProperty(param1,"cResource") * 0.7);
         ACHIEVEMENTS.Check("monstersblended",QUESTS._global.monstersblended);
         QUESTS.Check();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            BASE.Save();
         }
      }
      
      public function Blend(param1:int, param2:String, param3:Number = 1) : void
      {
         var _loc4_:* = param2.substr(0,2) == "IC";
         this._blend += param1;
         var _loc5_:Number = 0.6;
         if(_lvl.Get() == 2)
         {
            _loc5_ = 0.8;
         }
         else if(_lvl.Get() == 3)
         {
            _loc5_ = 1;
         }
         this._guardian = 0;
         BASE.Fund(4,Math.ceil(CREATURES.GetProperty(param2,"cResource") * _loc5_ * param3),false,null,param2.substr(0,1) == "I" && !BASE.isInfernoMainYardOrOutpost);
         this._lastType = _loc4_ ? 8 : 4;
         ResourcePackages.Create(this._lastType,this,Math.ceil(CREATURES.GetProperty(param2,"cResource") * _loc5_));
      }
      
      public function BlendGuardian(param1:int) : void
      {
         this._blend += param1;
         this._guardian = 1;
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(_animLoaded && !GLOBAL._catchup && (this._blend > 0 || _animTick > 2) && this._frameNumber % 2 == 0)
         {
            this.AnimFrame();
            if(_animTick == 1)
            {
               SOUNDS.Play("juice");
            }
            if(_animTick == 15)
            {
               this._blend = 0;
               if(!this._guardian)
               {
                  ResourcePackages.Create(this._lastType,this,1);
               }
            }
            if(_animTick == 52)
            {
               _animTick = 0;
            }
         }
         ++this._frameNumber;
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animContainerBMD)
         {
            _animContainerBMD.copyPixels(_animBMD,new Rectangle(60 * _animTick,0,60,39),new Point(0,0));
         }
         ++_animTick;
         var _loc2_:int = this._blend;
         if(_loc2_ > 70)
         {
            _loc2_ = 70;
         }
         if(_lvl.Get() == 2)
         {
            _loc2_ *= 1.2;
         }
         else if(_lvl.Get() == 3)
         {
            _loc2_ *= 1.4;
         }
         if(_animTick == 15)
         {
            if(this._guardian == 0)
            {
               GIBLETS.Create(_spoutPoint.add(new Point(_mc.x,_mc.y)),0.8,100,_loc2_,_spoutHeight);
            }
            else
            {
               GIBLETS.Create(_spoutPoint.add(new Point(_mc.x,_mc.y)),2,1000,_loc2_,_spoutHeight);
            }
         }
      }
      
      override public function Description() : void
      {
         super.Description();
         if(_lvl.Get() == 1)
         {
            if(_upgradeCosts != "")
            {
               _upgradeDescription = KEYS.Get("building_juicer_conversion",{
                  "v1":60,
                  "v2":80
               });
            }
         }
         else if(_lvl.Get() == 2)
         {
            if(_upgradeCosts != "")
            {
               _upgradeDescription = KEYS.Get("building_juicer_conversion",{
                  "v1":80,
                  "v2":100
               });
            }
         }
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bJuicer = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-mjl",KEYS.Get("pop_juicerbuilt_streamtitle"),KEYS.Get("pop_juicerbuilt_streambody"),"build-monsterjuiceloosener.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_juicerbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_juicerbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var percent:int = 0;
         var mc:MovieClip = null;
         super.Upgraded();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-fl-" + _lvl.Get(),KEYS.Get("pop_juicerupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_juicerupgraded_streambody"),"upgrade-monsterjuiceloosener.png"]);
               POPUPS.Next();
            };
            percent = 60;
            if(_lvl.Get() == 2)
            {
               percent = 80;
            }
            if(_lvl.Get() == 3)
            {
               percent = 100;
            }
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_juicerupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_juicerupgraded_body",{
               "v1":_lvl.Get(),
               "v2":percent
            });
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bJuicer = null;
         super.RecycleC();
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_countdownBuild.Get() == 0)
         {
            GLOBAL._bJuicer = this;
         }
         if(param1.tjc)
         {
            QUESTS._global.monstersblended = param1.tjc;
         }
         if(param1.tjg)
         {
            QUESTS._global.monstersblendedgoo = param1.tjg;
         }
         _animRandomStart = false;
         _animTick = 2;
      }
      
      override public function Export() : Object
      {
         return super.Export();
      }
   }
}
