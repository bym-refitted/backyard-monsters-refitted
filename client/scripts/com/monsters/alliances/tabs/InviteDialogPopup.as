package com.monsters.alliances.tabs
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   /**
    * Modal shown when a player opens a pending alliance invite from the Invites
    * tab. Mirrors the original canvas.htm message dialog (function `Ga`, the
    * type=="invite"/status=="pending" branch) and its #message-dialog CSS:
    *
    *   [ header ]
    *   From: {inviter} - {alliance}                       {date}
    *   Subject: Invitation to Join {alliance}
    *   {body text}
    *                                          [ Decline ] [ Join ]
    *
    * The body is left-aligned; From and Date share a row (From left, Date right);
    * the buttons sit bottom-right. The original rendered an `alliance_invitation.png`
    * header image; that asset isn't in the repo, so — consistent with the other
    * alliance popups — the header is drawn as Groboldov title text instead. The
    * original dialog has no alliance icon (the shield only appears in the table
    * row), so none is drawn here.
    */
   public class InviteDialogPopup
   {
      private static const BG_W:int = 460;
      private static const PAD_H:int = 28;
      private static const PAD_TOP:int = 29;
      private static const PAD_BTN:int = 71;
      private static const TITLE_SIZE:int = 22;
      private static const BODY_SIZE:int = 14;
      private static const TITLE_GAP:int = 12;
      private static const LINE_H:int = 22;
      // Matches the original #date field width (alliance.v343.css) — sized for
      // the "MM/DD" string, which is all the dialog shows (year dropped)
      private static const DATE_W:int = 60;
      private static const CONTENT_W:int = BG_W - PAD_H * 2;

      private var _mc:MovieClip;
      private var _onJoin:Function;
      private var _onDecline:Function;

      /**
       * Opens the invite dialog.
       * @param {String} inviterName - Name of the player who sent the invite
       * @param {String} allianceName - Alliance being invited to
       * @param {String} dateStr - Pre-formatted invite date
       * @param {Function} onJoin - Called when the player accepts
       * @param {Function} onDecline - Called when the player declines
       */
      public function Show(inviterName:String, allianceName:String, dateStr:String,
            onJoin:Function, onDecline:Function):void
      {
         _onJoin = onJoin;
         _onDecline = onDecline;
         _mc = new MovieClip();

         var tBody:TextField = new TextField();
         tBody.wordWrap = true;
         tBody.multiline = true;
         tBody.width = CONTENT_W;
         var bodyFmt:TextFormat = new TextFormat("Verdana", BODY_SIZE, 0x000000);
         bodyFmt.align = TextFormatAlign.LEFT;
         tBody.defaultTextFormat = bodyFmt;
         tBody.htmlText = KEYS.Get("alliance_invite_body", {"v1": inviterName, "v2": allianceName});

         const titleH:int = TITLE_SIZE + 8;
         const bodyH:int = int(tBody.textHeight) + 6;
         const totalH:int = PAD_TOP + titleH + TITLE_GAP + LINE_H + LINE_H + 4 + bodyH + PAD_BTN + 16;
         const frameX:int = -int(BG_W * 0.5);
         const frameY:int = -int(totalH * 0.5);
         const contentX:int = frameX + PAD_H;

         var frame:frame_CLIP = _mc.addChild(new frame_CLIP()) as frame_CLIP;
         frame.width = BG_W;
         frame.height = totalH;
         frame.x = frameX;
         frame.y = frameY;
         frame.Setup(true, _onClose);

         var tTitle:TextField = _mc.addChild(new TextField()) as TextField;
         tTitle.selectable = false;
         tTitle.mouseEnabled = false;
         tTitle.embedFonts = true;
         tTitle.antiAliasType = AntiAliasType.NORMAL;
         tTitle.width = CONTENT_W;
         tTitle.height = titleH;
         var titleFmt:TextFormat = new TextFormat("Groboldov", TITLE_SIZE, 0xFFFFFF);
         titleFmt.align = TextFormatAlign.CENTER;
         tTitle.defaultTextFormat = titleFmt;
         tTitle.text = KEYS.Get("alliance_invite_header");
         tTitle.filters = [new GlowFilter(0, 1, 3, 3, 9, 2), new DropShadowFilter(2, 45, 0, 0.55, 3, 3, 1, 2)];
         tTitle.x = contentX;
         tTitle.y = frameY + PAD_TOP;

         const bodyTop:int = tTitle.y + titleH + TITLE_GAP;

         // The original drops the year, rendering only the first two "/"-split
         // parts (MM/DD) in bold (alliances.min.v343.js: d.date = b[0] + "/" + b[1]).
         var dateParts:Array = dateStr.split("/");
         var shortDate:String = (dateParts.length >= 2) ? (dateParts[0] + "/" + dateParts[1]) : dateStr;
         _addLine("<b>" + KEYS.Get("alliance_dialog_from") + "</b> " + inviterName + " - " + allianceName,
               contentX, bodyTop, CONTENT_W - DATE_W, LINE_H, 13, 0x000000, TextFormatAlign.LEFT);
         _addLine("<b>" + shortDate + "</b>",
               contentX + CONTENT_W - DATE_W, bodyTop, DATE_W, LINE_H, 13, 0x000000, TextFormatAlign.RIGHT);

         // The original subject string has no alliance-name placeholder (a quirk
         // of the source data) — kept byte-faithful here.
         _addLine("<b>" + KEYS.Get("alliance_dialog_subject") + "</b> " + KEYS.Get("alliance_invite_subject"),
               contentX, bodyTop + LINE_H, CONTENT_W, LINE_H, 13, 0x000000, TextFormatAlign.LEFT);

         tBody.selectable = false;
         tBody.mouseEnabled = false;
         _mc.addChild(tBody);
         tBody.x = contentX;
         tBody.y = bodyTop + LINE_H + LINE_H + 4;

         const btnW:int = 120;
         const btnGap:int = 10;
         const btnY:int = frameY + totalH - PAD_BTN;

         var btnJoin:Button_CLIP = _mc.addChild(new Button_CLIP()) as Button_CLIP;
         btnJoin.Setup(KEYS.Get("alliance_btn_join"), false, btnW, 36);
         btnJoin.x = contentX + CONTENT_W - btnW;
         btnJoin.y = btnY;
         btnJoin.addEventListener(MouseEvent.CLICK, _onJoinClick);

         var btnDecline:Button_CLIP = _mc.addChild(new Button_CLIP()) as Button_CLIP;
         btnDecline.Setup(KEYS.Get("alliance_btn_decline"), false, btnW, 36);
         btnDecline.x = btnJoin.x - btnGap - btnW;
         btnDecline.y = btnY;
         btnDecline.addEventListener(MouseEvent.CLICK, _onDeclineClick);

         GLOBAL.BlockerAdd(GLOBAL._layerTop);
         GLOBAL._layerTop.addChild(_mc);
         POPUPSETTINGS.AlignToCenter(_mc);
         POPUPSETTINGS.ScaleUp(_mc);
      }

      /**
       * Adds a non-interactive single-line label (htmlText, so bold field labels
       * render).
       */
      private function _addLine(html:String, x:int, y:int, w:int, h:int,
            size:int, color:uint, align:String):void
      {
         var tf:TextField = _mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = w;
         tf.height = h;
         tf.x = x;
         tf.y = y;
         var fmt:TextFormat = new TextFormat("Verdana", size, color, false);
         fmt.align = align;
         tf.defaultTextFormat = fmt;
         tf.htmlText = html;
      }

      private function _onJoinClick(e:MouseEvent = null):void
      {
         SOUNDS.Play("click1");
         var cb:Function = _onJoin;
         _close();
         if (cb != null)
         {
            cb();
         }
      }

      private function _onDeclineClick(e:MouseEvent = null):void
      {
         SOUNDS.Play("click1");
         var cb:Function = _onDecline;
         _close();
         if (cb != null)
         {
            cb();
         }
      }

      /** Frame [X] button — dismisses without accepting or declining. */
      private function _onClose():void
      {
         SOUNDS.Play("close");
         _close();
      }

      private function _close():void
      {
         GLOBAL.BlockerRemove();
         if (_mc && _mc.parent)
         {
            _mc.parent.removeChild(_mc);
         }
         _mc = null;
         _onJoin = null;
         _onDecline = null;
      }
   }
}
