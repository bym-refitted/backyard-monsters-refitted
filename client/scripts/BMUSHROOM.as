package
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.rendering.RasterData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BMUSHROOM extends BFOUNDATION
   {
       
      
      public var _mushroom:DisplayObject;
      
      public var _mushroomFrame:int;
      
      public function BMUSHROOM()
      {
         super();
      }
      
      override public function SetProps() : void
      {
         super.SetProps();
      }
      
      override public function PlaceB() : void
      {
         var _loc1_:doodad_mushroom_mc = null;
         var _loc2_:doodad_mushroom_shadow = null;
         super.PlaceB();
         _loc1_ = new doodad_mushroom_mc();
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _mc.addChild(_loc1_);
         }
         else
         {
            _rasterData[_RASTERDATA_TOP] = _rasterData[_RASTERDATA_TOP] || new RasterData(_loc1_,_rasterPt[_RASTERDATA_TOP],int.MAX_VALUE);
         }
         _loc1_.mc.gotoAndStop(this._mushroomFrame);
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc2_ = new doodad_mushroom_shadow();
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _mcBase.addChild(_loc2_);
         }
         else
         {
            _rasterData[_RASTERDATA_SHADOW] = _rasterData[_RASTERDATA_SHADOW] || new RasterData(_loc2_,_rasterPt[_RASTERDATA_SHADOW],MAP.DEPTH_SHADOW,BlendMode.MULTIPLY,true);
         }
         _loc2_.gotoAndStop(this._mushroomFrame);
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         _loc2_.blendMode = BlendMode.MULTIPLY;
         _origin = new Point(x,y);
         updateRasterData();
      }
      
      override public function Setup(param1:Object) : void
      {
         this._mushroomFrame = param1.frame;
         super.Setup(param1);
         setHealth(maxHealth);
      }
      
      override public function Export() : Object
      {
         var _loc1_:Object = super.Export();
         _loc1_.frame = this._mushroomFrame;
         return _loc1_;
      }
      
      override public function Description() : void
      {
      }
      
      override public function HasWorker() : void
      {
         if(_shake > 60 && BASE._pendingPurchase.length == 0)
         {
            _mc.x = _origin.x;
            _mc.y = _origin.y;
            _mcBase.x = _origin.x;
            _mcBase.y = _origin.y;
            MUSHROOMS.Pick(this);
            return;
         }
         if(_shake % 2 == 0)
         {
            _mc.x = _origin.x - 2 + Math.random() * 4;
            _mc.y = _origin.y - 2 + Math.random() * 4;
            _mcBase.x = _origin.x - 1 + Math.random() * 2;
            _mcBase.y = _origin.y - 1 + Math.random() * 2;
         }
         ++_shake;
         updateRasterData();
      }
      
      override public function Click(param1:MouseEvent = null) : void
      {
         if(TUTORIAL._stage >= 200 && !_picking)
         {
            super.Click(param1);
         }
      }
      
      override public function Render(param1:String = "") : void
      {
         if(GLOBAL._catchup || param1 === _renderState && _lvl.Get() == _renderLevel)
         {
            return;
         }
         updateRasterData();
         _renderState = k_STATE_DEFAULT;
         _renderLevel = _lvl.Get();
      }
      
      public function SoundGood() : void
      {
      }
      
      public function SoundBad() : void
      {
      }
   }
}
