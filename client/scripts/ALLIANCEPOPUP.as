package
{
   import com.monsters.alliances.ALLIANCES;
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

         _innerBg.graphics.lineStyle();
         _innerBg.graphics.beginFill(AllianceConstants.INNER_BG, 1);
         _innerBg.graphics.drawRect(0, 0, w, contentHeight);
         _innerBg.graphics.endFill();

         var gapStart:int = -1;
         var gapEnd:int = -1;
         var active:Object = _activeTabDescriptor();
         if (active != null)
         {
            gapStart = int(active.btn.x) - CONTENT_X;
            gapEnd = gapStart + int(AllianceConstants.TAB_WIDTHS[int(active.index)]);
         }

         _innerBg.graphics.lineStyle(1, AllianceConstants.BORDER_COLOR, 1);
         _innerBg.graphics.moveTo(0, 0);
         _innerBg.graphics.lineTo(0, contentHeight);
         _innerBg.graphics.lineTo(w, contentHeight);
         _innerBg.graphics.lineTo(w, 0);
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
         var visible:Array = _visibleTabIndices();
         var n:int = 0;
         while (n < visible.length)
         {
            var i:int = int(visible[n]);
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
            // Store the button alongside its original TAB_LABELS index so layout
            // position stays decoupled from the index used by _createTab and the
            // inner-background gap.
            _tabs.push({btn: btn, index: i});
            currentX += int(AllianceConstants.TAB_WIDTHS[i]) + TAB_GAP;
            n++;
         }
      }

      /**
       * Indices into TAB_LABELS for the tabs that should be shown, in order.
       * Mirrors the original visibility rules (alliances.min.v343.js w()):
       * Power-Ups and Members require alliance membership; Suggested also
       * requires the player to be the alliance leader. Browse, My Alliance and
       * Invites are always shown.
       * @returns {Array} Visible tab indices.
       */
      private function _visibleTabIndices():Array
      {
         // TODO: hardcoded while alliance membership/role aren't wired up
         // server-side yet — mocks the player as an in-alliance leader so every
         // tab shows for UI work. Swap back to the real checks once the server
         // populates them:
         //   var inAlliance:Boolean = (ALLIANCES._myAlliance != null);
         //   var isLeader:Boolean = ALLIANCES._isLeader;
         var inAlliance:Boolean = true;
         var isLeader:Boolean = true;
         var out:Array = [];
         var i:int = 0;
         while (i < AllianceConstants.TAB_LABELS.length)
         {
            if (_isTabVisible(i, inAlliance, isLeader))
            {
               out.push(i);
            }
            i++;
         }
         return out;
      }

      /**
       * @param {int} idx - TAB_LABELS index
       * @param {Boolean} inAlliance - Whether the player is in an alliance
       * @param {Boolean} isLeader - Whether the player leads their alliance
       * @returns {Boolean} Whether the tab should be shown
       */
      private function _isTabVisible(idx:int, inAlliance:Boolean, isLeader:Boolean):Boolean
      {
         switch (idx)
         {
            case 2: // Power-Ups
            case 3: // Members
               return inAlliance;
            case 4: // Suggested — leader only
               return inAlliance && isLeader;
            default: // Browse, My Alliance, Invites
               return true;
         }
      }

      /**
       * @returns {Object} The visible-tab descriptor ({btn, index}) for the
       * active tab, or null if none matches.
       */
      private function _activeTabDescriptor():Object
      {
         if (_tabs == null)
         {
            return null;
         }
         var i:int = 0;
         while (i < _tabs.length)
         {
            if (int(_tabs[i].index) == _activeTab)
            {
               return _tabs[i];
            }
            i++;
         }
         return null;
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
            _tabs[i].btn.Highlight = (int(_tabs[i].index) == idx);
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

      /**
       * Switches to the given tab (TAB_LABELS index) and renders it. Used after
       * the player's alliance membership changes (e.g. jumping to My Alliance
       * once an alliance is created).
       * @param {int} idx - TAB_LABELS index to switch to.
       */
      public function SelectTab(idx:int):void
      {
         _switchTab(idx);
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
