package com.monsters.player
{
   import com.cc.utils.SecNum;
   import com.monsters.baseBuffs.BaseBuffHandler;
   import com.monsters.interfaces.IHandler;
   import com.monsters.interfaces.IPlayerHandler;
   import com.monsters.interfaces.ITickable;
   import com.monsters.kingOfTheHill.KOTHHandler;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.rewarding.RewardHandler;
   import com.monsters.subscriptions.SubscriptionHandler;
   
   public class Player
   {
      
      private static const HANDLER_REWARD:int = 0;
      
      private static const HANDLER_KOTH:int = 1;
      
      private static const HANDLER_SUBSCRIPTIONS:int = 2;
       
      
      public var ID:int;
      
      public var name:String;
      
      public var lastName:String;
      
      public var picture:String;
      
      public var timePlayed:int;
      
      public var level:int;
      
      public var townHallLevel:int;
      
      public var email:String;
      
      public var proxyMail:String;
      
      public var isAttacking:Boolean;
      
      private var _handlers:Vector.<IHandler>;
      
      public var m_upgrades:Object;
      
      private var m_monsterList:Vector.<MonsterData>;
      
      private var m_iMonsterList:Vector.<MonsterData>;
      
      private var m_monsterIndexList:Array;
      
      private var m_healQueue:Vector.<String>;
      
      private var m_iHealQueue:Vector.<String>;
      
      public function Player()
      {
         this._handlers = Vector.<IHandler>([RewardHandler.instance,KOTHHandler.instance,SubscriptionHandler.instance,BaseBuffHandler.instance]);
         this.m_upgrades = {};
         super();
         this.m_monsterList = new Vector.<MonsterData>();
         this.m_monsterIndexList = new Array();
         this.m_iMonsterList = new Vector.<MonsterData>();
         this.m_healQueue = new Vector.<String>();
         this.m_iHealQueue = new Vector.<String>();
      }
      
      public function initialize() : void
      {
      }
      
      public function clear() : void
      {
         var _loc1_:Vector.<MonsterData> = this.monsterList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].clear();
            _loc3_++;
         }
      }
      
      public function set monsterList(param1:Vector.<MonsterData>) : void
      {
         if(BASE.isInfernoMainYardOrOutpost && !MAPROOM_DESCENT._inDescent)
         {
            this.m_iMonsterList = param1;
         }
         else
         {
            this.m_monsterList = param1;
         }
      }
      
      public function get monsterList() : Vector.<MonsterData>
      {
         if(BASE.isInfernoMainYardOrOutpost && !MAPROOM_DESCENT._inDescent)
         {
            return this.m_iMonsterList;
         }
         return this.m_monsterList;
      }
      
      public function get healQueue() : Vector.<String>
      {
         if(BASE.isInfernoMainYardOrOutpost)
         {
            return this.m_iHealQueue;
         }
         return this.m_healQueue;
      }
      
      public function monsterListByID(param1:String) : MonsterData
      {
         if(param1.substr(0,1) == "B")
         {
            print("ERROR. ERROR. tried to get monsterListByID of a bunker.");
         }
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         if(this.m_monsterIndexList[param1])
         {
            return _loc2_[this.m_monsterIndexList[param1] - 1];
         }
         return null;
      }
      
      public function numCreepsByID(param1:String) : int
      {
         if(param1.substr(0,1) == "B")
         {
            return this.numCreepsInBunker(int(param1.substr(1)));
         }
         return this.monsterListByID(param1).numHousedCreeps;
      }
      
      public function totalHealthByID(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         if(param1.substr(0,1) == "B")
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_ += _loc2_[_loc5_].totalOwnedHealth(int(param1.substr(1)));
               _loc5_++;
            }
            return _loc4_;
         }
         return this.monsterListByID(param1).totalHealth;
      }
      
      public function curHealthByID(param1:String) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         if(param1.substr(0,1) == "B")
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc4_ += _loc2_[_loc5_].curHealth(int(param1.substr(1)));
               _loc5_++;
            }
            return _loc4_;
         }
         return this.monsterListByID(param1).curHealth();
      }
      
      public function getStorageByID(param1:String) : int
      {
         if(param1.substr(0,1) == "B")
         {
            return this.getBunkerStorage(int(param1.substr(1)));
         }
         return this.numCreepsByID(param1) * CREATURES.GetProperty(param1,"cStorage");
      }
      
      public function importAcademyData(param1:Object) : void
      {
         var _loc2_:String = null;
         this.m_upgrades = {};
         for(_loc2_ in param1)
         {
            if((_loc2_.substr(0,1) == "C" || _loc2_.substr(0,2) == "IC") && Boolean(param1[_loc2_]))
            {
               this.m_upgrades[_loc2_] = {};
               if(param1[_loc2_].time)
               {
                  if(param1[_loc2_].time <= 60 * 60 * 162)
                  {
                     this.m_upgrades[_loc2_].time = new SecNum(param1[_loc2_].time + GLOBAL.Timestamp());
                  }
                  else
                  {
                     this.m_upgrades[_loc2_].time = new SecNum(param1[_loc2_].time);
                  }
               }
               if(param1[_loc2_].duration)
               {
                  this.m_upgrades[_loc2_].duration = param1[_loc2_].duration;
               }
               if(param1[_loc2_].powerup)
               {
                  this.m_upgrades[_loc2_].powerup = param1[_loc2_].powerup;
               }
               this.m_upgrades[_loc2_].level = param1[_loc2_].level;
            }
         }
         if(this.m_upgrades.C100)
         {
            this.m_upgrades.C12 = this.m_upgrades.C100;
            delete this.m_upgrades.C100;
         }
      }
      
      public function exportAcademyData() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {};
         for(_loc2_ in this.m_upgrades)
         {
            if(this.m_upgrades[_loc2_])
            {
               _loc1_[_loc2_] = {};
               _loc1_[_loc2_].level = this.m_upgrades[_loc2_].level;
               if(this.m_upgrades[_loc2_].time)
               {
                  _loc1_[_loc2_].time = this.m_upgrades[_loc2_].time.Get();
               }
               if(this.m_upgrades[_loc2_].duration)
               {
                  _loc1_[_loc2_].duration = this.m_upgrades[_loc2_].duration;
               }
               if(this.m_upgrades[_loc2_].powerup)
               {
                  _loc1_[_loc2_].powerup = this.m_upgrades[_loc2_].powerup;
               }
            }
         }
         return _loc1_;
      }
      
      public function upgradeHealthData(param1:String) : void
      {
         if(!this.monsterListByID(param1))
         {
            return;
         }
         var _loc2_:Vector.<CreepInfo> = this.monsterListByID(param1).m_creeps;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = CREATURES.GetProperty(param1,"health",this.m_upgrades[param1].level) - this.monsterListByID(param1).maxHealth;
         this.monsterListByID(param1).level = this.m_upgrades[param1].level;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc2_[_loc5_].health += _loc4_;
            if(_loc2_[_loc5_].self)
            {
               _loc2_[_loc5_].self.setHealth(_loc2_[_loc5_].self.health + _loc4_);
            }
            _loc5_++;
         }
      }
      
      public function addMonster(param1:String, param2:MonsterBase = null) : void
      {
         var _loc3_:Vector.<MonsterData> = this.monsterList;
         var _loc4_:MonsterData;
         _loc4_ = this.monsterListByID(param1);
         if(_loc4_)
         {
            _loc4_.add(1,param2);
         }
         else
         {
            (_loc4_ = new MonsterData()).m_creatureID = param1;
            _loc4_.add(1,param2);
            if(this.m_upgrades[param1] != null)
            {
               _loc4_.level = this.m_upgrades[param1].level;
            }
            _loc3_.push(_loc4_);
            this.m_monsterIndexList[param1] = _loc3_.length;
         }
      }
      
      public function fillMonsterData(param1:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:MonsterData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         var _loc3_:Vector.<String> = this.healQueue;
         _loc2_.length = 0;
         this.m_monsterIndexList = [];
         var _loc4_:Boolean = false;
         for(_loc5_ in param1)
         {
            if(_loc5_.substr(0,1) == "C" || _loc5_.substr(0,2) == "IC")
            {
               if(!_loc4_ && !(param1[_loc5_] is Number))
               {
                  _loc4_ = true;
               }
               if(_loc4_)
               {
                  _loc6_ = int(param1[_loc5_].length);
               }
               else
               {
                  _loc6_ = int(param1[_loc5_]);
               }
               if(_loc6_)
               {
                  _loc7_ = new MonsterData();
                  if(_loc5_ == "C100")
                  {
                     _loc5_ = "C12";
                  }
                  _loc7_.m_creatureID = _loc5_;
                  _loc7_.add(_loc6_);
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_)
                  {
                     if(_loc4_)
                     {
                        _loc7_.m_creeps[_loc8_].health = param1[_loc5_][_loc8_].health > 0 ? Number(param1[_loc5_][_loc8_].health) : 1;
                        _loc7_.m_creeps[_loc8_].ownerID = param1[_loc5_][_loc8_].ownerID;
                        _loc7_.m_creeps[_loc8_].queued = !!param1[_loc5_][_loc8_].q ? uint(param1[_loc5_][_loc8_].q) : 0;
                     }
                     else
                     {
                        _loc7_.m_creeps[_loc8_].health = int.MAX_VALUE;
                     }
                     if(this.m_upgrades[_loc5_] != null)
                     {
                        _loc7_.level = this.m_upgrades[_loc5_].level;
                     }
                     _loc8_++;
                  }
                  _loc2_.push(_loc7_);
                  if(!this.m_monsterIndexList[_loc5_])
                  {
                     this.m_monsterIndexList[_loc5_] = _loc2_.length;
                  }
               }
            }
         }
         if(param1["Q"])
         {
            _loc6_ = int(param1["Q"].length);
            _loc9_ = 0;
            while(_loc9_ < _loc6_)
            {
               _loc3_[_loc9_] = param1["Q"][_loc9_];
               _loc10_ = 0;
               if(_loc3_[_loc9_].substr(0,1) == "B")
               {
                  _loc10_ = int(_loc3_[_loc9_].substr(1));
               }
               _loc9_++;
            }
         }
      }
      
      public function exportMonsters() : Object
      {
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc1_:Vector.<MonsterData> = this.monsterList;
         var _loc2_:Vector.<String> = this.healQueue;
         var _loc3_:Object = new Object();
         var _loc4_:int = int(_loc1_.length);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc5_ = _loc1_[_loc6_].numCreeps;
               _loc8_ = new Array(_loc5_);
               _loc7_ = 0;
               while(_loc7_ < _loc5_)
               {
                  if(_loc1_[_loc6_].m_creeps[_loc7_].self)
                  {
                     if(_loc1_[_loc6_].m_creeps[_loc7_].self.health < Math.floor(_loc1_[_loc6_].m_creeps[_loc7_].health))
                     {
                        _loc1_[_loc6_].m_creeps[_loc7_].queued = 0;
                     }
                     _loc1_[_loc6_].m_creeps[_loc7_].health = !!_loc1_[_loc6_].m_creeps[_loc7_].self.health ? _loc1_[_loc6_].m_creeps[_loc7_].self.health : 1;
                  }
                  _loc8_[_loc7_] = {
                     "health":_loc1_[_loc6_].m_creeps[_loc7_].health,
                     "ownerID":_loc1_[_loc6_].m_creeps[_loc7_].ownerID,
                     "q":_loc1_[_loc6_].m_creeps[_loc7_].queued
                  };
                  _loc7_++;
               }
               _loc3_[_loc1_[_loc6_].m_creatureID] = _loc8_;
               _loc6_++;
            }
            if(_loc2_.length)
            {
               _loc4_ = int(_loc2_.length);
               _loc8_ = new Array(_loc4_);
               _loc9_ = 0;
               while(_loc9_ < _loc4_)
               {
                  _loc8_[_loc9_] = _loc2_[_loc9_];
                  _loc9_++;
               }
               _loc3_["Q"] = _loc8_;
            }
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc3_[_loc1_[_loc6_].m_creatureID] = _loc1_[_loc6_].numCreeps;
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public function get monsterHealQueue() : Vector.<String>
      {
         return this.healQueue;
      }
      
      public function queueHeal(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:Vector.<String> = null;
         _loc3_ = this.healQueue;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:Boolean = true;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if(_loc3_[_loc6_] == param1)
            {
               if(!param2)
               {
                  return;
               }
               _loc5_ = false;
               break;
            }
            _loc6_++;
         }
         this.setQueueByID(param1,true);
         if(_loc5_)
         {
            _loc3_.push(param1);
         }
      }
      
      public function queuePartialHeal(param1:String, param2:int) : void
      {
         var _loc3_:Vector.<String> = null;
         _loc3_ = this.healQueue;
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc3_[_loc5_] == param1)
            {
               return;
            }
            _loc5_++;
         }
         this.setQueueByID(param1,true,param2);
         _loc3_.push(param1);
      }
      
      public function queueRemove(param1:String) : void
      {
         var _loc3_:Vector.<String> = null;
         var _loc2_:int = 0;
         _loc3_ = this.healQueue;
         var _loc4_:int = int(_loc3_.length);
         while(_loc2_ < _loc4_ && _loc3_[_loc2_] != param1)
         {
            _loc2_++;
         }
         if(_loc2_ == _loc4_)
         {
            return;
         }
         this.setQueueByID(param1,false);
         _loc3_.splice(_loc2_,1);
         BASE.SaveB();
      }
      
      private function setQueueByID(param1:String, param2:Boolean, param3:int = 0) : void
      {
         var _loc5_:Vector.<MonsterData> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         if(param1.substr(0,1) == "B")
         {
            _loc4_ = int(param1.substr(1));
            _loc6_ = int((_loc5_ = this.monsterList).length);
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc5_[_loc7_].setQueued(param2,_loc4_,param3);
               _loc7_++;
            }
         }
         else
         {
            this.monsterListByID(param1).setQueued(param2,_loc4_,param3);
         }
      }
      
      public function checkQueued(param1:String) : Boolean
      {
         var _loc2_:Vector.<String> = null;
         _loc2_ = this.healQueue;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = _loc3_ - 1;
         while(_loc4_ >= 0)
         {
            if(_loc2_[_loc4_] == param1)
            {
               return true;
            }
            _loc4_--;
         }
         return false;
      }
      
      public function checkForNonQueuedCreepsByID(param1:String) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         if(param1.substr(0,1) != "B")
         {
            return this.monsterListByID(param1).checkForNonQueuedCreeps();
         }
         _loc3_ = int(_loc2_.length);
         _loc4_ = int(param1.substr(1));
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            if(_loc2_[_loc5_].checkForNonQueuedCreeps(_loc4_))
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function getHighestTimeHealingUsingNumberOfHousing(param1:String) : int
      {
         var _loc4_:Vector.<MonsterData> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.substr(0,1) == "B")
         {
            _loc2_ = int(param1.substr(1));
            _loc5_ = int((_loc4_ = this.monsterList).length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc3_ += _loc4_[_loc6_].getHighestTimeWithHousingSplit(_loc2_);
               _loc6_++;
            }
         }
         else
         {
            _loc3_ = this.monsterListByID(param1).getHighestTimeWithHousingSplit();
         }
         return _loc3_;
      }
      
      public function refundResources(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:int = GLOBAL.player.getResourceCostByID(param1,param2);
         var _loc4_:* = param1.substr(0,1) == "I";
         BASE.Fund(4,_loc3_,true,null,_loc4_,true);
      }
      
      public function tickHeal(param1:int) : void
      {
         var _loc2_:Vector.<String> = this.healQueue;
         while(param1)
         {
            if(_loc2_.length)
            {
               if(this.healByID(_loc2_[0]))
               {
                  _loc2_.shift();
               }
            }
            param1--;
         }
      }
      
      private function healByID(param1:String) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         var _loc3_:Boolean = true;
         if(param1.substr(0,1) == "B")
         {
            _loc4_ = int(_loc2_.length);
            _loc5_ = int(param1.substr(1));
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               if(!_loc2_[_loc6_].heal(_loc5_))
               {
                  _loc3_ = false;
               }
               _loc6_++;
            }
         }
         else if(this.monsterListByID(param1))
         {
            return this.monsterListByID(param1).heal();
         }
         return _loc3_;
      }
      
      public function healInstantSingleByID(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         if(param1.substr(0,1) == "B")
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = int(param1.substr(1));
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc2_[_loc5_].healInstant(_loc4_);
               _loc5_++;
            }
         }
         else
         {
            this.monsterListByID(param1).healInstant();
         }
         this.queueRemove(param1);
      }
      
      public function healInstantAll() : void
      {
         var _loc1_:Vector.<MonsterData> = null;
         _loc1_ = this.monsterList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].healInstant(0,true);
            this.queueRemove(_loc1_[_loc3_].m_creatureID);
            _loc3_++;
         }
      }
      
      public function getSecsTillDoneByID(param1:String, param2:Boolean = false) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:Vector.<MonsterData> = this.monsterList;
         var _loc4_:int = 0;
         if(param1.substr(0,1) == "B")
         {
            _loc6_ = int(_loc3_.length);
            _loc7_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            while(_loc10_ < _loc6_)
            {
               _loc7_ = _loc3_[_loc10_].numCreepsByHouse(int(param1.substr(1)),!param2);
               if(_loc7_)
               {
                  _loc8_ = _loc3_[_loc10_].m_creatureID;
                  _loc9_ = CREATURES.GetProperty(_loc8_,"hTime");
                  _loc5_ = CREATURES.GetProperty(_loc8_,"health");
                  _loc4_ += (_loc7_ * _loc5_ - _loc3_[_loc10_].curHealth(int(param1.substr(1)))) / (_loc5_ / _loc9_);
               }
               _loc10_++;
            }
         }
         else
         {
            _loc4_ = CREATURES.GetProperty(param1,"hTime");
            _loc5_ = CREATURES.GetProperty(param1,"health");
            _loc4_ = ((_loc7_ = GLOBAL.player.monsterListByID(param1).numCreepsByHouse(0,!param2)) * _loc5_ - GLOBAL.player.monsterListByID(param1).curHealth(0,!param2)) / (_loc5_ / _loc4_);
         }
         return _loc4_;
      }
      
      public function getNumDamagedCreeps() : int
      {
         var _loc1_:Vector.<MonsterData> = null;
         _loc1_ = this.monsterList;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ += _loc1_[_loc4_].numCreeps - _loc1_[_loc4_].numTotalHealthyCreeps;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getNumQueuedCreepsByID(param1:String) : int
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Vector.<MonsterData> = this.monsterList;
         var _loc3_:int = 0;
         if(param1.substr(0,1) == "B")
         {
            _loc4_ = int(_loc2_.length);
            _loc6_ = int(param1.substr(1));
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc5_ = _loc2_[_loc7_].m_creatureID;
               _loc3_ += _loc2_[_loc7_].numHealingCreeps(_loc6_);
               _loc7_++;
            }
         }
         else
         {
            _loc3_ += this.monsterListByID(param1).numHealingCreeps();
         }
         return _loc3_;
      }
      
      public function getNumToHealByResourceCost(param1:String, param2:Number) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc3_:Vector.<MonsterData> = this.monsterList;
         _loc4_ = {
            "num":0,
            "resoLeft":param2
         };
         if(param1.substr(0,1) == "B")
         {
            _loc6_ = int(_loc3_.length);
            _loc8_ = int(param1.substr(1));
            _loc9_ = 0;
            while(_loc9_ < _loc6_ && Boolean(_loc4_.resoLeft))
            {
               _loc5_ = _loc3_[_loc9_].getNumCreepsCanHealWithSpecificResourceAmount(_loc4_.resoLeft,_loc8_);
               _loc4_.num += _loc5_.num;
               _loc4_.resoLeft = _loc5_.resoLeft;
               _loc9_++;
            }
         }
         else
         {
            _loc4_ = GLOBAL.player.monsterListByID(param1).getNumCreepsCanHealWithSpecificResourceAmount(param2);
         }
         return _loc4_;
      }
      
      public function getResourceCostByID(param1:String, param2:Boolean = false) : Number
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:Vector.<MonsterData> = this.monsterList;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1.substr(0,1) == "B")
         {
            _loc8_ = int(_loc3_.length);
            _loc10_ = int(param1.substr(1));
            _loc11_ = 0;
            while(_loc11_ < _loc8_)
            {
               _loc9_ = _loc3_[_loc11_].m_creatureID;
               _loc4_ = _loc3_[_loc11_].numCreepsByHouse(_loc10_,param2);
               if(_loc4_)
               {
                  _loc7_ = CREATURES.GetProperty(_loc9_,"health");
                  _loc5_ = _loc4_ - _loc4_ * (_loc3_[_loc11_].curHealth(_loc10_,param2) / (_loc7_ * _loc4_));
                  _loc6_ += CREATURES.GetProperty(_loc9_,"hResource") * _loc5_;
               }
               _loc11_++;
            }
         }
         else
         {
            _loc7_ = CREATURES.GetProperty(param1,"health");
            _loc4_ = GLOBAL.player.monsterListByID(param1).numCreepsByHouse(0,param2);
            _loc5_ = _loc4_ - _loc4_ * (GLOBAL.player.monsterListByID(param1).curHealth(0,param2) / (_loc7_ * _loc4_));
            _loc6_ = CREATURES.GetProperty(param1,"hResource") * _loc5_;
         }
         return _loc6_;
      }
      
      public function getResourceCostInShinyByID(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = this.getResourceCostByID(param1);
         return GLOBAL.getShinyCostFromResourceAmt(_loc3_);
      }
      
      public function numCreepsInBunker(param1:int) : int
      {
         var _loc2_:Vector.<MonsterData> = null;
         _loc2_ = this.monsterList;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ += _loc2_[_loc5_].numCreepsByHouse(param1);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function getBunkerStorage(param1:int) : int
      {
         var _loc2_:Vector.<MonsterData> = null;
         _loc2_ = this.monsterList;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ += _loc2_[_loc5_].numCreepsByHouse(param1) * CREATURES.GetProperty(_loc2_[_loc5_].m_creatureID,"cStorage");
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function initializeHandlers(param1:Object) : void
      {
         var _loc3_:IHandler = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.handlers.length)
         {
            _loc3_ = this.handlers[_loc2_];
            _loc3_.initialize(param1[_loc3_.name]);
            if(_loc2_ == 0)
            {
               ReplayableEventHandler.initialize(param1["events"]);
            }
            _loc2_++;
         }
      }
      
      private function getPlayerDataFromLoadObject(param1:Object) : Object
      {
         var _loc2_:Object = null;
         if(!this.isAttacking)
         {
            _loc2_ = param1["defendingplayer"];
            if(_loc2_)
            {
               return _loc2_;
            }
            _loc2_ = param1["player"];
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         else
         {
            _loc2_ = param1["attackingplayer"];
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function importPlayerSpecificHandlers(param1:Object) : void
      {
         var _loc4_:IHandler = null;
         var _loc2_:Object = this.getPlayerDataFromLoadObject(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.handlers.length)
         {
            if((_loc4_ = this.handlers[_loc3_]) is IPlayerHandler)
            {
               IPlayerHandler(_loc4_).player = this;
               if(_loc2_.hasOwnProperty(_loc4_.name))
               {
                  _loc4_.importData(_loc2_[_loc4_.name]);
               }
            }
            _loc3_++;
         }
      }
      
      public function get rewards() : RewardHandler
      {
         return this._handlers[HANDLER_REWARD] as RewardHandler;
      }
      
      public function get handlers() : Vector.<IHandler>
      {
         return this._handlers;
      }
      
      public function set handlers(param1:Vector.<IHandler>) : void
      {
         this._handlers = param1;
      }
      
      public function tick() : void
      {
         var _loc3_:IHandler = null;
         var _loc1_:int = int(this.handlers.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.handlers[_loc2_];
            if(_loc3_ is ITickable)
            {
               ITickable(_loc3_).tick();
            }
            _loc2_++;
         }
      }
   }
}
