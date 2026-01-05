package com.monsters.player
{
   import com.monsters.monsters.MonsterBase;
   
   public final class MonsterData
   {
      
      public static const kHealID:int = 1;
       
      
      public var m_creeps:Vector.<CreepInfo>;
      
      public var m_creatureID:String;
      
      private var m_level:int;
      
      private var m_maxHealth:int;
      
      public function MonsterData()
      {
         super();
         this.m_creatureID = "";
         this.m_creeps = new Vector.<CreepInfo>();
         this.m_level = 0;
         this.m_maxHealth = 0;
      }
      
      public function get maxHealth() : int
      {
         return this.m_maxHealth;
      }
      
      public function get level() : int
      {
         return this.m_level;
      }
      
      public function set level(param1:int) : void
      {
         this.m_level = param1;
         this.m_maxHealth = CREATURES.GetProperty(this.m_creatureID,"health",this.m_level);
      }
      
      public function get numCreeps() : int
      {
         return this.m_creeps.length;
      }
      
      public function get numBunkeredCreeps() : int
      {
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = _loc1_;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            if(this.m_creeps[_loc3_].ownerID == 0)
            {
               _loc2_--;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get numHousedCreeps() : int
      {
         return this.numCreeps - this.numBunkeredCreeps;
      }
      
      public function numCreepsByHouse(param1:int = 0, param2:Boolean = false) : int
      {
         var _loc3_:int = int(this.m_creeps.length);
         var _loc4_:int = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            if(this.m_creeps[_loc4_].ownerID != param1 || param2 && !this.m_creeps[_loc4_].queued)
            {
               _loc3_--;
            }
            _loc4_--;
         }
         return _loc3_;
      }
      
      public function get numHealthyHousedCreeps() : int
      {
         var _loc3_:CreepInfo = null;
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = _loc1_;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this.m_creeps[_loc4_];
            if(_loc3_.health < this.m_maxHealth || _loc3_.ownerID != 0)
            {
               _loc2_--;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function get numTotalHealthyCreeps() : int
      {
         var _loc3_:CreepInfo = null;
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = _loc1_;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this.m_creeps[_loc4_];
            if(_loc3_.health < this.m_maxHealth)
            {
               _loc2_--;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function numHealingCreeps(param1:int = 0) : int
      {
         var _loc3_:CreepInfo = null;
         var _loc2_:int = int(this.m_creeps.length);
         var _loc4_:int = _loc2_ - 1;
         while(_loc4_ >= 0)
         {
            _loc3_ = this.m_creeps[_loc4_];
            if(_loc3_.ownerID != param1 || !_loc3_.queued || _loc3_.health >= this.m_maxHealth)
            {
               _loc2_--;
            }
            _loc4_--;
         }
         return _loc2_;
      }
      
      public function getNumCreepsCanHealWithSpecificResourceAmount(param1:Number, param2:int = 0) : Object
      {
         var _loc3_:Number = CREATURES.GetProperty(this.m_creatureID,"hTime",this.m_level);
         var _loc4_:int = CREATURES.GetProperty(this.m_creatureID,"hResource",this.m_level);
         var _loc5_:int = Math.ceil(this.m_maxHealth / _loc3_);
         CREATURES.GetProperty(this.m_creatureID,"health",this.m_level);
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.m_creeps.sort(this.healthSort);
         var _loc8_:int = int(this.m_creeps.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            if(!((_loc6_ = (1 - this.m_creeps[_loc9_].health / this.m_maxHealth) * _loc4_) <= param1 && this.m_creeps[_loc9_].ownerID == param2))
            {
               break;
            }
            param1 -= _loc6_;
            _loc7_++;
            _loc9_++;
         }
         return {
            "num":_loc7_,
            "resoLeft":param1
         };
      }
      
      public function getHighestTimeWithHousingSplit(param1:int = 0) : int
      {
         var _loc6_:CreepInfo = null;
         var _loc2_:int = BASE.getNumHousingHealsPerTick();
         var _loc3_:int = this.numCreepsByHouse(param1,true);
         var _loc4_:int = int(this.m_creeps.length);
         var _loc5_:Vector.<int> = new Vector.<int>(_loc2_);
         var _loc7_:int = 0;
         this.m_creeps.sort(this.healthSort);
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_)
         {
            if((_loc6_ = this.m_creeps[_loc8_]).health < this.m_maxHealth && _loc6_.ownerID == param1 && Boolean(_loc6_.queued))
            {
               _loc5_[_loc7_] += this.timeLeftToHealCreep(_loc6_);
               _loc7_ = (_loc7_ + 1) % _loc2_;
            }
            _loc8_++;
         }
         _loc7_ = 0;
         _loc8_ = 1;
         while(_loc8_ < _loc2_)
         {
            if(_loc5_[_loc8_] > _loc5_[_loc7_])
            {
               _loc7_ = _loc8_;
            }
            _loc8_++;
         }
         return _loc5_[_loc7_];
      }
      
      private function timeLeftToHealCreep(param1:CreepInfo) : int
      {
         var _loc2_:Number = CREATURES.GetProperty(this.m_creatureID,"hTime",this.m_level);
         return (this.m_maxHealth - param1.health) / (this.m_maxHealth / _loc2_);
      }
      
      private function healthSort(param1:CreepInfo, param2:CreepInfo) : Number
      {
         if(param1.health == param2.health)
         {
            return 0;
         }
         if(param1.health >= this.m_maxHealth)
         {
            return 1;
         }
         if(param2.health >= this.m_maxHealth)
         {
            return -1;
         }
         if(param1.health < param2.health)
         {
            return 1;
         }
         if(param1.health > param2.health)
         {
            return -1;
         }
         return 0;
      }
      
      public function get totalHealth() : int
      {
         return this.numHousedCreeps * this.m_maxHealth;
      }
      
      public function totalOwnedHealth(param1:int = 0, param2:Boolean = false) : int
      {
         return this.numCreepsByHouse(param1,param2) * this.m_maxHealth;
      }
      
      public function curHealth(param1:int = 0, param2:Boolean = false) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = int(this.m_creeps.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.m_creeps[_loc5_].ownerID == param1 && (!param2 || param2 && this.m_creeps[_loc5_].queued))
            {
               if(this.m_creeps[_loc5_].health > this.m_maxHealth)
               {
                  _loc3_ += this.m_maxHealth;
               }
               else
               {
                  _loc3_ += this.m_creeps[_loc5_].health;
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function needsHeals() : Boolean
      {
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.m_creeps[_loc2_].health < this.m_maxHealth && !this.m_creeps[_loc2_].queued)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function heal(param1:int = 0) : Boolean
      {
         var _loc6_:CreepInfo = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc2_:Number = CREATURES.GetProperty(this.m_creatureID,"hTime",this.m_level);
         var _loc3_:Number = this.m_maxHealth / _loc2_;
         var _loc4_:int = int(this.m_creeps.length);
         var _loc5_:Boolean = true;
         var _loc7_:CreepInfo = null;
         var _loc8_:int = -1;
         var _loc9_:int = BASE.getNumHousingHealsPerTick();
         var _loc10_:Vector.<CreepInfo> = new Vector.<CreepInfo>();
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            _loc8_ = -1;
            _loc7_ = null;
            _loc13_ = 0;
            while(_loc13_ < _loc4_)
            {
               if((_loc6_ = this.m_creeps[_loc13_]).ownerID == param1 && Boolean(_loc6_.queued))
               {
                  if(_loc6_.health < this.m_maxHealth)
                  {
                     if(!this.checkAlreadyInList(_loc6_,_loc10_))
                     {
                        if(_loc6_.health > _loc8_)
                        {
                           _loc8_ = _loc6_.health;
                           _loc7_ = _loc6_;
                        }
                     }
                  }
                  if(_loc6_.health > this.m_maxHealth)
                  {
                     _loc6_.health = this.m_maxHealth;
                     _loc6_.queued = 0;
                  }
               }
               _loc13_++;
            }
            if(_loc7_)
            {
               _loc10_.push(_loc7_);
            }
            _loc11_++;
         }
         if(_loc4_ = int(_loc10_.length))
         {
            _loc14_ = 0;
            while(_loc14_ < _loc4_)
            {
               _loc10_[_loc14_].health += _loc3_;
               if(_loc10_[_loc14_].self)
               {
                  _loc12_ = _loc10_[_loc14_].health - _loc10_[_loc14_].self.health;
                  _loc10_[_loc14_].self.modifyHealth(_loc12_);
               }
               _loc14_++;
            }
         }
         return !_loc10_.length;
      }
      
      private function checkAlreadyInList(param1:CreepInfo, param2:Vector.<CreepInfo>) : Boolean
      {
         var _loc3_:int = int(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1 == param2[_loc4_])
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function healInstant(param1:int = 0, param2:Boolean = false) : void
      {
         var _loc3_:int = int(this.m_creeps.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.m_creeps[_loc4_].ownerID == param1 || param2)
            {
               this.m_creeps[_loc4_].health = this.m_maxHealth;
               this.m_creeps[_loc4_].queued = 0;
               if(this.m_creeps[_loc4_].self)
               {
                  this.m_creeps[_loc4_].self.modifyHealth(this.m_maxHealth);
               }
            }
            _loc4_++;
         }
      }
      
      public function setQueued(param1:Boolean, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:int = param1 ? 1 : 0;
         var _loc5_:int = !!param3 ? param3 : int(this.m_creeps.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(this.m_creeps[_loc6_].ownerID == param2)
            {
               if(!_loc4_ || this.m_creeps[_loc6_].health < this.m_maxHealth)
               {
                  this.m_creeps[_loc6_].queued = _loc4_;
               }
            }
            _loc6_++;
         }
      }
      
      public function checkForNonQueuedCreeps(param1:int = 0) : Boolean
      {
         var _loc2_:int = int(this.m_creeps.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.m_creeps[_loc3_].ownerID == param1 && !this.m_creeps[_loc3_].queued)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function add(param1:int, param2:MonsterBase = null, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:CreepInfo = null;
         if(param1 > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < param1)
            {
               this.m_creeps.push(new CreepInfo(0,int.MAX_VALUE,param2));
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = int(this.m_creeps.length);
            param1 *= -1;
            _loc4_ = _loc5_ - 1;
            while(_loc4_ >= 0 && Boolean(param1))
            {
               _loc6_ = this.m_creeps[_loc4_];
               if(param3 || !_loc6_.ownerID)
               {
                  this.m_creeps.splice(_loc4_,1);
                  param1--;
               }
               _loc4_--;
            }
         }
      }
      
      public function juiceCreep() : void
      {
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = 0;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            if(!this.m_creeps[_loc4_].ownerID)
            {
               if(this.m_creeps[_loc4_].health > _loc2_)
               {
                  _loc2_ = this.m_creeps[_loc4_].health;
                  _loc3_ = _loc4_;
               }
            }
            _loc4_++;
         }
         if(_loc3_ >= 0)
         {
            if(this.m_creeps[_loc3_].self)
            {
               this.m_creeps[_loc3_].self.changeModeJuice();
            }
            this.m_creeps.splice(_loc3_,1);
         }
      }
      
      public function setNum(param1:int) : void
      {
         if(param1 >= 0)
         {
         }
      }
      
      public function getOwnedCreeps(param1:int = 0) : Vector.<CreepInfo>
      {
         if(param1 == 0)
         {
            print("lol, you silly person. You can\'t do this with housing... for no good reason");
         }
         var _loc2_:Vector.<CreepInfo> = new Vector.<CreepInfo>();
         var _loc3_:int = int(this.m_creeps.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(this.m_creeps[_loc5_].ownerID == param1)
            {
               _loc2_.push(this.m_creeps[_loc5_]);
               _loc4_++;
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function linkCreepToData(param1:MonsterBase, param2:int = 0) : void
      {
         var _loc3_:int = int(this.m_creeps.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_ && (this.m_creeps[_loc4_].self || !this.m_creeps[_loc4_].ownerID && this.m_creeps[_loc4_].health < this.m_maxHealth || this.m_creeps[_loc4_].ownerID != param2))
         {
            _loc4_++;
         }
         if(_loc4_ < _loc3_)
         {
            this.m_creeps[_loc4_].self = param1;
         }
         else
         {
            print("what the fuck??? linkCreepToData, you somehow tried to assign a creep past the number of creeps you have???");
         }
      }
      
      public function unlinkCreepFromData(param1:MonsterBase) : void
      {
         var _loc2_:int = int(this.m_creeps.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.m_creeps[_loc3_].self == param1)
            {
               this.m_creeps[_loc3_].health = param1.health;
               this.m_creeps[_loc3_].self = null;
            }
            _loc3_++;
         }
      }
      
      public function clear() : void
      {
         var _loc1_:int = int(this.m_creeps.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.m_creeps[_loc2_].self = null;
            _loc2_++;
         }
      }
      
      public function reserve(param1:uint) : CreepInfo
      {
         var _loc2_:int = int(this.m_creeps.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(!(this.m_creeps[_loc3_].ownerID != 0 || this.m_creeps[_loc3_].health < this.m_maxHealth))
            {
               this.m_creeps[_loc3_].ownerID = param1;
               break;
            }
            _loc3_++;
         }
         if(_loc3_ < _loc2_)
         {
            return this.m_creeps[_loc3_];
         }
         return null;
      }
      
      public function release(param1:uint) : CreepInfo
      {
         var _loc2_:int = int(this.m_creeps.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.m_creeps[_loc3_].ownerID == param1 && this.m_creeps[_loc3_].health >= this.m_maxHealth)
            {
               this.m_creeps[_loc3_].ownerID = 0;
               return this.m_creeps[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}
