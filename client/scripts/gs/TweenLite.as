package gs
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import gs.plugins.*;
   import gs.utils.tween.*;
   
   public class TweenLite
   {
      
      public static const version:Number = 10.092;
      
      public static var plugins:Object = {};
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      public static var overwriteManager:Object;
      
      public static var currentTime:uint;
      
      public static var masterList:Dictionary = new Dictionary(false);
      
      public static var timingSprite:Sprite = new Sprite();
      
      private static var _tlInitted:Boolean;
      
      private static var _timer:Timer = new Timer(2000);
      
      protected static var _reservedProps:Object = {
         "ease":1,
         "delay":1,
         "overwrite":1,
         "onComplete":1,
         "onCompleteParams":1,
         "runBackwards":1,
         "startAt":1,
         "onUpdate":1,
         "onUpdateParams":1,
         "roundProps":1,
         "onStart":1,
         "onStartParams":1,
         "persist":1,
         "renderOnStart":1,
         "proxiedEase":1,
         "easeParams":1,
         "yoyo":1,
         "loop":1,
         "onCompleteListener":1,
         "onUpdateListener":1,
         "onStartListener":1,
         "orientToBezier":1,
         "timeScale":1
      };
       
      
      public var duration:Number;
      
      public var vars:Object;
      
      public var delay:Number;
      
      public var startTime:Number;
      
      public var initTime:Number;
      
      public var tweens:Array;
      
      public var target:Object;
      
      public var active:Boolean;
      
      public var ease:Function;
      
      public var initted:Boolean;
      
      public var combinedTimeScale:Number;
      
      public var gc:Boolean;
      
      public var started:Boolean;
      
      public var exposedVars:Object;
      
      protected var _hasPlugins:Boolean;
      
      protected var _hasUpdate:Boolean;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         super();
         if(param1 == null)
         {
            return;
         }
         if(!_tlInitted)
         {
            TweenPlugin.activate([TintPlugin,RemoveTintPlugin,FramePlugin,AutoAlphaPlugin,VisiblePlugin,VolumePlugin,EndArrayPlugin,TransformAroundPointPlugin,TransformAroundCenterPlugin]);
            currentTime = getTimer();
            timingSprite.addEventListener(Event.ENTER_FRAME,updateAll,false,0,true);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _timer.addEventListener("timer",killGarbage,false,0,true);
            _timer.start();
            _tlInitted = true;
         }
         this.vars = param3;
         this.duration = param2 || 0.001;
         this.delay = Number(param3.delay) || 0;
         this.combinedTimeScale = Number(param3.timeScale) || 1;
         this.active = Boolean(param2 == 0 && this.delay == 0);
         this.target = param1;
         if(typeof this.vars.ease != "function")
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = this.easeProxy;
         }
         this.ease = this.vars.ease;
         this.exposedVars = this.vars.isTV == true ? this.vars.exposedVars : this.vars;
         this.tweens = [];
         this.initTime = currentTime;
         this.startTime = this.initTime + this.delay * 1000;
         var _loc4_:int = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1 ? int(overwriteManager.mode) : int(param3.overwrite);
         if(!(param1 in masterList) || _loc4_ == 1)
         {
            masterList[param1] = [this];
         }
         else
         {
            masterList[param1].push(this);
         }
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || this.active)
         {
            this.initTweenVals();
            if(this.active)
            {
               this.render(this.startTime + 1);
            }
            else
            {
               this.render(this.startTime);
            }
            if(this.exposedVars.visible != null && this.vars.runBackwards == true && this.target is DisplayObject)
            {
               this.target.visible = this.exposedVars.visible;
            }
         }
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":0
         });
      }
      
      public static function updateAll(param1:Event = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:TweenLite = null;
         var _loc2_:uint = uint(currentTime = getTimer());
         var _loc3_:Dictionary = masterList;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.length - 1;
            while(_loc5_ > -1)
            {
               if((_loc6_ = _loc4_[_loc5_]).active)
               {
                  _loc6_.render(_loc2_);
               }
               else if(_loc6_.gc)
               {
                  _loc4_.splice(_loc5_,1);
               }
               else if(_loc2_ >= _loc6_.startTime)
               {
                  _loc6_.activate();
                  _loc6_.render(_loc2_);
               }
               _loc5_--;
            }
         }
      }
      
      public static function removeTween(param1:TweenLite, param2:Boolean = true) : void
      {
         if(param1 != null)
         {
            if(param2)
            {
               param1.clear();
            }
            param1.enabled = false;
         }
      }
      
      public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TweenLite = null;
         if(param1 != null && param1 in masterList)
         {
            _loc3_ = masterList[param1];
            _loc4_ = int(_loc3_.length - 1);
            while(_loc4_ > -1)
            {
               _loc5_ = _loc3_[_loc4_];
               if(param2 && !_loc5_.gc)
               {
                  _loc5_.complete(false);
               }
               _loc5_.clear();
               _loc4_--;
            }
            delete masterList[param1];
         }
      }
      
      protected static function killGarbage(param1:TimerEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Dictionary = masterList;
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_].length == 0)
            {
               delete _loc2_[_loc3_];
            }
         }
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public function initTweenVals() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:TweenInfo = null;
         if(this.exposedVars.timeScale != undefined && this.target.hasOwnProperty("timeScale"))
         {
            this.tweens[this.tweens.length] = new TweenInfo(this.target,"timeScale",this.target.timeScale,this.exposedVars.timeScale - this.target.timeScale,"timeScale",false);
         }
         for(_loc1_ in this.exposedVars)
         {
            if(!(_loc1_ in _reservedProps))
            {
               if(_loc1_ in plugins)
               {
                  _loc3_ = new plugins[_loc1_]();
                  if(_loc3_.onInitTween(this.target,this.exposedVars[_loc1_],this) == false)
                  {
                     this.tweens[this.tweens.length] = new TweenInfo(this.target,_loc1_,this.target[_loc1_],typeof this.exposedVars[_loc1_] == "number" ? this.exposedVars[_loc1_] - this.target[_loc1_] : Number(this.exposedVars[_loc1_]),_loc1_,false);
                  }
                  else
                  {
                     this.tweens[this.tweens.length] = new TweenInfo(_loc3_,"changeFactor",0,1,_loc3_.overwriteProps.length == 1 ? String(_loc3_.overwriteProps[0]) : "_MULTIPLE_",true);
                     this._hasPlugins = true;
                  }
               }
               else
               {
                  this.tweens[this.tweens.length] = new TweenInfo(this.target,_loc1_,this.target[_loc1_],typeof this.exposedVars[_loc1_] == "number" ? this.exposedVars[_loc1_] - this.target[_loc1_] : Number(this.exposedVars[_loc1_]),_loc1_,false);
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            _loc2_ = int(this.tweens.length - 1);
            while(_loc2_ > -1)
            {
               _loc4_ = this.tweens[_loc2_];
               _loc4_.start += _loc4_.change;
               _loc4_.change = -_loc4_.change;
               _loc2_--;
            }
         }
         if(this.vars.onUpdate != null)
         {
            this._hasUpdate = true;
         }
         if(Boolean(TweenLite.overwriteManager.enabled) && this.target in masterList)
         {
            overwriteManager.manageOverwrites(this,masterList[this.target]);
         }
         this.initted = true;
      }
      
      public function activate() : void
      {
         this.started = this.active = true;
         if(!this.initted)
         {
            this.initTweenVals();
         }
         if(this.vars.onStart != null)
         {
            this.vars.onStart.apply(null,this.vars.onStartParams);
         }
         if(this.duration == 0.001)
         {
            --this.startTime;
         }
      }
      
      public function render(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:TweenInfo = null;
         var _loc5_:int = 0;
         var _loc2_:Number = (param1 - this.startTime) * 0.001;
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
         if(this._hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            this.complete(true);
         }
      }
      
      public function complete(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            if(!this.initted)
            {
               this.initTweenVals();
            }
            this.startTime = currentTime - this.duration * 1000 / this.combinedTimeScale;
            this.render(currentTime);
            return;
         }
         if(this._hasPlugins)
         {
            _loc2_ = int(this.tweens.length - 1);
            while(_loc2_ > -1)
            {
               if(Boolean(this.tweens[_loc2_].isPlugin) && this.tweens[_loc2_].target.onComplete != null)
               {
                  this.tweens[_loc2_].target.onComplete();
               }
               _loc2_--;
            }
         }
         if(this.vars.persist != true)
         {
            this.enabled = false;
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
      
      public function clear() : void
      {
         this.tweens = [];
         this.vars = this.exposedVars = {"ease":this.vars.ease};
         this._hasUpdate = false;
      }
      
      public function killVars(param1:Object) : void
      {
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars(param1,this.exposedVars,this.tweens);
         }
      }
      
      protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function get enabled() : Boolean
      {
         return this.gc ? false : true;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         if(param1)
         {
            if(!(this.target in masterList))
            {
               masterList[this.target] = [this];
            }
            else
            {
               _loc2_ = masterList[this.target];
               _loc4_ = int(_loc2_.length - 1);
               while(_loc4_ > -1)
               {
                  if(_loc2_[_loc4_] == this)
                  {
                     _loc3_ = true;
                     break;
                  }
                  _loc4_--;
               }
               if(!_loc3_)
               {
                  _loc2_[_loc2_.length] = this;
               }
            }
         }
         this.gc = param1 ? false : true;
         if(this.gc)
         {
            this.active = false;
         }
         else
         {
            this.active = this.started;
         }
      }
   }
}
