package com.monsters
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.CModifiableProperty;
   import com.monsters.monsters.components.MaxHealthProperty;
   import com.monsters.rendering.RasterData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GameObject extends EventDispatcher implements IAttackable, IEventDispatcher
   {
      
      protected static const k_DOES_PRINT_DETAILED_LOGGING:Boolean = true;
       
      
      public var _middle:int;
      
      private var _health:SecNum;
      
      public var _size:int;
      
      public var _mc:Sprite;
      
      public var targetableStatus:int;
      
      public var maxHealthProperty:MaxHealthProperty;
      
      public var moveSpeedProperty:CModifiableProperty;
      
      public var armorProperty:CModifiableProperty;
      
      protected var m_children:Vector.<RasterDataContainer>;
      
      protected var m_baseDepth:Number;
      
      protected var m_isCleared:Boolean;
      
      private var m_attackFlags:int;
      
      private var m_defenseFlags:int;
      
      protected var m_attackPriorityFlags:Vector.<int>;
      
      public function GameObject()
      {
         super();
         this._mc = new Sprite();
         this._health = new SecNum(0);
         this.moveSpeedProperty = new CModifiableProperty(Number.MAX_VALUE,0,1);
         this.armorProperty = new CModifiableProperty(1,0,0);
         this.maxHealthProperty = new MaxHealthProperty(this,Number.MAX_VALUE,0);
         if(BYMConfig.instance.RENDERER_ON)
         {
            this.m_children = new Vector.<RasterDataContainer>();
         }
         this.m_baseDepth = 0;
         this.m_isCleared = false;
         this.m_attackFlags = this.m_defenseFlags = 0;
         this.m_attackPriorityFlags = new Vector.<int>();
      }
      
      public function getRandomPointOnGraphic() : Point
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = this.width * 0.25;
         _loc2_ = this.height * 0.25;
         var _loc3_:Number = Math.random() * (_loc1_ * 2) - _loc1_;
         var _loc4_:Number = Math.random() * (_loc2_ * 2) - _loc2_;
         return new Point(_loc3_,_loc4_);
      }
      
      public function get isImmobile() : Boolean
      {
         return this.moveSpeed <= 0;
      }
      
      public function get isCleared() : Boolean
      {
         return this.m_isCleared;
      }
      
      public function get armor() : Number
      {
         if (!this.armorProperty) return 1;

         return this.armorProperty.value;
      }
      
      public function get moveSpeed() : Number
      {
         if (!this.moveSpeedProperty) return 0;

         return this.moveSpeedProperty.value;
      }
      
      public function get isTargetable() : Boolean
      {
         return this.targetableStatus == 0;
      }
      
      public function get defenseFlags() : int
      {
         return this.m_defenseFlags;
      }
      
      public function get attackFlags() : int
      {
         return this.m_attackFlags;
      }
      
      public function get attackPriorityFlags() : Vector.<int>
      {
         return this.m_attackPriorityFlags;
      }
      
      public function set attackFlags(param1:int) : void
      {
         this.m_attackFlags = param1;
      }
      
      public function set defenseFlags(param1:int) : void
      {
         this.m_defenseFlags = param1;
      }
      
      public function get graphic() : Sprite
      {
         return this._mc as Sprite;
      }
      
      public function get x() : Number
      {
         return this._mc.x;
      }
      
      public function get y() : Number
      {
         return this._mc.y;
      }
      
      public function get width() : Number
      {
         return this._mc.width;
      }
      
      public function get height() : Number
      {
         return this._mc.height;
      }
      
      public function get numChildren() : int
      {
         return !BYMConfig.instance.RENDERER_ON ? this.graphic.numChildren : int(this.m_children.length);
      }
      
      public function get maxHealth() : Number
      {
         if (!this.maxHealthProperty) return 0;

         return this.maxHealthProperty.value;
      }
      
      public function get health() : Number
      {
         return this._health.Get();
      }
      
      public function setHealth(param1:Number) : void
      {
         this._health.Set(param1);
      }
      
      public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         return 0;
      }
      
      public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:IBitmapDrawable = null;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return this.graphic.addChild(param1);
         }
         if(param1 is IBitmapDrawable === false && param1 is SpriteSheetAnimation === false)
         {
            return param1;
         }
         _loc2_ = MAP.instance.offset;
         _loc3_ = new Point(this._mc.x + param1.x - _loc2_.x,this._mc.y + param1.y - _loc2_.y);
         _loc4_ = param1 is SpriteSheetAnimation ? (param1 as SpriteSheetAnimation).bitmapData : param1 as IBitmapDrawable;
         this.m_children.push(new RasterDataContainer(param1,new RasterData(_loc4_,_loc3_,int.MAX_VALUE),_loc3_,0));
         return param1;
      }
      
      public function removeChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return this.graphic.removeChild(param1);
         }
         _loc2_ = int(this.m_children.length);
         while(_loc3_ < _loc2_)
         {
            if(this.m_children[_loc3_].m_source === param1)
            {
               this.m_children[_loc3_].clear();
               this.m_children.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         return param1;
      }
      
      public function getChildAt(param1:int) : Object
      {
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return this.graphic.getChildAt(param1);
         }
         return this.m_children[param1].m_source;
      }
      
      public function setChildIndex(param1:DisplayObject, param2:int) : void
      {
         var _loc3_:Vector.<RasterDataContainer> = null;
         var _loc4_:RasterDataContainer = null;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            this.graphic.setChildIndex(param1,param2);
         }
         else
         {
            _loc3_ = this.m_children;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.m_source === param1)
               {
                  _loc4_.m_depth = param2;
                  return;
               }
            }
         }
      }
      
      protected function updateRasterData() : void
      {
         var _loc5_:RasterDataContainer = null;
         var _loc6_:RasterData = null;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return;
         }
         var _loc1_:Point = MAP.instance.offset;
         var _loc2_:Function = MAP.instance.viewRect.intersects;
         var _loc3_:Rectangle = new Rectangle();
         var _loc4_:int = int(this.m_children.length);
         if(Boolean(this._mc) && Boolean(_loc4_))
         {
            _loc9_ = this._mc.height * 0.5;
            if(this._middle)
            {
               _loc9_ = this._middle;
            }
            _loc10_ = this.m_baseDepth + (this._mc.y - _loc1_.y + _loc9_) * 1000 + (this._mc.x - _loc1_.x);
            while(_loc12_ < _loc4_)
            {
               _loc6_ = (_loc5_ = this.m_children[_loc12_]).m_rasterData;
               _loc7_ = _loc5_.m_rasterPt;
               _loc8_ = _loc5_.m_depth;
               if(Boolean(_loc6_) && Boolean(_loc7_))
               {
                  _loc6_.depth = !!_loc8_ ? _loc10_ + _loc8_ : _loc10_ + _loc12_ + 1;
                  _loc7_.x = this._mc.x + _loc5_.m_source.x - _loc1_.x;
                  _loc7_.y = this._mc.y + _loc5_.m_source.y - _loc1_.y;
                  _loc3_.x = _loc7_.x;
                  _loc3_.y = _loc7_.y;
                  _loc3_.width = _loc6_.rect.width;
                  _loc3_.height = _loc6_.rect.height;
                  _loc6_.visible = _loc2_(_loc3_) && this._mc.visible;
                  _loc6_.alpha = this._mc.alpha;
               }
               _loc12_++;
            }
         }
      }
      
      public function clear() : void
      {
         var _loc1_:RasterDataContainer = null;
         for each(_loc1_ in this.m_children)
         {
            _loc1_.clear();
         }
         this.maxHealthProperty = null;
         this.moveSpeedProperty = null;
         this.armorProperty = null;
         this.m_children = null;
         this.m_isCleared = true;
      }
   }
}

import com.monsters.rendering.RasterData;
import flash.display.DisplayObject;
import flash.geom.Point;

final class RasterDataContainer
{
    
   
   public var m_source:DisplayObject;
   
   public var m_rasterData:RasterData;
   
   public var m_rasterPt:Point;
   
   public var m_depth:Number;
   
   public function RasterDataContainer(param1:DisplayObject, param2:RasterData, param3:Point, param4:Number)
   {
      super();
      this.m_source = param1;
      this.m_rasterData = param2;
      this.m_rasterPt = param3;
      this.m_depth = param4;
   }
   
   public function clear() : void
   {
      if(this.m_rasterData)
      {
         this.m_rasterData.clear();
      }
      this.m_source = null;
      this.m_rasterData = null;
      this.m_rasterPt = null;
   }
}
