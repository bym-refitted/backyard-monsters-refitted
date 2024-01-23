package com.monsters.monsters.components.statusEffects
{
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.monsters.MonsterBase;
   
   public class AcidStatusEffect extends CStatusEffect
   {
       
      
      public function AcidStatusEffect(param1:MonsterBase, param2:Number)
      {
         super(param1);
         _dps = param2;
         SPRITES.SetupSprite("venomBal");
         _icon = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor("venomBal") as SpriteData,1);
         _icon.play();
      }
   }
}
