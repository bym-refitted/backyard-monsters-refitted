package com.monsters.alliance.tabs
{
   import com.monsters.alliance.AllianceTabBase;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

   public class BrowseTab extends AllianceTabBase
   {
      private static const PAD:int         = 10;
      private static const BTN_H:int       = 36;
      private static const BTN_FILTER_W:int = 120;
      private static const INPUT_W:int     = 260;
      private static const BTN_SEARCH_W:int = 110;
      private static const CTRL_Y:int      = 10;
      private static const TABLE_Y:int     = CTRL_Y + BTN_H + 12;
      private static const HEADER_H:int    = 22;
      private static const ROW_H:int       = 36;
      private static const TABLE_X:int     = PAD;
      private static const TABLE_W:int     = 788;  // CONTENT_W - PAD * 2

      // Column layout — widths sum to TABLE_W (788)
      // | Rank(50) | Icon(35) | Name(220) | Members(85) | EmpirePoints(135) | Leader(138) | Actions(125) |
      private static const C_RANK_X:int = 0;   private static const C_RANK_W:int = 50;
      private static const C_ICON_X:int = 50;  private static const C_ICON_W:int = 35;
      private static const C_NAME_X:int = 85;  private static const C_NAME_W:int = 220;
      private static const C_MEM_X:int  = 305; private static const C_MEM_W:int  = 85;
      private static const C_EP_X:int   = 390; private static const C_EP_W:int   = 135;
      private static const C_LDR_X:int  = 525; private static const C_LDR_W:int  = 138;
      private static const C_ACT_X:int  = 663; private static const C_ACT_W:int  = 125;

      private var _filterMode:int = 0;
      private var _filterBtnAll:MovieClip;
      private var _filterBtnWorld:MovieClip;

      public function BrowseTab()
      {
         super();
      }

      override public function build() : void
      {
         _buildControls();
         _buildTable();
      }

      private function _buildControls() : void
      {
         _filterBtnAll = addChild(new MovieClip()) as MovieClip;
         _filterBtnAll.x = PAD;
         _filterBtnAll.y = CTRL_Y;
         _filterBtnAll.buttonMode = true;
         _filterBtnAll.mouseChildren = false;
         _drawFilterBtn(_filterBtnAll, "All", BTN_FILTER_W, BTN_H, _filterMode == 0);
         _filterBtnAll.addEventListener(MouseEvent.CLICK, _onFilterClick);

         _filterBtnWorld = addChild(new MovieClip()) as MovieClip;
         _filterBtnWorld.x = PAD + BTN_FILTER_W + 5;
         _filterBtnWorld.y = CTRL_Y;
         _filterBtnWorld.buttonMode = true;
         _filterBtnWorld.mouseChildren = false;
         _drawFilterBtn(_filterBtnWorld, "This World", BTN_FILTER_W, BTN_H, _filterMode == 1);
         _filterBtnWorld.addEventListener(MouseEvent.CLICK, _onFilterClick);

         // Search input + button anchored to right edge
         const searchBtnX:int = CONTENT_W - PAD - BTN_SEARCH_W;
         const inputX:int = searchBtnX - 8 - INPUT_W;
         // INPUT_BOX_H intentionally shorter than BTN_H — gap sits at bottom
         const INPUT_BOX_H:int = 32;
         // FIELD_H sized to exactly one line — avoids Flash rendering typed text in corner of oversized INPUT TextField
         const FIELD_H:int = 18;

         var inputBg:MovieClip = addChild(new MovieClip()) as MovieClip;
         inputBg.mouseEnabled = false;
         inputBg.graphics.beginFill(0xFFFFFF, 1);
         inputBg.graphics.lineStyle(1, 0x888888, 1);
         inputBg.graphics.drawRoundRect(0, 0, INPUT_W, INPUT_BOX_H, 2, 2);
         inputBg.graphics.endFill();
         inputBg.x = inputX;
         inputBg.y = CTRL_Y;

         var searchField:TextField = addChild(new TextField()) as TextField;
         searchField.type = TextFieldType.INPUT;
         searchField.background = false;
         searchField.border = false;
         searchField.selectable = true;
         searchField.mouseEnabled = true;
         searchField.width = INPUT_W - 12;
         searchField.height = FIELD_H;
         searchField.x = inputX + 6;
         searchField.y = CTRL_Y + int((INPUT_BOX_H - FIELD_H) / 2);
         var sfmt:TextFormat = new TextFormat("Verdana", 11, 0x333333, true);
         searchField.defaultTextFormat = sfmt;

         var btnSearch:Button_CLIP = addChild(new Button_CLIP()) as Button_CLIP;
         btnSearch.Setup("Search", false, BTN_SEARCH_W, BTN_H);
         btnSearch.x = searchBtnX;
         btnSearch.y = CTRL_Y;
      }

      private function _buildTable() : void
      {
         var dummyData:Array = [
            {rank:1,  name:"VENDETTA",            members:47, ep:"167,880,178,107", leader:"Rob",       color:0xFF5625},
            {rank:2,  name:"VENDETTA Warriors",   members:50, ep:"113,926,937,744", leader:"Vicki",     color:0x0AB705},
            {rank:3,  name:"VENDETTA ASSASSINS",  members:49, ep:"73,787,416,124",  leader:"Kez",       color:0x0AB705},
            {rank:4,  name:"VENDETTA NORTH",      members:50, ep:"35,491,719,566",  leader:"Sarah",     color:0xFF5625},
            {rank:5,  name:"VENDETTA II",         members:44, ep:"27,786,251,042",  leader:"Duke",      color:0xFFF200},
            {rank:6,  name:"VENDETTA Fire",       members:8,  ep:"3,601,840,764",   leader:"Valerie",   color:0xFF5625},
            {rank:7,  name:"Vendetta CATS",       members:4,  ep:"1,104,151,282",   leader:"Mongmong",  color:0x0AB705},
            {rank:8,  name:"vendetta VS me",      members:1,  ep:"870,836,236",     leader:"Alexander", color:0xFFF200},
            {rank:9,  name:"DESTROY VENDETTA",    members:7,  ep:"461,837,177",     leader:"manuel",    color:0xFF5625},
            {rank:10, name:"DESTROY VENDETTA II", members:9,  ep:"216,302,898",     leader:"JanEman",   color:0x0AB705}
         ];

         const totalH:int = HEADER_H + dummyData.length * ROW_H;

         var tableMC:MovieClip = addChild(new MovieClip()) as MovieClip;
         tableMC.x = TABLE_X;
         tableMC.y = TABLE_Y;

         // Pass 1: row background fills
         tableMC.graphics.beginFill(0xCFA377);
         tableMC.graphics.drawRect(0, 0, TABLE_W, HEADER_H);
         tableMC.graphics.endFill();

         var fi:int = 0;
         while (fi < dummyData.length)
         {
            tableMC.graphics.beginFill((fi % 2 == 0) ? 0xF8ECDF : 0xF1DAC1);
            tableMC.graphics.drawRect(0, HEADER_H + fi * ROW_H, TABLE_W, ROW_H);
            tableMC.graphics.endFill();
            fi++;
         }

         // Pass 2: grid lines on top of fills
         tableMC.graphics.lineStyle(1, 0x000000, 1);
         var hli:int = 0;
         while (hli <= dummyData.length)
         {
            var hlineY:int = (hli == 0) ? HEADER_H : HEADER_H + hli * ROW_H;
            tableMC.graphics.moveTo(0, hlineY);
            tableMC.graphics.lineTo(TABLE_W, hlineY);
            hli++;
         }
         var vLineXs:Array = [C_RANK_W, C_MEM_X, C_EP_X, C_LDR_X, C_ACT_X];
         var vli:int = 0;
         while (vli < vLineXs.length)
         {
            tableMC.graphics.moveTo(int(vLineXs[vli]), 0);
            tableMC.graphics.lineTo(int(vLineXs[vli]), totalH);
            vli++;
         }
         // Outer border uses gray (not black) to match surrounding UI
         tableMC.graphics.lineStyle(1, 0x888888, 1);
         tableMC.graphics.drawRect(0, 0, TABLE_W, totalH);

         // Pass 3: header labels
         // "Name" anchored to left of full Name column (rank+icon), not just the text portion
         // "Leader" has 5px left padding so text doesn't butt against separator line
         _addLabel(tableMC, "Rank",          C_RANK_X,         0, C_RANK_W,               HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, "Name",          C_RANK_W + 5,     0, C_MEM_X - C_RANK_W - 5, HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, "Members",       C_MEM_X,          0, C_MEM_W,                HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, "Empire Points", C_EP_X,           0, C_EP_W,                 HEADER_H, true, TextFormatAlign.CENTER);
         _addLabel(tableMC, "Leader",        C_LDR_X + 5,      0, C_LDR_W - 5,            HEADER_H, true, TextFormatAlign.LEFT);
         _addLabel(tableMC, "Actions",       C_ACT_X,          0, C_ACT_W,                HEADER_H, true, TextFormatAlign.CENTER);

         // Pass 4: data rows
         var ri:int = 0;
         while (ri < dummyData.length)
         {
            var rowData:Object = dummyData[ri];
            var rowBaseY:int = HEADER_H + ri * ROW_H;

            // Alliance shield icon — fills full cell height, 1px side margin for separator visibility
            var iconMC:MovieClip = tableMC.addChild(new MovieClip()) as MovieClip;
            iconMC.mouseEnabled = false;
            iconMC.graphics.beginFill(rowData.color, 1);
            iconMC.graphics.drawRect(0, 0, C_ICON_W - 2, ROW_H);
            iconMC.graphics.endFill();
            iconMC.x = C_ICON_X + 1;
            iconMC.y = rowBaseY;

            _addLabel(tableMC, String(rowData.rank),    C_RANK_X,     rowBaseY, C_RANK_W,     ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, rowData.name,            C_NAME_X + 6, rowBaseY, C_NAME_W - 6, ROW_H, false, TextFormatAlign.LEFT);
            _addLabel(tableMC, String(rowData.members), C_MEM_X,      rowBaseY, C_MEM_W,      ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, rowData.ep,              C_EP_X,       rowBaseY, C_EP_W,       ROW_H, false, TextFormatAlign.CENTER);
            _addLabel(tableMC, rowData.leader,          C_LDR_X + 5,  rowBaseY, C_LDR_W - 5, ROW_H, false, TextFormatAlign.LEFT);

            // Button fills almost the full cell (7px margin each side)
            var actBtn:Button_CLIP = tableMC.addChild(new Button_CLIP()) as Button_CLIP;
            actBtn.Setup("Actions", false, C_ACT_W - 14, ROW_H - 6);
            actBtn._txt.htmlText = "<b><font color=\"#000000\">Actions</font></b>";
            actBtn.x = C_ACT_X + 7;
            actBtn.y = rowBaseY + 3;

            ri++;
         }
      }

      private function _onFilterClick(e:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         _filterMode = (e.currentTarget == _filterBtnAll) ? 0 : 1;
         _drawFilterBtn(_filterBtnAll,   "All",        BTN_FILTER_W, BTN_H, _filterMode == 0);
         _drawFilterBtn(_filterBtnWorld, "This World", BTN_FILTER_W, BTN_H, _filterMode == 1);
      }

      /**
       * Draws (or redraws) a custom filter button.
       * Active state: top-to-bottom gradient (near-white → gray), dark text.
       * Inactive state: solid white background, dimmed text.
       */
      private function _drawFilterBtn(mc:MovieClip, label:String, w:int, h:int, active:Boolean) : void
      {
         mc.graphics.clear();
         mc.graphics.lineStyle(1, 0x888888, 1);
         if (active)
         {
            var mtx:Matrix = new Matrix();
            mtx.createGradientBox(w, h, Math.PI / 2, 0, 0);
            mc.graphics.beginGradientFill(GradientType.LINEAR, [0xF4F5F2, 0xD9D9D9], [1, 1], [0, 255], mtx);
         }
         else
         {
            mc.graphics.beginFill(0xFFFFFF, 1);
         }
         mc.graphics.drawRoundRect(0, 0, w, h, 6, 6);
         mc.graphics.endFill();

         while (mc.numChildren > 0) { mc.removeChildAt(0); }

         var tf:TextField = mc.addChild(new TextField()) as TextField;
         tf.selectable = false;
         tf.mouseEnabled = false;
         tf.width = w;
         tf.height = 20;
         tf.x = 0;
         tf.y = int((h - 18) / 2);
         var fmt:TextFormat = new TextFormat("Verdana", 11, active ? 0x333333 : 0x666666, true);
         fmt.align = TextFormatAlign.CENTER;
         tf.defaultTextFormat = fmt;
         tf.text = label;
      }
   }
}
