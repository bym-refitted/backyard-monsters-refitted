package gs
{
   import flash.events.*;
   import flash.utils.*;
   import gs.events.TweenEvent;
   import gs.plugins.*;
   import gs.utils.tween.*;
   
   public class TweenMax extends TweenLite implements IEventDispatcher
   {
      
      public static const version:Number = 10.12;
      
      private static var _activatedPlugins:Boolean = TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin,HexColorsPlugin,BlurFilterPlugin,ColorMatrixFilterPlugin,BevelFilterPlugin,DropShadowFilterPlugin,GlowFilterPlugin,RoundPropsPlugin,BezierPlugin,BezierThroughPlugin,ShortRotationPlugin]);
      
      private static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init();
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var removeTween:Function = TweenLite.removeTween;
      
      protected static var _pausedTweens:Dictionary = new Dictionary(false);
      
      protected static var _globalTimeScale:Number = 1;
       
      
      protected var _dispatcher:EventDispatcher;
      
      protected var _callbacks:Object;
      
      protected var _repeatCount:Number;
      
      protected var _timeScale:Number;
      
      public var pauseTime:Number;
      
      public function TweenMax(param1:Object, param2:Number, param3:Object)
      {
         super(param1,param2,param3);
         if(TweenLite.version < 10.092)
         {
         }
         if(this.combinedTimeScale != 1 && this.target is TweenMax)
         {
            this._timeScale = 1;
            this.combinedTimeScale = _globalTimeScale;
         }
         else
         {
            this._timeScale = this.combinedTimeScale;
            this.combinedTimeScale *= _globalTimeScale;
         }
         if(this.combinedTimeScale != 1 && this.delay != 0)
         {
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
         }
         if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
         {
            this.initDispatcher();
            if(param2 == 0 && this.delay == 0)
            {
               this.onUpdateDispatcher();
               this.onCompleteDispatcher();
            }
         }
         this._repeatCount = 0;
         if(!isNaN(this.vars.yoyo) || !isNaN(this.vars.loop))
         {
            this.vars.persist = true;
         }
         if(this.delay == 0 && this.vars.startAt != null)
         {
            this.vars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.vars.startAt);
         }
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         return new TweenMax(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenMax
      {
         param3.runBackwards = true;
         return new TweenMax(param1,param2,param3);
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenMax
      {
         return new TweenMax(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "persist":param4,
            "overwrite":0
         });
      }
      
      public static function setGlobalTimeScale(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         if(param1 < 0.00001)
         {
            param1 = 0.00001;
         }
         var _loc2_:Dictionary = masterList;
         _globalTimeScale = param1;
         for each(_loc4_ in _loc2_)
         {
            _loc3_ = _loc4_.length - 1;
            while(_loc3_ > -1)
            {
               if(_loc4_[_loc3_] is TweenMax)
               {
                  _loc4_[_loc3_].timeScale *= 1;
               }
               _loc3_--;
            }
         }
      }
      
      public static function getTweensOf(param1:Object) : Array
      {
         var _loc4_:TweenLite = null;
         var _loc5_:int = 0;
         var _loc2_:Array = masterList[param1];
         var _loc3_:Array = [];
         if(_loc2_ != null)
         {
            _loc5_ = int(_loc2_.length - 1);
            while(_loc5_ > -1)
            {
               if(!_loc2_[_loc5_].gc)
               {
                  _loc3_[_loc3_.length] = _loc2_[_loc5_];
               }
               _loc5_--;
            }
         }
         for each(_loc4_ in _pausedTweens)
         {
            if(_loc4_.target == param1)
            {
               _loc3_[_loc3_.length] = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public static function isTweening(param1:Object) : Boolean
      {
         var _loc2_:Array = getTweensOf(param1);
         var _loc3_:int = int(_loc2_.length - 1);
         while(_loc3_ > -1)
         {
            if((_loc2_[_loc3_].active || _loc2_[_loc3_].startTime == currentTime) && !_loc2_[_loc3_].gc)
            {
               return true;
            }
            _loc3_--;
         }
         return false;
      }
      
      public static function getAllTweens() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TweenLite = null;
         var _loc1_:Dictionary = masterList;
         var _loc2_:Array = [];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = int(_loc3_.length - 1);
            while(_loc4_ > -1)
            {
               if(!_loc3_[_loc4_].gc)
               {
                  _loc2_[_loc2_.length] = _loc3_[_loc4_];
               }
               _loc4_--;
            }
         }
         for each(_loc5_ in _pausedTweens)
         {
            _loc2_[_loc2_.length] = _loc5_;
         }
         return _loc2_;
      }
      
      public static function killAllTweens(param1:Boolean = false) : void
      {
         killAll(param1,true,false);
      }
      
      public static function killAllDelayedCalls(param1:Boolean = false) : void
      {
         killAll(param1,false,true);
      }
      
      public static function killAll(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc5_:* = false;
         var _loc6_:int = 0;
         var _loc4_:Array;
         _loc6_ = int((_loc4_ = getAllTweens()).length - 1);
         while(_loc6_ > -1)
         {
            if((_loc5_ = _loc4_[_loc6_].target == _loc4_[_loc6_].vars.onComplete) == param3 || _loc5_ != param2)
            {
               if(param1)
               {
                  _loc4_[_loc6_].complete(false);
                  _loc4_[_loc6_].clear();
               }
               else
               {
                  TweenLite.removeTween(_loc4_[_loc6_],true);
               }
            }
            _loc6_--;
         }
      }
      
      public static function pauseAll(param1:Boolean = true, param2:Boolean = false) : void
      {
         changePause(true,param1,param2);
      }
      
      public static function resumeAll(param1:Boolean = true, param2:Boolean = false) : void
      {
         changePause(false,param1,param2);
      }
      
      public static function changePause(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
      {
         var _loc5_:* = false;
         var _loc4_:Array;
         var _loc6_:int = int((_loc4_ = getAllTweens()).length - 1);
         while(_loc6_ > -1)
         {
            _loc5_ = _loc4_[_loc6_].target == _loc4_[_loc6_].vars.onComplete;
            if(_loc4_[_loc6_] is TweenMax && (_loc5_ == param3 || _loc5_ != param2))
            {
               _loc4_[_loc6_].paused = param1;
            }
            _loc6_--;
         }
      }
      
      public static function set globalTimeScale(param1:Number) : void
      {
         setGlobalTimeScale(param1);
      }
      
      public static function get globalTimeScale() : Number
      {
         return _globalTimeScale;
      }
      
      override public function initTweenVals() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:TweenInfo = null;
         if(this.vars.startAt != null && this.delay != 0)
         {
            this.vars.startAt.overwrite = 0;
            new TweenMax(this.target,0,this.vars.startAt);
         }
         super.initTweenVals();
         if(this.exposedVars.roundProps is Array && TweenLite.plugins.roundProps != null)
         {
            _loc1_ = int((_loc5_ = this.exposedVars.roundProps).length - 1);
            while(_loc1_ > -1)
            {
               _loc3_ = String(_loc5_[_loc1_]);
               _loc2_ = int(this.tweens.length - 1);
               while(_loc2_ > -1)
               {
                  if((_loc7_ = this.tweens[_loc2_]).name == _loc3_)
                  {
                     if(_loc7_.isPlugin)
                     {
                        _loc7_.target.round = true;
                     }
                     else if(_loc6_ == null)
                     {
                        (_loc6_ = new TweenLite.plugins.roundProps()).add(_loc7_.target,_loc3_,_loc7_.start,_loc7_.change);
                        _hasPlugins = true;
                        this.tweens[_loc2_] = new TweenInfo(_loc6_,"changeFactor",0,1,_loc3_,true);
                     }
                     else
                     {
                        _loc6_.add(_loc7_.target,_loc3_,_loc7_.start,_loc7_.change);
                        this.tweens.splice(_loc2_,1);
                     }
                  }
                  else if(_loc7_.isPlugin && _loc7_.name == "_MULTIPLE_" && !_loc7_.target.round)
                  {
                     if((_loc4_ = " " + _loc7_.target.overwriteProps.join(" ") + " ").indexOf(" " + _loc3_ + " ") != -1)
                     {
                        _loc7_.target.round = true;
                     }
                  }
                  _loc2_--;
               }
               _loc1_--;
            }
         }
      }
      
      public function pause() : void
      {
         if(isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.enabled = false;
            _pausedTweens[this] = this;
         }
      }
      
      public function resume() : void
      {
         this.enabled = true;
         if(!isNaN(this.pauseTime))
         {
            this.initTime += currentTime - this.pauseTime;
            this.startTime = this.initTime + this.delay * (1000 / this.combinedTimeScale);
            this.pauseTime = NaN;
            if(!this.started && currentTime >= this.startTime)
            {
               activate();
            }
            else
            {
               this.active = this.started;
            }
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
      }
      
      public function restart(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.initTime = currentTime;
            this.startTime = currentTime + this.delay * (1000 / this.combinedTimeScale);
         }
         else
         {
            this.startTime = currentTime;
            this.initTime = currentTime - this.delay * (1000 / this.combinedTimeScale);
         }
         this._repeatCount = 0;
         if(this.target != this.vars.onComplete)
         {
            this.render(this.startTime);
         }
         this.pauseTime = NaN;
         _pausedTweens[this] = null;
         delete _pausedTweens[this];
         this.enabled = true;
      }
      
      public function reverse(param1:Boolean = true, param2:Boolean = true) : void
      {
         this.ease = this.vars.ease == this.ease ? this.reverseEase : this.vars.ease;
         var _loc3_:Number = this.progress;
         if(param1 && _loc3_ > 0)
         {
            this.startTime = currentTime - (1 - _loc3_) * this.duration * 1000 / this.combinedTimeScale;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         if(param2 != false)
         {
            if(_loc3_ < 1)
            {
               this.resume();
            }
            else
            {
               this.restart();
            }
         }
      }
      
      public function reverseEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.ease(param4 - param1,param2,param3,param4);
      }
      
      public function invalidate(param1:Boolean = true) : void
      {
         var _loc2_:Number = NaN;
         if(this.initted)
         {
            _loc2_ = this.progress;
            if(!param1 && _loc2_ != 0)
            {
               this.progress = 0;
            }
            this.tweens = [];
            _hasPlugins = false;
            this.exposedVars = this.vars.isTV == true ? this.vars.exposedProps : this.vars;
            this.initTweenVals();
            this._timeScale = Number(this.vars.timeScale) || 1;
            this.combinedTimeScale = this._timeScale * _globalTimeScale;
            this.delay = Number(this.vars.delay) || 0;
            if(isNaN(this.pauseTime))
            {
               this.startTime = this.initTime + this.delay * 1000 / this.combinedTimeScale;
            }
            if(this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
            {
               if(this._dispatcher != null)
               {
                  this.vars.onStart = this._callbacks.onStart;
                  this.vars.onUpdate = this._callbacks.onUpdate;
                  this.vars.onComplete = this._callbacks.onComplete;
                  this._dispatcher = null;
               }
               this.initDispatcher();
            }
            if(_loc2_ != 0)
            {
               if(param1)
               {
                  this.adjustStartValues();
               }
               else
               {
                  this.progress = _loc2_;
               }
            }
         }
      }
      
      public function setDestination(param1:String, param2:*, param3:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:TweenInfo = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Array = null;
         var _loc10_:Boolean = false;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc4_:Number = this.progress;
         if(this.initted)
         {
            if(!param3)
            {
               _loc5_ = int(this.tweens.length - 1);
               while(_loc5_ > -1)
               {
                  if((_loc6_ = this.tweens[_loc5_]).name == param1)
                  {
                     _loc6_.target[_loc6_.property] = _loc6_.start;
                  }
                  _loc5_--;
               }
            }
            _loc7_ = this.vars;
            _loc8_ = this.exposedVars;
            _loc9_ = this.tweens;
            _loc10_ = _hasPlugins;
            this.tweens = [];
            this.vars = this.exposedVars = {};
            this.vars[param1] = param2;
            this.initTweenVals();
            if(this.ease != this.reverseEase && _loc7_.ease is Function)
            {
               this.ease = _loc7_.ease;
            }
            if(param3 && _loc4_ != 0)
            {
               this.adjustStartValues();
            }
            _loc11_ = this.tweens;
            this.vars = _loc7_;
            this.exposedVars = _loc8_;
            this.tweens = _loc9_;
            (_loc12_ = {})[param1] = true;
            _loc5_ = int(this.tweens.length - 1);
            while(_loc5_ > -1)
            {
               if((_loc6_ = this.tweens[_loc5_]).name == param1)
               {
                  this.tweens.splice(_loc5_,1);
               }
               else if(_loc6_.isPlugin && _loc6_.name == "_MULTIPLE_")
               {
                  _loc6_.target.killProps(_loc12_);
                  if(_loc6_.target.overwriteProps.length == 0)
                  {
                     this.tweens.splice(_loc5_,1);
                  }
               }
               _loc5_--;
            }
            this.tweens = this.tweens.concat(_loc11_);
            _hasPlugins = Boolean(_loc10_ || _hasPlugins);
         }
         this.vars[param1] = this.exposedVars[param1] = param2;
      }
      
      protected function adjustStartValues() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:TweenInfo = null;
         var _loc6_:int = 0;
         var _loc1_:Number = this.progress;
         if(_loc1_ != 0)
         {
            _loc2_ = this.ease(_loc1_,0,1,1);
            _loc3_ = 1 / (1 - _loc2_);
            _loc6_ = int(this.tweens.length - 1);
            while(_loc6_ > -1)
            {
               _loc4_ = (_loc5_ = this.tweens[_loc6_]).start + _loc5_.change;
               if(_loc5_.isPlugin)
               {
                  _loc5_.change = (_loc4_ - _loc2_) * _loc3_;
               }
               else
               {
                  _loc5_.change = (_loc4_ - _loc5_.target[_loc5_.property]) * _loc3_;
               }
               _loc5_.start = _loc4_ - _loc5_.change;
               _loc6_--;
            }
         }
      }
      
      public function killProperties(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = {};
         _loc3_ = int(param1.length - 1);
         while(_loc3_ > -1)
         {
            _loc2_[param1[_loc3_]] = true;
            _loc3_--;
         }
         killVars(_loc2_);
      }
      
      override public function render(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:TweenInfo = null;
         var _loc5_:int = 0;
         var _loc2_:Number = (param1 - this.startTime) * 0.001 * this.combinedTimeScale;
         if(_loc2_ >= this.duration)
         {
            _loc2_ = this.duration;
            _loc3_ = this.ease == this.vars.ease || this.duration == 0.001 ? 1 : 0;
         }
         else
         {
            _loc3_ = this.ease(_loc2_,0,1,this.duration);
         }
         _loc5_ = int(this.tweens.length - 1);
         while(_loc5_ > -1)
         {
            (_loc4_ = this.tweens[_loc5_]).target[_loc4_.property] = _loc4_.start + _loc3_ * _loc4_.change;
            _loc5_--;
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            this.complete(true);
         }
      }
      
      override public function complete(param1:Boolean = false) : void
      {
         if(!isNaN(this.vars.yoyo) && (this._repeatCount < this.vars.yoyo || this.vars.yoyo == 0) || !isNaN(this.vars.loop) && (this._repeatCount < this.vars.loop || this.vars.loop == 0))
         {
            ++this._repeatCount;
            if(!isNaN(this.vars.yoyo))
            {
               this.ease = this.vars.ease == this.ease ? this.reverseEase : this.vars.ease;
            }
            this.startTime = param1 ? this.startTime + this.duration * (1000 / this.combinedTimeScale) : currentTime;
            this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         }
         else if(this.vars.persist == true)
         {
            this.pause();
         }
         super.complete(param1);
      }
      
      protected function initDispatcher() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         if(this._dispatcher == null)
         {
            this._dispatcher = new EventDispatcher(this);
            this._callbacks = {
               "onStart":this.vars.onStart,
               "onUpdate":this.vars.onUpdate,
               "onComplete":this.vars.onComplete
            };
            if(this.vars.isTV == true)
            {
               this.vars = this.vars.clone();
            }
            else
            {
               _loc1_ = {};
               for(_loc2_ in this.vars)
               {
                  _loc1_[_loc2_] = this.vars[_loc2_];
               }
               this.vars = _loc1_;
            }
            this.vars.onStart = this.onStartDispatcher;
            this.vars.onComplete = this.onCompleteDispatcher;
            if(this.vars.onStartListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.START,this.vars.onStartListener,false,0,true);
            }
            if(this.vars.onUpdateListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.UPDATE,this.vars.onUpdateListener,false,0,true);
               this.vars.onUpdate = this.onUpdateDispatcher;
               _hasUpdate = true;
            }
            if(this.vars.onCompleteListener is Function)
            {
               this._dispatcher.addEventListener(TweenEvent.COMPLETE,this.vars.onCompleteListener,false,0,true);
            }
         }
      }
      
      protected function onStartDispatcher(... rest) : void
      {
         if(this._callbacks.onStart != null)
         {
            this._callbacks.onStart.apply(null,this.vars.onStartParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
      }
      
      protected function onUpdateDispatcher(... rest) : void
      {
         if(this._callbacks.onUpdate != null)
         {
            this._callbacks.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
      }
      
      protected function onCompleteDispatcher(... rest) : void
      {
         if(this._callbacks.onComplete != null)
         {
            this._callbacks.onComplete.apply(null,this.vars.onCompleteParams);
         }
         this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(this._dispatcher == null)
         {
            this.initDispatcher();
         }
         if(param1 == TweenEvent.UPDATE && this.vars.onUpdate != this.onUpdateDispatcher)
         {
            this.vars.onUpdate = this.onUpdateDispatcher;
            _hasUpdate = true;
         }
         this._dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(this._dispatcher != null)
         {
            this._dispatcher.removeEventListener(param1,param2,param3);
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(this._dispatcher == null)
         {
            return false;
         }
         return this._dispatcher.dispatchEvent(param1);
      }
      
      public function get paused() : Boolean
      {
         return !isNaN(this.pauseTime);
      }
      
      public function set paused(param1:Boolean) : void
      {
         if(param1)
         {
            this.pause();
         }
         else
         {
            this.resume();
         }
      }
      
      public function get reversed() : Boolean
      {
         return this.ease == this.reverseEase;
      }
      
      public function set reversed(param1:Boolean) : void
      {
         if(this.reversed != param1)
         {
            this.reverse();
         }
      }
      
      public function get timeScale() : Number
      {
         return this._timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         if(param1 < 0.00001)
         {
            param1 = this._timeScale = 0.00001;
         }
         else
         {
            this._timeScale = param1;
            param1 *= _globalTimeScale;
         }
         this.initTime = currentTime - (currentTime - this.initTime - this.delay * (1000 / this.combinedTimeScale)) * this.combinedTimeScale * (1 / param1) - this.delay * (1000 / param1);
         if(this.startTime != 999999999999999)
         {
            this.startTime = this.initTime + this.delay * (1000 / param1);
         }
         this.combinedTimeScale = param1;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(!param1)
         {
            _pausedTweens[this] = null;
            delete _pausedTweens[this];
         }
         super.enabled = param1;
         if(param1)
         {
            this.combinedTimeScale = this._timeScale * _globalTimeScale;
         }
      }
      
      public function get repeatCount() : Number
      {
         return this._repeatCount;
      }
      
      public function set repeatCount(param1:Number) : void
      {
         this._repeatCount = param1;
      }
      
      public function get progress() : Number
      {
         var _loc1_:Number = !isNaN(this.pauseTime) ? this.pauseTime : currentTime;
         var _loc2_:Number = ((_loc1_ - this.initTime) * 0.001 - this.delay / this.combinedTimeScale) / this.duration * this.combinedTimeScale;
         if(_loc2_ > 1)
         {
            return 1;
         }
         if(_loc2_ < 0)
         {
            return 0;
         }
         return _loc2_;
      }
      
      public function set progress(param1:Number) : void
      {
         this.startTime = currentTime - this.duration * param1 * 1000;
         this.initTime = this.startTime - this.delay * (1000 / this.combinedTimeScale);
         if(!this.started)
         {
            activate();
         }
         this.render(currentTime);
         if(!isNaN(this.pauseTime))
         {
            this.pauseTime = currentTime;
            this.startTime = 999999999999999;
            this.active = false;
         }
      }
   }
}
