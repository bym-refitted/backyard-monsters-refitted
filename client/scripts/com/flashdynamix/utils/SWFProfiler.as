package com.flashdynamix.utils
{
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.LocalConnection;
   import flash.system.System;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.getTimer;
   
   public class SWFProfiler
   {
      
      private static var itvTime:int;
      
      private static var initTime:int;
      
      private static var currentTime:int;
      
      private static var frameCount:int;
      
      private static var totalCount:int;
      
      public static var minFps:Number;
      
      public static var maxFps:Number;
      
      public static var minMem:Number;
      
      public static var maxMem:Number;
      
      public static var history:int = 60;
      
      public static var fpsList:Array = [];
      
      public static var memList:Array = [];
      
      private static var displayed:Boolean = false;
      
      private static var started:Boolean = false;
      
      private static var inited:Boolean = false;
      
      private static var frame:Sprite;
      
      private static var stage:Stage;
      
      private static var content:ProfilerContent;
      
      private static var ci:ContextMenuItem;
       
      
      public function SWFProfiler()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:InteractiveObject = null) : void
      {
         var _loc3_:ContextMenu = null;
         if(inited)
         {
            return;
         }
         inited = true;
         stage = param1;
         content = new ProfilerContent();
         frame = new Sprite();
         minFps = Number.MAX_VALUE;
         maxFps = Number.MIN_VALUE;
         minMem = Number.MAX_VALUE;
         maxMem = Number.MIN_VALUE;
         if(param2)
         {
            _loc3_ = new ContextMenu();
            _loc3_.hideBuiltInItems();
            ci = new ContextMenuItem("Show Profiler",true);
            addEvent(ci,ContextMenuEvent.MENU_ITEM_SELECT,onSelect);
            _loc3_.customItems = [ci];
            param2.contextMenu = _loc3_;
         }
         start();
      }
      
      public static function start() : void
      {
         if(started)
         {
            return;
         }
         started = true;
         initTime = itvTime = getTimer();
         totalCount = frameCount = 0;
         addEvent(frame,Event.ENTER_FRAME,draw);
      }
      
      public static function stop() : void
      {
         if(!started)
         {
            return;
         }
         started = false;
         removeEvent(frame,Event.ENTER_FRAME,draw);
      }
      
      public static function gc() : void
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:Error)
         {
         }
      }
      
      public static function get currentFps() : Number
      {
         return frameCount / intervalTime;
      }
      
      public static function get currentMem() : Number
      {
         return System.totalMemory / 1024 / 1000;
      }
      
      public static function get averageFps() : Number
      {
         return totalCount / runningTime;
      }
      
      private static function get runningTime() : Number
      {
         return (currentTime - initTime) / 1000;
      }
      
      private static function get intervalTime() : Number
      {
         return (currentTime - itvTime) / 1000;
      }
      
      public static function onSelect(param1:ContextMenuEvent = null) : void
      {
         if(!displayed)
         {
            show();
         }
         else
         {
            hide();
         }
      }
      
      private static function show() : void
      {
         if(ci)
         {
            ci.caption = "Hide Profiler";
         }
         displayed = true;
         addEvent(stage,Event.RESIZE,resize);
         stage.addChild(content);
         updateDisplay();
      }
      
      private static function hide() : void
      {
         if(ci)
         {
            ci.caption = "Show Profiler";
         }
         displayed = false;
         removeEvent(stage,Event.RESIZE,resize);
         stage.removeChild(content);
      }
      
      private static function resize(param1:Event) : void
      {
         content.update(runningTime,minFps,maxFps,minMem,maxMem,currentFps,currentMem,averageFps,fpsList,memList,history);
         content.x = GLOBAL._SCREEN.x;
         content.y = GLOBAL._SCREEN.y;
      }
      
      private static function draw(param1:Event) : void
      {
         currentTime = getTimer();
         ++frameCount;
         ++totalCount;
         if(intervalTime >= 1)
         {
            if(displayed)
            {
               updateDisplay();
            }
            else
            {
               updateMinMax();
            }
            fpsList.unshift(currentFps);
            memList.unshift(currentMem);
            if(fpsList.length > history)
            {
               fpsList.pop();
            }
            if(memList.length > history)
            {
               memList.pop();
            }
            itvTime = currentTime;
            frameCount = 0;
         }
      }
      
      private static function updateDisplay() : void
      {
         updateMinMax();
         content.update(runningTime,minFps,maxFps,minMem,maxMem,currentFps,currentMem,averageFps,fpsList,memList,history);
      }
      
      private static function updateMinMax() : void
      {
         minFps = Math.min(currentFps,minFps);
         maxFps = Math.max(currentFps,maxFps);
         minMem = Math.min(currentMem,minMem);
         maxMem = Math.max(currentMem,maxMem);
      }
      
      private static function addEvent(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         param1.addEventListener(param2,param3,false,0,true);
      }
      
      private static function removeEvent(param1:EventDispatcher, param2:String, param3:Function) : void
      {
         param1.removeEventListener(param2,param3);
      }
   }
}

import flash.display.*;
import flash.events.Event;
import flash.text.*;

class ProfilerContent extends Sprite
{
    
   
   private var minFpsTxtBx:TextField;
   
   private var maxFpsTxtBx:TextField;
   
   private var minMemTxtBx:TextField;
   
   private var maxMemTxtBx:TextField;
   
   private var infoTxtBx:TextField;
   
   private var box:Shape;
   
   private var fps:Shape;
   
   private var mb:Shape;
   
