package
{
   import com.monsters.interfaces.ICoreBuilding;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GuardTower extends BTOWER implements ICoreBuilding
   {
      
      public static const k_SPECIAL_ANGLE:Point = new Point(90,180);
      
      private static var m_teslaPositions:Vector.<TeslaData>;
      
      private static var m_teslaDamagedPositions:Vector.<TeslaData>;
      
      public static const k_TYPE:int = 138;
       
      
      private var m_lastDamagedState:Boolean;
      
      private var m_teslas:Vector.<GuardTowerTesla>;
      
      private var m_tick:int;
      
      private var m_isAttacking:Boolean;
      
      public function GuardTower()
      {
         super();
         m_teslaPositions = Vector.<TeslaData>([new TeslaData(new Point(-0.5,-68),new Point(-180,0)),new TeslaData(new Point(58,-37),new Point(-90,90)),new TeslaData(new Point(-0.5,-7),new Point(0,180)),new TeslaData(new Point(-59,-40),k_SPECIAL_ANGLE)]);
         m_teslaDamagedPositions = Vector.<TeslaData>([new TeslaData(new Point(-0.5,-68),new Point(-180,0)),new TeslaData(new Point(58,-26),new Point(-90,90)),new TeslaData(new Point(-6,-7),new Point(0,180)),new TeslaData(new Point(-67,-53),k_SPECIAL_ANGLE)]);
         this.m_teslas = new Vector.<GuardTowerTesla>();
         _animRandomStart = false;
         _footprint = [new Rectangle(0,0,130,130)];
         _gridCost = [[new Rectangle(0,0,130,130),10],[new Rectangle(10,10,110,110),200]];
         _type = k_TYPE;
         SetProps();
         graphic.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      override public function ApplyJar(param1:int) : void
      {
      }
      
      override protected function onEnterFrame(param1:Event) : void
      {
         if(!_mcHit.parent)
         {
            return;
         }
         anim2Container.visible = false;
         ++this.m_tick;
         AnimFrame(true);
         if(this.m_tick % 2 == 0)
         {
            --_animTick;
         }
         anim2Container.visible = this.m_isAttacking;
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         this.setupTeslas();
         GLOBAL.setTownHall(this);
      }
      
      override public function Cancel() : void
      {
         GLOBAL.setTownHall(null);
         super.Cancel();
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL.setTownHall(this);
      }
      
      private function setupTeslas() : void
      {
         var _loc2_:GuardTowerTesla = null;
         var _loc1_:int = 0;
         while(_loc1_ < m_teslaPositions.length)
         {
            _loc2_ = new GuardTowerTesla(damage,_range,m_teslaPositions[_loc1_].angleRange,_rate);
            if(_loc1_ == 0)
            {
               _loc2_.parent = MAP._CREEPSMC;
            }
            this.m_teslas.push(_loc2_);
            _loc1_++;
         }
         this.updateTeslaPositions();
      }
      
      private function updateTeslas() : void
      {
         var _loc2_:GuardTowerTesla = null;
         this.m_isAttacking = false;
         var _loc1_:int = 0;
         while(_loc1_ < this.m_teslas.length)
         {
            _loc2_ = this.m_teslas[_loc1_];
            _loc2_.tick();
            if(_loc2_.target)
            {
               this.m_isAttacking = true;
            }
            _loc1_++;
         }
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
         if(isDamaged != this.m_lastDamagedState && Boolean(this.m_teslas))
         {
            this.updateTeslaPositions();
         }
      }
      
      private function updateTeslaPositions() : void
      {
         var _loc1_:Point = new Point(x,y);
         var _loc2_:Vector.<TeslaData> = isDamaged ? m_teslaDamagedPositions : m_teslaPositions;
         var _loc3_:int = 0;
         while(_loc3_ < this.m_teslas.length)
         {
            this.m_teslas[_loc3_].moveTo(_loc1_.add(_loc2_[_loc3_].position));
            _loc3_++;
         }
         this.m_lastDamagedState = isDamaged;
      }
      
      override public function TickAttack() : void
      {
         super.TickAttack();
         if(Boolean(this.m_teslas) && canAttack)
         {
            this.updateTeslas();
         }
      }
      
      override protected function onMove() : void
      {
         this.updateTeslaPositions();
      }
   }
}

import com.monsters.interfaces.ITickable;
import com.monsters.monsters.MonsterBase;
import com.monsters.utils.MathUtils;
import flash.display.DisplayObjectContainer;
import flash.geom.Point;

class GuardTowerTesla implements ITickable
{
    
   
   public var parent:DisplayObjectContainer;
   
   private var m_x:Number;
   
   private var m_y:Number;
   
   private var m_target:MonsterBase;
   
   private var m_damage:Number;
   
   private var m_range:Number;
   
   private var m_attackSpeed:Number;
   
   private var m_angleRange:Point;
   
   private var m_timeAbleToFire:Number;
   
   public function GuardTowerTesla(param1:Number, param2:Number, param3:Point, param4:Number = 0)
   {
      super();
      this.m_timeAbleToFire = 0;
      this.m_damage = param1;
      this.m_attackSpeed = param4;
      this.m_range = param2;
      this.m_angleRange = param3;
   }
   
   public function get target() : MonsterBase
   {
      return this.m_target;
   }
   
   public function tick(param1:int = 1) : void
   {
      if(!this.m_target || this.m_target.health <= 0 || !this.m_target.isTargetable)
      {
         this.m_target = this.getTarget();
      }
      if(this.m_target)
      {
         if(Math.random() > 0.5)
         {
            EFFECTS.Lightning(this.m_x,this.m_y,this.m_target.x,this.m_target.getDisplayY(),this.parent);
         }
         if(Number(GLOBAL.Timestamp()) >= this.m_timeAbleToFire)
         {
            this.fire();
         }
      }
   }
   
   private function fire() : void
   {
      SOUNDS.Play("lightningfire",0.8);
      EFFECTS.Lightning(this.m_x,this.m_y,this.m_target.x,this.m_target.getDisplayY(),this.parent);
      this.m_target.modifyHealth(-this.m_damage,this.m_target);
      this.m_timeAbleToFire = Number(GLOBAL.Timestamp()) + this.m_attackSpeed;
   }
   
   public function moveTo(param1:Point) : void
   {
      this.m_x = param1.x;
      this.m_y = param1.y;
   }
   
   private function getTarget() : MonsterBase
   {
      var _loc3_:MonsterBase = null;
      var _loc4_:Number = NaN;
      var _loc1_:Array = Targeting.getCreepsInRange(this.m_range,new Point(this.m_x,this.m_y),Targeting.k_TARGETS_FLYING | Targeting.k_TARGETS_GROUND | Targeting.k_TARGETS_ATTACKERS);
      if(_loc1_.length <= 0)
      {
         return null;
      }
      _loc1_.sortOn(["dist"],Array.NUMERIC);
      var _loc2_:int = 0;
      while(_loc2_ < _loc1_.length)
      {
         _loc3_ = _loc1_[_loc2_].creep as MonsterBase;
         _loc4_ = MathUtils.getAngleBetweenTwoPointsInDegrees(new Point(this.m_x,this.m_y),new Point(_loc3_.x,_loc3_.y));
         if(this.m_angleRange == GuardTower.k_SPECIAL_ANGLE)
         {
            _loc4_ = Math.abs(_loc4_);
         }
         if(_loc4_ >= this.m_angleRange.x && _loc4_ <= this.m_angleRange.y)
         {
            return _loc3_;
         }
         _loc2_++;
      }
      return null;
   }
}

import flash.geom.Point;

class TeslaData
{
    
   
   public var position:Point;
   
   public var angleRange:Point;
   
   public function TeslaData(param1:Point, param2:Point)
   {
      super();
      this.position = param1;
      this.angleRange = param2;
   }
}
