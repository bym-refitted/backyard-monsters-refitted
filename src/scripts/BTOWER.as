package
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.maproom_manager.IMapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.pathing.PATHING;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Jars;
   import com.monsters.siege.weapons.Vacuum;
   import com.monsters.siege.weapons.VacuumHose;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Point;
   import gs.TweenLite;
   import gs.easing.Expo;
   
   public class BTOWER extends BFOUNDATION
   {
      
      private static var _targetFlyerMode:Object = {
         20:0,
         21:1,
         23:0,
         25:1,
         115:2,
         118:0,
         129:0,
         130:0,
         132:1
      };
       
      
      private var creeps:Array;
      
      private var maxDist:int;
      
      private var minDist:int;
      
      public var _frameNumber:int;
      
      public var _hasTargets:Boolean;
      
      public var _targetCreeps:Array;
      
      public var _priority:int;
      
      public var _retarget:int;
      
      public var _top:int;
      
      public var _fireTick:int = 0;
      
      public var _target:IAttackable;
      
      private var pointA:Point;
      
      private var pointB:Point;
      
      private var _radiusGraphic:Shape;
      
      protected var _jarAnimation:SpriteSheetAnimation;
      
      public var _jarHealth:SecNum;
      
      public var _targetVacuum:Boolean;
      
      protected var _maxTargets:int = 1;
      
      public function BTOWER()
      {
         super();
         this._priority = 1;
         this._retarget = 0;
         attackFlags = Targeting.getOldStyleTargets(0);
      }
      
      public static function AdjustTowerRange(param1:IMapRoomCell, param2:int) : int
      {
         if(MapRoomManager.instance.isInMapRoom2 && BASE.isOutpostMapRoom2Only && param1 && param1.cellHeight && param1.cellHeight >= 100)
         {
            return int(param1.cellHeight * param2 / GLOBAL._averageAltitude.Get());
         }
         return param2;
      }
      
      public static function GetRandomString(param1:Vector.<String>) : String
      {
         return param1[Math.floor(Math.random() * param1.length)];
      }
      
      public function Props() : void
      {
         var _loc1_:int = 0;
         if(_lvl.Get() > 0)
         {
            if(MapRoomManager.instance.isInMapRoom2 && (BASE.isOutpostMapRoom2Only || GLOBAL.mode == "wmattack"))
            {
               _loc1_ = int(GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].range);
               super._range = _loc1_;
               if(GLOBAL._currentCell)
               {
                  super._range = AdjustTowerRange(GLOBAL._currentCell,_loc1_);
               }
            }
            else
            {
               super._range = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].range;
            }
            damageProperty.value = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].damage;
            super._rate = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].rate;
            super._splash = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].splash;
            super._speed = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].speed;
         }
         else if(_lvl.Get() > GLOBAL._buildingProps[_type - 1].stats.length)
         {
            throw new Error("ILLEGAL TOWER LEVEL Type: " + _type + " Level: " + _lvl.Get());
         }
         this._fireTick = super._rate;
      }
      
      override public function Place(param1:MouseEvent = null) : void
      {
         ++GLOBAL._bTowerCount;
         GLOBAL._bTower = this;
         super.Place(param1);
      }
      
      override public function Description() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _specialDescription = KEYS.Get("bdg_tower_desc");
         super.Description();
         _upgradeDescription = "";
         if(_lvl.Get() > 0 && _lvl.Get() < _buildingProps.costs.length)
         {
            _loc1_ = _buildingProps.stats[_lvl.Get() - 1];
            _loc2_ = _buildingProps.stats[_lvl.Get()];
            _loc3_ = int(_loc1_.range);
            _loc4_ = int(_loc2_.range);
            if(BASE.isOutpost)
            {
               _loc3_ = BTOWER.AdjustTowerRange(GLOBAL._currentCell,_loc3_);
               _loc4_ = BTOWER.AdjustTowerRange(GLOBAL._currentCell,_loc4_);
            }
            if(_loc1_.range < _loc2_.range)
            {
               _upgradeDescription += KEYS.Get("bdg_tower_rangeupgrade",{
                  "v1":_loc3_,
                  "v2":_loc4_
               }) + "<br>";
            }
            if(_loc1_.damage * (40 / _loc1_.rate) < _loc2_.damage * (40 / _loc2_.rate))
            {
               _upgradeDescription += KEYS.Get("bdg_tower_damageupgrade",{
                  "v1":int(_loc1_.damage * (40 / _loc1_.rate)),
                  "v2":int(_loc2_.damage * (40 / _loc2_.rate))
               }) + "<br>";
            }
            if(_loc1_.splash < _loc2_.splash)
            {
               _upgradeDescription += KEYS.Get("bdg_tower_explosionupgrade",{
                  "v1":_loc1_.splash,
                  "v2":_loc2_.splash
               }) + "<br>";
            }
         }
      }
      
      public function get canAttack() : Boolean
      {
         return health > 0 && _countdownBuild.Get() + _countdownUpgrade.Get() + _countdownFortify.Get() == 0;
      }
      
      protected function canShootVacuumHose() : Boolean
      {
         var _loc1_:VacuumHose = Vacuum.getHose();
         if(_loc1_ && GLOBAL.QuickDistance(new Point(_loc1_.x,_loc1_.y),_position) <= _range && Boolean(_targetFlyerMode[_type]))
         {
            return true;
         }
         return false;
      }
      
      override public function TickAttack() : void
      {
         var _loc1_:VacuumHose = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:MonsterBase = null;
         if(this.canAttack)
         {
            --this._fireTick;
            if(this._fireTick <= 0)
            {
               this._fireTick += _rate * 2;
               _loc1_ = Vacuum.getHose();
               if(!this._targetVacuum && (!this._hasTargets || !this.targetInRange()))
               {
                  if(this.canShootVacuumHose())
                  {
                     this._targetVacuum = true;
                     this._fireTick = 30;
                  }
                  else
                  {
                     this._targetVacuum = false;
                     this.FindTargets(this._maxTargets,this._priority);
                     this._fireTick = 30;
                     if(CREEPS._creepCount > 150)
                     {
                        this._fireTick += CREEPS._creepCount / 15;
                     }
                  }
               }
               else
               {
                  _loc2_ = false;
                  if(this._targetVacuum)
                  {
                     if(_loc1_)
                     {
                        this.Fire(_loc1_);
                     }
                     else
                     {
                        this._targetVacuum = false;
                     }
                  }
                  else
                  {
                     _loc3_ = 0;
                     while(_loc3_ < this._targetCreeps.length)
                     {
                        if((_loc4_ = this._targetCreeps[_loc3_].creep).health > 0 && _loc4_.isTargetable && !_loc4_.invisible)
                        {
                           this.Fire(this._targetCreeps[_loc3_].creep);
                        }
                        else
                        {
                           _loc2_ = true;
                           this._targetCreeps = [];
                        }
                        _loc3_++;
                     }
                  }
                  if(Boolean(this._retarget) || _loc2_)
                  {
                     this.FindTargets(this._maxTargets,this._priority);
                     this._fireTick = 30;
                     if(CREEPS._creepCount > 150)
                     {
                        this._fireTick += CREEPS._creepCount / 15;
                     }
                     this._retarget = 0;
                  }
               }
            }
         }
         if(this._jarAnimation)
         {
            this.TickJar();
         }
      }
      
      public function targetInRange() : Boolean
      {
         var _loc1_:Point = null;
         var _loc3_:Number = NaN;
         var _loc2_:Point = GRID.FromISO(_mc.x,_mc.y);
         _loc2_.add(new Point(_footprint[0].width * 0.5,_footprint[0].height * 0.5));
         var _loc4_:int = 0;
         while(_loc4_ < this._targetCreeps.length)
         {
            _loc1_ = GRID.FromISO(this._targetCreeps[_loc4_].creep._tmpPoint.x,this._targetCreeps[_loc4_].creep._tmpPoint.y);
            _loc3_ = GLOBAL.QuickDistanceSquared(_loc2_,_loc1_);
            if(_loc3_ < this._range * this._range)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function get isJard() : Boolean
      {
         return Boolean(this._jarHealth);
      }
      
      public function ApplyJar(param1:int) : void
      {
         ++targetableStatus;
         this._jarAnimation = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(Jars.JAR_GRAPHIC) as SpriteData,Jars.JAR_GRAPHIC_FRAMES);
         this._jarAnimation.render();
         this._jarAnimation.x += -(this._jarAnimation.width * 0.5) + _middle * 0.5;
         this._jarAnimation.y += -(this._jarAnimation.height * 0.5);
         addChild(this._jarAnimation);
         if(BYMConfig.instance.RENDERER_ON)
         {
            TweenLite.from(this._jarAnimation,1,{
               "y":this._jarAnimation.y - 300,
               "ease":Expo.easeIn,
               "onUpdate":updateRasterData,
               "onComplete":this.JarLanded
            });
         }
         else
         {
            TweenLite.from(this._jarAnimation,0.6,{
               "y":this._jarAnimation.y - 300,
               "ease":Expo.easeIn,
               "onComplete":this.JarLanded
            });
         }
         SOUNDS.Play(GetRandomString(Jars.LAND_SOUNDS));
      }
      
      private function JarLanded() : void
      {
         this._jarHealth = new SecNum(Jars(SiegeWeapons.getWeapon(Jars.ID)).durability);
      }
      
      private function UpdateJar() : void
      {
         var _loc1_:Number = this._jarHealth.Get() / Jars(SiegeWeapons.getWeapon(Jars.ID)).durability;
         if(_loc1_ < 0.3)
         {
            this._jarAnimation.gotoAndStop(2);
            SOUNDS.Play(GetRandomString(Jars.CRACKING_SOUNDS));
         }
         else if(_loc1_ < 0.6)
         {
            this._jarAnimation.gotoAndStop(1);
            SOUNDS.Play(GetRandomString(Jars.CRACKING_SOUNDS));
         }
         else
         {
            this._jarAnimation.gotoAndStop(0);
         }
         this._jarAnimation.render();
      }
      
      private function TickJar() : void
      {
         if(Boolean(this._jarHealth) && this._jarHealth.Get() <= 0)
         {
            this.KillJar();
         }
         this._jarAnimation.update();
         if(this._jarAnimation.currentFrame >= this._jarAnimation.totalFrames)
         {
            this.RemoveJar();
         }
      }
      
      private function RemoveJar() : void
      {
         removeChild(this._jarAnimation);
         this._jarAnimation = null;
         --targetableStatus;
      }
      
      public function KillJar() : void
      {
         this._jarHealth = null;
         if(this._jarAnimation)
         {
            this._jarAnimation.play();
            SOUNDS.Play(GetRandomString(Jars.EXPLODE_SOUNDS));
         }
      }
      
      public function Fire(param1:IAttackable) : void
      {
         if(this._jarHealth)
         {
            this.UpdateJar();
         }
         this._target = param1;
      }
      
      override public function Update(param1:Boolean = false) : void
      {
         super.Update(param1);
      }
      
      override public function Upgraded() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Upgraded();
         this.Props();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !(BASE.isInfernoBuilding(_type) || BASE.isInfernoMainYardOrOutpost))
         {
            Brag = function(param1:MouseEvent):void
            {
               var _loc2_:String = "build-cannon.png";
               if(_type == 21)
               {
                  _loc2_ = "build-sniper.png";
               }
               if(_type == 25)
               {
                  _loc2_ = "build-lightning.png";
               }
               if(_type == 23)
               {
                  _loc2_ = "build-laser.png";
               }
               if(_type == 115)
               {
                  _loc2_ = "build-aerial.v2.png";
               }
               if(_type == 118)
               {
                  _loc2_ = "build_railgun.png";
               }
               GLOBAL.CallJS("sendFeed",["build-" + String(_buildingProps.name).toLowerCase(),KEYS.Get("pop_tupgraded_streamtitle",{
                  "v1":_lvl.Get(),
                  "v2":KEYS.Get(_buildingProps.name)
               }),KEYS.Get("pop_tupgraded_streambody"),_loc2_]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_tupgraded_title",{
               "v1":KEYS.Get(_buildingProps.name),
               "v2":_lvl.Get()
            }) + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_tupgraded_body",{"v1":KEYS.Get(_buildingProps.name)});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         this.Props();
      }
      
      public function FindTargets(param1:int, param2:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:MonsterBase = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(_targetFlyerMode[_type])
         {
            _loc9_ = int(_targetFlyerMode[_type]);
         }
         var _loc10_:int = Targeting.getOldStyleTargets(_loc9_);
         this.creeps = Targeting.getCreepsInRange(_range,_position.add(new Point(0,_footprint[0].height / 2)),_loc10_);
         this._hasTargets = false;
         if(this.creeps.length > 0)
         {
            this._targetCreeps = [];
            if(param2 == 1)
            {
               this.creeps.sortOn(["dist"],Array.NUMERIC);
            }
            else if(param2 == 2)
            {
               this.creeps.sortOn(["dist"],Array.NUMERIC | Array.DESCENDING);
            }
            else if(param2 == 3)
            {
               this.creeps.sortOn(["hp"],Array.NUMERIC | Array.DESCENDING);
            }
            else if(param2 == 4)
            {
               this.creeps.sortOn(["hp"],Array.NUMERIC);
            }
            _loc8_ = 0;
            for(_loc5_ in this.creeps)
            {
               _loc8_++;
               if(_loc8_ <= param1)
               {
                  _loc3_ = this.creeps[_loc5_];
                  _loc4_ = _loc3_.creep;
                  _loc6_ = Number(_loc3_.dist);
                  _loc7_ = _loc3_.pos;
                  this._targetCreeps.push({
                     "creep":_loc4_,
                     "dist":_loc6_,
                     "position":_loc7_
                  });
                  this._hasTargets = true;
               }
            }
         }
      }
      
      override public function RecycleC() : void
      {
         GLOBAL._bTower = null;
         --GLOBAL._bTowerCount;
         super.RecycleC();
      }
      
      override public function Cancel() : void
      {
         GLOBAL._bTower = null;
         --GLOBAL._bTowerCount;
         super.Cancel();
      }
      
      protected function Rotate() : void
      {
         var _loc1_:Point = null;
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MonsterBase = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(this._targetVacuum)
         {
            _loc1_ = GLOBAL.townHall._position;
            _loc2_ = PATHING.FromISO(new Point(_mc.x,_mc.y));
            _loc2_ = _loc2_.add(new Point(35,35));
            _loc3_ = _loc1_.x - _loc2_.x;
            _loc4_ = _loc1_.y - _loc2_.y;
            if((_loc5_ = Math.atan2(_loc4_,_loc3_) * 57.2957795) < 0)
            {
               _loc5_ = 360 + _loc5_;
            }
            _loc5_ /= 11.25;
            _animTick = int(_loc5_);
            AnimFrame();
            ++this._frameNumber;
         }
         else if(this._hasTargets)
         {
            _loc6_ = this._targetCreeps[0].creep;
            _loc7_ = PATHING.FromISO(_loc6_._tmpPoint);
            _loc8_ = (_loc8_ = PATHING.FromISO(new Point(_mc.x,_mc.y))).add(new Point(35,35));
            _loc9_ = _loc7_.x - _loc8_.x;
            _loc10_ = _loc7_.y - _loc8_.y;
            if((_loc11_ = Math.atan2(_loc10_,_loc9_) * 57.2957795) < 0)
            {
               _loc11_ = 360 + _loc11_;
            }
            _loc11_ /= 11.25;
            _animTick = int(_loc11_);
            AnimFrame();
            ++this._frameNumber;
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         ++GLOBAL._bTowerCount;
         GLOBAL._bTower = this;
         this.Props();
      }
      
      override public function Over(param1:MouseEvent) : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && _lvl.Get() > 0 && _countdownBuild.Get() == 0 && _countdownFortify.Get() == 0 && _countdownUpgrade.Get() == 0 && health > 0)
         {
            TweenLite.delayedCall(0.25,this.RangeIndicator);
         }
      }
      
      private function RangeIndicator() : void
      {
         var _loc1_:uint = 16777215;
         this._radiusGraphic = new Shape();
         this._radiusGraphic.graphics.beginFill(16777215,0.1);
         this._radiusGraphic.graphics.lineStyle(1,_loc1_,0.25);
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Point = _position.add(new Point(0,_footprint[0].height * 0.25));
         var _loc4_:Point = new Point(_range * 2.8,_range * 1.2);
         this._radiusGraphic.graphics.drawEllipse(0,0,_loc4_.x,_loc4_.y);
         this._radiusGraphic.x = -(_loc4_.x * 0.5);
         this._radiusGraphic.y = -(_loc4_.y * 0.5);
         _loc2_.addChild(this._radiusGraphic);
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         MAP._BUILDINGFOOTPRINTS.addChild(_loc2_);
         TweenLite.from(_loc2_,0.25,{
            "alpha":0.5,
            "scaleX":0.25,
            "scaleY":0,
            "delay":0,
            "ease":Expo.easeOut
         });
         TweenLite.killDelayedCallsTo(this.RangeIndicator);
      }
      
      override public function Out(param1:MouseEvent) : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && Boolean(this._radiusGraphic))
         {
            if(this._radiusGraphic.parent)
            {
               this._radiusGraphic.parent.removeChild(this._radiusGraphic);
            }
            this._radiusGraphic = null;
         }
         TweenLite.killDelayedCallsTo(this.RangeIndicator);
      }
      
      public function setTarget(param1:MonsterBase) : void
      {
         this._target = param1;
      }
   }
}
