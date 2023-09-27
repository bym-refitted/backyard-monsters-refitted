package
{
   import com.monsters.interfaces.IAttackable;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class INFERNO_CANNON_TOWER extends BTOWER
   {
      
      public static const TYPE:int = 130;
       
      
      public function INFERNO_CANNON_TOWER()
      {
         super();
         _frameNumber = 0;
         _type = TYPE;
         _top = -25;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         SetProps();
         Props();
      }
      
      override public function TickAttack() : void
      {
         super.TickAttack();
         Rotate();
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
         SOUNDS.Play("icannon");
         var _loc2_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc3_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc3_ = 1.25;
         }
         PROJECTILES.Spawn(new Point(_mc.x,_mc.y + _top),null,param1,_speed,int(damage * _loc2_ * _loc3_),false,_splash,Targeting.getOldStyleTargets(-1));
      }
   }
}
