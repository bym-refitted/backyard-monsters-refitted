package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   import gs.utils.tween.TweenInfo;
   
   public class FilterPlugin extends TweenPlugin
   {
      
      public static const VERSION:Number = 1.03;
      
      public static const API:Number = 1;
       
      
      protected var _target:Object;
      
      protected var _type:Class;
      
      protected var _filter:BitmapFilter;
      
      protected var _index:int;
      
      protected var _remove:Boolean;
      
      public function FilterPlugin()
      {
         super();
      }
      
      protected function initFilter(param1:Object, param2:BitmapFilter) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:HexColorsPlugin = null;
         var _loc3_:Array = this._target.filters;
         this._index = -1;
         if(param1.index != null)
         {
            this._index = param1.index;
         }
         else
         {
            _loc5_ = int(_loc3_.length - 1);
            while(_loc5_ > -1)
            {
               if(_loc3_[_loc5_] is this._type)
               {
                  this._index = _loc5_;
                  break;
               }
               _loc5_--;
            }
         }
         if(this._index == -1 || _loc3_[this._index] == null || param1.addFilter == true)
         {
            this._index = param1.index != null ? int(param1.index) : int(_loc3_.length);
            _loc3_[this._index] = param2;
            this._target.filters = _loc3_;
         }
         this._filter = _loc3_[this._index];
         this._remove = Boolean(param1.remove == true);
         if(this._remove)
         {
            this.onComplete = this.onCompleteTween;
         }
         var _loc7_:Object = param1.isTV == true ? param1.exposedVars : param1;
         for(_loc4_ in _loc7_)
         {
            if(!(!(_loc4_ in this._filter) || this._filter[_loc4_] == _loc7_[_loc4_] || _loc4_ == "remove" || _loc4_ == "index" || _loc4_ == "addFilter"))
            {
               if(_loc4_ == "color" || _loc4_ == "highlightColor" || _loc4_ == "shadowColor")
               {
                  (_loc6_ = new HexColorsPlugin()).initColor(this._filter,_loc4_,this._filter[_loc4_],_loc7_[_loc4_]);
                  _tweens[_tweens.length] = new TweenInfo(_loc6_,"changeFactor",0,1,_loc4_,false);
               }
               else if(_loc4_ == "quality" || _loc4_ == "inner" || _loc4_ == "knockout" || _loc4_ == "hideObject")
               {
                  this._filter[_loc4_] = _loc7_[_loc4_];
               }
               else
               {
                  addTween(this._filter,_loc4_,this._filter[_loc4_],_loc7_[_loc4_],_loc4_);
               }
            }
         }
      }
      
      public function onCompleteTween() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         if(this._remove)
         {
            _loc2_ = this._target.filters;
            if(!(_loc2_[this._index] is this._type))
            {
               _loc1_ = int(_loc2_.length - 1);
               while(_loc1_ > -1)
               {
                  if(_loc2_[_loc1_] is this._type)
                  {
                     _loc2_.splice(_loc1_,1);
                     break;
                  }
                  _loc1_--;
               }
            }
            else
            {
               _loc2_.splice(this._index,1);
            }
            this._target.filters = _loc2_;
         }
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TweenInfo = null;
         var _loc4_:Array = this._target.filters;
         _loc2_ = int(_tweens.length - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = _tweens[_loc2_];
            _loc3_.target[_loc3_.property] = _loc3_.start + _loc3_.change * param1;
            _loc2_--;
         }
         if(!(_loc4_[this._index] is this._type))
         {
            this._index = _loc4_.length - 1;
            _loc2_ = int(_loc4_.length - 1);
            while(_loc2_ > -1)
            {
               if(_loc4_[_loc2_] is this._type)
               {
                  this._index = _loc2_;
                  break;
               }
               _loc2_--;
            }
         }
         _loc4_[this._index] = this._filter;
         this._target.filters = _loc4_;
      }
   }
}
