package gs.plugins
{
   import gs.*;
   
   public class AutoAlphaPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      protected var _tweenVisible:Boolean;
      
      protected var _visible:Boolean;
      
      protected var _tween:TweenLite;
      
      protected var _target:Object;
      
      public function AutoAlphaPlugin()
      {
         super();
         this.propName = "autoAlpha";
         this.overwriteProps = ["alpha","visible"];
         this.onComplete = this.onCompleteTween;
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         this._target = param1;
         this._tween = param3;
         this._visible = Boolean(param2 != 0);
         this._tweenVisible = true;
         addTween(param1,"alpha",param1.alpha,param2,"alpha");
         return true;
      }
      
      override public function killProps(param1:Object) : void
      {
         super.killProps(param1);
         this._tweenVisible = !Boolean("visible" in param1);
      }
      
      public function onCompleteTween() : void
      {
         if(this._tweenVisible && this._tween.vars.runBackwards != true && this._tween.ease == this._tween.vars.ease)
         {
            this._target.visible = this._visible;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         updateTweens(param1);
         if(this._target.visible != true && this._tweenVisible)
         {
            this._target.visible = true;
         }
      }
   }
}
