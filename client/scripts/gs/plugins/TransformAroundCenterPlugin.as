package gs.plugins
{
   import flash.display.*;
   import flash.geom.*;
   import gs.*;
   
   public class TransformAroundCenterPlugin extends TransformAroundPointPlugin
   {
      
      public static const VERSION:Number = 1.02;
      
      public static const API:Number = 1;
       
      
      public function TransformAroundCenterPlugin()
      {
         super();
         this.propName = "transformAroundCenter";
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         var _loc6_:Sprite = null;
         var _loc4_:Boolean = false;
         if(param1.parent == null)
         {
            _loc4_ = true;
            (_loc6_ = new Sprite()).addChild(param1 as DisplayObject);
         }
         var _loc5_:Rectangle = param1.getBounds(param1.parent);
         param2.point = new Point(_loc5_.x + _loc5_.width / 2,_loc5_.y + _loc5_.height / 2);
         if(_loc4_)
         {
            param1.parent.removeChild(param1);
         }
         return super.onInitTween(param1,param2,param3);
      }
   }
}
