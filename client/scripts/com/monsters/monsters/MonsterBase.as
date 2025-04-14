package com.monsters.monsters
{
   import com.cc.utils.SecNum;
   import com.monsters.GameObject;
   import com.monsters.configs.BYMConfig;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ILootable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.monsters.components.CModifiableProperty;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.IAttackingComponent;
   import com.monsters.monsters.components.IDefendingComponent;
   import com.monsters.monsters.components.modifiers.BeastMode;
   import com.monsters.monsters.components.modifiers.HyperSpeed;
   import com.monsters.monsters.components.modifiers.MonsterDust;
   import com.monsters.monsters.components.statusEffects.CStatusEffect;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import gs.TweenLite;
   import gs.easing.Bounce;
   import gs.easing.Sine;
   
   public class MonsterBase extends GameObject implements IAttackable, IComponentOwner
   {
      
      public static const k_sBHVR_ATTACK:String = "attack";
      
      public static const k_sBHVR_RETREAT:String = "retreat";
      
      public static const k_sBHVR_JUICE:String = "juice";
      
      public static const k_sBHVR_HOUSING:String = "housing";
      
      public static const k_sBHVR_PEN:String = "pen";
      
      public static const k_sBHVR_DEFEND:String = "defend";
      
      public static const k_sBHVR_FEED:String = "feed";
      
      public static const k_sBHVR_JUMP:String = "jump";
      
      public static const k_sBHVR_DECOY:String = "decoy";
      
      public static const k_sBHVR_BUNKER:String = "bunker";
      
      public static const k_sBHVR_HEAL:String = "heal";
      
      public static const k_sBHVR_WANDER:String = "wander";
      
      public static const k_sBHVR_BOUNCE:String = "bounce";
      
      public static const k_sBHVR_HUNT:String = "hunt";
      
      public static const k_sBHVR_BUFF:String = "buff";
      
      public static const k_DEATH_EVENT:String = "deathTime";
      
      public static const k_LOOT_PROPERTY:String = "lootProperty";
      
      public static const k_DAMAGE_PROPERTY:String = "damageProperty";
      
      public static const k_ARMOR_PROPERTY:String = "armorProperty";
      
      public static const k_ATTACK_DELAY_PROPERTY:String = "attackDelayProperty";
      
      public static const k_MOVE_SPEED_PROPERTY:String = "moveSpeedProperty";
       
      
      public var spriteAction:String = "walking";
      
      public var aggroRange:Number = 50;
      
      public var _components:Vector.<Component>;
      
      public var _attackComponents:Vector.<Component>;
      
      public var _frameNumber:int;
      
      public var _spawned:Boolean;
      
      public var _creatureID:String;
      
      public var _graphic:BitmapData;
      
      public var _visible:Boolean = true;
      
      public var _clicked:Boolean = false;
      
      public var _looking:Boolean = false;
      
      public var _glow:GlowFilter = null;
      
      public var _speed:Number;
      
      public var _goo:int;
      
      public var _damageMult:Number = 1;
      
      protected var m_range:Number = 1;
      
      public var _damagePerSecond:SecNum;
      
      public var _targetRotation:Number;
      
      public var _targetPosition:Point;
      
      public var _targetCenter:Point;
      
      public var _waypoints:Array;
      
      protected var _pathID:int = 0;
      
      protected var _jumping:Boolean = false;
      
      protected var _jumpingUp:Boolean = false;
      
      protected const _noDefensePath:Boolean = false;
      
      protected var _doDefenseBurrow:Boolean = true;
      
      protected var m_rotation:Number = 0;
      
      protected var m_state:int;
      
      public var _behaviour:String;
      
      public var _hasTarget:Boolean;
      
      public var _hasPath:Boolean;
      
      public var _attacking:Boolean;
      
      public var _intercepting:Boolean;
      
      public var _targetBuilding:BFOUNDATION;
      
      public var _homeBunker:*;
      
      public var _targetCreeps:Array;
      
      public var _targetCreep:MonsterBase;
      
      public var _id:String;
      
      public var _friendly:Boolean;
      
      public var _house:BFOUNDATION;
      
      public var _hits:int;
      
      public var _spawnPoint:Point;
      
      public var _lastRotation:int = 400;
      
      public var _targetGroup:int;
      
      public var targetMode:int;
      
      public var _explode:int = 0;
      
      public var _goeasy:Boolean = false;
      
      public var _hitLimit:int = 50;
      
      public var _tmpPoint:Point;
      
      public var _spawnTime:int;
      
      public var _atTarget:Boolean = false;
      
      public var _xd:Number = 0;
      
      public var _yd:Number = 0;
      
      public var _shadow:BitmapData;
      
      public var _shadowMC:DisplayObject;
      
      public var attackCooldown:int;
      
      protected var frameCount:int;
      
      protected var shocking:Boolean;
      
      protected var node:String;
      
      protected var newNode:String;
      
      public var _phase:Number = 0;
      
      public var _movement:String = "";
      
      public var _pathing:String = "";
      
      public var isDisposable:Boolean;
      
      public var _enraged:Number = 0;
      
      private var m_isInvisible:Boolean = false;
      
      public var _graphicMC:Bitmap;
      
      public var _altitude:int = 0;
      
      protected var _currentSkinOverride:String;
      
      protected var _rasterData:RasterData;
      
      protected var _rasterPt:Point;
      
      protected var _shadowData:RasterData;
      
      protected var _shadowPt:Point;
      
      protected var _dying:Boolean = false;
      
      protected var _dead:Boolean = false;
      
      protected var m_juiceReady:Boolean = false;
      
      public var attackDelayProperty:CModifiableProperty;
      
      public var damageProperty:CModifiableProperty;
      
      protected var m_filters:Array;
      
      public function MonsterBase()
      {
         this._components = new Vector.<Component>();
         this._attackComponents = new Vector.<Component>();
         this._damagePerSecond = new SecNum(0);
         this._tmpPoint = new Point(0,0);
         super();
         this._id = GLOBAL.NextCreepID().toString();
         this._rasterPt = new Point();
         this._shadowPt = new Point();
         this.m_filters = [];
         this.m_rotation = 0;
         this.addComponent(new CModifiableProperty(Number.MAX_VALUE,0,0.5),k_LOOT_PROPERTY);
         this.damageProperty = new CModifiableProperty();
         this.addComponent(this.damageProperty,k_DAMAGE_PROPERTY);
         this.attackDelayProperty = new CModifiableProperty(Number.MAX_VALUE,0);
         this.addComponent(this.attackDelayProperty,k_ATTACK_DELAY_PROPERTY);
         this.node = Targeting.CreepCellAdd(this._tmpPoint,this._id,this);
      }
      
      public function set currentSkinOverride(param1:String) : void
      {
         this._currentSkinOverride = param1;
      }
      
      public function getStatsString() : String
      {
         var _loc1_:String = "";
         _loc1_ += this._creatureID + "(" + this + ")\n";
         _loc1_ += "damage: " + this.damage + "\n";
         _loc1_ += "attack delay: " + this.attackDelay + "\n";
         _loc1_ += "move speed: " + moveSpeed + "\n";
         _loc1_ += "armor: " + (1 - armor) + "(doesnt reflect STORE armor)" + "\n";
         _loc1_ += "health: " + health + "\n";
         _loc1_ += "max health: " + maxHealth + "\n";
         return _loc1_ + ("loot bonus: " + this.lootingMultiplier + "\n");
      }
      
      public function get isRanged() : Boolean
      {
         return this.range > 1;
      }
      
      public function getDisplayY() : Number
      {
         return y - this._altitude;
      }
      
      protected function setInitialFriendlyFlags(param1:Boolean) : void
      {
         if(param1)
         {
            attackFlags = Targeting.k_TARGETS_ATTACKERS;
            defenseFlags = Targeting.k_TARGETS_DEFENDERS;
         }
         else
         {
            attackFlags = Targeting.k_TARGETS_DEFENDERS;
            defenseFlags = Targeting.k_TARGETS_ATTACKERS;
         }
      }
      
      override public function get width() : Number
      {
         return this._graphicMC.width;
      }
      
      override public function get height() : Number
      {
         return this._graphicMC.height;
      }
      
      public function get damage() : Number
      {
         return this.damageProperty.value;
      }
      
      public function get attackDelay() : Number
      {
         return this.attackDelayProperty.value;
      }
      
      public function get dying() : Boolean
      {
         return this._dying;
      }
      
      public function get dead() : Boolean
      {
         return this._dead;
      }
      
      public function get juiceReady() : Boolean
      {
         return this.m_juiceReady;
      }
      
      public function get rasterPt() : Point
      {
         return this._rasterPt;
      }
      
      public function get invisible() : Boolean
      {
         return this.m_isInvisible;
      }
      
      public function set invisible(param1:Boolean) : void
      {
         this.m_isInvisible = param1;
         if(this.m_isInvisible)
         {
            defenseFlags |= Targeting.k_TARGETS_INVISIBLE;
         }
         else
         {
            defenseFlags &= ~Targeting.k_TARGETS_INVISIBLE;
         }
      }
      
      public function get inBattleState() : Boolean
      {
         return this._behaviour == k_sBHVR_BUFF || this._behaviour == k_sBHVR_ATTACK || this._behaviour == k_sBHVR_DEFEND || this._behaviour == k_sBHVR_BUNKER || this._behaviour == k_sBHVR_HEAL || this._behaviour == k_sBHVR_BOUNCE || this._behaviour == k_sBHVR_HUNT;
      }
      
      public function get lootingMultiplier() : Number
      {
         return CModifiableProperty(this.getComponentByName(k_LOOT_PROPERTY)).value;
      }
      
      protected function rangedAttack(param1:ITargetable) : ITargetable
      {
         return null;
      }
      
      override public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         var _loc6_:Component = null;
         if(!health)
         {
            return 0;
         }
         var _loc3_:Number = param1;
         var _loc4_:int = 0;
         while(_loc4_ < this._components.length)
         {
            if((_loc6_ = this._components[_loc4_]) is IDefendingComponent)
            {
               param1 = IDefendingComponent(_loc6_).onDefend(this,param1,param2);
            }
            _loc4_++;
         }
         var _loc5_:Number;
         if((_loc5_ = param1 + health) == health)
         {
            return 0;
         }
         if(param1 < 0)
         {
            param1 *= !!armor ? 1 - armor : 1;
            this.damaged(param1);
         }
         else
         {
            if(_loc5_ >= maxHealth)
            {
               if(this._graphic)
               {
                  this._graphic.fillRect(this._graphic.rect,0);
               }
               param1 = maxHealth - health;
            }
            this.healed(param1);
         }
         if(k_DOES_PRINT_DETAILED_LOGGING)
         {
            param1 = Math.round(param1);
            _loc3_ = Math.round(_loc3_);
            print(this + " was modified for " + param1 + (!!(_loc3_ - param1) ? "(" + _loc3_ + " - " + (_loc3_ - param1) + ")" : "") + " health points, left with " + health + " out of " + maxHealth + "hp");
         }
         ATTACK.damage(-param1,this,param1 < 0 ? param1 - _loc3_ : 0);
         setHealth(health + param1);
         return param1;
      }
      
      protected function healed(param1:Number) : void
      {
      }
      
      protected function damaged(param1:Number) : void
      {
      }
      
      public function addStatusEffect(param1:CStatusEffect) : void
      {
         var _loc2_:CStatusEffect = this.getComponentByType(Object(param1).constructor) as CStatusEffect;
         if(_loc2_)
         {
            _loc2_.renew();
         }
         else
         {
            this.addComponent(param1);
         }
      }
      
      public function removeStatusEffect(param1:Class) : Boolean
      {
         var _loc2_:CStatusEffect = this.getComponentByType(param1) as CStatusEffect;
         if(_loc2_)
         {
            this.removeComponent(_loc2_);
            return true;
         }
         return false;
      }
      
      public function addComponent(param1:Component, param2:String = "", param3:uint = 0) : void
      {
         var _loc4_:int = -1;
         var _loc5_:Vector.<Component> = this.getComponentList(param1);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc5_[_loc6_].priority < param3)
            {
               _loc4_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         if(_loc4_ < 0 || _loc4_ >= _loc5_.length)
         {
            _loc5_.push(param1);
         }
         else
         {
            _loc5_.splice(_loc4_,0,param1);
         }
         param1.register(this,param2);
      }
      
      public function removeComponent(param1:Component) : void
      {
         var _loc2_:Vector.<Component> = this.getComponentList(param1);
         param1.unregister();
         _loc2_.splice(_loc2_.indexOf(param1),1);
      }
      
      public function getComponent(param1:Component) : Component
      {
         var _loc2_:Vector.<Component> = this.getComponentList(param1);
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ >= 0)
         {
            return _loc2_[_loc3_];
         }
         return null;
      }
      
      public function getComponentByType(param1:Class) : Component
      {
         var _loc2_:Component = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._components.length)
         {
            _loc2_ = this._components[_loc3_];
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._attackComponents.length)
         {
            _loc2_ = this._attackComponents[_loc3_];
            if(_loc2_ is param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getComponentByName(param1:String) : Component
      {
         var _loc2_:Component = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._components.length)
         {
            _loc2_ = this._components[_loc3_];
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._attackComponents.length)
         {
            _loc2_ = this._attackComponents[_loc3_];
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function getComponentList(param1:Component) : Vector.<Component>
      {
         if(param1 is IAttackingComponent)
         {
            return this._attackComponents;
         }
         return this._components;
      }
      
      public function tick(param1:int = 1) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this._dead)
         {
            return true;
         }
         var _loc3_:int = int(this._components.length - 1);
         while(_loc3_ >= 0)
         {
            this._components[_loc3_].tick(param1);
            _loc3_--;
         }
         _loc3_ = int(this._attackComponents.length - 1);
         while(_loc3_ >= 0)
         {
            this._attackComponents[_loc3_].tick(param1);
            _loc3_--;
         }
         _loc2_ = this.tickState(param1);
         this.move();
         this.render();
         return _loc2_;
      }
      
      public function changeState(param1:int) : Boolean
      {
         this.m_state = param1;
         return true;
      }
      
      public function getState() : int
      {
         return this.m_state;
      }
      
      public function get state() : int
      {
         return this.m_state;
      }
      
      protected function tickState(param1:int = 1) : Boolean
      {
         this._frameNumber += 1;
         if(Boolean(graphic) && graphic.filters.length > 0)
         {
            if(this._friendly)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  if(GLOBAL._playerMonsterOverdrive && GLOBAL._playerMonsterOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._playerMonsterDefenseOverdrive && GLOBAL._playerMonsterDefenseOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._playerMonsterSpeedOverdrive && GLOBAL._playerMonsterSpeedOverdrive.Get() < GLOBAL.Timestamp())
                  {
                     this.updateBuffs();
                  }
               }
               if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
               {
                  if(GLOBAL._monsterOverdrive && GLOBAL._monsterOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._monsterDefenseOverdrive && GLOBAL._monsterDefenseOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._monsterSpeedOverdrive && GLOBAL._monsterSpeedOverdrive.Get() < GLOBAL.Timestamp())
                  {
                     this.updateBuffs();
                  }
               }
            }
            else if(GLOBAL._attackerMonsterOverdrive && GLOBAL._attackerMonsterOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._attackerMonsterDefenseOverdrive && GLOBAL._attackerMonsterDefenseOverdrive.Get() < GLOBAL.Timestamp() || GLOBAL._attackerMonsterSpeedOverdrive && GLOBAL._attackerMonsterSpeedOverdrive.Get() < GLOBAL.Timestamp())
            {
               this.updateBuffs();
            }
         }
         return true;
      }
      
      protected function move() : void
      {
      }
      
      protected function render() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!GLOBAL._catchup)
         {
            this._targetRotation = Math.atan2(this._yd,this._xd) * 57.2957795 - 90;
            _loc1_ = this.m_rotation - this._targetRotation;
            if(_loc1_ > 180)
            {
               this._targetRotation += 360;
            }
            else if(_loc1_ < -180)
            {
               this._targetRotation -= 360;
            }
            this._targetRotation += 90;
            this.m_rotation = this._targetRotation;
            while(this.m_rotation < 0)
            {
               this.m_rotation += 360;
            }
            this.m_rotation %= 360;
            if(x != int(this._tmpPoint.x) || y != int(this._tmpPoint.y))
            {
               graphic.x = int(this._tmpPoint.x);
               graphic.y = int(this._tmpPoint.y);
            }
            if(this._graphic)
            {
               this._graphic.lock();
            }
            if(this._shadow)
            {
               this._shadow.lock();
            }
            _loc3_ = 0;
            if(this._movement == "burrow" && (this._behaviour === k_sBHVR_ATTACK || this._behaviour === k_sBHVR_DEFEND))
            {
               this.renderBurrow();
            }
            else
            {
               this._visible = true;
               if(BYMConfig.instance.RENDERER_ON)
               {
                  this._rasterData.visible = true;
               }
               if(!graphic.alpha)
               {
                  graphic.alpha = 1;
               }
            }
            this.getNextSprite();
            this._lastRotation = int(this.m_rotation / 12);
            if(health < maxHealth)
            {
               _loc4_ = 11 - int(11 / maxHealth * health);
               this._graphic.copyPixels(CREEPS._bmdHPbar,new Rectangle(0,5 * _loc4_,17,5),new Point(-this._graphicMC.x - CREEPS._bmdHPbar.width / 2,6));
            }
            if(this._graphic)
            {
               this._graphic.unlock();
            }
            if(this._shadow)
            {
               this._shadow.unlock();
            }
            this.updateRasterData();
         }
      }
      
      protected function getNextSprite() : void
      {
      }
      
      protected function renderBurrow() : void
      {
         if(this._speed > 0 && (this._behaviour === k_sBHVR_ATTACK || this._doDefenseBurrow))
         {
            if(this._phase != 1)
            {
               this._phase = 1;
               if(graphic.alpha)
               {
                  graphic.alpha = 0;
               }
               this.invisible = true;
               this._visible = false;
               if(BYMConfig.instance.RENDERER_ON)
               {
                  this._rasterData.visible = false;
               }
               EFFECTS.Dig(x,y);
               SOUNDS.Play("dig",0.5);
            }
            else if(this._frameNumber % 5 == 0)
            {
               EFFECTS.Burrow(x,y);
            }
         }
         else if(this._phase == 1)
         {
            this._phase = 0;
            this.jump();
            if(!graphic.alpha)
            {
               graphic.alpha = 1;
            }
            this.invisible = false;
            this._visible = true;
            if(BYMConfig.instance.RENDERER_ON)
            {
               this._rasterData.visible = true;
            }
            if(this._behaviour == k_sBHVR_ATTACK || this._doDefenseBurrow)
            {
               EFFECTS.Dig(x,y);
            }
            SOUNDS.Play("arise",0.5);
         }
      }
      
      public function jump() : void
      {
         var Land:Function = null;
         Land = function():void
         {
            TweenLite.to(_graphicMC,0.6,{
               "y":_graphicMC.y + 15,
               "ease":Bounce.easeOut
            });
         };
         TweenLite.to(this._graphicMC,0.3,{
            "y":this._graphicMC.y - 15,
            "ease":Sine.easeIn,
            "onComplete":Land
         });
      }
      
      protected function hackCheck() : Boolean
      {
         return true;
      }
      
      override protected function updateRasterData() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return;
         }
         var _loc1_:Point = MAP.instance.offset;
         if(Boolean(this._graphicMC) && Boolean(this._rasterData))
         {
            _loc2_ = graphic.height * 0.5;
            if(_middle)
            {
               _loc2_ = _middle;
            }
            this._rasterPt.x = x + this._graphicMC.x - _loc1_.x;
            this._rasterPt.y = y + this._graphicMC.y - _loc1_.y;
            this._rasterData.depth = Math.max(MAP.DEPTH_SHADOW + 1,(y + this._altitude - _loc1_.y + _loc2_) * 1000 + x - _loc1_.x);
            if(Boolean(this._graphicMC.filters.length) && this._rasterData.data !== this._graphicMC)
            {
               this._rasterData.data = this._graphicMC;
            }
            else if(!this._graphicMC.filters.length && this._rasterData.data !== this._graphic)
            {
               this._rasterData.data = this._graphic;
            }
         }
         if(this._shadowMC)
         {
            this._shadowPt.x = x + this._shadowMC.x - _loc1_.x;
            this._shadowPt.y = y + this._shadowMC.y - _loc1_.y;
         }
         super.updateRasterData();
      }
      
      protected function changeMode() : void
      {
         this._hasTarget = false;
         this._atTarget = false;
         this._hasPath = false;
      }
      
      public function changeModeJuice() : void
      {
      }
      
      public function changeModeAttack() : void
      {
         if(this._behaviour === k_sBHVR_RETREAT)
         {
            return;
         }
         this._behaviour = k_sBHVR_ATTACK;
         this.changeMode();
         this.findTarget(this._targetGroup);
      }
      
      public function changeModeRetreat() : void
      {
         this._behaviour = k_sBHVR_RETREAT;
         this.changeMode();
         this._attacking = false;
         if(this._movement == "burrow")
         {
            EFFECTS.Dig(x,y);
            SOUNDS.Play("dig");
         }
         this.WaypointTo(this._spawnPoint);
      }
      
      public function changeModeFeed() : void
      {
         this._behaviour = k_sBHVR_FEED;
         this.changeMode();
         this._targetBuilding = GLOBAL._bCage;
         this.WaypointTo(CREATURES._guardian._tmpPoint,null);
      }
      
      public function changeModeHousing() : void
      {
         this._behaviour = k_sBHVR_HOUSING;
         this.changeMode();
         var _loc1_:Point = GRID.ToISO(this._targetCenter.x + Math.random() * 100 + 30,this._targetCenter.y + Math.random() * 60 + 30,0);
         PATHING.GetPath(this._tmpPoint,new Rectangle(_loc1_.x,_loc1_.y,10,10),this.setWaypoints,true);
      }
      
      public function addFilter(param1:BitmapFilter) : void
      {
         if(this.m_filters.indexOf(param1) == -1)
         {
            this.m_filters.push(param1);
            this._graphicMC.filters = this.m_filters;
         }
      }
      
      public function removeFilter(param1:BitmapFilter) : void
      {
         var _loc2_:int = this.m_filters.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.m_filters.splice(_loc2_,1);
            this._graphicMC.filters = this.m_filters;
         }
      }
      
      public function updateBuffs() : void
      {
         var _loc1_:Number = 0;
         if(this._friendly)
         {
            if(Boolean(GLOBAL._monsterOverdrive) && GLOBAL._monsterOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!this.damageProperty.getModifier(MonsterDust.k_damageModifier))
               {
                  this.damageProperty.addModifier(MonsterDust.k_damageModifier);
               }
               _loc1_ |= MonsterDust.k_color;
            }
            if(Boolean(GLOBAL._monsterDefenseOverdrive) && GLOBAL._monsterDefenseOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!armorProperty.getModifier(BeastMode.k_armorModifier))
               {
                  armorProperty.addModifier(BeastMode.k_armorModifier);
               }
               _loc1_ |= BeastMode.k_color;
            }
            if(Boolean(GLOBAL._monsterSpeedOverdrive) && GLOBAL._monsterSpeedOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!moveSpeedProperty.getModifier(HyperSpeed.k_moveSpeedModifier))
               {
                  moveSpeedProperty.addModifier(HyperSpeed.k_moveSpeedModifier);
               }
               if(!this.attackDelayProperty.getModifier(HyperSpeed.k_attackSpeedModifier))
               {
                  this.attackDelayProperty.addModifier(HyperSpeed.k_attackSpeedModifier);
               }
               _loc1_ |= HyperSpeed.k_color;
            }
         }
         else
         {
            if(Boolean(GLOBAL._attackerMonsterOverdrive) && GLOBAL._attackerMonsterOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!this.damageProperty.getModifier(MonsterDust.k_damageModifier))
               {
                  this.damageProperty.addModifier(MonsterDust.k_damageModifier);
               }
               _loc1_ |= MonsterDust.k_color;
            }
            if(Boolean(GLOBAL._attackerMonsterDefenseOverdrive) && GLOBAL._attackerMonsterDefenseOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!armorProperty.getModifier(BeastMode.k_armorModifier))
               {
                  armorProperty.addModifier(BeastMode.k_armorModifier);
               }
               _loc1_ |= BeastMode.k_color;
            }
            if(Boolean(GLOBAL._attackerMonsterSpeedOverdrive) && GLOBAL._attackerMonsterSpeedOverdrive.Get() >= GLOBAL.Timestamp())
            {
               if(!moveSpeedProperty.getModifier(HyperSpeed.k_moveSpeedModifier))
               {
                  moveSpeedProperty.addModifier(HyperSpeed.k_moveSpeedModifier);
               }
               if(!this.attackDelayProperty.getModifier(HyperSpeed.k_attackSpeedModifier))
               {
                  this.attackDelayProperty.addModifier(HyperSpeed.k_attackSpeedModifier);
               }
               _loc1_ |= HyperSpeed.k_color;
            }
         }
         if(_loc1_ != 0)
         {
            if(this._glow)
            {
               this._glow.color = _loc1_;
            }
            else
            {
               this._glow = new GlowFilter(_loc1_,1,7,7,6,1);
               this.addFilter(this._glow);
            }
         }
         else if(this._glow)
         {
            this.removeFilter(this._glow);
            this._glow = null;
         }
      }
      
      public function poweredUp() : Boolean
      {
         if(this.isDisposable)
         {
            return false;
         }
         if(!this._friendly)
         {
            if(GLOBAL._wmCreaturePowerups[this._creatureID])
            {
               if(GLOBAL._wmCreaturePowerups[this._creatureID])
               {
                  return true;
               }
            }
            else if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.attackingPlayer.m_upgrades[this._creatureID] && Boolean(GLOBAL.attackingPlayer.m_upgrades[this._creatureID].powerup))
            {
               return true;
            }
         }
         else if(Boolean(GLOBAL.player.m_upgrades[this._creatureID]) && Boolean(GLOBAL.player.m_upgrades[this._creatureID].powerup))
         {
            return true;
         }
         return false;
      }
      
      public function powerUpLevel() : int
      {
         if(!this.poweredUp())
         {
            return 0;
         }
         if(!this._friendly)
         {
            if(GLOBAL._wmCreaturePowerups[this._creatureID])
            {
               if(GLOBAL._wmCreaturePowerups[this._creatureID])
               {
                  return GLOBAL._wmCreaturePowerups[this._creatureID];
               }
            }
            else if(GLOBAL.attackingPlayer.m_upgrades[this._creatureID].powerup)
            {
               return GLOBAL.attackingPlayer.m_upgrades[this._creatureID].powerup;
            }
         }
         else if(GLOBAL.player.m_upgrades[this._creatureID].powerup)
         {
            return GLOBAL.player.m_upgrades[this._creatureID].powerup;
         }
         return 0;
      }
      
      override public function clear() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         setHealth(0);
         if(this._house)
         {
            _loc1_ = this._house._creatures.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(this._house._creatures[_loc2_] === this)
               {
                  this._house._creatures.splice(_loc2_,1);
                  break;
               }
               _loc2_++;
            }
         }
         if(this._rasterData)
         {
            this._rasterData.clear();
         }
         if(this._shadowData)
         {
            this._shadowData.clear();
         }
         this._rasterData = null;
         this._shadowData = null;
         this._rasterPt = null;
         this._shadowPt = null;
         if(this._graphic)
         {
            this._graphic.dispose();
         }
         if(this._shadow)
         {
            this._shadow.dispose();
         }
         this._graphic = null;
         this._shadow = null;
         super.clear();
      }
      
      public function canShootCreep() : Boolean
      {
         return false;
      }
      
      public function findHuntingTargets() : void
      {
         var _loc4_:MonsterBase = null;
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Object = CREATURES._creatures;
         for each(_loc4_ in _loc3_)
         {
            if(!(_loc4_._behaviour != k_sBHVR_DEFEND && _loc4_._behaviour != k_sBHVR_BUNKER))
            {
               _loc2_.push({
                  "creep":_loc4_,
                  "dist":GLOBAL.QuickDistance(_loc4_._tmpPoint,this._tmpPoint)
               });
               _loc1_++;
               if(_loc1_ >= 10)
               {
                  break;
               }
            }
         }
         if(Boolean(CREATURES._guardian) && CREATURES._guardian.health > 0)
         {
            _loc2_.push({
               "creep":CREATURES._guardian,
               "dist":GLOBAL.QuickDistance(CREATURES._guardian._tmpPoint,this._tmpPoint)
            });
         }
         if(_loc2_.length > 0)
         {
            _loc2_.sortOn("dist",Array.NUMERIC);
            while(_loc2_.length > 0 && _loc2_[0].creep.health <= 0)
            {
               _loc2_.splice(0,1);
            }
         }
         if(_loc2_.length > 0)
         {
            this._targetCreep = _loc2_[0].creep;
            this._waypoints = [this._targetCreep._tmpPoint];
         }
      }
      
      public function loseTarget() : void
      {
         this._hasTarget = false;
         this._attacking = false;
         this._atTarget = false;
         this._targetCreep = null;
      }
      
      //targetGroup 1 targets all, 2 targets walls, 3 targets resorcers, 4 targets defenses, 5 heals, ¿6 are balthazars?
      public function findTarget(targetGroup:int = 0) : void
      {
         var targetDistance:Number = Number.MAX_VALUE;
         var targetDistance2:Number = Number.MAX_VALUE;
         var distance:int = 0;
         var target:BFOUNDATION = null;
         var target2:BFOUNDATION = null;
         var targetFound:Boolean = false;
         var currentBuilding:BFOUNDATION = null;
         var ownPosition:Point = null;
         var buildingPosition:Point = null;
         var bunker:Bunker = null;
         var hasMonsters:Boolean = false;
         var burrowToPoint:Point = null;
         var movementSeed:int = 0;
         var deltaX:int = 0;
         var deltaY:int = 0;
         var flySeed2:Number = NaN;
         var flySeed:Number = NaN;
         var flyToPoint:Point = null;
         this._looking = true;
         if(this._behaviour == k_sBHVR_HUNT && (CREATURES._creatureCount > 0 || CREATURES._guardian && CREATURES._guardian.health > 0))
         {
            this.findHuntingTargets();
            if(this._targetCreep)
            {
               this._hasTarget = true;
               this._hasPath = true;
               this._waypoints = [this._targetCreep._tmpPoint];
               this._targetPosition = this._targetCreep._tmpPoint;
               this._targetCenter = this._targetCreep._tmpPoint;
            }
         }
         ownPosition = PATHING.FromISO(this._tmpPoint);
         if(targetGroup == 2)
         {
            for each(currentBuilding in BASE._buildingsWalls)
            {
               if(!currentBuilding._destroyed && currentBuilding.health > 0)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target2 = target;
                     targetDistance2 = targetDistance;

                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  else if(distance<targetDistance2)
                  {
                     target2 = currentBuilding;
                     targetDistance2 = distance;
                  }
                  targetFound = true;
               }
            }
         }
         else if(targetGroup == 3)
         {
            for each(currentBuilding in BASE._buildingsMain)
            {
               if(currentBuilding.health > 0 && currentBuilding is ILootable && !currentBuilding._looted)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target2 = target;
                     targetDistance2 = targetDistance;

                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  else if(distance<targetDistance2)
                  {
                     target2 = currentBuilding;
                     targetDistance2 = distance;
                  }
                  targetFound = true;
               }
            }
         }
         else if(targetGroup == 4)
         {
            for each(currentBuilding in BASE._buildingsTowers)
            {
               if(MONSTERBUNKER.isBunkerBuilding(currentBuilding._type))
               {
                  if(currentBuilding.health > 0 && (currentBuilding._used > 0 || currentBuilding._monstersDispatchedTotal > 0))
                  {
                     buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                     distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target2 = target;
                     targetDistance2 = targetDistance;

                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  else if(distance<targetDistance2)
                  {
                     target2 = currentBuilding;
                     targetDistance2 = distance;
                  }
                  targetFound = true;
                  }
               }
               else if(currentBuilding._class != "trap" && currentBuilding.health > 0 && !(currentBuilding as BTOWER).isJard)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target2 = target;
                     targetDistance2 = targetDistance;

                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  else if(distance<targetDistance2)
                  {
                     target2 = currentBuilding;
                     targetDistance2 = distance;
                  }
                  targetFound = true;
               }
            }
         }
         else if(this._targetGroup == 6)
         {
            for each(bunker in BASE._buildingsBunkers)
            {
               if(bunker.health > 0)
               {
                  hasMonsters = false;
                  if(bunker._type == 22)
                  {
                     if(bunker._used > 0 || bunker._monstersDispatchedTotal > 0)
                     {
                        hasMonsters = true;
                     }
                  }
                  if(bunker._type == 128)
                  {
                     if(HOUSING._housingUsed.Get() > 0)
                     {
                        hasMonsters = true;
                     }
                  }
                  if(hasMonsters)
                  {
                     buildingPosition = GRID.FromISO(_loc13_._mc.x,_loc13_._mc.y + _loc13_._middle);
                     distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - bunker._middle;
                     if(distance < targetDistance)
                     {
                        target2 = target;
                        targetDistance2 = targetDistance;

                        target = currentBuilding;
                        targetDistance = distance;
                     }
                     else if(distance<targetDistance2)
                     {
                        target2 = currentBuilding;
                        targetDistance2 = distance;
                     }
                     targetFound = true;
                  }
               }
            }
         }
         if(!targetFound || targetGroup == 1)
         {
            for each(currentBuilding in BASE._buildingsMain)
            {
               if(currentBuilding._class != "decoration" && currentBuilding._class != "immovable" && currentBuilding.health > 0 && currentBuilding._class != "enemy")
               {
                  if(this._targetGroup != 4)
                  {
                     this._targetGroup = 1;
                  }
                  if(currentBuilding._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(currentBuilding._type))
                  {
                     if((currentBuilding as BTOWER).isJard)
                     {
                        continue;
                     }
                  }
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target2 = target;
                     targetDistance2 = targetDistance;

                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  else if(distance<targetDistance2)
                  {
                     target2 = currentBuilding;
                     targetDistance2 = distance;
                  }
                  targetFound = true;
               }
            }
         }
         if(!targetFound && !this._targetCreep)
         {
            this.changeModeRetreat();
         }
         else if(targetFound)
         {
            if(this._movement == "burrow")
            {
               this._hasTarget = true;
               this._hasPath = true;
               burrowToPoint = GRID.FromISO(target._mc.x,target._mc.y);
               movementSeed = int(Math.random() * 4);
               deltaX = int(target._footprint[0].height);
               deltaY = int(target._footprint[0].width);
               if(movementSeed == 0)
               {
                  burrowToPoint.x += Math.random() * deltaX;
                  burrowToPoint.y += deltaY;
               }
               else if(movementSeed == 1)
               {
                  burrowToPoint.x += deltaX;
                  burrowToPoint.y += deltaY;
               }
               else if(movementSeed == 2)
               {
                  burrowToPoint.x += deltaX - Math.random() * deltaX / 2;
                  burrowToPoint.y -= deltaY / 4;
               }
               else if(movementSeed == 3)
               {
                  burrowToPoint.x -= deltaX / 4;
                  burrowToPoint.y += deltaY - Math.random() * deltaY / 2;
               }
               this._waypoints = [GRID.ToISO(burrowToPoint.x,burrowToPoint.y,0)];
               this._targetPosition = this._waypoints[0];
               this._targetBuilding = target;
            }
            else if(this._movement == "fly" || this._movement == "fly_low")
            {
               this._hasTarget = true;
               this._hasPath = true;
               this._targetBuilding = target
               this._targetCenter = this._targetBuilding._position;
               if(this._creatureID == "IC5")
               {
                  if(!this._targetCreep)
                  {
                     if(GLOBAL.QuickDistance(this._tmpPoint,this._targetCenter) < 50)
                     {
                        this._atTarget = true;
                        this._hasPath = true;
                        this._targetPosition = this._targetCenter;
                     }
                     else
                     {
                        this._movement = "fly";
                        flySeed2 = (flySeed2 = (flySeed2 = Math.atan2(this._tmpPoint.y - this._targetCenter.y,this._tmpPoint.x - this._targetCenter.x) * 57.2957795) + (Math.random() * 40 - 20)) / (180 / Math.PI);
                        flySeed = 30 + Math.random() * 10;
                        flyToPoint = new Point(this._targetCenter.x + Math.cos(flySeed2) * flySeed,this._targetCenter.y + Math.sin(flySeed2) * flySeed);
                        this._waypoints = [flyToPoint];
                        this._targetPosition = this._waypoints[0];
                     }
                  }
               }
               else if(GLOBAL.QuickDistance(this._tmpPoint,this._targetCenter) < 170)
               {
                  this._atTarget = true;
                  this._hasPath = true;
                  this._targetPosition = this._targetCenter;
               }
               else
               {
                  flySeed2 = (flySeed2 = (flySeed2 = Math.atan2(this._tmpPoint.y - this._targetCenter.y,this._tmpPoint.x - this._targetCenter.x) * 57.2957795) + (Math.random() * 40 - 20)) / (180 / Math.PI);
                  flySeed = 120 + Math.random() * 10;
                  flyToPoint = new Point(this._targetCenter.x + Math.cos(flySeed2) * flySeed * 1.7,this._targetCenter.y + Math.sin(flySeed2) * flySeed);
                  this._waypoints = [flyToPoint];
                  this._targetPosition = this._waypoints[0];
               }
            }
            else if(!GLOBAL._catchup && targetDistance2 != Number.MAX_VALUE)
            {
               WaypointTo(new Point(target._mc.x,target._mc.y),target);   
               WaypointTo(new Point(target2._mc.x,target2._mc.y),target2);           
            }
            else
            {
               WaypointTo(new Point(target._mc.x,target._mc.y),target);     
            }
         }
      }
      
      public function WaypointTo(param1:Point, param2:BFOUNDATION = null) : void
      {
         var _loc3_:Boolean = false;
         if(this._behaviour === k_sBHVR_JUICE || this._behaviour === k_sBHVR_HOUSING || this._behaviour === k_sBHVR_PEN || this._behaviour === k_sBHVR_DEFEND || this._behaviour === k_sBHVR_FEED || this._movement === k_sBHVR_JUMP || this._behaviour === k_sBHVR_DECOY)
         {
            _loc3_ = true;
         }
         if(param2)
         {
            PATHING.GetPath(this._tmpPoint,new Rectangle(int(param1.x),int(param1.y),param2._footprint[0].width,param2._footprint[0].height),this.setWaypoints,_loc3_,param2);
         }
         else
         {
            PATHING.GetPath(this._tmpPoint,new Rectangle(int(param1.x),int(param1.y),10,10),this.setWaypoints,_loc3_);
         }
      }
      
      public function die() : void
      {
         if(this.dead)
         {
            return;
         }
         Targeting.CreepCellDelete(this._id,this.node,false);
         this._dying = true;
         if(!this.juiceReady && (this._movement == "fly" || this._movement == "fly_low"))
         {
            TweenLite.to(this._graphicMC,0.4,{
               "y":this._graphicMC.y + this._altitude,
               "ease":Sine.easeOut,
               "onComplete":this.dieFinish
            });
         }
         else
         {
            this.dieFinish();
         }
      }
      
      private function dieFinish() : void
      {
         SOUNDS.Play("monsterland" + (1 + int(Math.random() * 3)));
         if(health <= 0)
         {
            dispatchEvent(new Event(k_DEATH_EVENT));
            ++QUESTS._global.kills;
            this.deathSplat();
         }
         this.removeAllComponents();
         this.clear();
         this._dead = true;
         if(!this.isDisposable && this._creatureID.substr(0,1) != "G")
         {
            this.node = Targeting.CreepCellAdd(this._tmpPoint,this._id,this);
         }
      }
      
      public function corpseDeath() : void
      {
         Targeting.CreepCellDelete(this._id,this.node,true);
      }
      
      private function removeAllComponents() : void
      {
         while(this._components.length)
         {
            this.removeComponent(this._components[this._components.length - 1]);
         }
         while(this._attackComponents.length)
         {
            this.removeComponent(this._attackComponents[this._attackComponents.length - 1]);
         }
      }
      
      public function deathSplat() : void
      {
         SOUNDS.Play("splat" + (int(Math.random() * 3) + 1));
         EFFECTS.CreepSplat(this._creatureID,this._tmpPoint.x,this._tmpPoint.y);
      }
      
      protected function flyerJuice() : void
      {
         this.m_juiceReady = true;
      }
      
      public function setWaypoints(param1:Array, param2:BFOUNDATION = null, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         if(param3)
         {
            switch(this._behaviour)
            {
               case k_sBHVR_ATTACK:
                  this.findTarget(this._targetGroup);
                  break;
               case k_sBHVR_HOUSING:
                  this.changeModeHousing();
                  break;
               case k_sBHVR_RETREAT:
                  this.changeModeRetreat();
            }
         }
         else
         {
            _loc4_ = false;
            if(param1.length < this._waypoints.length)
            {
               _loc4_ = true;
            }
            if(_loc4_ && param2 && param2._class == "wall" && this._targetGroup != 2)
            {
               _loc4_ = false;
            }
            if(!this._hasTarget)
            {
               _loc4_ = true;
            }
            if(this._behaviour == k_sBHVR_DEFEND)
            {
               _loc4_ = true;
            }
            if(_loc4_)
            {
               this._hasTarget = true;
               this._atTarget = false;
               this._hasPath = true;
               this._waypoints = param1;
               this._targetPosition = this._waypoints[0];
               if(param2)
               {
                  this._targetBuilding = param2;
               }
            }
            this._looking = false;
         }
      }
      
      public function get range() : Number
      {
         return this.m_range;
      }
      
      public function set range(param1:Number) : void
      {
         this.m_range = param1;
      }
   }
}
