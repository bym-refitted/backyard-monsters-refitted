package
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;

   public class ALLIANCEPOPUP extends MovieClip
   {

      private static const W:int = 860;

      private static const H:int = 580;

      private static const CONTENT_X:int = 26;

      private static const CONTENT_Y:int = 63;

      private static const CONTENT_W:int = 808;

      private static const CONTENT_H:int = 452;

      private static const TAB_Y:int = 26;

      private static const TAB_H:int = 38;

      private static const TAB_GAP:int = 5;

      private static const INNER_BG:uint = 0xF0DCC0;

      private static const BORDER_COLOR:uint = 0x888888;

      private static const TAB_LABELS:Array = [
         "Browse Alliances", "My Alliance", "Power-Ups", "Members (0/50)", "Suggested", "Invites (0)"
      ];

      private static const TAB_WIDTHS:Array = [
         142, 110, 98, 126, 100, 100
      ];

      private var _tabs:Array;

      private var _contentMC:MovieClip;

      private var _activeTab:int = 0;

      public function ALLIANCEPOPUP()
      {
         super();
         _buildFrame();
         _buildTabs();
         _buildInnerBackground();
         _contentMC = addChild(new MovieClip()) as MovieClip;
         _contentMC.x = CONTENT_X;
         _contentMC.y = CONTENT_Y;
         _switchTab(0);
      }

      private function _buildFrame() : void
      {
         var mcFrame:frame_CLIP = addChild(new frame_CLIP()) as frame_CLIP;
         // Constructor called Setup() with no parent — no-op for visuals.
         // Define bounds via invisible fill so frame.resize() reads correct dimensions,
         // then call Setup() again now that we have a parent.
         mcFrame.graphics.beginFill(0, 0);
         mcFrame.graphics.drawRect(0, 0, W, H);
         mcFrame.graphics.endFill();
         mcFrame.Setup();
      }

      private function _buildInnerBackground() : void
      {
         var bg:MovieClip = addChild(new MovieClip()) as MovieClip;
         bg.mouseEnabled = false;
         bg.graphics.lineStyle(1, BORDER_COLOR, 1);
         bg.graphics.beginFill(INNER_BG, 1);
         bg.graphics.drawRect(0, 0, CONTENT_W, CONTENT_H);
         bg.graphics.endFill();
         bg.x = CONTENT_X;
         bg.y = CONTENT_Y;
      }

      private function _buildTabs() : void
      {
         var currentX:int = CONTENT_X;
         _tabs = [];
         var i:int = 0;
         while (i < TAB_LABELS.length)
         {
            var btn:ButtonBrown_CLIP = addChild(new ButtonBrown_CLIP()) as ButtonBrown_CLIP;
            btn.Setup(TAB_LABELS[i], false, int(TAB_WIDTHS[i]), TAB_H, "#ECBF88");
            btn.focusRect = false;
            btn.x = currentX;
            btn.y = TAB_Y;
            btn.addEventListener(MouseEvent.CLICK, _onTabClick(i));
            _tabs.push(btn);
            currentX += int(TAB_WIDTHS[i]) + TAB_GAP;
            i++;
         }
      }

      private function _onTabClick(idx:int) : Function
      {
         return function(e:MouseEvent) : void
         {
            SOUNDS.Play("click1");
            _switchTab(idx);
         };
      }

      private function _switchTab(idx:int) : void
      {
         var i:int = 0;
         while (i < _tabs.length)
         {
            _tabs[i].Highlight = (i == idx);
            i++;
         }
         _activeTab = idx;
         _buildContent();
      }

      private function _buildContent() : void
      {
         while (_contentMC.numChildren > 0)
         {
            _contentMC.removeChildAt(0);
         }
         var fmt:TextFormat = new TextFormat();
         fmt.font = "Verdana";
         fmt.size = 12;
         var tf:TextField = new TextField();
         tf.selectable = false;
         tf.wordWrap = true;
         tf.defaultTextFormat = fmt;
         tf.width = CONTENT_W - 20;
         tf.height = 60;
         tf.x = 10;
         tf.y = 10;
         tf.htmlText = "";
         _contentMC.addChild(tf);
      }

      public function Hide(param1:MouseEvent = null) : void
      {
         ALLIANCEWINDOW.Hide();
      }

      public function Center() : void
      {
         POPUPSETTINGS.AlignToUpperLeft(this);
         y += 70;
      }

      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}
