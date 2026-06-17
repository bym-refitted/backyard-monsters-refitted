package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.chat.Chat;
   import com.monsters.chat.Channel;
   import com.monsters.chat.ChatEvent;
   import com.monsters.chat.impl.ws.WSChatSystem;
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetV;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;

   public class MyAllianceTab extends AllianceTabBase
   {
      private static const TITLE_SIZE:int = 24;
      private static const BODY_SIZE:int = 15;
      private static const CONTENT_W_INNER:int = 500;
      private static const BTN_W:int = 200;
      private static const BTN_H:int = 36;
      private static const PAD_TOP:int = 24;
      private static const TITLE_GAP:int = 14;
      private static const BTN_GAP:int = 24;

      // --- In-alliance layout ---
      private static const PAD:int = 12;
      private static const COL_GAP:int = 12;
      // Left column holds details, shield, description and the two action buttons.
      // LEFT_INNER insets the column's content from its left/right edges.
      private static const LEFT_X:int = PAD;
      private static const LEFT_W:int = 318;
      private static const LEFT_INNER:int = 16;
      private static const LEFT_CONTENT_X:int = LEFT_X + LEFT_INNER;
      private static const LEFT_CONTENT_W:int = LEFT_W - LEFT_INNER * 2;
      // Right column holds the scrollable chat feed and the post-message bar
      private static const RIGHT_X:int = LEFT_X + LEFT_W + COL_GAP;
      private static const RIGHT_W:int = AllianceConstants.CONTENT_W - RIGHT_X - PAD;

      private static const ACTION_BTN_H:int = 40;
      // Visible bottom of the beige inner section, above the popup's wooden base.
      // Bottom-anchored content must stay above this or the brown frame shows
      // through behind it.
      private static const INNER_BOTTOM:int = 482;
      // Beige inner-background height for the in-alliance view — extends a little
      // below the content's inner-section bottom.
      private static const CONTENT_BG_H:int = INNER_BOTTOM + 10;
      // Brown footer panel attached flush to the chat bottom, framing the bar.
      // Sits 10px above the inner-section bottom.
      private static const PANEL_PAD:int = 14;
      private static const PANEL_H:int = ACTION_BTN_H + PANEL_PAD * 2;
      private static const PANEL_Y:int = INNER_BOTTOM - 10 - PANEL_H;
      // Input + Post Message baseline, padded inside the panel
      private static const ACTION_Y:int = PANEL_Y + PANEL_PAD;

      private static const SHIELD_SIZE:int = 90;
      // Extra right padding so the icon sits further off the column edge
      private static const SHIELD_PAD_R:int = 12;
      private static const DETAIL_ROW_H:int = 24;
      private static const DETAIL_ROW_GAP:int = 26;
      private static const TITLE_Y:int = 18;
      private static const DETAILS_Y:int = TITLE_Y + 30;

      private static const DESC_Y:int = 172;
      private static const DESC_H:int = 175;
      // Action buttons sit under the description box, with a clear gap above them
      private static const LEFT_BTN_Y:int = DESC_Y + DESC_H + 31;

      // Chat viewport sits above the post-message bar. Rows fill the full inner
      // width (inset 1px inside the frame border); the scrollbar overlays the
      // right edge rather than reserving a gutter.
      private static const CHAT_X:int = RIGHT_X;
      private static const CHAT_Y:int = PAD;
      private static const CHAT_W:int = RIGHT_W;
      // Chat ends exactly at the panel top so the brown footer is attached to it
      private static const CHAT_H:int = PANEL_Y - CHAT_Y;
      private static const SCROLLBAR_W:int = 16;
      private static const CHAT_MASK_W:int = CHAT_W - 2;

      private static const POST_BTN_W:int = 130;

      // Mock toggle: forces the in-alliance view so it can be previewed without
      // server data. The live condition is ALLIANCES._myAlliance != null.
      private static const MOCK_IN_ALLIANCE:Boolean = true;

      // Alternating chat band colours (original shout-alternating0 / 1)
      private static const BAND_A:uint = AllianceConstants.SHOUT_BAND0;
      private static const BAND_B:uint = AllianceConstants.SHOUT_BAND1;

      // Chat state — own WebSocket transport, left disconnected for now
      private var _chatContent:MovieClip;
      private var _chatScroll:ScrollSetV;
      private var _chatYOff:int = 0;
      private var _chatRowIndex:int = 0;
      private var _chatInput:TextField;
      private var _chat:WSChatSystem;
      private var _chatChannel:Channel;
      private var _names:Object;

      public function MyAllianceTab()
      {
         super();
      }

      override public function build():void
      {
         if (_inAlliance())
         {
            _buildInAlliance();
         }
         else
         {
            _buildNoAlliance();
         }
      }

      /**
       * The in-alliance layout extends below the standard content height, so its
       * beige background must reach the panel's inner-section bottom. The
       * no-alliance view keeps the shared default.
       */
      override public function get contentHeight():int
      {
         return _inAlliance() ? CONTENT_BG_H : CONTENT_H;
      }

      /**
       * @returns {Boolean} True when the player belongs to an alliance.
       */
      private function _inAlliance():Boolean
      {
         return MOCK_IN_ALLIANCE || ALLIANCES._myAlliance != null;
      }

      /**
       * @returns {Object} Alliance display data. Falls back to mock data while
       * the server-side alliance payload is wired up.
       */
      private function _allianceData():Object
      {
         return {
               name: "Klan Kill You",
               rank: 30,
               level: 48,
               leader: "Ryan",
               members: 50,
               image: 3,
               desc: "Website: http://www.fbgsource.com\n" +
               "Direct link to forums: http://www.fbgsource.com/forum/index.php - Please register on forums. " +
               "Some good posts there already, more to come."
            };
      }

      // -----------------------------------------------------------------
      // In-alliance view
      // -----------------------------------------------------------------

      private function _buildInAlliance():void
      {
         var data:Object = _allianceData();
         _buildLeftColumn(data);
         _buildChat();
         _buildPostBar();
      }

      private function _buildLeftColumn(data:Object):void
      {
         const detailBlockW:int = LEFT_CONTENT_W - SHIELD_SIZE - SHIELD_PAD_R - 12;

         // Alliance name title
         var tTitle:TextField = addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.width = detailBlockW;
         tTitle.height = 30;
         tTitle.x = LEFT_CONTENT_X;
         tTitle.y = TITLE_Y;
         var titleFmt:TextFormat = new TextFormat("Verdana", 16, 0x000000, true);
         titleFmt.align = TextFormatAlign.LEFT;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = String(data.name);

         // Detail rows (label + bold value)
         var rows:Array = [
               [KEYS.Get("alliance_my_rank"), String(data.rank)],
               [KEYS.Get("alliance_my_level"), String(data.level)],
               [KEYS.Get("alliance_my_leader"), String(data.leader)],
               [KEYS.Get("alliance_my_members"), String(data.members)]
            ];
         const labelW:int = 68;
         for (var ri:int = 0; ri < rows.length; ri++)
         {
            var rowY:int = DETAILS_Y + ri * DETAIL_ROW_GAP;
            _addLabel(this, String(rows[ri][0]), LEFT_CONTENT_X, rowY, labelW, DETAIL_ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(this, String(rows[ri][1]), LEFT_CONTENT_X + labelW + 10, rowY, detailBlockW - labelW - 10, DETAIL_ROW_H, true, TextFormatAlign.LEFT);
         }

         // Alliance shield icon, top-right of the left column
         var shield:MovieClip = addChild(new MovieClip()) as MovieClip;
         shield.mouseEnabled = false;
         shield.x = LEFT_X + LEFT_W - LEFT_INNER - SHIELD_PAD_R - SHIELD_SIZE;
         shield.y = TITLE_Y + 10;
         _loadAllianceIcon(shield, int(data.image), SHIELD_SIZE);

         // Description box (white, bordered, read-only)
         var descBg:MovieClip = addChild(new MovieClip()) as MovieClip;
         descBg.mouseEnabled = false;
         descBg.graphics.beginFill(0xFFFFFF, 1);
         descBg.graphics.lineStyle(1, 0x333333, 1);
         descBg.graphics.drawRoundRect(0, 0, LEFT_CONTENT_W, DESC_H, 8, 8);
         descBg.graphics.endFill();
         descBg.x = LEFT_CONTENT_X;
         descBg.y = DESC_Y;

         var descField:TextField = addChild(new TextField()) as TextField;
         descField.wordWrap = true;
         descField.multiline = true;
         descField.selectable = false;
         descField.mouseEnabled = false;
         descField.width = LEFT_CONTENT_W - 16;
         descField.height = DESC_H - 12;
         descField.x = LEFT_CONTENT_X + 8;
         descField.y = DESC_Y + 8;
         descField.defaultTextFormat = new TextFormat("Verdana", 13, 0x333333);
         descField.text = String(data.desc);

         // Action buttons split the content width evenly, directly under the box
         const btnGap:int = 24;
         const btnW:int = int((LEFT_CONTENT_W - btnGap) / 2);
         var editBtn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         editBtn.Setup(KEYS.Get("alliance_btn_edit"), false, btnW, ACTION_BTN_H);
         editBtn.x = LEFT_CONTENT_X;
         editBtn.y = LEFT_BTN_Y;
         editBtn.addEventListener(MouseEvent.CLICK, _onEdit);

         var leaveBtn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         leaveBtn.Setup(KEYS.Get("alliance_btn_leave"), false, btnW, ACTION_BTN_H);
         leaveBtn.x = LEFT_CONTENT_X + btnW + btnGap;
         leaveBtn.y = LEFT_BTN_Y;
         leaveBtn.addEventListener(MouseEvent.CLICK, _onLeave);
      }

      /**
       * Builds the chat viewport and wires it to its own WebSocket transport
       * (WSChatSystem). The connection is intentionally left disconnected for
       * now — no auth, no channel join, no tie-in to the global chat dock. The
       * receive/send paths are in place so it goes live once connect()/login()/
       * join() are wired up against a real alliance channel.
       */
      private function _buildChat():void
      {
         // Outer frame around the chat viewport
         var frame:MovieClip = addChild(new MovieClip()) as MovieClip;
         frame.mouseEnabled = false;
         frame.graphics.beginFill(0xFFFFFF, 1);
         frame.graphics.lineStyle(1, 0x333333, 1);
         frame.graphics.drawRect(0, 0, CHAT_W, CHAT_H);
         frame.graphics.endFill();
         frame.x = CHAT_X;
         frame.y = CHAT_Y;

         // Inset 1px inside the frame border so rows don't cover the border
         var container:MovieClip = addChild(new MovieClip()) as MovieClip;
         container.x = CHAT_X + 1;
         container.y = CHAT_Y + 1;

         _chatContent = container.addChild(new MovieClip()) as MovieClip;
         _chatYOff = 0;
         _chatRowIndex = 0;

         // Viewport mask
         var maskMC:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         maskMC.graphics.beginFill(0xFF0000, 1);
         maskMC.graphics.drawRect(0, 0, CHAT_MASK_W, CHAT_H - 2);
         maskMC.graphics.endFill();
         _chatContent.mask = maskMC;

         // Scrollbar overlays the right edge of the content (no reserved gutter)
         _chatScroll = container.addChild(new ScrollSetV(_chatContent, maskMC, true)) as ScrollSetV;
         _chatScroll.x = CHAT_MASK_W - SCROLLBAR_W;
         _chatScroll.y = 0;

         _names = {};
         _chatChannel = new Channel("alliance", "system");

         // Build the WebSocket transport from configured chat server (host:port),
         // wire receive handlers, but do not connect() — chat stays disconnected.
         var host:String = "localhost";
         var port:int = 3002;
         if (Chat._chatServers != null && Chat._chatServers.length > 0)
         {
            var parts:Array = String(Chat._chatServers[0]).split(":");
            host = String(parts[0]);
            if (parts.length > 1)
            {
               port = int(parts[1]);
            }
         }
         _chat = new WSChatSystem(host, port);
         _chat.addEventListener(ChatEvent.SAY, _onWsSay);
         _chat.addEventListener(ChatEvent.UPDATE_NAME, _onWsName);

         _appendSystemRow(KEYS.Get("alliance_chat_disconnected"));

         addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
      }

      /**
       * Renders an incoming chat message from the WebSocket transport.
       */
      private function _onWsSay(e:ChatEvent):void
      {
         var user:String = e.Get("user") as String;
         var message:String = e.Get("message") as String;
         if (message == null || message == "")
         {
            return;
         }
         var name:String = (user != null && _names[user] != null) ? String(_names[user]) : String(user);
         _appendUserRow(name, message);
      }

      /**
       * Caches a userId → display name mapping from the transport.
       */
      private function _onWsName(e:ChatEvent):void
      {
         var userId:String = e.Get("userid") as String;
         if (userId != null)
         {
            _names[userId] = e.Get("displayname");
         }
      }

      /**
       * Appends a player chat row (avatar placeholder, name, body) and scrolls
       * the viewport to the newest message.
       */
      private function _appendUserRow(name:String, message:String):void
      {
         const PAD_IN:int = 8;
         const AVATAR:int = 48;
         const textX:int = PAD_IN + AVATAR + PAD_IN;
         // Reserve the scrollbar width so wrapped text never sits under it
         const textW:int = CHAT_MASK_W - textX - PAD_IN - SCROLLBAR_W;

         // Measure body height before drawing the band
         var body:TextField = new TextField();
         body.wordWrap = true;
         body.multiline = true;
         body.selectable = false;
         body.mouseEnabled = false;
         body.width = textW;
         body.defaultTextFormat = new TextFormat("Verdana", 13, 0x333333);
         body.text = message;
         var bodyH:int = int(body.textHeight) + 6;

         const headerH:int = 20;
         var rowH:int = Math.max(AVATAR + PAD_IN * 2, headerH + bodyH + PAD_IN * 2);

         _drawBand(_chatContent, _chatYOff, rowH, _nextBandColor());

         var avatar:MovieClip = _chatContent.addChild(new MovieClip()) as MovieClip;
         avatar.mouseEnabled = false;
         avatar.graphics.beginFill(0xB7B7A8, 1);
         avatar.graphics.lineStyle(1, 0x8C8C7E, 1);
         avatar.graphics.drawRoundRect(0, 0, AVATAR, AVATAR, 4, 4);
         avatar.graphics.endFill();
         avatar.x = PAD_IN;
         avatar.y = _chatYOff + PAD_IN;

         _addLabel(_chatContent, name, textX, _chatYOff + PAD_IN, textW, headerH, true, TextFormatAlign.LEFT);

         body.x = textX;
         body.y = _chatYOff + PAD_IN + headerH;
         body.height = bodyH;
         _chatContent.addChild(body);

         _chatYOff += rowH;
         _afterAppend();
      }

      /**
       * Appends a centred system row (joins, status, server notices).
       */
      private function _appendSystemRow(message:String):void
      {
         const PAD_IN:int = 8;

         var body:TextField = new TextField();
         body.wordWrap = true;
         body.multiline = true;
         body.selectable = false;
         body.mouseEnabled = false;
         body.width = CHAT_MASK_W - PAD_IN * 2;
         var fmt:TextFormat = new TextFormat("Verdana", 12, 0x555555, true);
         fmt.align = TextFormatAlign.CENTER;
         body.defaultTextFormat = fmt;
         body.text = message;
         var bodyH:int = int(body.textHeight) + 6;
         var rowH:int = bodyH + PAD_IN * 2;

         _drawBand(_chatContent, _chatYOff, rowH, _nextBandColor());

         body.x = PAD_IN;
         body.y = _chatYOff + PAD_IN;
         body.height = bodyH;
         _chatContent.addChild(body);

         _chatYOff += rowH;
         _afterAppend();
      }

      private function _nextBandColor():uint
      {
         var color:uint = (_chatRowIndex % 2 == 0) ? BAND_A : BAND_B;
         _chatRowIndex++;
         return color;
      }

      /**
       * Resizes the scrollbar to the new content height and pins the view to the
       * latest message.
       */
      private function _afterAppend():void
      {
         if (_chatScroll != null)
         {
            _chatScroll.scrollToBottom();
         }
      }

      /**
       * Draws an alternating-colour background band with a bottom separator line.
       */
      private function _drawBand(content:MovieClip, yOff:int, rowH:int, color:uint):void
      {
         // Clear any line style left from a prior band so the fill isn't stroked
         content.graphics.lineStyle();
         content.graphics.beginFill(color, 1);
         content.graphics.drawRect(0, yOff, CHAT_MASK_W, rowH);
         content.graphics.endFill();
         content.graphics.lineStyle(1, 0xC4D2A8, 1);
         content.graphics.moveTo(0, yOff + rowH);
         content.graphics.lineTo(CHAT_MASK_W, yOff + rowH);
      }

      private function _buildPostBar():void
      {
         const GAP:int = 26;

         // Brown footer panel (matches the tab/frame brown), square corners,
         // attached flush to the chat bottom
         var panel:MovieClip = addChild(new MovieClip()) as MovieClip;
         panel.mouseEnabled = false;
         panel.graphics.beginFill(AllianceConstants.ACTION_BG, 1);
         panel.graphics.lineStyle(1, 0x6E4F2E, 1);
         panel.graphics.drawRect(0, 0, CHAT_W, PANEL_H);
         panel.graphics.endFill();
         panel.x = CHAT_X;
         panel.y = PANEL_Y;

         const btnX:int = CHAT_X + CHAT_W - PANEL_PAD - POST_BTN_W;
         const inputX:int = CHAT_X + PANEL_PAD;
         const inputW:int = btnX - GAP - inputX;

         var inputBg:MovieClip = addChild(new MovieClip()) as MovieClip;
         inputBg.mouseEnabled = false;
         inputBg.graphics.beginFill(0xFFFFFF, 1);
         inputBg.graphics.lineStyle(1, 0x888888, 1);
         inputBg.graphics.drawRoundRect(0, 0, inputW, ACTION_BTN_H, 2, 2);
         inputBg.graphics.endFill();
         inputBg.x = inputX;
         inputBg.y = ACTION_Y;

         const FIELD_H:int = 18;
         const MAX_CHARS:int = 200;
         _chatInput = addChild(new TextField()) as TextField;
         _chatInput.type = TextFieldType.INPUT;
         _chatInput.background = false;
         _chatInput.border = false;
         _chatInput.selectable = true;
         _chatInput.mouseEnabled = true;
         _chatInput.maxChars = MAX_CHARS;
         _chatInput.width = inputW - 12;
         _chatInput.height = FIELD_H;
         _chatInput.x = inputX + 6;
         _chatInput.y = ACTION_Y + int((ACTION_BTN_H - FIELD_H) / 2);
         _chatInput.defaultTextFormat = new TextFormat("Verdana", 12, 0x333333);
         _chatInput.addEventListener(KeyboardEvent.KEY_DOWN, _onInputKey);

         var postBtn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         postBtn.Setup(KEYS.Get("alliance_btn_post"), false, POST_BTN_W, ACTION_BTN_H);
         postBtn.x = btnX;
         postBtn.y = ACTION_Y;
         postBtn.addEventListener(MouseEvent.CLICK, _onPost);
      }

      /**
       * Loads an alliance shield icon into a container via ImageCache, scaled to fit.
       * IDs 1-20 use the _large suffix; 21+ use _medium (matches AllianceFormPopup).
       */
      private function _loadAllianceIcon(container:MovieClip, id:int, size:int):void
      {
         var suffix:String = id <= 20 ? "_large" : "_medium";
         var key:String = "alliances/" + id + suffix + ".png";
         ImageCache.GetImageWithCallBack(
               key,
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var mc:MovieClip = args[0] as MovieClip;
                  var ts:int = int(args[1]);
                  if (bmd.width > 0 && bmd.height > 0)
                  {
                     var scale:Number = Math.min(ts / bmd.width, ts / bmd.height);
                     bmp.scaleX = bmp.scaleY = scale;
                     bmp.x = int((ts - bmd.width * scale) / 2);
                     bmp.y = int((ts - bmd.height * scale) / 2);
                  }
                  mc.addChild(bmp);
               },
               true, 4, "", [container, size]
            );
      }

      private function _onEdit(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         new AllianceFormPopup().Show(AllianceFormPopup.MODE_EDIT, String(_allianceData().name));
      }

      private function _onLeave(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         // TODO: confirm + send leave-alliance request to server
      }

      private function _onInputKey(e:KeyboardEvent):void
      {
         if (e.keyCode == Keyboard.ENTER)
         {
            _sendChat();
         }
      }

      private function _onPost(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         _sendChat();
      }

      /**
       * Sends the input text over the WebSocket transport. While disconnected
       * the transport silently drops the message, so we surface a status row.
       */
      private function _sendChat():void
      {
         if (_chatInput == null)
         {
            return;
         }
         var text:String = _chatInput.text;
         if (text == null || text.replace(/^\s+|\s+$/g, "") == "")
         {
            return;
         }
         if (_chat != null && _chat.isConnected)
         {
            _chat.say(_chatChannel, text);
         }
         else
         {
            _appendSystemRow(KEYS.Get("alliance_chat_disconnected"));
         }
         _chatInput.text = "";
      }

      /**
       * Tears down the chat transport when this tab is removed (tab switch or
       * popup close) so no listeners or sockets leak.
       */
      private function _onRemovedFromStage(e:Event):void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
         if (_chat != null)
         {
            _chat.removeEventListener(ChatEvent.SAY, _onWsSay);
            _chat.removeEventListener(ChatEvent.UPDATE_NAME, _onWsName);
            _chat.disconnect();
            _chat = null;
         }
      }

      // -----------------------------------------------------------------
      // No-alliance view
      // -----------------------------------------------------------------

      private function _buildNoAlliance():void
      {
         const titleH:int = TITLE_SIZE + 8;
         const innerX:int = int((CONTENT_W - CONTENT_W_INNER) / 2);

         // Measure body height before layout so we can vertically center the block
         var tBody:TextField = new TextField();
         tBody.wordWrap = true;
         tBody.multiline = true;
         tBody.selectable = false;
         tBody.mouseEnabled = false;
         tBody.width = CONTENT_W_INNER;
         var bodyFmt:TextFormat = new TextFormat("Verdana", BODY_SIZE, 0x333333);
         bodyFmt.align = TextFormatAlign.CENTER;
         tBody.defaultTextFormat = bodyFmt;
         tBody.text = KEYS.Get("alliance_no_alliance_desc");
         tBody.height = int(tBody.textHeight) + 6;

         const startY:int = PAD_TOP;

         var tTitle:TextField = addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W_INNER;
         tTitle.height = titleH;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = KEYS.Get("alliance_no_alliance_title");
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = innerX;
         tTitle.y = startY;

         tBody.x = innerX;
         tBody.y = startY + titleH + TITLE_GAP;
         addChild(tBody);

         var btn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btn.Setup(KEYS.Get("alliance_no_alliance_btn"), false, BTN_W, BTN_H);
         btn.x = int((CONTENT_W - BTN_W) / 2);
         btn.y = tBody.y + tBody.height + BTN_GAP;
         btn.addEventListener(MouseEvent.CLICK, _onCreateAlliance);
      }

      private function _onCreateAlliance(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         new AllianceFormPopup().Show(AllianceFormPopup.MODE_CREATE);
      }
   }
}
