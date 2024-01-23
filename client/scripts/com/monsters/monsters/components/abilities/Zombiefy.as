package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.components.modifiers.DivisionModifier;
   import com.monsters.monsters.components.modifiers.MultiplicationPropertyModifier;
   import flash.geom.Point;
   import gs.TweenMax;
   
   public class Zombiefy extends Component
   {
       
      
      private var m_attackDelayModifier:DivisionModifier;
      
      private var m_moveSpeedModifier:MultiplicationPropertyModifier;
      
      private var m_damageModifier:MultiplicationPropertyModifier;
      
      private var m_maxHealthModifier:MultiplicationPropertyModifier;
      
      public function Zombiefy(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.m_attackDelayModifier = new DivisionModifier(param1);
         this.m_moveSpeedModifier = new MultiplicationPropertyModifier(param1);
         this.m_damageModifier = new MultiplicationPropertyModifier(param3);
         this.m_maxHealthModifier = new MultiplicationPropertyModifier(param2);
      }
      
      override protected function onRegister() : void
      {
         owner.attackDelayProperty.addModifier(this.m_attackDelayModifier);
         owner.moveSpeedProperty.addModifier(this.m_moveSpeedModifier);
         owner.maxHealthProperty.store();
         owner.maxHealthProperty.addModifier(this.m_maxHealthModifier);
         owner.maxHealthProperty.updateHealth();
         owner.damageProperty.addModifier(this.m_damageModifier);
         TweenMax.to(owner._graphicMC,1,{"colorMatrixFilter":{"saturation":0}});
         owner.isDisposable = true;
      }
      
      override protected function onUnregister() : void
      {
         owner.attackDelayProperty.removeModifier(this.m_attackDelayModifier);
         owner.moveSpeedProperty.removeModifier(this.m_moveSpeedModifier);
         owner.maxHealthProperty.removeModifier(this.m_maxHealthModifier);
         owner.damageProperty.removeModifier(this.m_damageModifier);
         TweenMax.to(owner._graphicMC,1,{"colorMatrixFilter":{"saturation":1}});
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         if(Math.random() > 0.9)
         {
            _loc2_ = new Point(owner.x,owner.y).add(owner.getRandomPointOnGraphic());
            _loc3_ = new Point(owner.x,owner.y).add(owner.getRandomPointOnGraphic());
            EFFECTS.Lightning(_loc2_.x,_loc2_.y,_loc3_.x,_loc3_.y,null,65280);
         }
      }
      
      override public function clone() : Component
      {
         return new Zombiefy(this.m_moveSpeedModifier.multiple,this.m_maxHealthModifier.multiple,this.m_damageModifier.multiple);
      }
   }
}
