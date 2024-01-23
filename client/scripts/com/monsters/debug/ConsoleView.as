package com.monsters.debug
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   public class ConsoleView extends Sprite
   {
       
      
      private const _OUTPUT_COLOR:uint = 0;
      
      private const _INPUT_COLOR:uint = 0;
      
      protected var _messageQueue:Array;
      
      protected var _maxLength:uint = 200000;
      
      protected var _truncating:Boolean = false;
      
      protected var _width:uint = 500;
      
      protected var _height:uint = 150;
      
      protected var _consoleHistory:Array;
      
      protected var _historyIndex:uint = 0;
      
      protected var _outputBitmap:Bitmap;
      
      protected var _input:TextField;
      
      protected var tabCompletionPrefix:String = "";
      
      protected var tabCompletionCurrentStart:int = 0;
      
      protected var tabCompletionCurrentEnd:int = 0;
      
      protected var tabCompletionCurrentOffset:int = 0;
      
      protected var glyphCache:GlyphCache;
      
      protected var bottomLineIndex:int = 2147483647;
      
      protected var logCache:Array;
      
      protected var _dirtyConsole:Boolean = true;
      
      protected var _isActive:Boolean;
      
      public function ConsoleView()
      {
         this._messageQueue = [];
         this._consoleHistory = [];
         this._outputBitmap = new Bitmap(new BitmapData(640,480,false,0));
         this.glyphCache = new GlyphCache();
         this.logCache = [];
         super();
         this.layout();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      public static function clamp(param1:Number, param2:Number = 0, param3:Number = 1) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      private function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         this.addListeners();
         this.resize();
      }
      
      protected function layout() : void
      {
         if(!this._input)
         {
            this.createInputField();
         }
         this.resize();
         this._outputBitmap.name = "ConsoleOutput";
         addEventListener(MouseEvent.DOUBLE_CLICK,this.onBitmapDoubleClick);
         this._outputBitmap.alpha = 0.85;
         addChild(this._outputBitmap);
         addChild(this._input);
         mouseEnabled = true;
         doubleClickEnabled = true;
         this._dirtyConsole = true;
      }
      
      protected function addListeners() : void
      {
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown,false,1,true);
         this._input.addEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp,false,1,true);
         stage.addEventListener(Event.RESIZE,this.resize);
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.resize);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      protected function onInputKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Dictionary = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1.keyCode == Keyboard.TAB)
         {
            _loc2_ = Console.commands;
            _loc3_ = new Vector.<String>();
            this.tabCompletionPrefix = this._input.text.toLowerCase();
            for(_loc4_ in _loc2_)
            {
               if(_loc4_.substr(0,this.tabCompletionPrefix.length).toLowerCase() == this.tabCompletionPrefix)
               {
                  _loc3_.push(_loc4_);
               }
            }
            if(_loc3_.length >= 1)
            {
               this._input.text = _loc3_[0] + " ";
               if(_loc3_.length >= 2)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_.length)
                  {
                     print("    " + _loc3_[_loc5_]);
                     _loc5_++;
                  }
               }
               stage.focus = this._input;
               this._input.setSelection(5,6);
            }
         }
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      protected function removeListeners() : void
      {
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputKeyDown);
         this._input.removeEventListener(KeyboardEvent.KEY_UP,this.onInputKeyUp);
         stage.removeEventListener(Event.RESIZE,this.resize);
         stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.resize);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.onFrame();
      }
      
      protected function onBitmapDoubleClick(param1:MouseEvent = null) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < this.logCache.length)
         {
            _loc2_ += this.logCache[_loc3_].text + "\n";
            _loc3_++;
         }
         System.setClipboard(_loc2_);
      }
      
      protected function resize(param1:Event = null) : void
      {
         if(Boolean(stage) && Boolean(GLOBAL._SCREEN))
         {
            x = GLOBAL._SCREEN.x;
            y = GLOBAL._SCREEN.y;
            this._width = stage.stageWidth - 1;
            this._height = stage.stageHeight / 3;
         }
         this._outputBitmap.bitmapData.dispose();
         this._outputBitmap.bitmapData = new BitmapData(this._width,this._height,false,this._OUTPUT_COLOR);
         this._input.height = 18;
         this._input.width = this._width;
         this._input.y = this._outputBitmap.height;
         this._dirtyConsole = true;
      }
      
      protected function createInputField() : TextField
      {
         this._input = new TextField();
         this._input.type = TextFieldType.INPUT;
         this._input.border = true;
         this._input.borderColor = this._INPUT_COLOR;
         this._input.multiline = false;
         this._input.wordWrap = false;
         this._input.condenseWhite = false;
         this._input.background = true;
         this._input.backgroundColor = this._INPUT_COLOR;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Verdana";
         _loc1_.size = 12;
         _loc1_.bold = true;
         _loc1_.color = 16777215;
         _loc1_.align = TextFormatAlign.LEFT;
         this._input.setTextFormat(_loc1_);
         this._input.defaultTextFormat = _loc1_;
         this._input.name = "ConsoleInput";
         return this._input;
      }
      
      protected function setHistory(param1:String) : void
      {
         this._input.text = param1;
      }
      
      protected function onInputKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode != Keyboard.TAB && param1.keyCode != Keyboard.SHIFT)
         {
            this.tabCompletionPrefix = this._input.text;
            this.tabCompletionCurrentStart = -1;
            this.tabCompletionCurrentOffset = 0;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._input.text.length <= 0)
            {
               this.addLogMessage("CMD",">",this._input.text);
               return;
            }
            this.processCommand();
         }
         else if(param1.keyCode == Keyboard.UP)
         {
            if(this._historyIndex > 0)
            {
               this.setHistory(this._consoleHistory[--this._historyIndex]);
            }
            else if(this._consoleHistory.length > 0)
            {
               this.setHistory(this._consoleHistory[0]);
            }
            param1.preventDefault();
         }
         else if(param1.keyCode == Keyboard.DOWN)
         {
            if(this._historyIndex < this._consoleHistory.length - 1)
            {
               this.setHistory(this._consoleHistory[++this._historyIndex]);
            }
            else if(this._historyIndex == this._consoleHistory.length - 1)
            {
               this._input.text = "";
            }
            param1.preventDefault();
         }
         else if(param1.keyCode == Keyboard.PAGE_UP)
         {
            if(this.bottomLineIndex == int.MAX_VALUE)
            {
               this.bottomLineIndex = this.logCache.length - 1;
            }
            this.bottomLineIndex -= this.getScreenHeightInLines() - 2;
            if(this.bottomLineIndex < 0)
            {
               this.bottomLineIndex = 0;
            }
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            if(this.bottomLineIndex != int.MAX_VALUE)
            {
               this.bottomLineIndex += this.getScreenHeightInLines() - 2;
               if(this.bottomLineIndex + this.getScreenHeightInLines() >= this.logCache.length)
               {
                  this.bottomLineIndex = int.MAX_VALUE;
               }
            }
         }
         else if(Console.isKey(param1.keyCode))
         {
            this.toggleActive();
            this._input.text = "";
         }
         this._dirtyConsole = true;
         param1.stopImmediatePropagation();
      }
      
      protected function processCommand() : void
      {
         this.addLogMessage("CMD",">",this._input.text);
         var _loc1_:String = Console.processLine(this._input.text);
         if(_loc1_)
         {
            this.addLogMessage("CMD","<",_loc1_);
         }
         this._consoleHistory.push(this._input.text);
         this._historyIndex = this._consoleHistory.length;
         this._input.text = "";
         this._dirtyConsole = true;
      }
      
      public function getScreenHeightInLines() : int
      {
         var _loc1_:int = this._outputBitmap.bitmapData.height;
         return Math.floor(_loc1_ / this.glyphCache.getLineHeight());
      }
      
      public function onFrame(param1:Number = 0) : void
      {
         if(this._dirtyConsole == false || parent == null)
         {
            return;
         }
         this._dirtyConsole = false;
         var _loc2_:int = this.getScreenHeightInLines() - 1;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.bottomLineIndex == int.MAX_VALUE)
         {
            _loc3_ = clamp(this.logCache.length - _loc2_,0,int.MAX_VALUE);
         }
         else
         {
            _loc3_ = clamp(this.bottomLineIndex - _loc2_,0,int.MAX_VALUE);
         }
         _loc4_ = clamp(_loc3_ + _loc2_,0,this.logCache.length - 1);
         _loc3_--;
         var _loc5_:BitmapData = this._outputBitmap.bitmapData;
         _loc5_.fillRect(_loc5_.rect,this._OUTPUT_COLOR);
         var _loc6_:int = _loc4_;
         while(_loc6_ >= _loc3_)
         {
            if(this.logCache[_loc6_])
            {
               this.glyphCache.drawLineToBitmap(this.logCache[_loc6_].text,0,this._outputBitmap.height - (_loc4_ + 1 - _loc6_) * this.glyphCache.getLineHeight(),this.logCache[_loc6_].color,this._outputBitmap.bitmapData);
            }
            _loc6_--;
         }
      }
      
      public function addLogMessage(param1:String, param2:String, param3:String) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc4_:String = this.getColorFromLevel(param1);
         var _loc5_:uint;
         if((_loc5_ = 0) < 2)
         {
            if((_loc8_ = param2.lastIndexOf("::")) != -1)
            {
               param2 = param2.substr(_loc8_ + 2);
            }
         }
         var _loc6_:Array = param3.split("\n");
         for each(_loc7_ in _loc6_)
         {
            _loc9_ = (_loc5_ > 0 ? param1 + ": " : "") + param2 + _loc7_;
            this.logCache.push({
               "color":parseInt(_loc4_.substr(1),16),
               "text":_loc9_
            });
         }
         this._dirtyConsole = true;
      }
      
      private function getColorFromLevel(param1:String) : String
      {
         if(param1 == Console.WARNING)
         {
            return "#FF0000";
         }
         return "#FFFFFF";
      }
      
      public function toggleActive() : void
      {
         if(this._isActive)
         {
            this.deactivate();
         }
         else
         {
            this.activate();
         }
      }
      
      public function activate() : void
      {
         visible = true;
         this.layout();
         this._isActive = true;
         this.addListeners();
         if(stage)
         {
            stage.focus = this._input;
         }
         this._input.text = "";
      }
      
      public function deactivate() : void
      {
         visible = false;
         this.removeListeners();
         this._isActive = false;
         if(stage)
         {
            stage.focus = null;
         }
      }
      
      public function set restrict(param1:String) : void
      {
         this._input.restrict = param1;
      }
      
      public function get restrict() : String
      {
         return this._input.restrict;
      }
   }
}

