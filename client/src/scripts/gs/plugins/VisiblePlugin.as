package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class VisiblePlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _tween:TweenLite;
      
      protected var _visible:Boolean;
      
      public function VisiblePlugin()
      {
         super();
         this.propName = "visible";
         this.overwriteProps = ["visible"];
         this.onComplete = this.onCompleteTween;
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         this._target = param1;
         this._tween = param3;
         this._visible = Boolean(param2);
         return true;
      }
      
      public function onCompleteTween() : void
      {
         if(this._tween.vars.runBackwards != true && this._tween.ease == this._tween.vars.ease)
         {
            this._target.visible = this._visible;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         if(this._target.visible != true)
         {
            this._target.visible = true;
         }
      }
   }
}
