package
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.input.KeyboardInputHandler;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.rendering.RasterData;
   import com.monsters.rendering.Renderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.*;
   import flash.geom.*;
   import gs.*;
   import gs.easing.*;
   
   public class MAP
   {
      
      public static var _inited:Boolean = false;
      
      public static var _dragX:Number;
      
      public static var _dragY:Number;
      
      public static var tx:Number;
      
      public static var ty:Number;
      
      public static var targX:Number;
      
      public static var targY:Number;
      
      public static var d:Number;
      
      public static var _startX:Number;
      
      public static var _startY:Number;
      
      public static var _autoScroll:Boolean;
      
      public static const stage:Stage = GLOBAL._ROOT.stage;
      
      public static var _dragging:Boolean;
      
      public static var _dragged:Boolean;
      
      public static var _dragDistance:Number;
      
      public static var _EFFECTSBMP:BitmapData;
      
      public static var _GROUND:Sprite;
      
      public static var _EDGE:MovieClip;
      
      public static var _UNDERLAY:MovieClip;
      
      public static var _RESOURCES:MovieClip;
      
      public static var _BUILDINGBASES:MovieClip;
      
      public static var _WORKERS:MovieClip;
      
      public static var _WALLS:MovieClip;
      
      public static var _EFFECTS:Sprite;
      
      public static var _CREEPSMC:MovieClip;
      
      public static var _BUILDINGFOOTPRINTS:MovieClip;
      
      public static var _BUILDINGINFO:MovieClip;
      
      public static var _PROJECTILES:MovieClip;
      
      public static var _FIREBALLS:MovieClip;
      
      public static var _EFFECTSTOP:MovieClip;
      
      public static var _BGTILES:MovieClip;
      
      public static var _BUILDINGTOPS:Sprite;
      
      public static var _damageGrid:Object;
      
      public static var _following:Boolean;
      
      public static var _sortTo:int = 0;
      
      public static var _canScroll:Boolean = true;
      
      public static const MAP_TYPE_GRASS:int = 0;
      
      public static const MAP_TYPE_ROCK:int = 1;
      
      public static const MAP_TYPE_SAND:int = 2;
      
      public static const MAP_TYPE_CRATER:int = 3;
      
      public static const MAP_TYPE_LAVA:int = 4;
      
      public static const DEPTH_SHADOW:uint = 1;
      
      protected static var _bmdTile:BitmapData;
      
      protected static var s_texture:String;
      
      private static var _instance:MAP;
      
      private static var _canvas:BitmapData;
      
      private static var _canvasContainer:Bitmap;
      
      public static const MAP_WIDTH:uint = 3994;
      
      public static const MAP_HEIGHT:uint = 1994;
      
      private static const _viewRect:Rectangle = new Rectangle();
      
      protected static var _effectsRasterData:RasterData;
      
      public static var vol:Number = 1;
       
      
      protected var _renderer:Renderer;
      
      protected const _point:Point = new Point();
      
      public function MAP(param1:String)
      {
         var rect:Rectangle = null;
         var efxbmp:Bitmap = null;
         var texture:String = param1;
         super();
         _instance = this;
         try
         {
            tx = GLOBAL._SCREENINIT.width / 2;
            ty = GLOBAL._SCREENINIT.height / 2;
            rect = GLOBAL._SCREEN;
            _viewRect.x = GLOBAL._SCREEN.x + MAP_WIDTH / 2;
            _viewRect.y = GLOBAL._SCREEN.y + MAP_HEIGHT / 2;
            _viewRect.width = GLOBAL._SCREEN.width;
            _viewRect.height = GLOBAL._SCREEN.height;
            _GROUND = GLOBAL._layerMap.addChild(new Sprite()) as Sprite;
            if(!BYMConfig.instance.RENDERER_ON)
            {
               _BGTILES = _GROUND.addChild(new MovieClip()) as MovieClip;
            }
            if(BYMConfig.instance.RENDERER_ON)
            {
               _canvas = new BitmapData(MAP_WIDTH,MAP_HEIGHT,false,0);
               _canvasContainer = new Bitmap(_canvas);
               _canvasContainer.x -= _canvasContainer.width / 2;
               _canvasContainer.y -= _canvasContainer.height / 2;
               _GROUND.addChild(_canvasContainer);
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MAP.Setup A: " + e.message + " | " + e.getStackTrace());
         }
         try
         {
            _GROUND.x = tx;
            _GROUND.y = ty;
            _UNDERLAY = _GROUND.addChild(new MovieClip()) as MovieClip;
            if(BYMConfig.instance.RENDERER_ON)
            {
               _EFFECTSBMP = new BitmapData(_canvas.width,_canvas.height,false,0);
               _effectsRasterData = new RasterData(_EFFECTSBMP,new Point((_canvas.width - _EFFECTSBMP.width) * 0.5,(_canvas.height - _EFFECTSBMP.height) * 0.5),0,null,true);
            }
            else
            {
               _EFFECTSBMP = new BitmapData(3200,1800,true,0);
               efxbmp = _GROUND.addChild(new Bitmap(_EFFECTSBMP)) as Bitmap;
               efxbmp.x = -_EFFECTSBMP.width * 0.5;
               efxbmp.y = -_EFFECTSBMP.height * 0.5;
            }
            s_texture = texture;
            swapBG(s_texture);
            _EFFECTS = _GROUND.addChild(new MovieClip()) as MovieClip;
            _EFFECTS.mouseEnabled = false;
            _EFFECTS.mouseChildren = false;
            _EFFECTS.tabChildren = false;
            _BUILDINGBASES = _GROUND.addChild(new MovieClip()) as MovieClip;
            _BUILDINGBASES.mouseEnabled = false;
            _BUILDINGBASES.mouseChildren = true;
            _BUILDINGBASES.tabChildren = false;
            _BUILDINGFOOTPRINTS = _GROUND.addChild(new MovieClip()) as MovieClip;
            _BUILDINGFOOTPRINTS.mouseEnabled = false;
            _BUILDINGFOOTPRINTS.mouseChildren = false;
            _BUILDINGFOOTPRINTS.tabChildren = false;
            _CREEPSMC = BYMConfig.instance.RENDERER_ON ? new MovieClip() : _GROUND.addChild(new MovieClip()) as MovieClip;
            _CREEPSMC.mouseEnabled = false;
            _CREEPSMC.mouseChildren = true;
            _CREEPSMC.tabChildren = false;
            _BUILDINGTOPS = _GROUND.addChild(new Sprite()) as Sprite;
            _BUILDINGTOPS.mouseEnabled = false;
            _BUILDINGTOPS.mouseChildren = true;
            _BUILDINGTOPS.tabChildren = false;
            _RESOURCES = _GROUND.addChild(new MovieClip()) as MovieClip;
            _RESOURCES.mouseEnabled = false;
            _RESOURCES.mouseChildren = false;
            _RESOURCES.tabChildren = false;
            _BUILDINGINFO = _GROUND.addChild(new MovieClip()) as MovieClip;
            _BUILDINGINFO.mouseEnabled = false;
            _BUILDINGINFO.mouseChildren = true;
            _BUILDINGINFO.tabChildren = false;
            _PROJECTILES = _GROUND.addChild(new MovieClip()) as MovieClip;
            _PROJECTILES.mouseEnabled = false;
            _PROJECTILES.mouseChildren = false;
            _PROJECTILES.tabChildren = false;
            _FIREBALLS = _GROUND.addChild(new MovieClip()) as MovieClip;
            _FIREBALLS.mouseEnabled = false;
            _FIREBALLS.mouseChildren = false;
            _FIREBALLS.tabChildren = false;
            _EFFECTSTOP = _GROUND.addChild(new MovieClip()) as MovieClip;
            _EFFECTSTOP.mouseEnabled = false;
            _EFFECTSTOP.mouseChildren = false;
            _EFFECTSTOP.tabChildren = false;
            _dragged = false;
            _GROUND.addEventListener(MouseEvent.MOUSE_DOWN,Click);
            _GROUND.addEventListener(Event.ENTER_FRAME,Scroll);
            _GROUND.stage.addEventListener(KeyboardEvent.KEY_DOWN,KeyboardInputHandler.instance.OnKeyDown);
            if(GLOBAL.DOES_USE_SCROLL)
            {
               _GROUND.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseScroll);
            }
            _GROUND.stage.addEventListener(KeyboardEvent.KEY_UP,KeyUp);
            _EDGE = null;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MAP.Setup B: " + e.message + " | " + e.getStackTrace());
         }
         if(!BYMConfig.instance.RENDERER_ON)
         {
            Edge();
         }
         if(BYMConfig.instance.RENDERER_ON)
         {
            this._renderer = new Renderer(_canvas,_viewRect);
            GLOBAL._ROOT.addEventListener(Event.RENDER,this.render);
         }
         Targeting.init();
         _inited = true;
      }
      
      public static function get effectsBMD() : BitmapData
      {
         return _EFFECTSBMP;
      }
      
      public static function get texture() : String
      {
         return s_texture;
      }
      
      public static function get instance() : MAP
      {
         return _instance;
      }
      
      public static function swapBG(param1:String) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         s_texture = param1;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            while(_BGTILES.numChildren)
            {
               _BGTILES.removeChildAt(0);
            }
         }
         _bmdTile = MAPBG.MakeTile(s_texture);
         var _loc2_:Array = [];
         var _loc6_:Point = new Point();
         if(BYMConfig.instance.RENDERER_ON)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_ = 0;
               while(_loc5_ < 4)
               {
                  _loc6_.x = _loc4_ * 1000;
                  _loc6_.y = _loc5_ * 500;
                  _EFFECTSBMP.copyPixels(_bmdTile,_bmdTile.rect,_loc6_);
                  _loc5_++;
               }
               _loc4_++;
            }
            _bmdTile.dispose();
            _bmdTile = null;
            Edge();
         }
         else
         {
            _loc4_ = -2;
            while(_loc4_ < 2)
            {
               _loc5_ = -2;
               while(_loc5_ < 2)
               {
                  _loc3_ = _BGTILES.addChild(new Bitmap(_bmdTile));
                  _loc3_.x = _loc4_ * 998;
                  _loc3_.y = _loc5_ * 498;
                  _loc3_.cacheAsBitmap = true;
                  _loc5_++;
               }
               _loc4_++;
            }
         }
      }
      
      public static function swapIntBG(param1:int) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case MAP_TYPE_ROCK:
               _loc2_ = "rock";
               break;
            case MAP_TYPE_SAND:
               _loc2_ = "sand";
               break;
            case MAP_TYPE_CRATER:
               _loc2_ = "crater";
               break;
            case MAP_TYPE_LAVA:
               _loc2_ = "lava";
               break;
            case MAP_TYPE_GRASS:
            default:
               _loc2_ = "grass";
         }
         swapBG(_loc2_);
      }
      
      public static function Clear() : void
      {
         if(_GROUND)
         {
            _GROUND.removeEventListener(MouseEvent.MOUSE_DOWN,Click);
            _GROUND.removeEventListener(Event.ENTER_FRAME,Scroll);
            while(_GROUND.numChildren)
            {
               _GROUND.removeChildAt(0);
            }
         }
         if(_BUILDINGTOPS)
         {
            while(_BUILDINGTOPS.numChildren)
            {
               _BUILDINGTOPS.removeChildAt(0);
            }
         }
         if(BYMConfig.instance.RENDERER_ON && GLOBAL._ROOT.hasEventListener(Event.RENDER))
         {
            GLOBAL._ROOT.removeEventListener(Event.RENDER,_instance.render);
         }
         _BGTILES = null;
         _BUILDINGBASES = null;
         _BUILDINGFOOTPRINTS = null;
         _BUILDINGTOPS = null;
         _RESOURCES = null;
         _BUILDINGINFO = null;
         _PROJECTILES = null;
         _FIREBALLS = null;
         _EFFECTS = null;
         _EFFECTSTOP = null;
         _GROUND = null;
         s_texture = null;
         if(_effectsRasterData)
         {
            _effectsRasterData.clear();
         }
         if(_bmdTile)
         {
            _bmdTile.dispose();
         }
         if(_canvas)
         {
            _canvas.dispose();
         }
         if(_EFFECTSBMP)
         {
            _EFFECTSBMP.dispose();
         }
         _effectsRasterData = null;
         _bmdTile = null;
         _canvas = null;
         _EFFECTSBMP = null;
         _inited = false;
      }
      
      public static function Edge() : void
      {
         var iso:Point = null;
         if(GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode !== GLOBAL.e_BASE_MODE.IBUILD)
         {
            return;
         }
         try
         {
            if(Boolean(_EDGE) && _EDGE.parent == _UNDERLAY)
            {
               _UNDERLAY.removeChild(_EDGE);
            }
            _EDGE = BYMConfig.instance.RENDERER_ON ? new MovieClip() : _UNDERLAY.addChild(new MovieClip()) as MovieClip;
            _EDGE.graphics.lineStyle(2,16777215,0.5);
            iso = GRID.ToISO((0 - GLOBAL._mapWidth) / 2,(0 - GLOBAL._mapHeight) / 2,0);
            _EDGE.graphics.moveTo(iso.x,iso.y);
            iso = GRID.ToISO(GLOBAL._mapWidth / 2,(0 - GLOBAL._mapHeight) / 2,0);
            _EDGE.graphics.lineTo(iso.x,iso.y);
            iso = GRID.ToISO(GLOBAL._mapWidth / 2,GLOBAL._mapHeight / 2,0);
            _EDGE.graphics.lineTo(iso.x,iso.y);
            iso = GRID.ToISO((0 - GLOBAL._mapWidth) / 2,GLOBAL._mapHeight / 2,0);
            _EDGE.graphics.lineTo(iso.x,iso.y);
            iso = GRID.ToISO((0 - GLOBAL._mapWidth) / 2,(0 - GLOBAL._mapHeight) / 2,0);
            _EDGE.graphics.lineTo(iso.x,iso.y);
            if(BYMConfig.instance.RENDERER_ON)
            {
               _EFFECTSBMP.draw(_EDGE,new Matrix(1,0,0,1,_EFFECTSBMP.width * 0.5,_EFFECTSBMP.height * 0.5));
            }
            else
            {
               _EDGE.cacheAsBitmap = true;
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MAP.Edge: " + e.message + " | " + e.getStackTrace());
         }
      }
      
      public static function SortDepth(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc6_:int = 0;
         if(BYMConfig.instance.RENDERER_ON)
         {
            return;
         }
         var _loc4_:Array = [];
         var _loc5_:int = _BUILDINGTOPS.numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc3_ = _BUILDINGTOPS.getChildAt(_loc5_);
            _loc6_ = _loc3_.height * 0.5;
            _loc4_.push({
               "depth":(_loc3_.y + _loc6_) * 1000 + _loc3_.x,
               "mc":_loc3_
            });
            _loc5_--;
         }
         _loc4_.sortOn("depth",Array.NUMERIC);
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_BUILDINGTOPS.getChildIndex(_loc4_[_loc5_].mc) != _loc5_)
            {
               _BUILDINGTOPS.setChildIndex(_loc4_[_loc5_].mc,_loc5_);
            }
            _loc5_++;
         }
      }
      
      private static function onMouseScroll(param1:MouseEvent) : void
      {
         GLOBAL.magnification += param1.delta * 0.05;
      }
      
      public static function KeyUp(param1:KeyboardEvent) : void
      {
      }
      
      public static function Click(param1:MouseEvent = null) : void
      {
         if(UI2._scrollMap)
         {
            _dragX = stage.mouseX - _GROUND.x;
            _dragY = stage.mouseY - _GROUND.y;
            _startX = _GROUND.x;
            _startY = _GROUND.y;
            _dragging = true;
            stage.addEventListener(MouseEvent.MOUSE_UP,Release);
         }
      }
      
      public static function Release(param1:MouseEvent) : void
      {
         _dragging = false;
         _dragged = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,Release);
      }
      
      public static function Focus(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!GLOBAL._catchup)
         {
            tx = GLOBAL._SCREEN.x - (param1 - GLOBAL._SCREEN.width / 2);
            ty = GLOBAL._SCREEN.y - (param2 - GLOBAL._SCREEN.height / 2);
            _loc3_ = GLOBAL._SCREEN.width;
            _loc4_ = GLOBAL._SCREEN.height;
            _GROUND.x = tx;
            _GROUND.y = ty;
            _instance.resizeViewRect();
         }
      }
      
      public static function FocusTo(param1:int, param2:int, param3:Number, param4:Number = 0, param5:Number = 0, param6:Boolean = true, param7:Function = null) : void
      {
         var FocusToDone:Function;
         var w:int = 0;
         var h:int = 0;
         var X:int = param1;
         var Y:int = param2;
         var time:Number = param3;
         var delay:Number = param4;
         var pause:Number = param5;
         var ease:Boolean = param6;
         var callback:Function = param7;
         if(!GLOBAL._catchup)
         {
            FocusToDone = function():void
            {
               if(!_GROUND)
               {
                  return;
               }
               tx = _GROUND.x;
               ty = _GROUND.y;
               _autoScroll = false;
               if(callback != null)
               {
                  callback();
               }
               _instance.resizeViewRect();
               BFOUNDATION.updateAllRasterData();
            };
            if(pause > 0)
            {
               UI2.Hide("top");
               UI2.Hide("bottom");
            }
            _autoScroll = true;
            tx = 0 - (X - 380);
            ty = 0 - (Y - 340);
            w = stage.stageWidth;
            h = GLOBAL.GetGameHeight();
            if(ease)
            {
               TweenLite.to(_GROUND,time,{
                  "x":tx,
                  "y":ty,
                  "ease":Cubic.easeInOut,
                  "delay":delay,
                  "onUpdate":BFOUNDATION.updateAllRasterData,
                  "onComplete":FocusToDone,
                  "overwrite":false
               });
            }
            else
            {
               TweenLite.to(_GROUND,time,{
                  "x":tx,
                  "y":ty,
                  "ease":Linear.easeNone,
                  "delay":delay,
                  "onUpdate":BFOUNDATION.updateAllRasterData,
                  "onComplete":FocusToDone,
                  "overwrite":false
               });
            }
         }
      }
      
      public static function FollowStart() : void
      {
         UI2.Hide("top");
         UI2.Hide("bottom");
         _following = true;
      }
      
      public static function FollowStop() : void
      {
         UI2.Show("top");
         UI2.Show("bottom");
         _following = false;
      }
      
      public static function Scroll(param1:Event = null) : void
      {
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         var _loc14_:MonsterBase = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(_following)
         {
            _loc13_ = CREEPS._creeps;
            tx = 0;
            ty = 0;
            for each(_loc14_ in _loc13_)
            {
               if(_loc14_._behaviour === "attack" || _loc14_._behaviour === "loot")
               {
                  _loc12_++;
                  tx += _loc14_.x;
                  ty += _loc14_.y;
               }
            }
            if(_loc12_ <= 0)
            {
               tx = _dragX;
               ty = _dragY;
               if(CREEPS._creepCount == 0)
               {
                  FollowStop();
               }
               return;
            }
            tx /= _loc12_;
            ty /= _loc12_;
            tx = 0 - tx + GLOBAL._ROOT.stage.stageWidth * 0.5;
            ty = 0 - ty + GLOBAL._ROOT.stage.stageHeight * 0.5;
            _dragX = tx;
            _dragY = ty;
            BFOUNDATION.updateAllRasterData();
         }
         else if(_dragging && UI2._scrollMap && !_autoScroll && _canScroll)
         {
            _loc15_ = stage.mouseX;
            _loc16_ = stage.mouseY;
            tx = _loc15_ - _dragX >> 0;
            ty = _loc16_ - _dragY >> 0;
            _loc17_ = _loc15_ - (_dragX + _startX);
            _loc18_ = _loc16_ - (_dragY + _startY);
            _dragDistance = Math.abs(_loc17_ * _loc17_ + _loc18_ * _loc18_);
            if(_dragDistance > 100)
            {
               _dragged = true;
               BFOUNDATION.updateAllRasterData();
            }
         }
         var _loc2_:int = GLOBAL._ROOT.stage.stageWidth;
         var _loc3_:int = GLOBAL._ROOT.stage.stageHeight;
         var _loc4_:int = -1615;
         var _loc5_:int = 2375;
         var _loc6_:int = -650;
         var _loc7_:int = 1325;
         var _loc8_:int = 670;
         var _loc9_:int = 760;
         var _loc10_:int = _loc5_ - (_loc2_ >> 1);
         var _loc11_:Number = 2;
         if(GLOBAL._zoomed)
         {
            _loc10_ = (_loc5_ - _loc2_ + _loc9_ / _loc11_) / _loc11_;
         }
         if(tx > _loc10_)
         {
            tx = _loc10_;
         }
         _loc10_ = _loc4_ + (_loc2_ >> 1);
         if(GLOBAL._zoomed)
         {
            _loc10_ = (_loc4_ + _loc2_ + _loc9_ / _loc11_) / _loc11_;
         }
         if(tx < _loc10_)
         {
            tx = _loc10_;
         }
         _loc10_ = _loc6_ + (_loc3_ >> 1);
         if(GLOBAL._zoomed)
         {
            _loc10_ = (_loc6_ + _loc3_ + _loc8_ / _loc11_) / _loc11_;
         }
         if(ty < _loc10_)
         {
            ty = _loc10_;
         }
         _loc10_ = _loc7_ - (_loc3_ >> 1);
         if(GLOBAL._zoomed)
         {
            _loc10_ = (_loc7_ - _loc3_ + _loc8_ / _loc11_) / _loc11_;
         }
         if(ty > _loc10_)
         {
            ty = _loc10_;
         }
         d = 2;
         targX = _GROUND.x;
         targY = _GROUND.y;
         if(targX < tx)
         {
            targX += tx - targX >> 1;
         }
         else if(targX > tx)
         {
            targX -= targX - tx >> 1;
         }
         if(Math.abs(targX - tx) <= 2)
         {
            targX = tx;
            --d;
         }
         if(targY < ty - 1)
         {
            targY += ty - targY >> 1;
         }
         else
         {
            targY -= targY - ty >> 1;
         }
         if(Math.abs(targY - ty) <= 2)
         {
            targY = ty;
            --d;
         }
         if(!(d == 0 || _autoScroll))
         {
            _GROUND.x = targX >> 0;
            _GROUND.y = targY >> 0;
         }
         _instance.resizeViewRect();
      }
      
      public function get canvas() : BitmapData
      {
         return _canvas;
      }
      
      public function get canvasContainer() : Bitmap
      {
         return _canvasContainer;
      }
      
      public function get offset() : Point
      {
         this._point.x = _canvasContainer.x;
         this._point.y = _canvasContainer.y;
         return this._point;
      }
      
      public function get viewRect() : Rectangle
      {
         return _viewRect;
      }
      
      public function resizeCanvas() : void
      {
         if(_inited && _canvas.width !== GLOBAL._SCREEN.width || _canvas.height !== GLOBAL._SCREEN.height)
         {
            _canvas = new BitmapData(GLOBAL._SCREEN.width,GLOBAL._SCREEN.height,true,4278255360);
            _canvasContainer.bitmapData = _canvas;
            _canvasContainer.x = GLOBAL._SCREEN.x;
            _canvasContainer.y = GLOBAL._SCREEN.y;
            this._renderer.canvas = _canvas;
         }
      }
      
      public function resizeViewRect() : void
      {
         var _loc1_:Rectangle = GLOBAL._SCREEN;
         var _loc2_:int = 32;
         var _loc3_:int = 50;
         _viewRect.width = _loc1_.width * (1 / _GROUND.scaleX) + _loc2_;
         _viewRect.height = _loc1_.height * (1 / _GROUND.scaleY) + _loc2_;
         _viewRect.x = -(_GROUND.x * (1 / _GROUND.scaleX)) - (1 / _GROUND.scaleX - 1) * _loc3_ + (MAP_WIDTH >>> 1) + _loc1_.x - _loc2_;
         _viewRect.y = -(_GROUND.y * (1 / _GROUND.scaleY)) - (1 / _GROUND.scaleY - 1) * _loc3_ + (MAP_HEIGHT >>> 1) + _loc1_.y - _loc2_;
      }
      
      private function render(param1:Event) : void
      {
         this._renderer.render();
      }
   }
}
