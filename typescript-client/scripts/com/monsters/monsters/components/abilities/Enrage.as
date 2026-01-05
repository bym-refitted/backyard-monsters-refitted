package com.monsters.monsters.components.abilities
{
   import com.monsters.interfaces.IPropertyModifier;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.modifiers.ArmorPropertyModifier;
   import com.monsters.monsters.components.modifiers.DivisionModifier;
   import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;
   import flash.filters.BitmapFilter;
   import flash.filters.GlowFilter;
   
   public class Enrage extends Component
   {
       
      
      private var m_moveSpeedModifier:IPropertyModifier;
      
      private var m_attackSpeedModifier:IPropertyModifier;
      
      private var m_armorModifier:IPropertyModifier;
      
      private var m_filter:BitmapFilter;
      
      private var m_sourceCreatureID:String;
      
      public function Enrage(param1:Number, param2:Number, param3:String = null)
      {
         super();
         this.m_moveSpeedModifier = new MultiplicationPropertyModifier(param1);
         this.m_attackSpeedModifier = new DivisionModifier(param1);
         this.m_armorModifier = new ArmorPropertyModifier(param2);
         this.m_sourceCreatureID = param3;

         var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
         if (activeEvent.active && this.m_sourceCreatureID != "G3") {
            this.m_filter = new GlowFilter(13582340,1,3,3,5,1);
            return;
         }
         this.m_filter = new GlowFilter(16724735,0.6,8,8,4,3);
      }
      
      override protected function onUnregister() : void
      {
         owner.moveSpeedProperty.removeModifier(this.m_moveSpeedModifier);
         owner.attackDelayProperty.removeModifier(this.m_attackSpeedModifier);
         owner.armorProperty.removeModifier(this.m_armorModifier);
         owner.removeFilter(this.m_filter);
      }
      
      override protected function onRegister() : void
      {
         owner.moveSpeedProperty.addModifier(this.m_moveSpeedModifier);
         owner.attackDelayProperty.addModifier(this.m_attackSpeedModifier);
         owner.armorProperty.addModifier(this.m_armorModifier);
         owner.addFilter(this.m_filter);
      }
   }
}
