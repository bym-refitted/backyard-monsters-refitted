package com.monsters.baseBuffs
{
   import com.monsters.interfaces.IPlayerHandler;
   import com.monsters.player.Player;
   
   public class BaseBuffHandler implements IPlayerHandler
   {
      
      public static var instance:BaseBuffHandler = new BaseBuffHandler();
       
      
      private var m_buffs:Vector.<BaseBuff>;
      
      private var m_player:Player;
      
      private var m_isInitialized:Boolean;
      
      public function BaseBuffHandler()
      {
         super();
      }
      
      public function get isInitialized() : Boolean
      {
         return this.m_isInitialized;
      }
      
      public function getBuffByID(param1:uint) : BaseBuff
      {
         var _loc3_:BaseBuff = null;
         if(!this.isInitialized)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.m_buffs.length)
         {
            _loc3_ = this.m_buffs[_loc2_];
            if(param1 == _loc3_.id)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getBuffByName(param1:String) : BaseBuff
      {
         var _loc3_:BaseBuff = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.m_buffs.length)
         {
            _loc3_ = this.m_buffs[_loc2_];
            if(param1 == _loc3_.name)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addBuffByID(param1:uint) : BaseBuff
      {
         var _loc2_:BaseBuff = BaseBuffLibrary.getBuffByID(param1);
         if(_loc2_)
         {
            this.addBuff(_loc2_);
         }
         return _loc2_;
      }
      
      private function addBuff(param1:BaseBuff) : void
      {
         this.m_buffs.push(param1);
         param1.apply();
         print("added base buff " + param1 + "(id:" + param1.id + ") with a value of " + param1.value);
      }
      
      public function clearBuffs() : void
      {
         this.m_isInitialized = false;
         if(!this.m_buffs)
         {
            return;
         }
         var _loc1_:int = int(this.m_buffs.length - 1);
         while(_loc1_ >= 0)
         {
            this.m_buffs[_loc1_].clear();
            this.m_buffs.splice(_loc1_,1);
            _loc1_--;
         }
      }
      
      public function exportData() : Object
      {
         return null;
      }
      
      public function importData(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:BaseBuff = null;
         for(_loc2_ in param1)
         {
            if(!(!(_loc2_ is uint) || param1[_loc2_] == null || param1[_loc2_] == 0))
            {
               _loc3_ = BaseBuffLibrary.getBuffByID(uint(_loc2_),this.m_player.isAttacking ? BaseBuffLibrary.k_ATTACKING : BaseBuffLibrary.k_DEFENDING);
               if(_loc3_)
               {
                  _loc3_.value = param1[_loc2_];
                  this.addBuff(_loc3_);
               }
            }
         }
      }
      
      public function initialize(param1:Object = null) : void
      {
         if(!this.m_buffs)
         {
            BaseBuffLibrary.initialize();
            this.m_buffs = new Vector.<BaseBuff>();
         }
         this.m_isInitialized = true;
      }
      
      public function get name() : String
      {
         return "buffs";
      }
      
      public function set player(param1:Player) : void
      {
         this.m_player = param1;
      }
   }
}
