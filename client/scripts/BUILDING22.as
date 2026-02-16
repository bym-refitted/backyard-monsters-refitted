package
{
   import com.cc.utils.SecNum;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.player.CreepInfo;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Decoy;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import gs.TweenLite;
   import gs.easing.Expo;
   
   public class BUILDING22 extends Bunker
   {
      
      private static const kPercentAllowed:Number = 0.1;
       
      
      public var _animMC:MovieClip;
      
      public var _animFrame:int = 0;
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public var _blend:int;
      
      public var _blending:Boolean;
      
      public var _bank:SecNum;
      
      public var _monsters:Dictionary;
      
      public var _open:Boolean;
      
      public var _releaseCooldown:int = 0;
      
      public var _targetCreeps:Array;
      
      public var _targetFlyers:Array;
      
      public var _targetCreep:*;
      
      public var _hasTargets:Boolean = false;
      
      public var _tickNumber:int = 0;
      
      public var _capacity:int = 0;
      
      private var _logged:Boolean = false;
      
      private var _radiusGraphic:Shape;
      
      public function BUILDING22()
      {
         super();
         _type = 22;
         this._frameNumber = 0;
         _footprint = [new Rectangle(0,0,90,90)];
         _gridCost = [[new Rectangle(0,0,10,10),50],[new Rectangle(80,0,10,10),50],[new Rectangle(0,80,10,10),50],[new Rectangle(80,80,10,10),50]];
         _spoutPoint = new Point(0,0);
         _spoutHeight = 40;
         this._monsters = new Dictionary(true);
         _monstersDispatched = {};
         this._targetCreeps = [];
         this._targetFlyers = [];
         SetProps();
      }
      
      public function FindTargets(param1:int, param2:int = 1) : void
      {
         var _loc3_:Object = null;
         var _loc4_:MonsterBase = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         if(_lvl.Get() > 0 && health > 0)
         {
            _loc9_ = Targeting.getCreepsInRange(GLOBAL._buildingProps[21].stats[_lvl.Get() - 1].range,_position.add(new Point(0,_footprint[0].height / 2)),Targeting.getOldStyleTargets(0));
            this._hasTargets = false;
            if(_loc9_.length > 0)
            {
               this._targetCreeps = [];
               if(param2 == 1)
               {
                  _loc9_.sortOn(["dist"],Array.NUMERIC);
               }
               else if(param2 == 2)
               {
                  _loc9_.sortOn(["dist"],Array.NUMERIC | Array.DESCENDING);
               }
               else if(param2 == 3)
               {
                  _loc9_.sortOn(["hp"],Array.NUMERIC | Array.DESCENDING);
               }
               else if(param2 == 4)
               {
                  _loc9_.sortOn(["hp"],Array.NUMERIC);
               }
               _loc8_ = 0;
               for(_loc5_ in _loc9_)
               {
                  _loc8_++;
                  if(_loc8_ <= param1 && _loc9_[_loc5_].creep._behaviour != "retreat")
                  {
                     _loc3_ = _loc9_[_loc5_];
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
            if(Boolean(this._monsters["C12"]) && Boolean(GLOBAL.player.m_upgrades["C12"].powerup) || Boolean(this._monsters["C5"]) && Boolean(GLOBAL.player.m_upgrades["C5"].powerup) || Boolean(this._monsters["IC5"]) || Boolean(this._monsters["IC7"]))
            {
               if((_loc9_ = Targeting.getCreepsInRange(GLOBAL._buildingProps[21].stats[_lvl.Get() - 1].range,_position.add(new Point(0,_footprint[0].height / 2)),Targeting.getOldStyleTargets(2))).length > 0)
               {
                  this._targetFlyers = [];
                  if(param2 == 1)
                  {
                     _loc9_.sortOn(["dist"],Array.NUMERIC);
                  }
                  else if(param2 == 2)
                  {
                     _loc9_.sortOn(["dist"],Array.NUMERIC | Array.DESCENDING);
                  }
                  else if(param2 == 3)
                  {
                     _loc9_.sortOn(["hp"],Array.NUMERIC | Array.DESCENDING);
                  }
                  else if(param2 == 4)
                  {
                     _loc9_.sortOn(["hp"],Array.NUMERIC);
                  }
                  _loc8_ = 0;
                  for(_loc5_ in _loc9_)
                  {
                     _loc8_++;
                     if(_loc8_ <= param1 && _loc9_[_loc5_].creep._behaviour != "retreat")
                     {
                        _loc3_ = _loc9_[_loc5_];
                        _loc4_ = _loc3_.creep;
                        _loc6_ = Number(_loc3_.dist);
                        _loc7_ = _loc3_.pos;
                        this._targetFlyers.push({
                           "creep":_loc4_,
                           "dist":_loc6_,
                           "position":_loc7_
                        });
                        this._hasTargets = true;
                     }
                  }
               }
            }
            else
            {
               this._targetFlyers = [];
            }
            return;
         }
         this._targetCreeps = [];
         this._targetFlyers = [];
         this._hasTargets = false;
      }
      
      public function GetTarget(param1:int = 0) : *
      {
         var _loc2_:int = 0;
         if(this._hasTargets)
         {
            if(param1 > 0 && this._targetFlyers.length > 0)
            {
               _loc2_ = int(Math.random() * this._targetFlyers.length);
               if(_loc2_ > this._targetFlyers.length)
               {
                  _loc2_ = 2;
               }
               return this._targetFlyers[_loc2_].creep;
            }
            if(this._targetCreeps.length > 0)
            {
               _loc2_ = int(Math.random() * this._targetCreeps.length);
               if(_loc2_ > this._targetCreeps.length)
               {
                  _loc2_ = 2;
               }
               return this._targetCreeps[_loc2_].creep;
            }
            return null;
         }
         return null;
      }
      
      private function numMonsters(param1:String) : int
      {
         if(this._monsters[param1])
         {
            return MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard ? int(this._monsters[param1].length) : int(this._monsters[param1]);
         }
         return 0;
      }
      
      public function EjectCreeps(param1:Point) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc2_:String = null;
         for(_loc3_ in this._monsters)
         {
            if(this._monsters[_loc3_] && _monstersDispatched[_loc3_] < this.numMonsters(_loc3_) && _animTick >= 15)
            {
               _loc2_ = _loc3_;
               if(_loc2_)
               {
                  _loc4_ = param1.x - _position.x;
                  _loc5_ = param1.y - _position.y;
                  _loc6_ = int(_footprint[0].width);
                  _loc7_ = int(_footprint[0].height);
                  if(_loc5_ <= 0)
                  {
                     _loc5_ = _loc7_ / 4;
                     if(_loc4_ <= 0)
                     {
                        _loc4_ = _loc6_ / -3;
                     }
                     else
                     {
                        _loc4_ = _loc6_ / 2;
                     }
                  }
                  else
                  {
                     _loc5_ = _loc7_ / 2;
                     if(_loc4_ <= 0)
                     {
                        _loc4_ = _loc6_ / -4;
                     }
                     else
                     {
                        _loc4_ = _loc6_ / 2;
                     }
                  }
                  if(_loc8_ = CREATURES.Spawn(_loc2_,MAP._BUILDINGTOPS,"decoy",_position.add(new Point(_loc4_,_loc5_)),Math.random() * 360))
                  {
                     _loc8_._homeBunker = this;
                     var dispatechedCount:int = int(_monstersDispatched[_loc2_]);
                     _monstersDispatched[_loc2_] = ++dispatechedCount;
                     ++_monstersDispatchedTotal;
                  }
               }
            }
         }
      }
      
      private function DecoyInRange() : Boolean
      {
         var _loc1_:Decoy = null;
         var _loc2_:Point = null;
         if(Boolean(SiegeWeapons.activeWeapon) && SiegeWeapons.activeWeaponID == Decoy.ID)
         {
            _loc1_ = SiegeWeapons.activeWeapon as Decoy;
            if(_loc1_)
            {
               _loc2_ = new Point(_loc1_.x,_loc1_.y);
               if(GLOBAL.QuickDistance(_loc2_,_position) < _loc1_.range)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function getNumReleasableCreeps(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
         {
            return this._monsters[param1];
         }
         _loc2_ = this.numMonsters(param1);
         _loc3_ = CREATURES.GetProperty(param1,"health",0,true);
         _loc4_ = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            if(Boolean(this._monsters[param1][_loc4_].self) || Boolean(this._monsters[param1][_loc4_].queued) || this._monsters[param1][_loc4_].health < _loc3_ * kPercentAllowed)
            {
               _loc2_--;
            }
            _loc4_--;
         }
         return _loc2_;
      }
      
      private function getNextCreepToRelease(param1:String) : CreepInfo
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
         {
            return null;
         }
         _loc2_ = int(this._monsters[param1].length);
         _loc3_ = CREATURES.GetProperty(param1,"health",0,true);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            if(!this._monsters[param1][_loc4_].self && !this._monsters[param1][_loc4_].queued && this._monsters[param1][_loc4_].health > _loc3_ * kPercentAllowed)
            {
               return this._monsters[param1][_loc4_];
            }
            _loc4_++;
         }
         return null;
      }
      
      override public function TickAttack() : void
      {
         var _loc2_:CreepInfo = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:MonsterBase = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:MonsterBase = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc14_:Boolean = false;
         var _loc1_:Boolean = false;
         super.TickAttack();
         if(health > 0)
         {
            this._capacity = GLOBAL._buildingProps[21].capacity[_lvl.Get() - 1];
         }
         _used = 0;
         for(_loc3_ in this._monsters)
         {
            _used += CREATURES.GetProperty(_loc3_,"cStorage",0,true) * this.numMonsters(_loc3_);
            if(!_monstersDispatched[_loc3_])
            {
               _monstersDispatched[_loc3_] = 0;
            }
         }
         this.Cull();
         _loc4_ = 0;
         while(_loc4_ < this._targetCreeps.length)
         {
            if(this._targetCreeps[_loc4_].creep.health <= 0)
            {
               _loc1_ = true;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this._targetFlyers.length)
         {
            if(this._targetFlyers[_loc4_].creep.health <= 0)
            {
               _loc1_ = true;
            }
            _loc4_++;
         }
         if(_loc1_)
         {
            this._targetCreeps = [];
            this._targetFlyers = [];
            this._hasTargets = false;
         }
         if(_countdownUpgrade.Get() == 0 && ((!this._hasTargets || _loc1_) && this._frameNumber % 10 == 0 || this._frameNumber % 60 == 0))
         {
            this.FindTargets(3);
         }
         ++this._tickNumber;
         if((this._targetFlyers.length > 0 || this._targetCreeps.length > 0) && (_animTick >= 15 || GLOBAL._catchup) && this._tickNumber % 30 == 0)
         {
            _loc5_ = null;
            this._targetCreeps.sortOn(["dist"],Array.NUMERIC);
            this._targetFlyers.sortOn(["dist"],Array.NUMERIC);
            if(this._targetFlyers.length > 0 && this.getNumReleasableCreeps("C12") > 0 && (_monstersDispatched["C12"] < this.numMonsters("C12") && GLOBAL.player.m_upgrades["C12"].powerup))
            {
               _loc5_ = "C12";
            }
            else if(this._targetFlyers.length > 0 && this.getNumReleasableCreeps("C5") > 0 && _monstersDispatched["C5"] < this.numMonsters("C5") && Boolean(GLOBAL.player.m_upgrades["C5"].powerup))
            {
               _loc5_ = "C5";
            }
            else if(this._targetFlyers.length > 0 && this.getNumReleasableCreeps("IC5") > 0 && _monstersDispatched["IC5"] < this.numMonsters("IC5"))
            {
               _loc5_ = "IC5";
            }
            else if(this._targetFlyers.length > 0 && this.getNumReleasableCreeps("IC7") > 0 && _monstersDispatched["IC7"] < this.numMonsters("IC7"))
            {
               _loc5_ = "IC7";
            }
            else if(this._targetCreeps.length > 0)
            {
               for(_loc3_ in this._monsters)
               {
                  if(this._monsters[_loc3_] && this.getNumReleasableCreeps(_loc3_) > 0 && _monstersDispatched[_loc3_] < this.numMonsters(_loc3_))
                  {
                     _loc5_ = _loc3_;
                  }
               }
            }
            if(_loc5_)
            {
               if(!this._logged)
               {
                  _loc12_ = [];
                  for(_loc3_ in this._monsters)
                  {
                     if(this._monsters[_loc3_] > 0)
                     {
                        _loc14_ = false;
                        _loc13_ = KEYS.Get(CREATURELOCKER._creatures[_loc3_].name);
                        _loc12_.push([this.numMonsters(_loc3_),_loc13_]);
                     }
                  }
                  this._logged = true;
                  ATTACK.Log("b" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attacklog_unleashed",{
                     "v1":_lvl.Get(),
                     "v2":KEYS.Get(_buildingProps.name),
                     "v3":GLOBAL.Array2String(_loc12_)
                  }) + "</font>");
               }
               if(this._targetFlyers.length > 0 && (_loc5_ == "C12" || _loc5_ == "C5" || _loc5_ == "IC5" || _loc5_ == "IC7"))
               {
                  _loc6_ = this._targetFlyers[int(Math.random() * this._targetFlyers.length)].creep;
               }
               else
               {
                  _loc6_ = this._targetCreeps[int(Math.random() * this._targetCreeps.length)].creep;
               }
               _loc7_ = _loc6_._tmpPoint.x - _position.x;
               _loc8_ = _loc6_._tmpPoint.y - _position.y;
               _loc9_ = int(_footprint[0].width);
               _loc10_ = int(_footprint[0].height);
               if(_loc8_ <= 0)
               {
                  _loc8_ = _loc10_ / 4;
                  if(_loc7_ <= 0)
                  {
                     _loc7_ = _loc9_ / -3;
                  }
                  else
                  {
                     _loc7_ = _loc9_ / 2;
                  }
               }
               else
               {
                  _loc8_ = _loc10_ / 2;
                  if(_loc7_ <= 0)
                  {
                     _loc7_ = _loc9_ / -4;
                  }
                  else
                  {
                     _loc7_ = _loc9_ / 2;
                  }
               }
               _loc2_ = this.getNextCreepToRelease(_loc5_);
               if(_loc11_ = CREATURES.Spawn(_loc5_,MAP._BUILDINGTOPS,"defend",_position.add(new Point(_loc7_,_loc8_)),Math.random() * 360,null,null,0,!!_loc2_ ? int(_loc2_.health) : int.MAX_VALUE))
               {
                  _loc11_._targetCreep = _loc6_;
                  _loc11_._homeBunker = this;
                  _loc11_._hasTarget = true;
                  if(_loc2_)
                  {
                     _loc2_.self = _loc11_;
                  }
                  if(_loc11_._pathing == "direct")
                  {
                     _loc11_._phase = 1;
                  }
                  _loc11_.WaypointTo(_loc11_._targetCreep._tmpPoint);
                  _loc11_._targetPosition = _loc11_._targetCreep._tmpPoint;
                  _monstersDispatched[_loc5_] = int(_monstersDispatched[_loc5_]) + 1;
                  ++_monstersDispatchedTotal;
               }
            }
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         ++this._frameNumber;
         if(!GLOBAL._catchup)
         {
            if(_used > 0 && (this._targetCreeps.length > 0 || this._targetFlyers.length > 0 || _monstersDispatchedTotal > 0 || this.DecoyInRange()))
            {
               if(_animTick == 1)
               {
                  SOUNDS.Play("bunkerdoor");
               }
               if(_animTick < 15)
               {
                  _animTick += 1;
                  AnimFrame(false);
               }
            }
            else
            {
               if(_animTick == 15)
               {
                  SOUNDS.Play("bunkerdoor");
               }
               if(_animTick > 0)
               {
                  --_animTick;
                  AnimFrame(false);
               }
            }
         }
      }
      
      override public function Description() : void
      {
         super.Description();
         _upgradeDescription = KEYS.Get("bunker_upgrade_desc");
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
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-wmb",KEYS.Get("pop_bunkerbuilt_streamtitle"),KEYS.Get("pop_bunkerbuilt_streambody"),"build-monsterbunker.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_bunkerbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_bunkerbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
         if(_lvl.Get() > 0)
         {
            this._capacity = GLOBAL._buildingProps[21].capacity[_lvl.Get() - 1];
            super._range = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].range;
         }
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         for(_loc2_ in this._monsters)
         {
            if(MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard)
            {
               _loc3_ = 0;
               while(_loc3_ < this._monsters[_loc2_].length)
               {
                  this._monsters[_loc2_][_loc3_].health *= 0.5;
                  _loc3_++;
               }
            }
            else
            {
               this._monsters[_loc2_] = _monstersDispatched[_loc2_];
               if(this._monsters[_loc2_] == 0)
               {
                  delete this._monsters[_loc2_];
               }
            }
         }
         super.Destroyed();
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
               GLOBAL.CallJS("sendFeed",["upgrade-wmb-" + _lvl.Get(),KEYS.Get("pop_bunkerupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_bunkerupgraded_streambody"),"build-monsterbunker.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_bunkerupgraded_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_bunkerupgraded_body",{"v1":_lvl.Get()});
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
         if(_lvl.Get() > 0)
         {
            this._capacity = GLOBAL._buildingProps[21].capacity[_lvl.Get() - 1];
            super._range = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].range;
         }
      }
      
      override public function Recycle() : void
      {
         var _loc1_:String = null;
         _blockRecycle = false;
         if(MapRoomManager.instance.isInMapRoom3 && !BASE.isMainYardOrInfernoMainYard)
         {
            for(_loc1_ in this._monsters)
            {
               if(this._monsters[_loc1_].length)
               {
                  _blockRecycle = true;
                  break;
               }
            }
         }
         super.Recycle();
      }
      
      override public function RecycleC() : void
      {
         super.RecycleC();
         this._capacity = 0;
         this.Cull();
      }
      
      public function Cull() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:int = _monstersDispatchedTotal + 1;
         while(_used > this._capacity)
         {
            for(_loc4_ in this._monsters)
            {
               if(this.numMonsters(_loc4_))
               {
                  this._monsters[_loc4_] = int(this._monsters[_loc4_]) - 1;
                  _used -= CREATURELOCKER._creatures[_loc4_].props.cStorage;
                  _loc1_ = true;
               }
               else
               {
                  this._monsters[_loc4_] = 0;
                  delete this._monsters[_loc4_];
                  _loc1_ = true;
               }
            }
            _loc2_ = 0;
            for each(_loc5_ in this._monsters)
            {
               _loc2_ += _loc5_;
            }
         }
         for(_loc3_ in this._monsters)
         {
            if(Boolean(this._monsters[_loc3_]) && this._monsters[_loc3_] == 0)
            {
               delete this._monsters[_loc3_];
               _loc1_ = true;
            }
         }
         if(_loc1_)
         {
            BASE.Save();
         }
      }
      
      public function RemoveCreature(param1:String) : void
      {
         var count:int = int(this._monsters[param1]);
         --count;
         if(count < 0)
         {
            count = 0;
         }
         this._monsters[param1] = count;
         var dispatchedCount:int = int(_monstersDispatched[param1]);
         --dispatchedCount;
         if(dispatchedCount < 0)
         {
            dispatchedCount = 0;
         }
         _monstersDispatched[param1] = dispatchedCount;
         --_monstersDispatchedTotal;
         if(_monstersDispatchedTotal < 0)
         {
            _monstersDispatchedTotal = 0;
         }
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
      
      private function linkMonstersToData(param1:Object) : void
      {
         var _loc3_:Vector.<CreepInfo> = null;
         if(!this._monsters)
         {
            this._monsters = new Dictionary(true);
         }
         var _loc2_:int = int(GLOBAL.player.monsterList.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = GLOBAL.player.monsterList[_loc4_].getOwnedCreeps(_id);
            if(_loc3_.length)
            {
               this._monsters[GLOBAL.player.monsterList[_loc4_].m_creatureID] = _loc3_;
               _monstersDispatched[GLOBAL.player.monsterList[_loc4_].m_creatureID] = 0;
            }
            _loc4_++;
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         var _loc2_:String = null;
         super.Setup(param1);
         if(MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard)
         {
            this.linkMonstersToData(param1);
         }
         else
         {
            for(_loc2_ in param1.m)
            {
               this._monsters[_loc2_] = param1.m[_loc2_];
               _monstersDispatched[_loc2_] = 0;
            }
         }
         if(_lvl.Get() > 0)
         {
            this._capacity = GLOBAL._buildingProps[21].capacity[_lvl.Get() - 1];
            super._range = GLOBAL._buildingProps[_type - 1].stats[_lvl.Get() - 1].range;
         }
      }
      
      override public function Export() : Object
      {
         var _loc3_:String = null;
         var _loc1_:Object = super.Export();
         var _loc2_:int = 0;
         if(Boolean(this._monsters) && health > 0)
         {
            for(_loc3_ in this._monsters)
            {
               _loc2_ = 0;
               if(this._monsters[_loc3_] is Number)
               {
                  _loc2_ = int(this._monsters[_loc3_]);
               }
               else if(this._monsters[_loc3_].length > 0)
               {
                  _loc2_ = int(this._monsters[_loc3_].length);
               }
               if(_loc1_.m)
               {
                  _loc1_.m[_loc3_.valueOf()] = _loc2_;
               }
               else
               {
                  _loc1_.m = {(_loc3_.valueOf()):_loc2_};
               }
            }
         }
         return _loc1_;
      }
   }
}
