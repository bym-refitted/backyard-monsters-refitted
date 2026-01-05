package
{
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Point;
   
   public class ProjectileBase extends EventDispatcher implements ITargetable
   {
       
      
      public var _startPoint:Point;
      
      public var _targetPoint:Point;
      
      public var _speed:Number;
      
      public var _yd:Number;
      
      public var _xd:Number;
      
      public var _newX:int;
      
      public var _newY:int;
      
      public var _damage:Number;
      
      public var _splash:Number;
      
      public var _maxSpeed:Number;
      
      public var _graphic:MovieClip;
      
      public var _rotation:Number;
      
      public var _targetRotation:Number;
      
      public var _rotationDifference:Number;
      
      public var _rotationChange:Number;
      
      public var _rotationEasing:Number;
      
      public var _startDistance:int;
      
      public var _distance:int;
      
      public var _targetType:int;
      
      public var _tmpX:Number;
      
      public var _tmpY:Number;
      
      public var _xChange:Number;
      
      public var _yChange:Number;
      
      public var _id:int;
      
      public var _frameNumber:int = 4;
      
      public var _glaves:int = 0;
      
      public var _source:IAttackable;
      
      public function ProjectileBase(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get x() : Number
      {
         return this._graphic.x;
      }
      
      public function get y() : Number
      {
         return this._graphic.y;
      }
      
      public function get defenseFlags() : int
      {
         return 0;
      }
   }
}
