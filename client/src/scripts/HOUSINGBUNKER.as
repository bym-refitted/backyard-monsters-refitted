package
{
   import com.monsters.interfaces.ITargetable;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   import gs.easing.Expo;
   
   public class HOUSINGBUNKER extends Bunker
   {
       
      
      public var bragPopUp:popup_building;
      
      public var _capacity:int;
      
      public var _hasTargets:Boolean;
      
      public var _frameNumber:int;
      
      public var _monsters:Object;
      
      public var _dispatchedMonsters:Array;
      
      public var _targetCreeps:Array;
      
      public var _targetFlyers:Array;
      
      public var _tickNumber:int;
      
      public var _isLogged:Boolean;
      
      private var _radiusGraphic:Shape;
      
      public function HOUSINGBUNKER()
      {
         super();
         _type = 128;
         _footprint = [new Rectangle(0,0,160,160)];
         _gridCost = [[new Rectangle(10,10,140,20),400],[new Rectangle(10,30,20,120),400],[new Rectangle(30,130,120,20),400],[new Rectangle(130,30,20,30),400],[new Rectangle(130,100,20,30),400]];
         this._frameNumber = 0;
         _spoutPoint = new Point(0,0);
         _spoutHeight = 40;
         this._monsters = {};
         _monstersDispatched = {};
         this._dispatchedMonsters = [];
         this._targetCreeps = [];
         this._targetFlyers = [];
         SetProps();
      }
      
      override public function StopMoveB() : void
      {
         super.StopMoveB();
         UpdateHousedCreatureTargets();
      }
      
      override public function Description() : void
      {
         super.Description();
         _upgradeDescription = KEYS.Get("bdg_housing_capacitydesc",{
            "v1":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get() - 1]),
            "v2":GLOBAL.FormatNumber(_buildingProps.capacity[_lvl.Get()])
         });
         if(_recycleCosts != null)
         {
            _recycleDescription = "<b>" + KEYS.Get("bdg_housing_recycledesc") + "</b><br>" + _recycleCosts;
         }
         HOUSING.HousingSpace();
         if(!BASE.isOutpost)
         {
            _blockRecycle = false;
         }
         if(HOUSING._housingSpace.Get() - _buildingProps.capacity[_lvl.Get() - 1] < 0)
         {
            _recycleDescription = "<font color=\"#CC0000\">" + KEYS.Get("bdg_compound_recyclewarning") + "</font>";
            _blockRecycle = true;
         }
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         HOUSING.AddHouse(this);
         this.updateLocalProperties();
      }
      
      private function updateLocalProperties() : void
      {
         if(_lvl.Get() > 0)
         {
            this._capacity = _buildingProps.capacity[_lvl.Get() - 1];
            _range = _buildingProps.stats[_lvl.Get() - 1].range;
         }
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
         HOUSING.HousingSpace();
         this.updateLocalProperties();
      }
      
      private function CloseUpgradePopUp(param1:MouseEvent) : void
      {
         this.bragPopUp.bPost.removeEventListener(MouseEvent.CLICK,this.CloseUpgradePopUp);
         POPUPS.Next();
         GLOBAL.CallJS("sendFeed",["upgrade-ho-" + _lvl.Get(),KEYS.Get("pop_housingupgraded_streamtitle",{"v1":_lvl.Get()}),KEYS.Get("pop_housingupgraded_streambody"),"upgrade-housing.png"]);
      }
      
      private function CloseConstructionPopUp(param1:MouseEvent) : void
      {
         this.bragPopUp.bPost.removeEventListener(MouseEvent.CLICK,this.CloseConstructionPopUp);
         POPUPS.Next();
         GLOBAL.CallJS("sendFeed",["build-wmb",KEYS.Get("pop_bunkerbuilt_streamtitle"),KEYS.Get("pop_bunkerbuilt_streambody"),"build-monsterbunker.png"]);
      }
      
      override public function RecycleC() : void
      {
         super.RecycleC();
         this.Removed();
         HOUSING.HousingSpace();
         RelocateHousedCreatures();
      }
      
      override public function Destroyed(param1:Boolean = true) : void
      {
         super.Destroyed(param1);
         var _loc2_:Boolean = MapRoomManager.instance.isInMapRoom3;
         var _loc3_:int = 0;
         while(_loc3_ < _creatures.length)
         {
            _creatures[_loc3_].setHealth(_loc2_ ? _creatures[_loc3_].health * 0.5 : 0);
            _loc3_++;
         }
         if(!_loc2_)
         {
            HOUSING.Cull();
         }
      }
      
      private function Removed() : void
      {
         this._capacity = 0;
         this._dispatchedMonsters = [];
         HOUSING.RemoveHouse(this);
      }
      
      override public function Setup(param1:Object) : void
      {
         param1.t = _type;
         super.Setup(param1);
         if(health > 10 && health < maxHealth && health % 1000 == 0)
         {
            setHealth(maxHealth);
         }
         if(_countdownBuild.Get() == 0)
         {
            HOUSING.AddHouse(this);
            BASE._buildingsBunkers["b" + _id] = this;
            BASE._buildingsTowers["b" + _id] = this;
         }
         this.updateLocalProperties();
      }
      
      public function FindTargets(param1:int, param2:int = 1) : void
      {
         this._hasTargets = false;
         if(_lvl.Get() <= 0 && health <= 0)
         {
            this._targetCreeps = [];
            this._targetFlyers = [];
            return;
         }
         var _loc3_:Array = Targeting.getCreepsInRange(GLOBAL._buildingProps[127].stats[_lvl.Get() - 1].range,_position.add(new Point(0,_footprint[0].height / 2)),Targeting.getOldStyleTargets(0));
         this._targetCreeps = this.addTargetCreeps(param1,_loc3_,param2);
         if(this.canTargetAir())
         {
            _loc3_ = Targeting.getCreepsInRange(GLOBAL._buildingProps[127].stats[_lvl.Get() - 1].range,_position.add(new Point(0,_footprint[0].height / 2)),Targeting.getOldStyleTargets(2));
            this._targetFlyers = this.addTargetCreeps(param1,_loc3_,param2);
         }
         else
         {
            this._targetFlyers = [];
         }
      }
      
      private function canTargetAir() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         while(_loc1_ < _creatures.length)
         {
            _loc2_ = _creatures[_loc1_];
            if(_loc2_._creatureID == "IC5" || _loc2_._creatureID == "IC7")
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function addTargetCreeps(param1:int, param2:Array, param3:int) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc4_:Array = [];
         if(param2.length > 0)
         {
            this.sortCreeps(param2,param3);
            _loc5_ = 0;
            while(_loc5_ < param2.length)
            {
               _loc6_ = param2[_loc5_];
               _loc7_ = param2[_loc5_];
               if(_loc5_ <= param1 && _loc7_._behaviour != "retreat")
               {
                  _loc4_.push({
                     "creep":_loc7_.creep,
                     "dist":_loc6_.dist,
                     "position":_loc6_.pos
                  });
                  this._hasTargets = true;
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private function sortCreeps(param1:Array, param2:int) : void
      {
         switch(param2)
         {
            case 1:
               param1.sortOn(["dist"],Array.NUMERIC);
               break;
            case 2:
               param1.sortOn(["dist"],Array.NUMERIC | Array.DESCENDING);
               break;
            case 3:
               param1.sortOn(["hp"],Array.NUMERIC | Array.DESCENDING);
               break;
            case 4:
               param1.sortOn(["hp"],Array.NUMERIC);
               break;
            default:
               throw new Error("invalid sorting type");
         }
      }
      
      private function getUnusedCreatures() : Array
      {
         var _loc1_:Array = _creatures.slice();
         var _loc2_:uint = _loc1_.length;
         var _loc3_:int = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(this._dispatchedMonsters.indexOf(_loc1_[_loc3_]) >= 0)
            {
               _loc1_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         return _loc1_;
      }
      
      override public function TickAttack() : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         super.TickAttack();
         if(health > 0)
         {
            this._capacity = _buildingProps.capacity[_lvl.Get() - 1];
         }
         var _loc1_:Array = this.getUnusedCreatures();
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this._targetCreeps.length)
         {
            if(this._targetCreeps[_loc3_].creep.health <= 0)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this._targetFlyers.length)
         {
            if(this._targetFlyers[_loc3_].creep.health <= 0)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this._targetCreeps = [];
            this._targetFlyers = [];
            this._hasTargets = false;
         }
         if(_countdownUpgrade.Get() == 0 && ((!this._hasTargets || _loc2_) && this._frameNumber % 10 == 0 || this._frameNumber % 60 == 0))
         {
            this.FindTargets(3);
         }
         ++this._tickNumber;
         if((this._targetFlyers.length > 0 || this._targetCreeps.length > 0) && this._tickNumber % 30 == 0)
         {
            _loc4_ = null;
            this._targetCreeps.sortOn(["dist"],Array.NUMERIC);
            this._targetFlyers.sortOn(["dist"],Array.NUMERIC);
            if(this._targetFlyers.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < this._targetFlyers.length)
               {
                  _loc5_ = this._targetFlyers[_loc7_].creep;
                  if(_loc6_ = this.getInterceptor(_loc1_,_loc5_))
                  {
                     this.dispatchCreature(_loc6_,_loc5_);
                     _loc1_.splice(_loc1_.indexOf(_loc6_),1);
                  }
                  _loc7_++;
               }
            }
            if(this._targetCreeps.length > 0)
            {
               _loc9_ = int((_loc8_ = _loc1_.length) - 1);
               while(_loc9_ >= 0)
               {
                  _loc5_ = this._targetCreeps[0].creep;
                  _loc6_ = _loc1_[_loc3_];
                  this.dispatchCreature(_loc6_,_loc5_);
                  _loc1_.splice(_loc3_,1);
                  _loc9_--;
               }
            }
         }
      }
      
      private function getInterceptor(param1:Array, param2:*) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc4_ = param1[_loc3_])._creatureID == "IC7" || _loc4_._creatureID == "IC5")
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function dispatchCreature(param1:*, param2:*) : void
      {
         var _loc3_:Number = param2._tmpPoint.x - _position.x;
         var _loc4_:Number = param2._tmpPoint.y - _position.y;
         var _loc5_:int = int(_footprint[0].width);
         var _loc6_:int = int(_footprint[0].height);
         if(_loc4_ <= 0)
         {
            _loc4_ = _loc6_ / 4;
            if(_loc3_ <= 0)
            {
               _loc3_ = _loc5_ / -3;
            }
            else
            {
               _loc3_ = _loc5_ / 2;
            }
         }
         else
         {
            _loc4_ = _loc6_ / 2;
            if(_loc3_ <= 0)
            {
               _loc3_ = _loc5_ / -4;
            }
            else
            {
               _loc3_ = _loc5_ / 2;
            }
         }
         var _loc7_:CreepBase;
         if(_loc7_ = param1)
         {
            _loc7_._targetRotation = Math.random() * 360;
            _loc7_.changeModeDefend();
            _loc7_._targetCreep = param2;
            _loc7_._homeBunker = this;
            _loc7_._hasTarget = true;
            if(_loc7_._pathing == "direct")
            {
               _loc7_.graphic.alpha = 0;
               _loc7_._phase = 1;
            }
            _loc7_.WaypointTo(_loc7_._targetCreep._tmpPoint);
            _loc7_._targetPosition = _loc7_._targetCreep._tmpPoint;
            this._dispatchedMonsters.push(param1);
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         ++this._frameNumber;
      }
      
      override public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         if(health <= 0)
         {
            ATTACK.Log("b" + _id,"<font color=\"#990000\">" + KEYS.Get("attack_log_%damaged",{
               "v1":_lvl.Get(),
               "v2":KEYS.Get(_buildingProps.name),
               "v3":100 - int(100 / maxHealth * health)
            }) + "</font>");
         }
         return super.modifyHealth(param1);
      }
      
      public function Cull() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         HOUSING.Cull();
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
      
      public function RemoveCreature(param1:String) : void
      {
         if(!MapRoomManager.instance.isInMapRoom3 || !BASE.isMainYardOrInfernoMainYard)
         {
            --this._monsters[param1];
            if(this._monsters[param1] < 0)
            {
               this._monsters[param1] = 0;
            }
            if(GLOBAL.player.monsterListByID(param1).numCreeps > 0)
            {
               GLOBAL.player.monsterListByID(param1).add(-1);
            }
         }
         --_monstersDispatched[param1];
         if(_monstersDispatched[param1] < 0)
         {
            _monstersDispatched[param1] = 0;
         }
         --_monstersDispatchedTotal;
         if(_monstersDispatchedTotal < 0)
         {
            _monstersDispatchedTotal = 0;
         }
         HOUSING.HousingSpace();
         BASE.Save();
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
   }
}
