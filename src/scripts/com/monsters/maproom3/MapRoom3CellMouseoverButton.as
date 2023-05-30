package com.monsters.maproom3
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class MapRoom3CellMouseoverButton extends Sprite
   {
      
      private static var s_ButtonToolTip:bubblepopup5 = null;
       
      
      private var m_BackgroundImage:Bitmap;
      
      private var m_ButtonImage:Bitmap;
      
      private var m_ButtonRolloverImage:Bitmap;
      
      private var m_ToolTip:String;
      
      public function MapRoom3CellMouseoverButton(param1:BitmapData, param2:BitmapData, param3:String)
      {
         super();
         this.m_ToolTip = param3;
         buttonMode = true;
         this.m_BackgroundImage = new Bitmap(MapRoom3AssetCache.instance.GetAsset(MapRoom3AssetCache.MOUSEOVER_BUTTON_BACKGROUND));
         addChild(this.m_BackgroundImage);
         this.m_ButtonImage = new Bitmap(param1);
         addChild(this.m_ButtonImage);
         this.m_ButtonRolloverImage = new Bitmap(param2);
         this.m_ButtonRolloverImage.visible = false;
         addChild(this.m_ButtonRolloverImage);
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
         SOUNDS.Play("ui_over");
         if(s_ButtonToolTip == null)
         {
            s_ButtonToolTip = new bubblepopup5();
            s_ButtonToolTip.mouseEnabled = false;
            s_ButtonToolTip.mouseChildren = false;
            s_ButtonToolTip.mcText.autoSize = TextFieldAutoSize.LEFT;
            s_ButtonToolTip.x = width * 0.5;
            s_ButtonToolTip.y = height;
         }
      }
      
      public function OnMouseOver(param1:MouseEvent) : void
      {
         this.m_ButtonImage.visible = false;
         this.m_ButtonRolloverImage.visible = true;
         s_ButtonToolTip.mcText.htmlText = "<b>" + KEYS.Get(this.m_ToolTip) + "</b>";
         var _loc2_:Point = new Point(width * 0.5,height);
         _loc2_ = GLOBAL._layerUI.globalToLocal(localToGlobal(_loc2_));
         s_ButtonToolTip.x = _loc2_.x;
         s_ButtonToolTip.y = _loc2_.y;
         s_ButtonToolTip.mcBG.width = s_ButtonToolTip.mcText.width + 10;
         GLOBAL._layerUI.addChild(s_ButtonToolTip);
      }
      
      public function OnMouseOut(param1:MouseEvent) : void
      {
         this.m_ButtonImage.visible = true;
         this.m_ButtonRolloverImage.visible = false;
         s_ButtonToolTip.mcText.htmlText = "";
         if(s_ButtonToolTip.parent == GLOBAL._layerUI)
         {
            GLOBAL._layerUI.removeChild(s_ButtonToolTip);
         }
      }
   }
}
