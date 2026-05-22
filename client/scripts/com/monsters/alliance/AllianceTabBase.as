package com.monsters.alliance
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class AllianceTabBase extends MovieClip
   {
      protected const CONTENT_W:int = AllianceConstants.CONTENT_W;
      protected const CONTENT_H:int = AllianceConstants.CONTENT_H;

      public function AllianceTabBase()
      {
         super();
      }

      public function build() : void {}

      /**
       * Adds a non-interactive text label, vertically centered within rowH.
       * @param {MovieClip} parent - Container to add the label to
       * @param {String} text - Label text
       * @param {int} colX - X position within parent
       * @param {int} colY - Y offset of the row within parent
       * @param {int} colW - Column width
       * @param {int} rowH - Row height (used for vertical centering)
       * @param {Boolean} bold - Bold text
       * @param {String} align - TextFormatAlign constant, defaults to CENTER
       * @param {uint} color - Text color, defaults to black
       */
      protected function _addLabel(parent:MovieClip, text:String, colX:int, colY:int,
                                   colW:int, rowH:int, bold:Boolean = false,
                                   align:String = null, color:uint = 0x000000) : void
      {
         var tf:TextField = parent.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.autoSize = TextFieldAutoSize.NONE;
         tf.width = colW;
         tf.height = 20;
         tf.x = colX;
         tf.y = colY + int((rowH - 18) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", 12, color, bold);
         fmt.align = (align != null) ? align : TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = text;
      }
   }
}
