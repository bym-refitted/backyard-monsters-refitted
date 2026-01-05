package com.monsters.monsters.components.statusEffects
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import com.monsters.rendering.RasterData;
   import flash.geom.Point;
   
   public class CStatusEffect extends Component
   {
      
      protected static const _MAGIC_PADDING:int = 5;
      
      protected static const _MAX_TICKS:int = 40;
       
      
      protected var _icon:SpriteSheetAnimation;
      
      protected var _rasterData:RasterData;
      
      protected var _rasterPt:Point;
      
      protected var _priority:int = 0;
      
      protected var _dps:Number;
      
      protected var _target:MonsterBase;
      
      protected var _curLife:int;
      
      protected var _curTick:int;
      
      public function CStatusEffect(param1:MonsterBase)
      {
         super();
         this._target = param1;
      }
      
      public function get icon() : SpriteSheetAnimation
      {
         return this._icon;
      }
      
      override protected function onRegister() : void
      {
         this._target.addChild(this._icon);
         if(BYMConfig.instance.RENDERER_ON)
         {
            this._rasterPt = new Point();
            this._rasterData = new RasterData(this._icon.bitmapData,this._rasterPt,int.MAX_VALUE);
         }
         this._priority = -1;
         var _loc1_:int = 0;
         while(_loc1_ < this._target._components.length)
         {
            if(this._target._components[_loc1_] is CStatusEffect)
            {
               ++this._priority;
            }
            _loc1_++;
         }
      }
      
      override protected function onUnregister() : void
      {
         this._target.removeChild(this._icon);
         this.destoy();
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(this._target.health <= 0)
         {
            owner.removeComponent(this);
            return;
         }
         this._curTick += param1;
         if(this._curTick >= _MAX_TICKS)
         {
            this._curTick -= _MAX_TICKS;
            this.updateDPS(param1);
         }
         this.updatePosition();
         if(this._icon)
         {
            this._icon.update();
         }
      }
      
      protected function updatePosition() : void
      {
         this._icon.x = -this._icon.width / 2;
         if(this._priority % 2)
         {
            this._icon.x += int(this._priority / 2 + 1) * (this._icon.width + _MAGIC_PADDING);
         }
         else
         {
            this._icon.x -= this._priority / 2 * (this._icon.width + _MAGIC_PADDING);
         }
         this._icon.y = this._target._graphicMC.y - this._icon.height;
         if(BYMConfig.instance.RENDERER_ON)
         {
            this._rasterPt.x = this._target.rasterPt.x + (this._target._graphicMC.width >> 1) + this._icon.x;
            this._rasterPt.y = this._target.rasterPt.y - this._icon.height;
         }
      }
      
      public function renew() : void
      {
         this._curLife = 0;
      }
      
      protected function updateDPS(param1:int) : void
      {
         this._target.modifyHealth(-this._dps);
      }
      
      public function setDPS(param1:Number) : void
      {
         this._dps = param1;
      }
      
      override public function destoy() : void
      {
         this._icon = null;
         if(this._rasterData)
         {
            this._rasterData.clear();
         }
         this._rasterData = null;
         this._rasterPt = null;
         this._target = null;
      }
   }
}
