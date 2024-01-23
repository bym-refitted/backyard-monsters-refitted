package gs.plugins
{
   import gs.*;
   import gs.utils.tween.*;
   
   public class TweenPlugin
   {
      
      public static const VERSION:Number = 1.03;
      
      public static const API:Number = 1;
       
      
      public var propName:String;
      
      public var overwriteProps:Array;
      
      public var round:Boolean;
      
      public var onComplete:Function;
      
      protected var _tweens:Array;
      
      protected var _changeFactor:Number = 0;
      
      public function TweenPlugin()
      {
         this._tweens = [];
         super();
      }
      
      public static function activate(param1:Array) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         _loc2_ = int(param1.length - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = new param1[_loc2_]();
            TweenLite.plugins[_loc3_.propName] = param1[_loc2_];
            _loc2_--;
         }
         return true;
      }
      
      public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         this.addTween(param1,this.propName,param1[this.propName],param2,this.propName);
         return true;
      }
      
      protected function addTween(param1:Object, param2:String, param3:Number, param4:*, param5:String = null) : void
      {
         var _loc6_:Number = NaN;
         if(param4 != null)
         {
            if((_loc6_ = typeof param4 == "number" ? param4 - param3 : Number(param4)) != 0)
            {
               this._tweens[this._tweens.length] = new TweenInfo(param1,param2,param3,_loc6_,param5 || param2,false);
            }
         }
      }
      
      protected function updateTweens(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TweenInfo = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this.round)
         {
            _loc2_ = int(this._tweens.length - 1);
            while(_loc2_ > -1)
            {
               _loc3_ = this._tweens[_loc2_];
               _loc5_ = (_loc4_ = _loc3_.start + _loc3_.change * param1) < 0 ? -1 : 1;
               _loc3_.target[_loc3_.property] = _loc4_ % 1 * _loc5_ > 0.5 ? int(_loc4_) + _loc5_ : int(_loc4_);
               _loc2_--;
            }
         }
         else
         {
            _loc2_ = int(this._tweens.length - 1);
            while(_loc2_ > -1)
            {
               _loc3_ = this._tweens[_loc2_];
               _loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
               _loc2_--;
            }
         }
      }
      
      public function set changeFactor(param1:Number) : void
      {
         this.updateTweens(param1);
         this._changeFactor = param1;
      }
      
      public function get changeFactor() : Number
      {
         return this._changeFactor;
      }
      
      public function killProps(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(this.overwriteProps.length - 1);
         while(_loc2_ > -1)
         {
            if(this.overwriteProps[_loc2_] in param1)
            {
               this.overwriteProps.splice(_loc2_,1);
            }
            _loc2_--;
         }
         _loc2_ = int(this._tweens.length - 1);
         while(_loc2_ > -1)
         {
            if(this._tweens[_loc2_].name in param1)
            {
               this._tweens.splice(_loc2_,1);
            }
            _loc2_--;
         }
      }
   }
}
