package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.pathing.PATHING;
   import com.monsters.siege.weapons.Vacuum;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING115 extends BTOWER
   {
       
      
      public var _animMC:MovieClip;
      
      public var _animBitmap:BitmapData;
      
      public var _shotsFired:int;
      
      public var _lostCreep:Boolean = false;
      
      public var _fireStage:int = 1;
      
      public var _targetArray:Array;
      
      public function BUILDING115()
      {
         this._targetArray = [4,4,6,8,10,12,14,16];
         super();
         _frameNumber = 0;
         _type = 115;
         _top = -5;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         this._fireStage = 1;
         SetProps();
         this.Props();
         attackFlags = Targeting.getOldStyleTargets(2);
      }
      
      override public function TickAttack() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:MonsterBase = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:int = int(this._targetArray[_lvl.Get() - 1]);
         ++_frameNumber;
         if(health > 0 && _countdownBuild.Get() + _countdownUpgrade.Get() + _countdownFortify.Get() == 0)
         {
            if(this._fireStage == 1)
            {
               --_fireTick;
               if(_fireTick <= 0)
               {
                  this._fireStage = 2;
                  this._shotsFired = 0;
                  _fireTick += _rate * 2;
               }
            }
            if(this._fireStage == 2)
            {
               if(canShootVacuumHose())
               {
                  _targetVacuum = true;
                  _fireTick = 30;
               }
               else if(!_hasTargets || !targetInRange())
               {
                  _targetVacuum = false;
                  FindTargets(_loc1_,_priority);
                  _fireTick = 30;
               }
               if(_targetVacuum || _hasTargets)
               {
                  if(this._shotsFired >= _loc1_)
                  {
                     this._fireStage = 1;
                  }
                  else if(_frameNumber % 4 == 0)
                  {
                     _loc2_ = false;
                     _loc3_ = 0;
                     if(Boolean(_targetCreeps) && _targetCreeps.length > 0)
                     {
                        _loc3_ = this._shotsFired % _targetCreeps.length;
                     }
                     if(_targetVacuum)
                     {
                        this.Fire(Vacuum.getHose());
                        ++this._shotsFired;
                     }
                     else if(_targetCreeps[_loc3_].creep.health > 0)
                     {
                        this.Fire(_targetCreeps[_loc3_].creep);
                        ++this._shotsFired;
                     }
                     else
                     {
                        _loc2_ = true;
                     }
                     if(Boolean(_retarget) || _loc2_)
                     {
                        FindTargets(_loc1_,_priority);
                     }
                  }
               }
            }
         }
         if(_hasTargets)
         {
            _loc4_ = _targetCreeps[0].creep;
            _loc5_ = PATHING.FromISO(_loc4_._tmpPoint);
            _loc6_ = (_loc6_ = PATHING.FromISO(new Point(_mc.x,_mc.y))).add(new Point(35,35));
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if((_loc9_ = Math.atan2(_loc8_,_loc7_) * 57.2957795) < 0)
            {
               _loc9_ = 360 + _loc9_;
            }
            _loc9_ /= 12;
            _animTick = int(_loc9_);
            this.AnimFrame();
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
         super.Fire(param1);
         SOUNDS.Play("snipe1",!isJard ? 0.8 : 0.4);
         var _loc2_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc3_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc3_ = 1.25;
         }
         if(isJard)
         {
            _jarHealth.Add(-int(damage * _loc2_ * _loc3_));
            ATTACK.Damage(_mc.x,_mc.y + _top,damage * _loc2_ * _loc3_);
            if(_jarHealth.Get() <= 0)
            {
               KillJar();
            }
         }
         else
         {
            PROJECTILES.Spawn(new Point(_mc.x,_mc.y + _top),null,param1,_speed,int(damage * _loc2_ * _loc3_),false,_splash,attackFlags);
         }
      }
      
      override public function Description() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
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
               _upgradeDescription += KEYS.Get("building_rangeincrease",{
                  "v1":_loc3_,
                  "v2":_loc4_
               }) + "<br>";
            }
            if(_loc1_.damage < _loc2_.damage)
            {
               _upgradeDescription += KEYS.Get("building_dpsincrease",{
                  "v1":_loc1_.damage,
                  "v2":_loc2_.damage
               }) + "<br>";
            }
            if(_lvl.Get() > 1)
            {
               _upgradeDescription += KEYS.Get("building_sfpsincrease",{
                  "v1":this._targetArray[_lvl.Get() - 1],
                  "v2":this._targetArray[_lvl.Get()]
               }) + "<br>";
            }
         }
      }
      
      override public function Props() : void
      {
         super.Props();
      }
      
      override public function Upgraded() : void
      {
         super.Upgraded();
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function():void
            {
               GLOBAL.CallJS("sendFeed",["aatower-construct",KEYS.Get("pop_aabuilt_streamtitle"),KEYS.Get("pop_aabuilt_streambody"),"build-aerial.v2.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_aabuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_aabuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
   }
}
