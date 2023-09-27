package com.monsters.monsters.components.abilities
{
   import com.cc.utils.SecNum;
   import com.monsters.interfaces.ITickable;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.components.Component;
   
   public class ProximityLootBuff extends Component implements ITickable
   {
       
      
      protected var _radiusSqrd:SecNum;
      
      protected var _championOwner:ChampionBase;
      
      private var m_buddiesInRange:Vector.<MonsterBase>;
      
      public function ProximityLootBuff()
      {
         this.m_buddiesInRange = new Vector.<MonsterBase>();
         super();
      }
      
      override public function register(param1:MonsterBase, param2:String = null) : void
      {
         super.register(param1,param2);
         this._championOwner = param1 as ChampionBase;
         this._radiusSqrd = new SecNum(this._championOwner._buffRadius * this._championOwner._buffRadius);
      }
      
      override public function unregister() : void
      {
         this.removeBuffFromCreepsNoLongerInRange();
         this._championOwner = null;
         super.onUnregister();
      }
      
      override public function tick(param1:int = 1) : void
      {
         var _loc4_:Object = null;
         var _loc5_:MonsterBase = null;
         var _loc6_:ChampionBase = null;
         var _loc7_:LootingMultiplier = null;
         var _loc8_:* = false;
         var _loc2_:Object = CREEPS._creeps;
         var _loc3_:Function = GLOBAL.QuickDistanceSquared;
         if(owner._behaviour !== MonsterBase.k_sBHVR_ATTACK && owner._behaviour !== MonsterBase.k_sBHVR_BOUNCE)
         {
            return;
         }
         if(owner._frameNumber % 50 == 0)
         {
            for each(_loc4_ in _loc2_)
            {
               _loc5_ = _loc4_ as MonsterBase;
               if(!(_loc4_ === owner || !_loc5_))
               {
                  _loc7_ = _loc5_.getComponentByType(LootingMultiplier) as LootingMultiplier;
                  if((_loc8_ = _loc3_(this._championOwner._tmpPoint,_loc5_._tmpPoint) < this._radiusSqrd.Get()) && !_loc7_)
                  {
                     _loc5_.addComponent(new LootingMultiplier(1 + this._championOwner._buff));
                     this.m_buddiesInRange.push(_loc5_);
                  }
               }
            }
            this.removeBuffFromCreepsNoLongerInRange();
         }
      }
      
      private function removeBuffFromCreepsNoLongerInRange() : void
      {
         var _loc4_:MonsterBase = null;
         var _loc5_:LootingMultiplier = null;
         var _loc6_:* = false;
         var _loc1_:Function = GLOBAL.QuickDistanceSquared;
         var _loc2_:int = int(this.m_buddiesInRange.length - 1);
         var _loc3_:int = _loc2_;
         while(_loc3_ >= 0)
         {
            _loc5_ = (_loc4_ = this.m_buddiesInRange[_loc3_]).getComponentByType(LootingMultiplier) as LootingMultiplier;
            if(!(_loc6_ = _loc1_(this._championOwner._tmpPoint,_loc4_._tmpPoint) < this._radiusSqrd.Get()) && Boolean(_loc5_))
            {
               _loc4_.removeComponent(_loc5_);
               this.m_buddiesInRange.splice(_loc3_,1);
            }
            _loc3_--;
         }
      }
   }
}
