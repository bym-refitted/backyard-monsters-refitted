package
{
   import flash.display.BitmapData;

   // Authentic protection-shield glyph extracted from assets.swf (symbol id1096, 17x18) and
   // baked to the desktop red tint. Embedded as a straight PNG bitmap (composites fine on iOS
   // AIR, unlike the original DefineShape-with-bitmap-fill which rasterizes to 0 px). Used by
   // GLOBAL.SyncIOSBadge for the iOS top-HUD protection badge.
   [Embed(source="/_assets/badge_shield.png")]
   public dynamic class badge_shield extends BitmapData
   {
      public function badge_shield(param1:int = 17, param2:int = 18)
      {
         super(param1, param2);
      }
   }
}