import flash.display.BitmapData;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;

class GlyphCache
{
    
   
   protected const _textFormat:TextFormat = new TextFormat("Verdana",12,14540253,true);
   
   protected const _textField:TextField = new TextField();
   
   protected const _glyphCache:Array = [];
   
   protected const _colorCache:Array = [];
   
   public function GlyphCache()
   {
      super();
      this._textField.setTextFormat(this._textFormat);
      this._textField.defaultTextFormat = this._textFormat;
   }
   
   public function drawLineToBitmap(param1:String, param2:int, param3:int, param4:uint, param5:BitmapData) : int
   {
      var _loc11_:int = 0;
      var _loc12_:Glyph = null;
      if(!this._colorCache[param4])
      {
         this._colorCache[param4] = new BitmapData(128,128,false,param4);
      }
      var _loc6_:BitmapData = this._colorCache[param4] as BitmapData;
      var _loc7_:Point = new Point(param2,param3);
      var _loc8_:int = 1;
      var _loc9_:int = param1.length;
      var _loc10_:int = 0;
      while(_loc10_ < _loc9_)
      {
         if((_loc11_ = param1.charCodeAt(_loc10_)) == 10)
         {
            _loc7_.x = param2;
            _loc7_.y += 16;
            _loc8_++;
         }
         else
         {
            _loc12_ = this.getGlyph(_loc11_);
            param5.copyPixels(_loc6_,_loc12_.rect,_loc7_,_loc12_.bitmap,null,true);
            _loc7_.x += _loc12_.rect.width - 1;
         }
         _loc10_++;
      }
      return _loc8_;
   }
   
   protected function getGlyph(param1:int) : Glyph
   {
      var _loc2_:Glyph = null;
      if(this._glyphCache[param1] == null)
      {
         _loc2_ = new Glyph();
         this._textField.text = String.fromCharCode(param1);
         _loc2_.bitmap = new BitmapData(this._textField.textWidth + 2,16,true,0);
         _loc2_.bitmap.draw(this._textField);
         _loc2_.rect = _loc2_.bitmap.rect;
         this._glyphCache[param1] = _loc2_;
      }
      return this._glyphCache[param1] as Glyph;
   }
   
   public function getLineHeight() : int
   {
      this._textField.text = "HPI";
      return this._textField.getLineMetrics(0).height;
   }
}

import flash.display.BitmapData;
import flash.geom.Rectangle;

class Glyph
{
    
   
   public var rect:Rectangle;
   
   public var bitmap:BitmapData;
   
   public function Glyph()
   {
      super();
   }
}
