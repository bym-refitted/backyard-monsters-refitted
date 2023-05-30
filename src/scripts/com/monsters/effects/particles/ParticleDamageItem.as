package com.monsters.effects.particles
{
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Cubic;
   
   public class ParticleDamageItem extends ParticleDamageItem_CLIP
   {
       
      
      public var _mc:com.monsters.effects.particles.ParticleDamageItem;
      
      public function ParticleDamageItem()
      {
         super();
      }
      
      public function Init(param1:Point, param2:int, param3:uint) : void
      {
         this._mc = MAP._PROJECTILES.addChild(this) as com.monsters.effects.particles.ParticleDamageItem;
         this.Fill(param2,param3);
         this.Move(param1);
      }
      
      public function Fill(param1:int, param2:uint) : void
      {
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param2 == ParticleText.TYPE_DAMAGE || param2 == ParticleText.TYPE_HEAL)
         {
            switch(param2)
            {
               case ParticleText.TYPE_DAMAGE:
                  _loc4_ = "FF0000";
                  _loc3_ = "<b>" + param1 + "</b>";
                  break;
               case ParticleText.TYPE_HEAL:
                  _loc4_ = "00ff00";
                  _loc3_ = "<b>+" + param1 * -1 + "</b>";
            }
         }
         else
         {
            _loc4_ = this.getLootColor(param2);
            _loc5_ = GLOBAL.mode;
            _loc6_ = "";
            _loc6_ = _loc5_ == "attack" || _loc5_ == "wmattack" ? "+" : "-";
            _loc3_ = "<b>" + _loc6_ + param1 + "</b>";
         }
         this._mc.tLootA.htmlText = "<font color=\"#" + _loc4_ + "\">" + _loc3_ + "</font>";
         this._mc.tLootB.htmlText = _loc3_;
      }
      
      public function getLootColor(param1:uint) : String
      {
         switch(param1)
         {
            case BRESOURCE.RESOURCE_TWIGS:
               return "723228";
            case BRESOURCE.RESOURCE_PEBBLES:
               return "999999";
            case BRESOURCE.RESOURCE_PUTTY:
               return "FF00FF";
            case BRESOURCE.RESOURCE_GOO:
               return "00FF00";
            case BRESOURCE.RESOURCE_COAL:
               return "3F3B36";
            case BRESOURCE.RESOURCE_BONE:
               return "F0E6C5";
            case BRESOURCE.RESOURCE_SULFUR:
               return "EEED71";
            case BRESOURCE.RESOURCE_MAGMA:
               return "D95300";
            default:
               return "FFFF00";
         }
      }
      
      public function Move(param1:Point) : void
      {
         this._mc.x = param1.x;
         this._mc.y = param1.y;
         this._mc.cacheAsBitmap = true;
         TweenLite.to(this._mc,0.5,{
            "y":param1.y - 25,
            "ease":Cubic.easeInOut,
            "onComplete":this.Remove
         });
      }
      
      public function Remove() : void
      {
         this._mc.x = this._mc.y = -10000;
         try
         {
            MAP._PROJECTILES.removeChild(this._mc);
         }
         catch(e:Error)
         {
         }
         ParticleText.Remove(this);
      }
   }
}
