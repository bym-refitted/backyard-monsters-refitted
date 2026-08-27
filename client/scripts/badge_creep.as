package
{
   import flash.display.BitmapData;

   // Reinforcement glyph extracted from assets.swf (symbol id1100, 20x20), baked to an orange
   // tint. Same straight-PNG embed approach as badge_shield. Reinforcements are not populated by
   // this client build, so this badge stays hidden, but the art is wired for completeness.
   [Embed(source="/_assets/badge_creep.png")]
   public dynamic class badge_creep extends BitmapData
   {
      public function badge_creep(param1:int = 20, param2:int = 20)
      {
         super(param1, param2);
      }
   }
}
