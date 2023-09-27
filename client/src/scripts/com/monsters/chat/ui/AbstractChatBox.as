package com.monsters.chat.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class AbstractChatBox extends MovieClip
   {
       
      
      protected var _displayAssets:MovieClip;
      
      protected var _chats:Array;
      
      protected var _borderColor:uint = 0;
      
      protected var _thumbColor:uint = 0;
      
      protected var _inputColor:uint = 0;
      
      protected var _defaultColor:uint = 3355443;
      
      protected var _outputColor:uint = 0;
      
      protected var _fontName:String = "_sans";
      
      protected var _fontSize:int = 9;
      
      protected var _inputHeight:int;
      
      protected var _defaultTxtBG:uint = 14596743;
      
      protected var _highlightTxtBG:uint = 15918030;
      
      protected var fmt:TextFormat;
      
      protected var fmt_input:TextFormat;
      
      protected var fmt_userIndent:TextFormat;
      
      public function AbstractChatBox(param1:MovieClip)
      {
         this._chats = [];
         this._inputHeight = this._fontSize + 5;
         this.fmt = new TextFormat(this._fontName,this._fontSize,this._defaultColor);
         this.fmt_input = new TextFormat(this._fontName,this._fontSize,this._inputColor);
         this.fmt_userIndent = new TextFormat(this._fontName,this._fontSize,this._defaultColor);
         super();
         this._displayAssets = param1;
         this.addChild(this._displayAssets);
      }
      
      public function init() : void
      {
      }
      
      protected function createInput(param1:Number) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = this.fmt_input;
         _loc2_.background = true;
         _loc2_.width = param1;
         _loc2_.height = this._inputHeight;
         _loc2_.autoSize = TextFieldAutoSize.NONE;
         _loc2_.multiline = false;
         _loc2_.wordWrap = false;
         _loc2_.selectable = true;
         _loc2_.mouseEnabled = true;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.text = "";
         return _loc2_;
      }
      
      public function push(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:Boolean = false) : void
      {
         var _loc7_:String = null;
         this._chats.push(param1);
         var _loc6_:String = "";
         if(!param5)
         {
            while(this._chats.length > 40)
            {
               this._chats.shift();
            }
         }
         for each(_loc7_ in this._chats)
         {
            _loc6_ += _loc7_ + "<br>";
         }
         this.background._output.htmlText = _loc6_;
         this.background._output.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function get inputText() : String
      {
         if(this.input != null)
         {
            return this.input.text;
         }
         return "";
      }
      
      public function clearInputText() : void
      {
         if(this.input != null)
         {
            this.input.text = "";
         }
      }
      
      protected function onHideOver(param1:MouseEvent) : void
      {
      }
      
      protected function onHideOut(param1:MouseEvent) : void
      {
      }
      
      public function update() : void
      {
      }
      
      public function clearChat() : void
      {
         this._chats = [];
      }
      
      public function get background() : MovieClip
      {
         return null;
      }
      
      public function get input() : TextField
      {
         return null;
      }
      
      public function get output() : TextField
      {
         return null;
      }
   }
}
