package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.AllianceTabBase;
   import com.monsters.chat.BYMChat;
   import com.monsters.chat.Chat;
   import com.monsters.chat.Channel;
   import com.monsters.chat.ChatEvent;
   import com.monsters.chat.IChatSystem;
   import com.monsters.chat.impl.ws.AllianceMessageType;
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetV;
   import com.monsters.utils.TimeUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
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

      private static const PAD:int = 12;
      private static const COL_GAP:int = 12;
      private static const LEFT_X:int = PAD;
      private static const LEFT_W:int = 318;
      private static const LEFT_INNER:int = 16;
      private static const LEFT_CONTENT_X:int = LEFT_X + LEFT_INNER;
      private static const LEFT_CONTENT_W:int = LEFT_W - LEFT_INNER * 2;
      private static const RIGHT_X:int = LEFT_X + LEFT_W + COL_GAP;
      private static const RIGHT_W:int = AllianceConstants.CONTENT_W - RIGHT_X - PAD;

      private static const ACTION_BTN_H:int = 40;
      // Visible bottom of the beige inner section; bottom-anchored content must
      // stay above this or the brown frame shows through behind it.
      private static const INNER_BOTTOM:int = 482;
      private static const CONTENT_BG_H:int = INNER_BOTTOM + 10;
      private static const PANEL_PAD:int = 14;
      private static const PANEL_H:int = ACTION_BTN_H + PANEL_PAD * 2;
      private static const PANEL_Y:int = INNER_BOTTOM - 10 - PANEL_H;
      private static const ACTION_Y:int = PANEL_Y + PANEL_PAD;

      // TAB_LABELS index of the My Alliance tab; re-selected to re-render after a leave.
      private static const MY_ALLIANCE_TAB:int = 1;

      private static const SHIELD_SIZE:int = 90;
      private static const SHIELD_PAD_R:int = 12;
      private static const DETAIL_ROW_H:int = 24;
      private static const DETAIL_ROW_GAP:int = 26;
      private static const TITLE_Y:int = 18;
      private static const DETAILS_Y:int = TITLE_Y + 30;

      private static const DESC_Y:int = 172;
      private static const DESC_H:int = 175;
      private static const LEFT_BTN_Y:int = DESC_Y + DESC_H + 31;

      private static const CHAT_X:int = RIGHT_X;
      private static const CHAT_Y:int = PAD;
      private static const CHAT_W:int = RIGHT_W;
      private static const CHAT_H:int = PANEL_Y - CHAT_Y;
      private static const SCROLLBAR_W:int = 16;
      private static const CHAT_MASK_W:int = CHAT_W - 2;

      private static const POST_BTN_W:int = 130;

      /**
       * Rows kept on screen, mirroring ALLIANCE_MESSAGE_LIMIT on the server. Without
       * this the transcript grows for the whole session while only 50 are stored, so
       * reopening the popup would silently drop messages the player had just seen.
       */
      private static const MAX_CHAT_ROWS:int = 50;

      private static const ROW_BORDER:uint = 0x949493;

      private static const ROW_BORDER_H:int = 1;

      private static const BAND_A:uint = AllianceConstants.SHOUT_BAND0;
      private static const BAND_B:uint = AllianceConstants.SHOUT_BAND1;

      private var _chatContent:MovieClip;
      private var _chatScroll:ScrollSetV;
      private var _chatYOff:int = 0;
      private var _chatRowIndex:int = 0;

      /** Bumped on clear, so avatar loads that finish afterwards are discarded. */
      private var _chatGeneration:int = 0;
      private var _chatInput:TextField;
      private static const ALLIANCE_CHANNEL_ALIAS:String = "alliance";

      private var _chat:IChatSystem;

      /** Alias sent on join; the server resolves it to this player's own alliance. */
      private var _joinChannel:Channel;

      /** The resolved channel key, known only once the server confirms the join. */
      private var _chatChannel:Channel;
      private var _data:Object;

      public function MyAllianceTab()
      {
         super();
      }

      override public function build():void
      {
         ALLIANCES.LoadMyAlliance(_onMyAllianceData);
      }

      /**
       * The My Alliance layout extends below the standard content height (the
       * in-alliance view fills it; the no-alliance prompt simply sits in a taller
       * beige area), so the background always reaches the inner-section bottom.
       */
      override public function get contentHeight():int
      {
         return CONTENT_BG_H;
      }

      /**
       * Renders the tab from the cached store payload (fetched on popup open and
       * refreshed after mutations, not per tab switch). Receives the alliance data
       * object, or null when the player is unaffiliated or the load failed.
       */
      private function _onMyAllianceData(data:Object):void
      {
         if (stage == null)
         {
            return;
         }
         if (data)
         {
            _data = data;
            _buildInAlliance();
         }
         else
         {
            _buildNoAlliance();
         }
      }

      private function _buildInAlliance():void
      {
         _buildLeftColumn(_data);
         _buildChat();
         _buildPostBar();
      }

      private function _buildLeftColumn(data:Object):void
      {
         const detailBlockW:int = LEFT_CONTENT_W - SHIELD_SIZE - SHIELD_PAD_R - 12;

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

         var rows:Array = [
               [KEYS.Get("alliance_my_rank"), String(data.rank)],
               [KEYS.Get("alliance_my_level"), String(data.avg_level)],
               [KEYS.Get("alliance_my_leader"), String(data.leader_name)],
               [KEYS.Get("alliance_my_members"), String(data.number_of_members)]
            ];
         const labelW:int = 68;
         for (var ri:int = 0; ri < rows.length; ri++)
         {
            var rowY:int = DETAILS_Y + ri * DETAIL_ROW_GAP;
            _addLabel(this, String(rows[ri][0]), LEFT_CONTENT_X, rowY, labelW, DETAIL_ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(this, String(rows[ri][1]), LEFT_CONTENT_X + labelW + 10, rowY, detailBlockW - labelW - 10, DETAIL_ROW_H, true, TextFormatAlign.LEFT);
         }

         var shield:MovieClip = addChild(new MovieClip()) as MovieClip;
         shield.mouseEnabled = false;
         shield.x = LEFT_X + LEFT_W - LEFT_INNER - SHIELD_PAD_R - SHIELD_SIZE;
         shield.y = TITLE_Y + 10;
         _loadAllianceIcon(shield, int(data.image), SHIELD_SIZE);

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
         descField.text = String(data.description);

         const btnGap:int = 24;
         const btnW:int = int((LEFT_CONTENT_W - btnGap) / 2);

         if (ALLIANCES._isLeader)
         {
            var editBtn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
            editBtn.Setup(KEYS.Get("alliance_btn_edit"), false, btnW, ACTION_BTN_H);
            editBtn.x = LEFT_CONTENT_X;
            editBtn.y = LEFT_BTN_Y;
            editBtn.addEventListener(MouseEvent.CLICK, _onEdit);
         }

         var leaveBtn:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         leaveBtn.Setup(KEYS.Get("alliance_btn_leave"), false, btnW, ACTION_BTN_H);
         leaveBtn.x = LEFT_CONTENT_X + btnW + btnGap;
         leaveBtn.y = LEFT_BTN_Y;
         leaveBtn.addEventListener(MouseEvent.CLICK, _onLeave);
      }

      /**
       * Builds the chat viewport and joins the alliance channel on the chat dock's
       * existing connection. The server permits one socket per player, so opening a
       * second transport here would authenticate and close the dock's own — the two
       * features share one socket and separate on channel instead.
       */
      private function _buildChat():void
      {
         var frame:MovieClip = addChild(new MovieClip()) as MovieClip;
         frame.mouseEnabled = false;
         frame.graphics.beginFill(0xFFFFFF, 1);
         frame.graphics.lineStyle(1, 0x333333, 1);
         frame.graphics.drawRect(0, 0, CHAT_W, CHAT_H);
         frame.graphics.endFill();
         frame.x = CHAT_X;
         frame.y = CHAT_Y;

         var container:MovieClip = addChild(new MovieClip()) as MovieClip;
         container.x = CHAT_X + 1;
         container.y = CHAT_Y + 1;

         _chatContent = container.addChild(new MovieClip()) as MovieClip;
         _chatYOff = 0;
         _chatRowIndex = 0;

         var maskMC:MovieClip = container.addChild(new MovieClip()) as MovieClip;
         maskMC.graphics.beginFill(0xFF0000, 1);
         maskMC.graphics.drawRect(0, 0, CHAT_MASK_W, CHAT_H - 2);
         maskMC.graphics.endFill();
         _chatContent.mask = maskMC;

         _chatScroll = container.addChild(new ScrollSetV(_chatContent, maskMC, true)) as ScrollSetV;
         _chatScroll.x = CHAT_MASK_W - SCROLLBAR_W;
         _chatScroll.y = 0;

         _joinChannel = new Channel(ALLIANCE_CHANNEL_ALIAS, "system");
         _chatChannel = null;

         addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);

         Chat.ensureConnected();
         _chat = BYMChat.chatSystem;

         if (_chat == null)
         {
            _appendSystemRow(KEYS.Get("alliance_chat_unavailable"));
            return;
         }

         _chat.addEventListener(ChatEvent.LOGIN, _onWsLogin);
         _chat.addEventListener(ChatEvent.JOIN, _onWsJoin);
         _chat.addEventListener(ChatEvent.SAY, _onWsSay);

         _appendSystemRow(KEYS.Get("alliance_chat_connecting"));

         if (_chat.isLoggedIn)
         {
            _chat.join(_joinChannel);
         }
      }

      /**
       * Joins once the shared transport finishes authenticating. The socket connects
       * asynchronously and may still be opening when the popup is built, so the join
       * waits for login rather than sampling the connection state once.
       */
      private function _onWsLogin(e:ChatEvent):void
      {
         if (!e.Success || _chat == null)
         {
            return;
         }
         _chat.join(_joinChannel);
      }

      /**
       * Records the channel key the server resolved our join alias to. The dock
       * shares this transport, so its own joins arrive here too and are ignored.
       */
      private function _onWsJoin(e:ChatEvent):void
      {
         if (!e.Success)
         {
            return;
         }
         var channel:Channel = e.Get("channel") as Channel;
         if (channel == null || !BYMChat.isAllianceChannel(channel.Name))
         {
            return;
         }
         _chatChannel = channel;
         _clearChat();
      }

      /**
       * Empties the chat transcript. Each row carries its own band, so removing the
       * rows takes the backgrounds with them.
       */
      private function _clearChat():void
      {
         while (_chatContent.numChildren > 0)
         {
            _chatContent.removeChildAt(0);
         }
         _chatYOff = 0;
         _chatRowIndex = 0;
         _chatGeneration++;
      }

      /**
       * Renders an incoming chat message from the shared transport, ignoring
       * anything addressed to a channel other than this alliance's.
       */
      private function _onWsSay(event:ChatEvent):void
      {
         var channel:Channel = event.Get("channel") as Channel;
         if (_chatChannel == null || channel == null || channel.Name != _chatChannel.Name)
         {
            return;
         }
         var user:String = event.Get("user") as String;
         var message:String = event.Get("message") as String;
         if (message == null || message == "")
         {
            return;
         }
         var picSquare:String = event.Get("picsquare") as String;
         var ts:Number = Number(event.Get("ts"));

         var messageType:String = event.Get("messagetype") as String;
         if (messageType != null && messageType != AllianceMessageType.MESSAGE)
         {
            _appendSystemRow(message, picSquare, ts);
            return;
         }

         var name:String = event.Get("displayname") as String;
         if (name == null || name == "")
         {
            name = String(user);
         }
         _appendUserRow(name, message, picSquare, ts);
      }


      /**
       * Appends a player chat row (avatar placeholder, name, body) and scrolls
       * the viewport to the newest message.
       */
      /**
       * Appends one player message, laid out as the original shout row was
       * (user-shout-message-template plus alliance.v343.css): a 25px picture
       * inset 5px, the name at x=38 / y=5, the body at x=38 / y=25, over a
       * 40px minimum row, with the relative time pinned to the top right. The
       * picture is drawn bare - the original had no frame around it, so a player
       * without one leaves the space empty.
       */
      private function _appendUserRow(name:String, message:String, picSquare:String = null, ts:Number = 0):void
      {
         const PAD:int = 5;
         const AVATAR:int = 32;
         const AVATAR_GAP:int = 8;
         const TEXT_X:int = PAD + AVATAR + AVATAR_GAP;
         const NAME_Y:int = 5;
         const BODY_Y:int = 25;
         const MIN_ROW_H:int = Math.max(40, PAD + AVATAR + PAD);
         const PAD_BOTTOM:int = 8;
         const TIME_W:int = 110;
         const TIME_INSET_RIGHT:int = 3;
         const TIME_INSET_TOP:int = 5;
         const GUTTER:int = 2;
         const textW:int = CHAT_MASK_W - TEXT_X - PAD - SCROLLBAR_W;

         var body:TextField = new TextField();
         body.wordWrap = true;
         body.multiline = true;
         body.selectable = false;
         body.mouseEnabled = false;
         body.width = textW;
         body.defaultTextFormat = new TextFormat("Verdana", 12, 0x333333);
         body.text = message;
         var bodyH:int = int(body.textHeight) + 6;

         var rowH:int = Math.max(MIN_ROW_H, BODY_Y + bodyH + PAD_BOTTOM);

         var row:MovieClip = _beginRow(rowH);

         var avatar:MovieClip = row.addChild(new MovieClip()) as MovieClip;
         avatar.mouseEnabled = false;
         avatar.x = PAD;
         avatar.y = PAD;
         _loadAvatar(picSquare, avatar, AVATAR);

         var nameField:TextField = row.addChild(new TextField()) as TextField;
         nameField.selectable = false;
         nameField.mouseEnabled = false;
         nameField.width = textW - TIME_W;
         nameField.height = 18;
         nameField.x = TEXT_X;
         nameField.y = NAME_Y;
         nameField.defaultTextFormat = new TextFormat("Verdana", 12, 0x000000, true);
         nameField.text = name;

         // Timestamps arrive in milliseconds; the shared helper works in seconds.
         if (ts > 0)
         {
            var timeField:TextField = row.addChild(new TextField()) as TextField;
            timeField.selectable = false;
            timeField.mouseEnabled = false;
            timeField.width = TIME_W;
            timeField.height = 16;

            timeField.x = CHAT_MASK_W - SCROLLBAR_W - TIME_W - TIME_INSET_RIGHT + GUTTER;
            timeField.y = TIME_INSET_TOP - GUTTER;
            var timeFmt:TextFormat = new TextFormat("Verdana", 10, 0x000000);
            timeFmt.align = TextFormatAlign.RIGHT;
            timeField.defaultTextFormat = timeFmt;
            timeField.text = TimeUtils.TimeDistance(ts / 1000);
         }

         body.x = TEXT_X;
         body.y = BODY_Y;
         body.height = bodyH;
         row.addChild(body);

         _afterAppend();
      }

      /**
       * Loads a sender's profile picture into their message row, over the grey
       * placeholder that is drawn first. Squashed to a square as the original
       * member rows were, so avatars line up down the column.
       *
       * pic_square is an external URL rather than a bundled asset, so it goes
       * through a Loader like the members table does rather than ImageCache. The
       * placeholder simply stays put for a player with no picture, or one whose
       * picture fails to load.
       *
       * The load outlives the append, and a rejoin clears the transcript, so the
       * generation is checked before drawing - otherwise a late avatar would land
       * on a row that no longer exists.
       *
       * @param {String} url - The sender's pic_square URL, possibly empty
       * @param {MovieClip} holder - The placeholder square to draw into
       * @param {int} size - Width and height to squash the picture to
       */
      private function _loadAvatar(url:String, holder:MovieClip, size:int):void
      {
         if (url == null || url == "")
         {
            return;
         }

         const generation:int = _chatGeneration;
         var loader:Loader = new Loader();
         var onLoad:Function = null;
         var onError:Function = null;

         onLoad = function(e:Event):void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            if (generation != _chatGeneration)
            {
               return;
            }
            loader.width = loader.height = size;
            loader.mouseEnabled = false;
            loader.mouseChildren = false;
            holder.addChild(loader);
         };

         onError = function(e:IOErrorEvent):void
         {
            loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
            loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
         };

         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
         loader.load(new URLRequest(url));
      }

      /**
       * Appends a system row: an alliance shout, or one of our own connection
       * notices.
       *
       * Laid out as the original's system-shout-message-template was - the
       * subject's picture inset 5px, the relative time pinned top right, and the
       * message centred in the box beside the picture rather than across the
       * whole row (.system-message is left:38px, width:310px, text-align:center).
       * Bold, where a player row's body is normal weight, and three pixels
       * higher than one.
       *
       * Connection notices pass neither picture nor timestamp - they are ours,
       * not the original's, and have no subject to show - so their text spans the
       * full width instead of sitting indented past an empty avatar slot.
       *
       * @param {String} message - The text to show, already composed by the server.
       * @param {String} picSquare - The subject's picture, null for a notice.
       * @param {Number} ts - Milliseconds since epoch, 0 for a notice.
       */
      private function _appendSystemRow(message:String, picSquare:String = null, ts:Number = 0):void
      {
         const PAD:int = 5;
         const AVATAR:int = 32;
         const AVATAR_GAP:int = 8;
         const BODY_Y:int = 22;
         const MIN_ROW_H:int = Math.max(40, PAD + AVATAR + PAD);
         const PAD_BOTTOM:int = 8;
         const TIME_W:int = 110;
         const TIME_INSET_RIGHT:int = 3;
         const TIME_INSET_TOP:int = 5;
         const GUTTER:int = 2;

         var hasAvatar:Boolean = picSquare != null && picSquare != "";
         var textX:int = PAD;
         if (hasAvatar)
         {
            textX = PAD + AVATAR + AVATAR_GAP;
         }
         var textW:int = CHAT_MASK_W - textX - PAD - SCROLLBAR_W;

         var body:TextField = new TextField();
         body.wordWrap = true;
         body.multiline = true;
         body.selectable = false;
         body.mouseEnabled = false;
         body.width = textW;
         var fmt:TextFormat = new TextFormat("Verdana", 12, 0x333333, true);
         fmt.align = TextFormatAlign.CENTER;
         body.defaultTextFormat = fmt;
         body.text = message;
         var bodyH:int = int(body.textHeight) + 6;

         var rowH:int = Math.max(MIN_ROW_H, BODY_Y + bodyH + PAD_BOTTOM);

         var row:MovieClip = _beginRow(rowH);

         if (hasAvatar)
         {
            var avatar:MovieClip = row.addChild(new MovieClip()) as MovieClip;
            avatar.mouseEnabled = false;
            avatar.x = PAD;
            avatar.y = PAD;
            _loadAvatar(picSquare, avatar, AVATAR);
         }

         if (ts > 0)
         {
            var timeField:TextField = row.addChild(new TextField()) as TextField;
            timeField.selectable = false;
            timeField.mouseEnabled = false;
            timeField.width = TIME_W;
            timeField.height = 16;
            timeField.x = CHAT_MASK_W - SCROLLBAR_W - TIME_W - TIME_INSET_RIGHT + GUTTER;
            timeField.y = TIME_INSET_TOP - GUTTER;
            
            var timeFmt:TextFormat = new TextFormat("Verdana", 10, 0x000000);
            timeFmt.align = TextFormatAlign.RIGHT;
            timeField.defaultTextFormat = timeFmt;
            timeField.text = TimeUtils.TimeDistance(ts / 1000);
         }

         body.x = textX;
         body.y = BODY_Y;
         body.height = bodyH;
         row.addChild(body);

         _afterAppend();
      }

      /**
       * Creates one row, draws its band, and places it at the bottom of the transcript.
       *
       * Each row owns its own graphics and children rather than everything sharing the
       * content clip, so dropping the oldest is a removeChild plus a shift of the rows
       * below it - no redraw, and no avatars reloaded.
       *
       * @param {int} rowH - Height of the row being added.
       * @returns {MovieClip} The row, whose children use row-local coordinates.
       */
      private function _beginRow(rowH:int):MovieClip
      {
         var row:MovieClip = _chatContent.addChild(new MovieClip()) as MovieClip;
         row.mouseEnabled = false;
         row.y = _chatYOff;
         row.rowHeight = rowH;

         _drawBand(row, rowH, _nextBandColor());

         _chatYOff += rowH;
         return row;
      }

      /**
       * Drops the oldest rows once the transcript passes MAX_CHAT_ROWS, shifting what
       * remains up by exactly the height removed. Colours are baked into each row, so
       * neighbours keep alternating as the window rolls forward.
       */
      private function _trimRows():void
      {
         while (_chatContent.numChildren > MAX_CHAT_ROWS)
         {
            var oldest:MovieClip = _chatContent.getChildAt(0) as MovieClip;
            var shift:int = int(oldest.rowHeight);

            _chatContent.removeChildAt(0);

            var i:int = 0;
            while (i < _chatContent.numChildren)
            {
               _chatContent.getChildAt(i).y -= shift;
               i++;
            }

            _chatYOff -= shift;
         }
      }

      private function _nextBandColor():uint
      {
         var color:uint = (_chatRowIndex % 2 == 0) ? BAND_A : BAND_B;
         _chatRowIndex++;
         return color;
      }

      /**
       * Enforces the row cap, then resizes the scrollbar to the new content height
       * and pins the view to the latest message.
       */
      private function _afterAppend():void
      {
         _trimRows();

         if (_chatScroll != null)
         {
            _chatScroll.scrollToBottom();
         }
      }

      /**
       * Fills a row with its alternating band colour and the 1px #949493 bottom border
       * the original had (.shout-message).
       *
       * The separator is a filled rect on the row's last pixel rather than a stroke on
       * the boundary, which would straddle the seam and be half-covered by the row below.
       */
      private function _drawBand(row:MovieClip, rowH:int, color:uint):void
      {
         row.graphics.beginFill(color, 1);
         row.graphics.drawRect(0, 0, CHAT_MASK_W, rowH);
         row.graphics.endFill();

         row.graphics.beginFill(ROW_BORDER, 1);
         row.graphics.drawRect(0, rowH - ROW_BORDER_H, CHAT_MASK_W, ROW_BORDER_H);
         row.graphics.endFill();
      }

      private function _buildPostBar():void
      {
         const GAP:int = 26;

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
         if (_data == null) return;
         
         new AllianceFormPopup().Show(
               AllianceFormPopup.MODE_EDIT,
               String(_data.name),
               int(_data.image),
               String(_data.description)
            );
      }

      /**
       * Handles the Leave Alliance button. A leader with members remaining cannot
       * leave and is told to promote a successor first; otherwise a confirmation is shown, using the
       * disband warning when they are the last member and the plain leave warning
       * otherwise — matching the original's two variants.
       */
      private function _onLeave(e:MouseEvent):void
      {
         SOUNDS.Play("click1");
         if (_data == null)
         {
            return;
         }
         var members:int = int(_data.number_of_members);
         if (ALLIANCES._isLeader && members > 1)
         {
            GLOBAL.Message(KEYS.Get("alliance_err_leader_cannot_leave", {"alliance": String(_data.name)}));
            return;
         }
         var confirmKey:String = (ALLIANCES._isLeader && members <= 1) ? "alliance_disband_confirm" : "alliance_leave_confirm";
         GLOBAL.Message(
               KEYS.Get(confirmKey, {"alliance": String(_data.name)}),
               KEYS.Get("btn_yes"), _confirmLeave, null,
               KEYS.Get("btn_no"), null, null
            );
      }

      private function _confirmLeave():void
      {
         // A non-empty body is required: Flash downgrades a POST with no data to a
         // GET, which would miss the POST route. The server ignores the payload and
         // identifies the alliance from the auth token.
         var r:URLLoaderApi = new URLLoaderApi();
         r.load(GLOBAL._allianceURL + "leavealliance", [["confirm", "1"]], _onLeaveComplete, _onLeaveFail);
      }

      /**
       * Handles the leave/disband response. On success the player's alliance state
       * is cleared and the My Alliance tab is re-selected, which now renders the
       * "create an alliance" prompt; a present `error` field surfaces a message.
       */
      private function _onLeaveComplete(response:Object):void
      {
         if (response && response.error)
         {
            GLOBAL.Message(String(response.error));
            return;
         }
         ALLIANCES.Clear();
         ALLIANCES._allianceID = 0;
         ALLIANCES.InvalidateMyAlliance();
         if (ALLIANCEWINDOW._mc != null)
         {
            ALLIANCEWINDOW._mc.SelectTab(MY_ALLIANCE_TAB);
         }
      }

      private function _onLeaveFail(e:IOErrorEvent):void
      {
         GLOBAL.Message(KEYS.Get("alliance_err_generic"));
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
       * Sends the input text over the shared transport. Until the server confirms
       * the join there is no channel to send on, so we surface a status row instead.
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
         if (_chat != null && _chat.isConnected && _chatChannel != null)
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
       * Leaves the alliance channel when this tab is removed (tab switch or popup
       * close). The socket belongs to the chat dock and stays open — disconnecting
       * it here would drop the player out of global chat as well.
       */
      private function _onRemovedFromStage(e:Event):void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
         if (_chat != null)
         {
            _chat.removeEventListener(ChatEvent.LOGIN, _onWsLogin);
            _chat.removeEventListener(ChatEvent.JOIN, _onWsJoin);
            _chat.removeEventListener(ChatEvent.SAY, _onWsSay);
            if (_chatChannel != null)
            {
               _chat.leave(_chatChannel);
            }
            _chat = null;
         }
         _chatChannel = null;
      }

      private function _buildNoAlliance():void
      {
         const titleH:int = TITLE_SIZE + 8;
         const innerX:int = int((CONTENT_W - CONTENT_W_INNER) / 2);

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
