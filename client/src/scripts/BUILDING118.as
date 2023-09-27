package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.pathing.PATHING;
   import com.monsters.siege.weapons.Vacuum;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING118 extends BTOWER
   {
       
      
      public var _animMC:MovieClip;
      
      public var _animBitmap:BitmapData;
      
      private var _gunballs:Array;
      
      private var _trail:Array;
      
      private var _spawnCount:int = 0;
      
      private var _segment:Point;
      
      private var _spot:Point;
      
      private var _fireCount:int;
      
      public function BUILDING118()
      {
         this._gunballs = [];
         this._trail = [];
         super();
         _frameNumber = 0;
         _type = 118;
         _top = 15;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         SetProps();
         this.Props();
         attackFlags = Targeting.getOldStyleTargets(-1);
      }
      
      override public function TickAttack() : void
      {
         var _loc1_:MonsterBase = null;
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super.TickAttack();
         if(_hasTargets)
         {
            _loc1_ = _targetCreeps[0].creep;
            _loc2_ = PATHING.FromISO(_loc1_._tmpPoint);
            _loc3_ = PATHING.FromISO(new Point(_mc.x,_mc.y));
            _loc3_ = _loc3_.add(new Point(35,35));
            _loc4_ = _loc2_.x - _loc3_.x;
            _loc5_ = _loc2_.y - _loc3_.y;
            if((_loc6_ = Math.atan2(_loc5_,_loc4_) * 57.2957795 + 30) < 0)
            {
               _loc6_ = 360 + _loc6_;
            }
            if(_loc6_ > 360)
            {
               _loc6_ -= 360;
            }
            _loc6_ /= 12;
            _animTick = int(_loc6_);
            this.AnimFrame();
            ++_frameNumber;
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         super.TickFast();
         if(this._gunballs.length > 0)
         {
            ++this._fireCount;
            if(this._fireCount > 10)
            {
               _loc2_ = int(this._gunballs.length);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  if(this._fireCount > 15)
                  {
                     if(Boolean(this._gunballs[0]) && Boolean(this._gunballs[0].parent))
                     {
                        MAP._PROJECTILES.removeChild(this._gunballs[0]);
                     }
                     if(Boolean(this._trail[0]) && Boolean(this._trail[0].parent))
                     {
                        MAP._PROJECTILES.removeChild(this._trail[0]);
                     }
                  }
                  else
                  {
                     _loc4_ = 1 - (this._fireCount - 10) * 0.2;
                     if(Boolean(this._gunballs[0]) && Boolean(this._gunballs[0].parent))
                     {
                        this._gunballs[_loc3_].alpha = _loc4_;
                     }
                     if(Boolean(this._trail[0]) && Boolean(this._trail[0].parent))
                     {
                        this._trail[_loc3_].alpha = _loc4_;
                     }
                  }
                  _loc3_++;
               }
            }
         }
         if(this._fireCount > 15)
         {
            this._gunballs = [];
            this._trail = [];
         }
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animLoaded && GLOBAL._render)
         {
            _animRect.x = _animRect.width * _animTick;
            _animContainerBMD.copyPixels(_animBMD,_animRect,_nullPoint);
         }
      }
      
      override public function Fire(param1:IAttackable) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         var _loc13_:* = undefined;
         super.Fire(param1);
         SOUNDS.Play("railgun1",!isJard ? 0.8 : 0.4);
         var _loc2_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc3_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc3_ = 1.25;
         }
         if(isJard)
         {
            _jarHealth.Add(-int(damage * 3 * _loc2_ * _loc3_));
            ATTACK.Damage(_mc.x,_mc.y + _top,damage * 3 * _loc2_ * _loc3_);
            if(_jarHealth.Get() <= 0)
            {
               KillJar();
            }
         }
         else
         {
            _loc4_ = new Point(_mc.x,_mc.y + _top);
            this._spot = new Point(_loc4_.x,_loc4_.y);
            if(_targetVacuum)
            {
               _loc6_ = GLOBAL.townHall._mc.x - _loc4_.x;
               _loc5_ = GLOBAL.townHall._mc.y - GLOBAL.townHall._mc.height - _loc4_.y;
               Vacuum.getHose().modifyHealth(-int(damage * 3 * _loc2_ * _loc3_));
            }
            else
            {
               _loc5_ = param1.y - _loc4_.y;
               _loc6_ = param1.x - _loc4_.x;
            }
            this._segment = new Point(Math.cos(Math.atan2(_loc5_,_loc6_)) * 32,Math.sin(Math.atan2(_loc5_,_loc6_)) * 32);
            while(this._gunballs.length > 0)
            {
               if(Boolean(this._gunballs[0]) && Boolean(this._gunballs[0].parent))
               {
                  MAP._PROJECTILES.removeChild(this._gunballs[0]);
               }
               if(Boolean(this._trail[0]) && Boolean(this._trail[0].parent))
               {
                  MAP._PROJECTILES.removeChild(this._trail[0]);
               }
               this._gunballs.shift();
               this._trail.shift();
            }
            this._spawnCount = 0;
            this._fireCount = 0;
            _loc7_ = 0;
            while(_loc7_ < 50)
            {
               this._gunballs[_loc7_] = new RAILGUNPROJECTILE_CLIP();
               this._gunballs[_loc7_].x = this._spot.x + this._segment.x;
               this._gunballs[_loc7_].y = this._spot.y + this._segment.y;
               this._trail[_loc7_] = new Shape();
               this._trail[_loc7_].graphics.lineStyle(1,16777215,1);
               this._trail[_loc7_].graphics.moveTo(this._spot.x,this._spot.y);
               this._trail[_loc7_].graphics.lineTo(this._spot.x + this._segment.x,this._spot.y + this._segment.y);
               this._trail[_loc7_].filters = [new GlowFilter(35003,1,5 + Math.random() * 2,5 + Math.random() * 2,4,1,false,false)];
               this._spot = this._spot.add(this._segment);
               MAP._PROJECTILES.addChild(this._trail[_loc7_]);
               MAP._PROJECTILES.addChild(this._gunballs[_loc7_]);
               ++this._spawnCount;
               _loc7_++;
            }
            if(!_targetVacuum)
            {
               _loc9_ = int((_loc8_ = Targeting.getCreepsInRange(1600,_loc4_,attackFlags)).length);
               _loc10_ = 0;
               _loc11_ = _loc4_.add(new Point(this._segment.x * 50,this._segment.y * 50));
               _loc12_ = 0;
               while(_loc12_ < _loc9_)
               {
                  _loc13_ = _loc8_[_loc12_].creep;
                  if(this.lineIntersectCircle(_loc4_,_loc11_,_loc13_._tmpPoint))
                  {
                     _loc10_ += damage * _loc3_ * _loc2_ * _loc13_._damageMult;
                     _loc13_.modifyHealth(-(damage * _loc3_ * _loc2_ * _loc13_._damageMult));
                  }
                  _loc12_++;
               }
            }
            ATTACK.Damage(_mc.x,_mc.y + _top,_loc10_);
         }
      }
      
      private function lineIntersectCircle(param1:Point, param2:Point, param3:Point, param4:Number = 20) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc5_:Number = (param2.x - param1.x) * (param2.x - param1.x) + (param2.y - param1.y) * (param2.y - param1.y);
         var _loc6_:Number = 2 * ((param2.x - param1.x) * (param1.x - param3.x) + (param2.y - param1.y) * (param1.y - param3.y));
         var _loc7_:Number = param3.x * param3.x + param3.y * param3.y + param1.x * param1.x + param1.y * param1.y - 2 * (param3.x * param1.x + param3.y * param1.y) - param4 * param4;
         var _loc8_:Number;
         if((_loc8_ = _loc6_ * _loc6_ - 4 * _loc5_ * _loc7_) <= 0)
         {
            return false;
         }
         _loc9_ = Math.sqrt(_loc8_);
         _loc10_ = (-_loc6_ + _loc9_) / (2 * _loc5_);
         _loc11_ = (-_loc6_ - _loc9_) / (2 * _loc5_);
         if((_loc10_ < 0 || _loc10_ > 1) && (_loc11_ < 0 || _loc11_ > 1))
         {
            return false;
         }
         return true;
      }
      
      override public function Props() : void
      {
         super.Props();
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         super.Destroyed(param1);
         while(this._gunballs.length > 0)
         {
            if(Boolean(this._gunballs[0]) && Boolean(this._gunballs[0].parent))
            {
               MAP._PROJECTILES.removeChild(this._gunballs[0]);
            }
            if(Boolean(this._trail[0]) && Boolean(this._trail[0].parent))
            {
               MAP._PROJECTILES.removeChild(this._trail[0]);
            }
            this._gunballs.shift();
            this._trail.shift();
         }
         this._spawnCount = 0;
         this._fireCount = 0;
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-wmb",KEYS.Get("pop_railgunbuilt_streamtitle"),KEYS.Get("pop_railgunbuilt_streambody"),"build_railgun.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_railgunbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_railgunbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
   }
}
