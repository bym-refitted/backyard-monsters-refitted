package
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import org.bytearray.display.ScaleBitmap;
   
   public class UI_MENU extends Sprite
   {
       
      public var menuScale:Number = 1.8;
      
      public var woodmargin:int = 10;
      
      public var wood:ScaleBitmap;
      
      public var bBuild:StoneButton;
      
      public var bQuests:StoneButton;
      
      public var bStore:StoneButton;
      
      public var bMap:StoneButton;
      
      public var bKits:StoneButton;
      
      public var buttonspacing:int = 3;
      
      public var _loaded:Boolean = false;
      
      public var _sorted:Boolean = false;
      
      public var wood_mc:MovieClip;
      
      public function UI_MENU()
      {
         super();
         this.bBuild = new StoneButton();
         this.bQuests = new StoneButton();
         this.bStore = new StoneButton();
         this.bMap = new StoneButton();
         if(BASE.isOutpostMapRoom2Only)
         {
            this.bKits = new StoneButton();
         }
      }
      
      public function Setup() : void
      {
         var cbf1:Function = null;
         cbf1 = function():void
         {
            var cbf2:Function = null;
            cbf2 = function(param1:String, param2:BitmapData):void
            {
               wood = new ScaleBitmap(param2.clone());
               wood.scale9Grid = new Rectangle(15,15,10,10);
               addChild(wood);

               bBuild.scaleX = bBuild.scaleY = menuScale;
               bQuests.scaleX = bQuests.scaleY = menuScale;
               bStore.scaleX = bStore.scaleY = menuScale;
               bMap.scaleX = bMap.scaleY = menuScale;

               addChild(bBuild);
               if(MapRoomManager.instance.isInMapRoom3 && !BASE.isMainYardOrInfernoMainYard)
               {
                  bBuild.Enabled = false;
               }
               if(GLOBAL._loadmode == GLOBAL.mode)
               {
                  addChild(bQuests);
               }
               addChild(bStore);
               addChild(bMap);
               if(BASE.isOutpostMapRoom2Only)
               {
                  addChild(bKits);
               }

               wood.height = wood.height * menuScale;
               sortAll();
               _loaded = true;
               UI_BOTTOM.Resize();
               UI_BOTTOM.Update();
            };
            bBuild.SetupKey("ui_topbuildings",12);
            if(GLOBAL._loadmode == GLOBAL.mode)
            {
               bQuests.SetupKey("ui_topquests",12);
            }
            bStore.SetupKey("ui_topstore",12);
            bMap.SetupKey("ui_topmap",12);
            if(BASE.isOutpostMapRoom2Only)
            {
               bKits.SetupKey("btn_kits",12);
            }
            if(GLOBAL.InfernoMode())
            {
               ImageCache.GetImageWithCallBack("ui/stonemenu2.png",cbf2);
            }
            else
            {
               ImageCache.GetImageWithCallBack("ui/wood1.png",cbf2);
            }
         };
         if(GLOBAL.InfernoMode())
         {
            ImageCache.GetImageGroupWithCallBack("bottom_ui_inferno",["ui/lava1.png","ui/lava2.png","ui/lava3.png","ui/stonemenu2.png"],cbf1,true,1);
         }
         else
         {
            ImageCache.GetImageGroupWithCallBack("bottom_ui",["ui/wood1.png","ui/stone1.png","ui/stone2.png","ui/stone3.png"],cbf1,true,1);
         }
      }
      
      public function sortAll() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:StoneButton = null;
         var _loc3_:StoneButton = null;
         var _loc4_:Number = NaN;
         this.buttonspacing = 5 * menuScale;

         if(BASE.isOutpostMapRoom2Only)
         {
            _loc1_ = [this.bKits,this.bBuild,this.bQuests,this.bStore,this.bMap];
         }
         else if(GLOBAL.mode != GLOBAL._loadmode)
         {
            _loc1_ = [this.bBuild,this.bStore,this.bMap];
         }
         else
         {
            _loc1_ = [this.bBuild,this.bQuests,this.bStore,this.bMap];
         }
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_._bm == null)
            {
               return false;
            }
            if(!_loc2_)
            {
               _loc3_.x = this.woodmargin;
            }
            else
            {
               _loc3_.x = _loc2_.x + (_loc2_.getButtonWidth() * menuScale) + this.buttonspacing;
            }
            _loc3_.y = this.wood.height * 0.5 - (_loc3_.getButtonHeight() * menuScale) * 0.5;
            _loc2_ = _loc3_;
         }
         _loc4_ = _loc2_.x + (_loc2_.getButtonWidth() * menuScale) + this.woodmargin;
         this.wood.setSize(_loc4_,this.wood.height);
         this._sorted = true;
         return true;
      }
      
      public function Resize() : void
      {
         if(this._loaded)
         {
            x = int(GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - (this.wood.width + 10));
            y = int(GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - this.wood.height - 10);
            if(Boolean(UI_BOTTOM._missions) && Boolean(UI_BOTTOM._missions.frame))
            {
               y = int(UI_BOTTOM._missions.y + UI_BOTTOM._missions.frame.y - this.wood.height);
            }
         }
      }
   }
}
