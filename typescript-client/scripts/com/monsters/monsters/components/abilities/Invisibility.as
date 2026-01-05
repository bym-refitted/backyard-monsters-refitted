package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.components.Component;
   
   public class Invisibility extends Component
   {
       
      
      private var m_timeInvisiblityExpires:int;
      
      private var m_cooldownDuration:int;
      
      private var m_isInvisible:Boolean;
      
      private var m_oldAggroRange:Number;
      
      public function Invisibility(param1:Number)
      {
         super();
         this.m_cooldownDuration = param1;
      }
      
      override public function tick(param1:int = 1) : void
      {
         if(this.m_isInvisible)
         {
            if(owner._atTarget)
            {
               if(this.m_timeInvisiblityExpires)
               {
                  if(GLOBAL.Timestamp() >= this.m_timeInvisiblityExpires)
                  {
                     this.stopInvisibility();
                  }
               }
               else
               {
                  this.m_timeInvisiblityExpires = this.m_cooldownDuration + GLOBAL.Timestamp();
               }
            }
            else
            {
               this.m_timeInvisiblityExpires = 0;
            }
         }
         else if(owner._hasTarget && !owner._atTarget)
         {
            this.startInvisibility();
         }
      }
      
      private function startInvisibility() : void
      {
         owner.spriteAction = "invisible";
         this.m_isInvisible = owner.invisible = true;
         this.m_oldAggroRange = owner.aggroRange;
         owner.aggroRange = 1;
      }
      
      private function stopInvisibility() : void
      {
         owner.spriteAction = "walking";
         this.m_isInvisible = owner.invisible = false;
         owner.aggroRange = this.m_oldAggroRange;
         this.m_timeInvisiblityExpires = 0;
      }
   }
}
