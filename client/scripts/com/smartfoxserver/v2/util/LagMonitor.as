package com.smartfoxserver.v2.util
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.requests.PingPongRequest;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class LagMonitor extends EventDispatcher
   {
       
      
      private var _lastReqTime:int;
      
      private var _valueQueue:Array;
      
      private var _interval:int;
      
      private var _queueSize:int;
      
      private var _thread:Timer;
      
      private var _sfs:SmartFox;
      
      public function LagMonitor(param1:SmartFox, param2:int = 2, param3:int = 10)
      {
         super();
         this._sfs = param1;
         this._valueQueue = [];
         this._interval = param2;
         this._queueSize = param3;
         this._thread = new Timer(param2 * 1000);
         this._thread.addEventListener(TimerEvent.TIMER,this.threadRunner);
      }
      
      public function start() : void
      {
         if(this.isRunning)
         {
            return;
         }
         this._thread.start();
      }
      
      public function stop() : void
      {
         if(!this.isRunning)
         {
            return;
         }
         this._thread.stop();
      }
      
      public function destroy() : void
      {
         this.stop();
         this._thread.removeEventListener(TimerEvent.TIMER,this.threadRunner);
         this._thread = null;
         this._sfs = null;
      }
      
      public function get isRunning() : Boolean
      {
         return this._thread.running;
      }
      
      public function onPingPong() : int
      {
         var _loc1_:int = getTimer() - this._lastReqTime;
         if(this._valueQueue.length >= this._queueSize)
         {
            this._valueQueue.shift();
         }
         this._valueQueue.push(_loc1_);
         return this.averagePingTime;
      }
      
      public function get lastPingTime() : int
      {
         if(this._valueQueue.length > 0)
         {
            return this._valueQueue[this._valueQueue.length - 1];
         }
         return 0;
      }
      
      public function get averagePingTime() : int
      {
         var _loc2_:int = 0;
         if(this._valueQueue.length == 0)
         {
            return 0;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in this._valueQueue)
         {
            _loc1_ += _loc2_;
         }
         return _loc1_ / this._valueQueue.length;
      }
      
      private function threadRunner(param1:Event) : void
      {
         this._lastReqTime = getTimer();
         this._sfs.send(new PingPongRequest());
      }
   }
}
