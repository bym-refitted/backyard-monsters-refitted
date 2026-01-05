package com.monsters.monsters.components.statusEffects
{
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.monsters.MonsterBase;
   
   public class FlameEffect extends CStatusEffect
   {
       
      
      public function FlameEffect(param1:MonsterBase, param2:Number = 25)
      {
         super(param1);
         _dps = param2;
         SPRITES.SetupSprite("flame");
         _icon = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor("flame") as SpriteData,1);
         _icon.play();
      }
   }
}
