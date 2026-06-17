package com.monsters.alliances
{
   public class AllianceConstants
   {
      public static const CONTENT_W:int = 808;
      // Default beige inner-background height. Tabs may override via
      // AllianceTabBase.contentHeight (e.g. My Alliance needs a taller area).
      public static const CONTENT_H:int = 452;

      // Beige inner panel — original "tabs-background" (#efd9c1 / border #a28c74)
      public static const INNER_BG:uint = 0xEFD9C1;
      public static const BORDER_COLOR:uint = 0xA28C74;

      // ── Original alliance palette (from alliance.v343.css) ──────────────
      // Tables
      public static const HEADER_BG:uint = 0xCAA276;    // header row
      public static const ROW_ALT0:uint = 0xF7ECE0;     // even rows
      public static const ROW_ALT1:uint = 0xEFD9C1;     // odd rows (matches beige)
      public static const ROW_ME:uint = 0xFAF082;       // current player's row
      public static const TABLE_BORDER:uint = 0x949493; // table outer border
      public static const CELL_BORDER:uint = 0x4D4D4D;  // inset cell/separator border

      // Shared accents
      public static const ACTION_BG:uint = 0xAF7F53;    // actionsBox / shout post-bar
      public static const SHOUTBOX_BG:uint = 0xDDDDDD;  // shoutbox background

      // Shout message bands
      public static const SHOUT_BAND0:uint = 0xCCDFBE;
      public static const SHOUT_BAND1:uint = 0xE6EFDF;
      public static const SHOUT_GOLD:uint = 0xFBF39D;

      // Relationship swatches (relative to viewer's alliance)
      public static const REL_HOSTILE:uint = 0xFF4628;
      public static const REL_NEUTRAL:uint = 0xFFFF00;
      public static const REL_FRIENDLY:uint = 0x13DD05;
      public static const REL_FRIEND:uint = 0x00A0DB;   // own / allied

      public static const TAB_LABELS:Array = [
            "alliance_tab_browse",
            "alliance_tab_myalliance",
            "alliance_tab_powerups",
            "alliance_tab_members",
            "alliance_tab_suggested",
            "alliance_tab_invites"
         ];
      public static const TAB_WIDTHS:Array = [142, 110, 98, 126, 100, 100];
   }
}
