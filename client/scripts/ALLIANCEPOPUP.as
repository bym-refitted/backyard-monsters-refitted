package
{
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.alliances.tabs.BrowseTab;
   import com.monsters.alliances.tabs.InvitesTab;
   import com.monsters.alliances.tabs.MembersTab;
   import com.monsters.alliances.tabs.MyAllianceTab;
   import com.monsters.alliances.tabs.PowerUpsTab;
   import com.monsters.alliances.tabs.SuggestedTab;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;

   public class ALLIANCEPOPUP extends MovieClip
   {
      private static const W:int = 860;
      private static const H:int = 580;
      private static const CONTENT_X:int = 26;
      private static const CONTENT_Y:int = 63;
      private static const TAB_Y:int = 26;
      private static const TAB_H:int = 38;
      private static const TAB_GAP:int = 5;

      private var _tabs:Array;
      private var _contentMC:MovieClip;
      private var _innerBg:MovieClip;
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

      private function _buildFrame():void
      {
         var mcFrame:frame_CLIP = addChild(new frame_CLIP()) as frame_CLIP;
         mcFrame.graphics.beginFill(0, 0);
         mcFrame.graphics.drawRect(0, 0, W, H);
         mcFrame.graphics.endFill();
         mcFrame.Setup();
      }

      private function _buildInnerBackground():void
      {
         _innerBg = addChild(new MovieClip()) as MovieClip;
         _innerBg.mouseEnabled = false;
         _innerBg.x = CONTENT_X;
         _innerBg.y = CONTENT_Y;
      }

      /**
       * Redraws the beige inner background at the given height. Called per tab
       * switch so each tab can size its own content area. The panel's top border
       * is split around the active tab so the active tab visually merges into the
       * content area (no line drawn beneath it), while inactive tabs keep the line.
       * @param {int} contentHeight - The active tab's desired background height.
       */
      private function _drawInnerBackground(contentHeight:int):void
      {
         const w:int = AllianceConstants.CONTENT_W;

         _innerBg.graphics.clear();

         // Fill only (no stroke) — borders are drawn as segments below
         _innerBg.graphics.lineStyle();
         _innerBg.graphics.beginFill(AllianceConstants.INNER_BG, 1);
         _innerBg.graphics.drawRect(0, 0, w, contentHeight);
         _innerBg.graphics.endFill();

         // Active tab's horizontal span in inner-bg-local coordinates
         var gapStart:int = -1;
         var gapEnd:int = -1;
         if (_tabs != null && _activeTab >= 0 && _activeTab < _tabs.length)
         {
            gapStart = int(_tabs[_activeTab].x) - CONTENT_X;
            gapEnd = gapStart + int(AllianceConstants.TAB_WIDTHS[_activeTab]);
         }

         _innerBg.graphics.lineStyle(1, AllianceConstants.BORDER_COLOR, 1);
         // Left, right and bottom edges
         _innerBg.graphics.moveTo(0, 0);
         _innerBg.graphics.lineTo(0, contentHeight);
         _innerBg.graphics.lineTo(w, contentHeight);
         _innerBg.graphics.lineTo(w, 0);
         // Top edge, split around the active tab so its underside stays open
         if (gapStart < 0)
         {
            _innerBg.graphics.moveTo(0, 0);
            _innerBg.graphics.lineTo(w, 0);
         }
         else
         {
            _innerBg.graphics.moveTo(0, 0);
            _innerBg.graphics.lineTo(gapStart, 0);
            _innerBg.graphics.moveTo(gapEnd, 0);
            _innerBg.graphics.lineTo(w, 0);
         }
      }

      private function _buildTabs():void
      {
         var currentX:int = CONTENT_X;
         _tabs = [];
         var i:int = 0;
         while (i < AllianceConstants.TAB_LABELS.length)
         {
            var btn:ButtonBrown_CLIP = addChild(new ButtonBrown_CLIP()) as ButtonBrown_CLIP;
            var tabLabel:String;
            if (i == 3)
               tabLabel = KEYS.Get(String(AllianceConstants.TAB_LABELS[i]), {"v1": "0", "v2": "50"});
            else if (i == 5)
               tabLabel = KEYS.Get(String(AllianceConstants.TAB_LABELS[i]), {"v1": "0"});
            else
               tabLabel = KEYS.Get(String(AllianceConstants.TAB_LABELS[i]));
            btn.Setup(tabLabel, false, int(AllianceConstants.TAB_WIDTHS[i]), TAB_H, "#ECBF88");
            btn.focusRect = false;
            btn.x = currentX;
            btn.y = TAB_Y;
            btn.addEventListener(MouseEvent.CLICK, _onTabClick(i));
            _tabs.push(btn);
            currentX += int(AllianceConstants.TAB_WIDTHS[i]) + TAB_GAP;
            i++;
         }
      }

      private function _onTabClick(idx:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _switchTab(idx);
         };
      }

      private function _switchTab(idx:int):void
      {
         var i:int = 0;
         while (i < _tabs.length)
         {
            _tabs[i].Highlight = (i == idx);
            i++;
         }
         _activeTab = idx;
         while (_contentMC.numChildren > 0)
         {
            _contentMC.removeChildAt(0);
         }
         var tab:AllianceTabBase = _createTab(idx);
         _drawInnerBackground(tab.contentHeight);
         _contentMC.addChild(tab);
         tab.build();
      }

      private function _createTab(idx:int):AllianceTabBase
      {
         switch (idx)
         {
            case 0:
               return new BrowseTab();
            case 1:
               return new MyAllianceTab();
            case 2:
               return new PowerUpsTab();
            case 3:
               return new MembersTab();
            case 4:
               return new SuggestedTab();
            case 5:
               return new InvitesTab();
            default:
               return new BrowseTab();
         }
      }

      public function Hide(param1:MouseEvent = null):void
      {
         ALLIANCEWINDOW.Hide();
      }

      public function Center():void
      {
         POPUPSETTINGS.AlignToUpperLeft(this);
         y += 70;
      }

      public function ScaleUp():void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}
