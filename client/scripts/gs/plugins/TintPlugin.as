package gs.plugins
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   import gs.*;
   import gs.utils.tween.TweenInfo;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.1;
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
       
      
      protected var _target:DisplayObject;
      
      protected var _ct:ColorTransform;
      
      protected var _ignoreAlpha:Boolean;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is DisplayObject))
         {
            return false;
         }
         var _loc4_:ColorTransform = new ColorTransform();
         if(param2 != null && param3.exposedVars.removeTint != true)
         {
            _loc4_.color = uint(param2);
         }
         this._ignoreAlpha = true;
         this.init(param1 as DisplayObject,_loc4_);
         return true;
      }
      
      public function init(param1:DisplayObject, param2:ColorTransform) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         this._target = param1;
         this._ct = this._target.transform.colorTransform;
         _loc3_ = int(_props.length - 1);
         while(_loc3_ > -1)
         {
            _loc4_ = String(_props[_loc3_]);
            if(this._ct[_loc4_] != param2[_loc4_])
            {
               _tweens[_tweens.length] = new TweenInfo(this._ct,_loc4_,this._ct[_loc4_],param2[_loc4_] - this._ct[_loc4_],"tint",false);
            }
            _loc3_--;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:ColorTransform = null;
         updateTweens(param1);
         if(this._ignoreAlpha)
         {
            _loc2_ = this._target.transform.colorTransform;
            this._ct.alphaMultiplier = _loc2_.alphaMultiplier;
            this._ct.alphaOffset = _loc2_.alphaOffset;
         }
         this._target.transform.colorTransform = this._ct;
      }
   }
}
