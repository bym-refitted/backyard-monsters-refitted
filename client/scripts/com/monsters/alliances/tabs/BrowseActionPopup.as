package com.monsters.alliances.tabs
{
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.alliances.AllianceConstants;
   import com.monsters.alliances.tabs.AllianceMessagePopup;
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class BrowseActionPopup extends MovieClip
   {
      public static const POPUP_W:int = 150;
      private static const BTN_W:int = 134;
      private static const BTN_H:int = 32;
      private static const BTN_FONT_SIZE:int = 12;
      private static const PAD:int = 8;
      private static const BTN_GAP:int = 6;
      private static const ICON_ROW_GAP:int = 8;
      private static const ICON_W:int = 37;
      private static const ICON_H:int = 35;
      private static const ICON_GAP:int = 8;
      private static const ICON_INSET:int = 3;
      private static const RELATION_COLORS:Array = [
            AllianceConstants.REL_HOSTILE,
            AllianceConstants.REL_NEUTRAL,
            AllianceConstants.REL_FRIENDLY
         ];
      private static const RELATION_VALUES:Array = [-1, 0, 1];
      private static const RELATION_KEYS:Array = [
            "alliance_relation_foe",
            "alliance_relation_neutral",
            "alliance_relation_ally"
         ];

      public static const POPUP_H:int =
         PAD + BTN_H + BTN_GAP + BTN_H + ICON_ROW_GAP + ICON_H + PAD;

      private var _rowData:Object;
      private var _dismiss:Function;
      private var _onChanged:Function;
      private var _leaderBaseId:Number;

      /**
       * @param {Object} rowData - Alliance row data for this popup's row
       * @param {Function} dismiss - Callback supplied by BrowseTab to clean up popup state
       * @param {Function} onChanged - Called after a relationship change lands, so the row's swatch repaints
       */
      public function BrowseActionPopup(rowData:Object, dismiss:Function, onChanged:Function = null)
      {
         super();
         _rowData = rowData;
         _dismiss = dismiss;
         _onChanged = onChanged;
         _leaderBaseId = (_rowData != null) ? Number(_rowData.leader_baseid) : 0;
         _build();
      }

      private function _build():void
      {
         var bg:MovieClip = addChild(new MovieClip()) as MovieClip;
         bg.mouseEnabled = false;
         bg.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
         bg.graphics.beginFill(AllianceConstants.ACTION_BG, 1);
         bg.graphics.drawRoundRect(0, 0, POPUP_W, POPUP_H, 3, 3);
         bg.graphics.endFill();

         const btnX:int = int((POPUP_W - BTN_W) / 2);

         var visitBtn:MovieClip = _makeBtn(KEYS.Get("alliance_btn_visit_leader"));
         visitBtn.x = btnX;
         visitBtn.y = PAD;
         visitBtn.addEventListener(MouseEvent.CLICK, _onVisitLeader);

         var joinBtn:MovieClip = _makeBtn(KEYS.Get("alliance_btn_request_join"));
         joinBtn.x = btnX;
         joinBtn.y = PAD + BTN_H + BTN_GAP;
         joinBtn.addEventListener(MouseEvent.CLICK, _onRequestJoin);

         const iconsY:int = PAD + BTN_H + BTN_GAP + BTN_H + ICON_ROW_GAP;
         const startX:int = PAD;
         const shieldId:int = (_rowData != null) ? int(_rowData.image) : 0;

         var ci:int = 0;
         while (ci < RELATION_COLORS.length)
         {
            var box:MovieClip = addChild(new MovieClip()) as MovieClip;
            box.buttonMode = true;
            box.mouseChildren = false;
            box.graphics.lineStyle(1, AllianceConstants.CELL_BORDER, 1);
            box.graphics.beginFill(uint(RELATION_COLORS[ci]), 1);
            box.graphics.drawRect(0, 0, ICON_W, ICON_H);
            box.graphics.endFill();
            box.x = startX + ci * (ICON_W + ICON_GAP);
            box.y = iconsY;
            box.addEventListener(MouseEvent.CLICK, _makeRelationHandler(ci));
            _loadShield(box, shieldId, ICON_INSET);
            ci++;
         }
      }

      /**
       * Loads the alliance's shield into a relation-coloured swatch, inset so the
       * fill reads as a coloured border around it - the same treatment the Browse
       * table gives the name column. IDs 1-20 use the _large asset, 21+ _medium.
       * 
       * @param {MovieClip} container - The relation-tinted swatch.
       * @param {int} id - Shield id 1-41.
       * @param {int} inset - Padding between the swatch edge and the shield.
       */
      private function _loadShield(container:MovieClip, id:int, inset:int):void
      {
         if (id <= 0) return;

         var suffix:String = id <= 20 ? "_large" : "_medium";
         var key:String = "alliances/" + id + suffix + ".png";
         
         ImageCache.GetImageWithCallBack(
               key,
               function(k:String, bmd:BitmapData, args:Array):void
               {
                  var bmp:Bitmap = new Bitmap(bmd);
                  bmp.smoothing = true;
                  var mc:MovieClip = args[0] as MovieClip;
                  var ins:int = int(args[1]);
                  var bw:int = int(args[2]);
                  var bh:int = int(args[3]);
                  if (bmd.width > 0 && bmd.height > 0)
                  {
                     var scale:Number = Math.min(bw / bmd.width, bh / bmd.height);
                     bmp.scaleX = bmp.scaleY = scale;
                     bmp.x = ins + int((bw - bmd.width * scale) / 2);
                     bmp.y = ins + int((bh - bmd.height * scale) / 2);
                  }
                  mc.addChild(bmp);
               },
               true, 4, "", [container, inset, ICON_W - inset * 2, ICON_H - inset * 2]
            );
      }

      private function _makeBtn(label:String):MovieClip
      {
         var mc:MovieClip = addChild(new MovieClip()) as MovieClip;
         mc.buttonMode = true;
         mc.mouseChildren = false;

         _drawBtnBg(mc, false);

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = BTN_W;
         tf.height = 18;
         tf.x = 0;
         tf.y = int((BTN_H - 16) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", BTN_FONT_SIZE, 0x333333, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;

         mc.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void
            {
               _drawBtnBg(mc, true);
            });
         mc.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void
            {
               _drawBtnBg(mc, false);
            });

         return mc;
      }

      private function _drawBtnBg(mc:MovieClip, hover:Boolean):void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         if (hover)
         {
            mc.graphics.beginFill(0xF5F5F5, 1);
         }
         else
         {
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(BTN_W, BTN_H, Math.PI / 2, 0, 0);
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF4F5F2, 0xD9D9D9], [1, 1], [0, 255], mtx);
         }
         mc.graphics.drawRoundRect(0, 0, BTN_W, BTN_H, 6, 6);
         mc.graphics.endFill();
      }

      /**
       * Flags this row's alliance, then confirms.
       *
       * The confirmation is only shown once the server has taken the change, the
       * same way Request to Join works - a leader who is refused, or who is no
       * longer a leader, gets the server's own wording instead of a dialog
       * claiming something happened.
       *
       * @param {int} idx - Which swatch was clicked: 0 Foe, 1 Neutral, 2 Ally.
       * @returns {Function} The click handler for that swatch.
       */
      private function _makeRelationHandler(idx:int):Function
      {
         return function(e:MouseEvent):void
         {
            SOUNDS.Play("click1");

            var allianceId:int = (_rowData != null) ? int(_rowData.alliance_id) : 0;

            if (allianceId <= 0) return;

            var name:String = (_rowData && _rowData.name) ? String(_rowData.name) : "";
            var stance:int = int(RELATION_VALUES[idx]);
            var rowData:Object = _rowData;
            var onChanged:Function = _onChanged;
            var body:String = KEYS.Get(String(RELATION_KEYS[idx]), {"v1": name});

            // Already flagged this way, so there is nothing to send. The dialog
            // still shows - clicking Foe on a foe should read as confirmation,
            // not as a dead button - but the server is spared a write and the
            // feed a shout that announces nothing.
            if (int(_rowData.relationship) == stance)
            {
               _dismiss();
               new AllianceMessagePopup().Show(KEYS.Get("alliance_relation_title"), body);
               return;
            }

            _dismiss();
            PLEASEWAIT.Show(KEYS.Get("msg_loading"));

            ALLIANCES.ChangeRelationship(allianceId, stance, function(response:Object):void
               {
                  PLEASEWAIT.Hide();

                  if (response == null || response.error)
                  {
                     GLOBAL.Message((response && response.error)
                        ? String(response.error)
                        : KEYS.Get("alliance_err_generic"));
                     return;
                  }

                  if (rowData != null)
                  {
                     rowData.relationship = stance;
                  }

                  new AllianceMessagePopup().Show(KEYS.Get("alliance_relation_title"), body);

                  if (onChanged != null)
                  {
                     onChanged();
                  }
               });
         };
      }

      private function _onVisitLeader(e:MouseEvent):void
      {
         SOUNDS.Play("click1");

         if (!(_leaderBaseId > 0)) return;
         if (BASE._saving || BASE._loading || BASE._saveCounterA != BASE._saveCounterB) return;
         if (BASE.isInfernoMainYardOrOutpost) return;

         _dismiss();
         ALLIANCEWINDOW.Hide();

         GLOBAL._currentCell = null;

         var yardType:int = MapRoomManager.instance.isInMapRoom3
            ? int(EnumYardType.PLAYER)
            : int(EnumYardType.MAIN_YARD);

         BASE.LoadBase(null, 0, _leaderBaseId, GLOBAL.e_BASE_MODE.VIEW, true, yardType);
      }

      /**
       * Asks the alliance to take the player in. The confirmation is only shown
       * once the server has the request, so "REQUEST SENT!" means it was: a player
       * already in an alliance, or one who has asked this alliance before, gets the
       * server's own wording instead.
       */
      private function _onRequestJoin(e:MouseEvent):void
      {
         SOUNDS.Play("click1");

         var allianceId:int = (_rowData != null) ? int(_rowData.alliance_id) : 0;

         if (allianceId <= 0) return;

         _dismiss();
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));

         ALLIANCES.RequestJoin(allianceId, function(response:Object):void
            {
               PLEASEWAIT.Hide();

               if (response == null || response.error)
               {
                  GLOBAL.Message((response && response.error)
                     ? String(response.error)
                     : KEYS.Get("alliance_err_generic"));
                  return;
               }

               new AllianceMessagePopup().Show(
                     KEYS.Get("alliance_join_request_title"),
                     KEYS.Get("alliance_join_request_body")
                  );
            });
      }
   }
}