   public function ProfilerContent()
   {
      var _loc1_:TextFormat = null;
      super();
      this.fps = new Shape();
      this.mb = new Shape();
      this.box = new Shape();
      this.mouseChildren = false;
      this.mouseEnabled = false;
      this.fps.x = 65;
      this.fps.y = 45;
      this.mb.x = 65;
      this.mb.y = 90;
      _loc1_ = new TextFormat("_sans",9,11184810);
      this.infoTxtBx = new TextField();
      this.infoTxtBx.autoSize = TextFieldAutoSize.LEFT;
      this.infoTxtBx.defaultTextFormat = new TextFormat("_sans",11,13421772);
      this.infoTxtBx.y = 98;
      this.minFpsTxtBx = new TextField();
      this.minFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
      this.minFpsTxtBx.defaultTextFormat = _loc1_;
      this.minFpsTxtBx.x = 7;
      this.minFpsTxtBx.y = 37;
      this.maxFpsTxtBx = new TextField();
      this.maxFpsTxtBx.autoSize = TextFieldAutoSize.LEFT;
      this.maxFpsTxtBx.defaultTextFormat = _loc1_;
      this.maxFpsTxtBx.x = 7;
      this.maxFpsTxtBx.y = 5;
      this.minMemTxtBx = new TextField();
      this.minMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
      this.minMemTxtBx.defaultTextFormat = _loc1_;
      this.minMemTxtBx.x = 7;
      this.minMemTxtBx.y = 83;
      this.maxMemTxtBx = new TextField();
      this.maxMemTxtBx.autoSize = TextFieldAutoSize.LEFT;
      this.maxMemTxtBx.defaultTextFormat = _loc1_;
      this.maxMemTxtBx.x = 7;
      this.maxMemTxtBx.y = 50;
      addChild(this.box);
      addChild(this.infoTxtBx);
      addChild(this.minFpsTxtBx);
      addChild(this.maxFpsTxtBx);
      addChild(this.minMemTxtBx);
      addChild(this.maxMemTxtBx);
      addChild(this.fps);
      addChild(this.mb);
      this.addEventListener(Event.ADDED_TO_STAGE,this.added,false,0,true);
      this.addEventListener(Event.REMOVED_FROM_STAGE,this.removed,false,0,true);
   }
   
   public function update(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Array, param10:Array, param11:int) : void
   {
      var _loc19_:Number = NaN;
      if(param1 >= 1)
      {
         this.minFpsTxtBx.text = param2.toFixed(3) + " Fps";
         this.maxFpsTxtBx.text = param3.toFixed(3) + " Fps";
         this.minMemTxtBx.text = param4.toFixed(3) + " Mb";
         this.maxMemTxtBx.text = param5.toFixed(3) + " Mb";
      }
      this.infoTxtBx.text = "Current Fps " + param6.toFixed(3) + "   |   Average Fps " + param8.toFixed(3) + "   |   Memory Used " + param7.toFixed(3) + " Mb";
      this.infoTxtBx.x = stage.stageWidth - this.infoTxtBx.width - 20;
      var _loc12_:Graphics;
      (_loc12_ = this.fps.graphics).clear();
      _loc12_.lineStyle(1,3407616,0.7);
      var _loc13_:int = 0;
      var _loc14_:int = int(param9.length);
      var _loc15_:int = 35;
      var _loc16_:int;
      var _loc17_:Number = (_loc16_ = stage.stageWidth - 80) / (param11 - 1);
      var _loc18_:Number = param3 - param2;
      _loc13_ = 0;
      while(_loc13_ < _loc14_)
      {
         _loc19_ = (param9[_loc13_] - param2) / _loc18_;
         if(_loc13_ == 0)
         {
            _loc12_.moveTo(0,-_loc19_ * _loc15_);
         }
         else
         {
            _loc12_.lineTo(_loc13_ * _loc17_,-_loc19_ * _loc15_);
         }
         _loc13_++;
      }
      (_loc12_ = this.mb.graphics).clear();
      _loc12_.lineStyle(1,26367,0.7);
      _loc13_ = 0;
      _loc14_ = int(param10.length);
      _loc18_ = param5 - param4;
      _loc13_ = 0;
      while(_loc13_ < _loc14_)
      {
         _loc19_ = (param10[_loc13_] - param4) / _loc18_;
         if(_loc13_ == 0)
         {
            _loc12_.moveTo(0,-_loc19_ * _loc15_);
         }
         else
         {
            _loc12_.lineTo(_loc13_ * _loc17_,-_loc19_ * _loc15_);
         }
         _loc13_++;
      }
   }
   
   private function added(param1:Event) : void
   {
      this.resize();
      stage.addEventListener(Event.RESIZE,this.resize,false,0,true);
   }
   
   private function removed(param1:Event) : void
   {
      stage.removeEventListener(Event.RESIZE,this.resize);
   }
   
   private function resize(param1:Event = null) : void
   {
      var _loc2_:Graphics = this.box.graphics;
      _loc2_.clear();
      _loc2_.beginFill(0,0.8);
      _loc2_.drawRect(0,0,stage.stageWidth,120);
      _loc2_.lineStyle(1,16777215,0.2);
      _loc2_.moveTo(65,45);
      _loc2_.lineTo(65,10);
      _loc2_.moveTo(65,45);
      _loc2_.lineTo(stage.stageWidth - 15,45);
      _loc2_.moveTo(65,90);
      _loc2_.lineTo(65,55);
      _loc2_.moveTo(65,90);
      _loc2_.lineTo(stage.stageWidth - 15,90);
      _loc2_.endFill();
      this.infoTxtBx.x = stage.stageWidth - this.infoTxtBx.width - 20;
   }
}
