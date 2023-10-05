package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING5 extends BFOUNDATION
   {
       
      
      public function BUILDING5()
      {
         super();
         _type = 5;
         _footprint = [new Rectangle(0,0,90,90)];
         _gridCost = [[new Rectangle(0,0,90,90),10],[new Rectangle(10,10,70,70),200]];
         SetProps();
      }
      
      public static function getFlingerRange(param1:int, param2:Boolean) : int
      {
         return param2 ? 2 + 2 * param1 : param1;
      }
      
      override public function get tickLimit() : int
      {
         var _loc1_:int = super.tickLimit;
         if(_countdownBuild.Get() > 0)
         {
            _loc1_ = Math.min(_loc1_,_countdownBuild.Get());
         }
         if(_countdownUpgrade.Get() > 0)
         {
            _loc1_ = Math.max(_loc1_,_countdownUpgrade.Get());
         }
         return _loc1_;
      }
      
      override public function Tick(param1:int) : void
      {
         _canFunction = _countdownBuild.Get() <= 0 && health >= maxHealth * 0.5;
         super.Tick(param1);
      }
      
      public function Fund() : void
      {
      }
      
      override public function PlaceB() : void
      {
         GLOBAL._bFlinger = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerFlingerLevel.Set(_lvl.Get());
         }
         super.PlaceB();
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bFlinger = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerFlingerLevel.Set(0);
         }
         super.Cancel();
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bFlinger = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerFlingerLevel.Set(0);
         }
         super.RecycleC();
      }
      
      override public function Description() : void
      {
         super.Description();
         _upgradeDescription = KEYS.Get("building_flinger_upgrade_desc");
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL._bFlinger = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerFlingerLevel.Set(_lvl.Get());
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
               GLOBAL.CallJS("sendFeed",["upgrade-fl-" + _lvl.Get(),KEYS.Get("pop_flingerupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_flingerupgraded_streambody"),"upgrade-flinger.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_flingerupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_flingerupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
            GLOBAL._playerFlingerLevel.Set(_lvl.Get());
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_countdownBuild.Get() <= 0)
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL._playerFlingerLevel.Set(_lvl.Get());
            }
            GLOBAL._bFlinger = this;
         }
      }
   }
}
