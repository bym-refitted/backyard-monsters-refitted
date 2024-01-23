package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.CModifiableProperty;
   import com.monsters.monsters.components.Component;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   
   public class LootingMultiplier extends Component
   {
       
      
      protected var m_multiplier:Number;
      
      protected var m_modifier:LootingModifier;
      
      protected var m_lootingProperty:CModifiableProperty;
      
      private var m_filter:BitmapFilter;
      
      public function LootingMultiplier(param1:Number)
      {
         super();
         this.m_multiplier = param1;
      }
      
      override protected function onRegister() : void
      {
         this.m_lootingProperty = owner.getComponentByName(MonsterBase.k_LOOT_PROPERTY) as CModifiableProperty;
         if(this.m_lootingProperty)
         {
            this.m_modifier = new LootingModifier(this.m_multiplier);
            this.m_lootingProperty.addModifier(this.m_modifier);
            if(!this.m_filter)
            {
               this.m_filter = new GlowFilter(5635873,0.6,8,8,4,3);
               owner.addFilter(this.m_filter);
            }
         }
      }
      
      override protected function onUnregister() : void
      {
         if(Boolean(this.m_lootingProperty) && Boolean(this.m_modifier))
         {
            this.m_lootingProperty.removeModifier(this.m_modifier);
         }
         if(this.m_filter)
         {
            owner.removeFilter(this.m_filter);
         }
      }
   }
}

import com.monsters.monsters.components.modifiers.AdditionPropertyModifier;

class LootingModifier extends AdditionPropertyModifier
{
    
   
   public function LootingModifier(param1:Number)
   {
      super(param1);
   }
}
