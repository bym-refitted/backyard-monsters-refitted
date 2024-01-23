package com.monsters.monsters.components.statusEffects
{
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.monsters.MonsterBase;
   
   public class DOTEffect extends CStatusEffect
   {
      
      public static const kDOTType_Stacks:int = 0;
      
      public static const kDOTType_Renews:int = 1;
       
      
      private var _initialDPS:Number = 0;
      
      private var _renewsPerAttack:int = 0;
      
      private var _numRenews:int = -1;
      
      private var _stacks:int = 1;
      
      private var _dotType:int = 0;
      
      public function DOTEffect(param1:MonsterBase, param2:Number = 0, param3:String = "venom", param4:int = 0, param5:int = -1)
      {
         super(param1);
         this._renewsPerAttack = this._numRenews = param5;
         this._initialDPS = _dps = param2;
         SPRITES.SetupSprite(param3);
         _icon = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(param3) as SpriteData,1);
         _icon.play();
      }
      
      override protected function updateDPS(param1:int) : void
      {
         super.updateDPS(param1);
         if(this._numRenews > 0)
         {
            --this._numRenews;
         }
         if(!this._numRenews)
         {
            unregister();
         }
      }
      
      override public function renew() : void
      {
         if(this._dotType == kDOTType_Stacks)
         {
            ++this._stacks;
            _dps = this._initialDPS * this._stacks;
         }
         else if(this._dotType == kDOTType_Renews)
         {
            if(this._numRenews > -1)
            {
               this._numRenews += this._renewsPerAttack;
            }
         }
      }
   }
}
