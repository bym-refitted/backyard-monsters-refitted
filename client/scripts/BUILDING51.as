package
{
   import com.monsters.display.ImageCache;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BUILDING51 extends BFOUNDATION
   {
       
      
      public function BUILDING51()
      {
         super();
         _type = 51;
         _footprint = [new Rectangle(0,0,90,90)];
         _gridCost = [[new Rectangle(0,0,90,90),10],[new Rectangle(10,10,70,70),200]];
         SetProps();
      }
      
      override public function Tick(param1:int) : void
      {
         if(_countdownBuild.Get() > 0 || health < maxHealth * 0.5)
         {
            _canFunction = false;
         }
         else
         {
            _canFunction = true;
         }
         super.Tick(param1);
      }
      
      public function Fund() : void
      {
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         super.Place(param1);
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bCatapult = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerCatapultLevel.Set(0);
         }
         super.Cancel();
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bCatapult = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL._playerCatapultLevel.Set(0);
         }
         super.RecycleC();
      }
      
      override public function Description() : void
      {
         super.Description();
         _upgradeDescription = KEYS.Get("bdg_catapult_upgrade");
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bCatapult = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-cat",KEYS.Get("pop_catapultbuilt_streamtitle"),KEYS.Get("pop_catapultbuilt_streambody"),"build-catapult.png"]);
               POPUPS.Next();
            };
            this.LoadEffects();
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_catapultbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_catapultbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL._playerCatapultLevel.Set(_lvl.Get());
            }
         }
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Upgraded();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["upgrade-cat-" + _lvl.Get(),KEYS.Get("pop_catapultupgraded" + _lvl.Get() + "_streamtitle"),KEYS.Get("pop_catapultupgraded" + _lvl.Get() + "_streambody"),"upgrade-catapult.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_catapultupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_catapultupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
            GLOBAL._playerCatapultLevel.Set(_lvl.Get());
         }
      }
      
      public function LoadEffects() : void
      {
         ImageCache.GetImageWithCallBack("effects/pebble.png",null,true,6);
         ImageCache.GetImageWithCallBack("effects/pebblehit.png",null,true,6);
         ImageCache.GetImageWithCallBack("effects/twigs.png",null,true,6);
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(_countdownBuild.Get() <= 0)
         {
            this.LoadEffects();
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL._playerCatapultLevel.Set(_lvl.Get());
            }
            GLOBAL._bCatapult = this;
         }
      }
   }
}
