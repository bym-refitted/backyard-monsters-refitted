package
{
   
   import com.gskinner.utils.Rndm;
   import com.monsters.ai.*;
   import com.monsters.display.ImageCache;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.abilities.Enrage;
   import com.monsters.monsters.components.abilities.TemporaryComponent;
   import com.monsters.pathing.PATHING;
   import com.monsters.replayableEvents.monsterInvasion.WaveObj;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class WMATTACK
   {
      
      public static var _history:Object;
      
      public static var _lastClick:int = 0;
      
      public static var _solutions:Vector.<Solution>;
      
      private static var solsProcessed:int;
      
      public static var _attackResolution:int = 16;
      
      private static var processStepResolution:int = 3;
      
      public static var _isAI:Boolean = true;
      
      public static var _inProgress:Boolean;
      
      public static var _damageBias:int = 200;
      
      public static var _processing:Boolean = false;
      
      public static var _monsterKeys:Array = ["C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15"];
      
      public static var _looters:Array = ["C3","C9","C14"];
      
      public static var _dps:Array = ["C1","C4","C7","C8","C11","C11"];
      
      public static var _tanks:Array = ["C2","C6","C10","C12"];
      
      public static var _anything:Array = ["C1","C4","C7","C8","C12"];
      
      public static var _fodder:Array = ["C1","C1","C1","C3","C8","C9"];
      
      public static var _kamikaze:Array = ["C5"];
      
      public static var _infernoMonsterKeys:Array = ["IC1","IC2","IC3","IC4","IC5","IC6","IC7","IC8"];
      
      public static var _infernoLooters:Array = ["IC3","IC3","IC3","IC6"];
      
      public static var _infernoDps:Array = ["IC1","IC1","IC2","IC3","IC4","IC6","IC7","IC8"];
      
      public static var _infernoTanks:Array = ["IC2","IC2","IC2","IC2","IC7"];
      
      public static var _infernoAnything:Array = ["IC1","IC1","IC1","IC1","IC8"];
      
      public static var _infernoHunters:Array = ["IC1","IC1","IC2","IC5"];
      
      public static var _infernoFodder:Array = ["IC1","IC1","IC1","IC2","IC3"];
      
      public static var _infernoKamikaze:Array = ["IC4"];
      
      public static var _sessionsBetweenAttacks:int = 4;
      
      public static var _minAdvanceWarningTime:int = 30;
      
      public static var _maxAdvanceWarningTime:int = 600;
      
      public static var _attackVolumeAmplifier:Number = 1;
      
      public static var _trojanThreshold:Number = 2000000;
      
      public static var _hitsPerCreep:Number = 30;
      
      private static var attackPreference:int = 0;
      
      private static var intelligence:Number = 0.1;
      
      private static var quickly:Boolean = false;
      
      public static var _trojan:Boolean = false;
      
      public static var _queued:Object;
      
      public static var warningPopup:AIATTACKPOPUP;
      
      private static var t:Number = 0;
      
      private static var baseIsRepairing:Boolean = true;
      
      public static const TYPE_LOOT:int = 1;
      
      public static const TYPE_DAMAGE:int = 2;
      
      public static const TYPE_TOWERS:int = 3;
      
      public static const TYPE_SWARM:int = 4;
      
      public static const TYPE_KAMIKAZE:int = 5;
      
      public static const TYPE_DAVE:int = 6;
      
      public static const TYPE_NERD:int = 7;
      
      public static var processor:IPROCESS;
      
      public static var _type:int = TYPE_TOWERS;
      
      public static var _attackersBaseID:int = 1;
      
      public static var _rage:int = 0;
      
      public static var _enabled:Boolean;
      
      private static var _cleanUpFunc:Function;
       
      
      public function WMATTACK()
      {
         super();
      }
      
      public static function Setup(param1:Object) : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _enabled = true;
            if(param1 == null)
            {
               param1 = {};
            }
            _history = param1;
            if(!_history.sessionsSinceLastAttack)
            {
               _history.sessionsSinceLastAttack = 0;
            }
            if(!_history || _history.currentid != null)
            {
               _history = {};
            }
            if(!_history.lastattack)
            {
               _history.lastattack = 0;
            }
            if(!_history.attackPreference)
            {
               _history.attackPreference = 0;
            }
            _history.sessionsSinceLastAttack += 1;
            if(GLOBAL._aiDesignMode)
            {
               _sessionsBetweenAttacks = 1;
            }
            _inProgress = false;
            setEnd();
            if(_history["s1"])
            {
               if(_history["s1"].length == 2 && _history["s1"][0] == 1)
               {
                  _history["s1"][2] = 0;
               }
               if(_history["s1"][0] == 1 && _history["s1"][2] == 0)
               {
                  _trojan = true;
               }
               if(_history["s1"][0] == 1 && _history.queued != undefined && _history["s1"][2] == 0)
               {
                  delete _history.queued;
               }
            }
            if(_history.queued != undefined && _history.queued.type != undefined && _history.queued.t != undefined)
            {
               _queued = _history.queued;
               _type = _queued.type;
               _attackersBaseID = _queued.t;
               if(_queued.warned == undefined)
               {
                  _queued.warned = 0;
               }
            }
            if(Boolean(_queued) && Boolean(_queued.attack))
            {
               if(_queued.attack.C100)
               {
                  _queued.attack.C12 = _queued.attack.C100;
                  delete _queued.attack.C100;
               }
               if(_queued.distances.C100)
               {
                  _queued.distances.C12 = _queued.distances.C100;
                  delete _queued.distances.C100;
               }
            }
            if(GLOBAL.Timestamp() - _history.lastattack > 345600)
            {
               if(_history["s1"])
               {
                  if(_history["s1"][0] != 1)
                  {
                     _history.nextAttack = new Date().time / 1000 + 60;
                  }
               }
               else
               {
                  _history.nextAttack = new Date().time / 1000 + 60;
               }
            }
            else if(_history.nextAttack == undefined)
            {
               _attackPreference = _history.attackPreference;
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.VIEW || GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP)
         {
            _history = param1;
         }
      }
      
      public static function DoTests(param1:int = -1) : void
      {
         switch(param1)
         {
            case -1:
               return;
            case 0:
               _history.sessionsSinceLastAttack = 300;
               _history.lastattack = 20;
               _history.queued = {
                  "attack":{"C1":10},
                  "attackTime":GLOBAL.Timestamp() + 10,
                  "degrees":0,
                  "distances":{"C1":300}
               };
               break;
            case 1:
               _history.sessionsSinceLastAttack = 300;
               _history.lastattack = 20;
               if(_history.queued)
               {
                  delete _history.queued;
               }
               break;
            case 2:
               _history.sessionsSinceLastAttack = 300;
               _history.lastattack = 20;
               delete _history.nextAttack;
               delete _history["s1"];
               delete _history.queued;
               _trojanThreshold = 0;
               _history.nextAttack = GLOBAL.Timestamp() + 10;
               break;
            case 3:
               _history.sessionsSinceLastAttack = 300;
               _history.lastattack = 20;
               _history.nextAttack = GLOBAL.Timestamp() + 10;
               delete _history.queued;
               break;
            case 4:
               delete _history["s1"];
               break;
            case 5:
               delete _history["s1"];
               _trojanThreshold = 10;
               _history.lastattack = 20;
               _history.sessionsSinceLastAttack = 20;
               break;
            case 6:
               _history = JSON.decode("{\"sessionsSinceLastAttack\":45,\"attackPreference\":0,\"queued\":{\"attack\":{\"C10\":27,\"C7\":13},\"warned\":1,\"degrees\":180,\"attackTime\":1284677486,\"distances\":{\"C10\":275,\"C7\":275}},\"lastattack\":1284676962,\"nextAttack\":1284612571,\"s1\":[1,1284676962,1]}");
         }
      }
      
      public static function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
      }
      
      public static function Tick() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         var a:int = 0;
         var _loc5_:Object = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            // The following logic was added from an older SWF which included Wild Monster Invasion 1 specific logic
            // SWF version: game-v120.v7
            // =============================================== // 
            SPECIALEVENT_WM1.Tick();
            // =============================================== // 
            if(t % 10 == 0)
            {
               _loc1_ = 0;
               baseIsRepairing = false;
               _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
               for each(_loc3_ in _loc2_)
               {
                  if(!(_loc3_ is BTRAP === false || _loc3_ is BTOWER === false))
                  {
                     _loc1_++;
                     if(_loc3_.health < _loc3_.maxHealth)
                     {
                        baseIsRepairing = true;
                     }
                  }
               }
               if(!BASE.isMainYard && _loc1_ < 10)
               {
                  baseIsRepairing = true;
               }
            }
            t += 1;
            if(_queued != null && !_inProgress)
            {
               if(!GLOBAL._catchup && !warningPopup && !_trojan && _queued.warned == 0 && !baseIsRepairing && BASE._isSanctuary <= GLOBAL.Timestamp() && _enabled && !SPECIALEVENT_WM1.EventActive() && !INFERNO_EMERGENCE_EVENT.ShouldRunEvent() && !PLANNER.isOpen())
               {
                  ShowWarning();
               }
               if(!GLOBAL._catchup && !_trojan && _queued.warned == 1 && !UI2._wildMonsterBar && !_inProgress && !baseIsRepairing && BASE._isSanctuary <= GLOBAL.Timestamp() && _enabled && !SPECIALEVENT_WM1.EventActive() && !INFERNO_EMERGENCE_EVENT.ShouldRunEvent())
               {
                  UI2.Show("wmbar");
               }
               else if(baseIsRepairing && !GLOBAL._catchup)
               {
                  _queued = null;
                  delete _history.queued;
                  if(UI2._wildMonsterBar)
                  {
                     UI2.Hide("wmbar");
                  }
               }
               if(!baseIsRepairing && _queued.attackTime <= GLOBAL.Timestamp() && _enabled && !PLANNER.isOpen() && BASE._isSanctuary <= GLOBAL.Timestamp())
               {
                  if(!_inProgress && !CUSTOMATTACKS._started && !baseIsRepairing)
                  {
                     LaunchQueuedAttack();
                  }
               }
               else if(Boolean(UI2._wildMonsterBar) && !baseIsRepairing)
               {
                  UI2._wildMonsterBar.eta_txt.htmlText = KEYS.Get("ai_eta",{"v1":GLOBAL.ToTime(_queued.attackTime - GLOBAL.Timestamp())});
               }
            }
            else if(!_inProgress)
            {
               if(!GLOBAL._catchup && _history.sessionsSinceLastAttack >= _sessionsBetweenAttacks && !baseIsRepairing && !_processing && GLOBAL.Timestamp() > _history.nextAttack && BASE._baseLevel >= 9 && !_trojan && BASE._isSanctuary <= GLOBAL.Timestamp() && _enabled && !PLANNER.isOpen() && !SPECIALEVENT_WM1.EventActive() && !INFERNO_EMERGENCE_EVENT.ShouldRunEvent())
               {
                  _processing = true;
                  Trigger();
               }
            }
            else if(_inProgress)
            {
               if(CREEPS._creepCount == 0 && (!SPECIALEVENT_WM1.active || SPECIALEVENT_WM1.AllWavesSpawned()))
               {
                  _cleanUpFunc();
               }
               else if(GLOBAL.Timestamp() % 10 == 0)
               {
                  a = 0;
                  for each(_loc5_ in CREEPS._creeps)
                  {
                     if(_loc5_._behaviour == GLOBAL.e_BASE_MODE.ATTACK || _loc5_._behaviour == "bounce" || _loc5_._behaviour == "loot" || _loc5_._behaviour == "heal" || _loc5_._behaviour == "buff" || _loc5_._behaviour == "hunt")
                     {
                        a++;
                     }
                  }
                  if(a == 0 && (!SPECIALEVENT_WM1.active || SPECIALEVENT_WM1.AllWavesSpawned()))
                  {
                     _cleanUpFunc();
                  }
               }
            }
         }
      }
      
      public static function ShowWarning() : void
      {
         if(!warningPopup)
         {
            warningPopup = new AIATTACKPOPUP(_queued.type);
            GLOBAL._layerWindows.addChild(warningPopup);
            PreloadAttackers();
            BASE.Save();
         }
      }
      
      public static function PreloadAttackers() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in _queued.attack)
         {
            if(_queued.attack[_loc1_] > 0)
            {
               ImageCache.GetImageWithCallBack(SPRITES._sprites[_loc1_].key);
            }
         }
      }
      
      public static function HideWarning() : void
      {
         if(warningPopup)
         {
            if(warningPopup.parent)
            {
               warningPopup.parent.removeChild(warningPopup);
            }
            warningPopup = null;
         }
      }
      
      public static function ShowAttackSettings() : void
      {
         var asp:popup_attacksettings = null;
         var onImage:Function = null;
         var onMoreDown:Function = null;
         var onSameDown:Function = null;
         var onLessDown:Function = null;
         var closeDown:Function = null;
         onImage = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            asp.mcImage.addChild(_loc3_);
         };
         onMoreDown = function(param1:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _attackPreference = 1;
            POPUPS.Next();
            BASE.Save();
         };
         onSameDown = function(param1:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _attackPreference = 0;
            POPUPS.Next();
            BASE.Save();
         };
         onLessDown = function(param1:MouseEvent):void
         {
            SOUNDS.Play("click1");
            _attackPreference = -1;
            POPUPS.Next();
            BASE.Save();
         };
         closeDown = function(param1:MouseEvent = null):void
         {
            SOUNDS.Play("close");
            POPUPS.Next();
            BASE.Save();
         };
         asp = new popup_attacksettings();
         asp.title_txt.htmlText = KEYS.Get("ai_settings_title");
         asp.bMore.SetupKey("ai_settings_more_btn");
         asp.bSame.SetupKey("ai_settings_same_btn");
         asp.bLess.SetupKey("ai_settings_less_btn");
         asp.bMore.addEventListener(MouseEvent.CLICK,onMoreDown);
         asp.bLess.addEventListener(MouseEvent.CLICK,onLessDown);
         asp.bSame.addEventListener(MouseEvent.CLICK,onSameDown);
         (asp.mcFrame as frame).Setup(true,closeDown);
         asp.taunt_txt.htmlText = "<b>" + TRIBES.TribeForBaseID(_attackersBaseID).taunt + "</b>";
         ImageCache.GetImageWithCallBack(TRIBES.TribeForBaseID(_attackersBaseID).splash,onImage);
         POPUPS.Push(asp);
      }
      
      public static function Export() : Object
      {
         return _history;
      }
      
      public static function TriggerType(param1:int) : void
      {
         var _loc2_:Class = null;
         switch(param1)
         {
            case 1:
               _loc2_ = PROCESS3;
               _type = WMATTACK.TYPE_TOWERS;
               break;
            case 2:
               _type = WMATTACK.TYPE_SWARM;
               _loc2_ = PROCESS4;
               break;
            case 3:
               _type = WMATTACK.TYPE_KAMIKAZE;
               _loc2_ = PROCESS5;
               break;
            case 4:
               _type = WMATTACK.TYPE_NERD;
               _loc2_ = PROCESS7;
               break;
            case INFERNO_EMERGENCE_PROCESS.TYPE:
               _type = WMATTACK.TYPE_TOWERS;
               _loc2_ = INFERNO_EMERGENCE_PROCESS;
         }
         _attackersBaseID = 1;
         processor = new _loc2_();
         processor.Trigger(1);
      }
      
      public static function Trigger(param1:Boolean = false, param2:Number = 1) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && GLOBAL._render && POPUPS.Done())
         {
            intelligence = param2;
            quickly = param1;
            if(Boolean(WMBASE._bases) && WMBASE._bases.length > 0)
            {
               for each(_loc4_ in WMBASE._bases)
               {
                  if(_loc4_.destroyed == 0 && _loc4_.level >= BASE._baseLevel - 10)
                  {
                     _attackersBaseID = _loc4_.baseid;
                     if(BASE.isInfernoMainYardOrOutpost)
                     {
                        _type = WMATTACK.TYPE_SWARM;
                        _loc3_ = PROCESS_INFERNO1;
                     }
                     else
                     {
                        _type = _loc4_.tribe.type;
                        _loc3_ = _loc4_.tribe.process;
                     }
                     break;
                  }
               }
            }
            else
            {
               _loc5_ = int(Math.random() * 4) + 1;
               _attackersBaseID = _loc5_ * 10;
               switch(_loc5_)
               {
                  case 1:
                     _type = WMATTACK.TYPE_TOWERS;
                     _loc3_ = PROCESS3;
                     break;
                  case 2:
                     _type = WMATTACK.TYPE_SWARM;
                     _loc3_ = PROCESS4;
                     break;
                  case 3:
                     _type = WMATTACK.TYPE_KAMIKAZE;
                     _loc3_ = PROCESS5;
                     break;
                  case 4:
                     _type = WMATTACK.TYPE_NERD;
                     _loc3_ = PROCESS7;
               }
            }
            if(!_loc3_)
            {
               _loc3_ = PROCESS3;
               _type = WMATTACK.TYPE_TOWERS;
               _attackersBaseID = 1;
            }
            processor = new _loc3_();
            processor.Trigger(intelligence);
         }
      }
      
      public static function Queue(param1:Solution) : void
      {
         var _loc2_:int = 0;
         if(!quickly)
         {
            _loc2_ = 300;
         }
         else
         {
            _loc2_ = 5;
         }
         var _loc3_:int = BASE._basePoints + BASE._baseValue;
         _queued = {
            "type":_type,
            "attack":param1.attack,
            "attackTime":GLOBAL.Timestamp() + _loc2_,
            "degrees":param1.degrees,
            "distances":param1.distances,
            "warned":0,
            "t":_attackersBaseID
         };
         if(_loc3_ > _trojanThreshold && !_history["s1"] && !BASE.isMainYard)
         {
            _trojan = true;
            _history["s1"] = [1,GLOBAL.Timestamp(),0];
            _queued.attackTime = GLOBAL.Timestamp();
         }
         else
         {
            _history.queued = _queued;
         }
         _processing = false;
         BASE.Save();
      }
      
      public static function PreemptQueue() : void
      {
         _queued.attackTime = GLOBAL.Timestamp();
         _type = !!_queued.type ? int(_queued.type) : 1;
         BASE.Save(0,false,true);
         Tick();
      }
      
      public static function LaunchQueuedAttack() : void
      {
         PATHING.ResetCosts();
         SendAttack(WMATTACK._queued.attack,WMATTACK._queued.degrees,WMATTACK._queued.distances);
      }
      
      public static function SendAttack(param1:Object, param2:Number, param3:Object) : void
      {
         var _loc8_:String = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:* = undefined;
         if(_history)
         {
            if(_history["s1"] && _history["s1"][0] == 1 && _history["s1"][2] == 0 && !BASE.isInfernoMainYardOrOutpost)
            {
               _history["s1"][2] = 1;
               _history.lastattack = GLOBAL.Timestamp();
               _trojan = true;
               _queued = null;
               delete _history.queued;
               CUSTOMATTACKS.TrojanHorse();
               return;
            }
         }
         AttackB();
         AttackC();
         WMATTACK._history.lastattack = GLOBAL.Timestamp();
         _isAI = true;
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicipanic");
         }
         else
         {
            SOUNDS.PlayMusic("musicpanic");
         }
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc9_:Object = {};
         var _loc10_:Object = {};
         var _loc11_:Object = {};
         var _loc12_:Object = {};
         var _loc13_:Number = param2;
         _loc13_ = param2;
         for(_loc8_ in param1)
         {
            _loc7_.push([_loc8_,"bounce",param1[_loc8_],param3[_loc8_],_loc13_,0,0]);
         }
         _loc14_ = SpawnA(_loc7_);
         for each(_loc15_ in _loc14_)
         {
            for each(_loc16_ in _loc15_)
            {
               _loc16_._hitLimit = _hitsPerCreep;
            }
         }
         if(_loc14_.length > 0 && _loc14_[0].length > 0)
         {
            MAP.FocusTo(_loc14_[0][0].x,_loc14_[0][0].y,1);
         }
      }
      
      public static function Attack(param1:String = "") : void
      {
         PreemptQueue();
      }
      
      public static function SpawnWave(param1:WaveObj, param2:int) : Array
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Array = null;
         var _loc3_:int = getTimer();
         var _loc4_:Array = [];
         var _loc8_:int = 3;
         var _loc9_:int = param1.direction + param2;
         var _loc10_:int = 250;
         _loc5_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * (800 + _loc10_ / 2),Math.sin(_loc9_ * 0.0174532925) * (800 + _loc10_ / 2),0);
         _loc6_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * 900,Math.sin(_loc9_ * 0.0174532925) * 900,0);
         if(param1.powerLevel)
         {
            GLOBAL._wmCreaturePowerups[param1.creatureID] = param1.powerLevel;
         }
         _loc7_ = SpawnCreep(_loc5_,_loc10_,param1.creatureID,param1.numCreep,param1.behavior,param1.level);
         _loc4_.push(_loc7_);
         if(param1.cameraFocus)
         {
            MAP.FocusTo(_loc6_.x,_loc6_.y,1,0,0,true);
         }
         return _loc4_;
      }
      
      public static function SpawnCreep(param1:Point, param2:int, param3:String, param4:int, param5:String, param6:int = 0) : Array
      {
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Point = null;
         var _loc10_:MonsterBase = null;
         var _loc11_:Rndm = new Rndm(int(param1.x + param1.y));
         param1 = GRID.FromISO(param1.x,param1.y);
         var _loc12_:Array = [];
         var _loc13_:int = 0;
         while(_loc13_ < param4)
         {
            _loc7_ = _loc11_.random() * 360 * 0.0174532925;
            _loc8_ = _loc11_.random() * param2 / 2;
            _loc9_ = param1.add(new Point(Math.cos(_loc7_) * _loc8_,Math.sin(_loc7_) * _loc8_));
            if(param3.substr(0,1) == "G")
            {
               _loc10_ = CREEPS.SpawnGuardian(int(param3.substr(1)),MAP._BUILDINGTOPS,"bounce",param6,GRID.ToISO(_loc9_.x,_loc9_.y,0),_loc11_.random() * 360,int.MAX_VALUE,0,3,true);
            }
            else
            {
               _loc10_ = CREEPS.Spawn(param3,MAP._BUILDINGTOPS,"bounce",GRID.ToISO(_loc9_.x,_loc9_.y,0),_loc11_.random() * 360);
            }
            _loc10_._hitLimit = int.MAX_VALUE;
            if(_rage)
            {
               _loc10_.addComponent(new TemporaryComponent(new Enrage(2,0),_rage));
            }
            _loc12_.push(_loc10_);
            _loc13_++;
         }
         return _loc12_;
      }
      
      public static function SpawnA(param1:Array) : Array
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:int = getTimer();
         var _loc3_:Array = [];
         var _loc7_:int = 3;
         var _loc8_:int = 0;
         while(_loc8_ < param1.length)
         {
            _loc9_ = int(param1[_loc8_][4]);
            if(_type == TYPE_SWARM)
            {
               _loc10_ = 0;
               while(_loc10_ < param1[_loc8_][2])
               {
                  _loc9_ += 8;
                  _loc4_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),Math.sin(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),0);
                  _loc5_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * 900,Math.sin(_loc9_ * 0.0174532925) * 900,0);
                  _loc6_ = SpawnB(_loc4_,param1[_loc8_][3],param1[_loc8_][0],_loc7_,param1[_loc8_][1]);
                  _loc3_.push(_loc6_);
                  _loc10_ += _loc7_;
               }
               if(param1[_loc8_][2] % _loc7_ != 0)
               {
                  _loc4_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),Math.sin(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),0);
                  _loc5_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * 900,Math.sin(_loc9_ * 0.0174532925) * 900,0);
                  _loc6_ = SpawnB(_loc4_,param1[_loc8_][3],param1[_loc8_][0],param1[_loc8_][2] % _loc7_,param1[_loc8_][1]);
                  _loc3_.push(_loc6_);
               }
            }
            else
            {
               _loc4_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),Math.sin(_loc9_ * 0.0174532925) * (800 + param1[_loc8_][3] / 2),0);
               _loc5_ = GRID.ToISO(Math.cos(_loc9_ * 0.0174532925) * 900,Math.sin(_loc9_ * 0.0174532925) * 900,0);
               _loc6_ = SpawnB(_loc4_,param1[_loc8_][3],param1[_loc8_][0],param1[_loc8_][2],param1[_loc8_][1]);
               _loc3_.push(_loc6_);
            }
            if(param1[_loc8_][6] == 1)
            {
               MAP.Focus(_loc5_.x,_loc5_.y);
            }
            _loc8_ += 1;
         }
         return _loc3_;
      }
      
      public static function SpawnB(param1:Point, param2:int, param3:String, param4:int, param5:String) : Array
      {
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:MonsterBase = null;
         var _loc10_:uint = uint(BASE._basePoints) + uint(BASE._baseValue);
         var _loc11_:Number = 0.4;
         var _loc12_:Rndm = new Rndm(int(param1.x + param1.y));
         if(_loc10_ > 1000000)
         {
            _loc11_ = 0.5;
         }
         if(_loc10_ > 3000000)
         {
            _loc11_ = 0.6;
         }
         if(_loc10_ > 6000000)
         {
            _loc11_ = 0.7;
         }
         if(_loc10_ > 15000000)
         {
            _loc11_ = 0.8;
         }
         if(_loc10_ > 50000000)
         {
            _loc11_ = 0.9;
         }
         param1 = GRID.FromISO(param1.x,param1.y);
         var _loc13_:Array = [];
         var _loc14_:int = 0;
         while(_loc14_ < param4)
         {
            _loc6_ = _loc12_.random() * 360 * 0.0174532925;
            _loc7_ = _loc12_.random() * param2 / 2;
            _loc8_ = param1.add(new Point(Math.cos(_loc6_) * _loc7_,Math.sin(_loc6_) * _loc7_));
            _loc9_ = CREEPS.Spawn(param3,MAP._BUILDINGTOPS,"bounce",GRID.ToISO(_loc8_.x,_loc8_.y,0),_loc12_.random() * 360,_loc11_,true);
            if(_rage)
            {
               _loc9_.addComponent(new TemporaryComponent(new Enrage(2,0),_rage));
            }
            _loc13_.push(_loc9_);
            _loc14_++;
         }
         return _loc13_;
      }
      
      public static function AttackB() : void
      {
         HideWarning();
         _inProgress = true;
         ATTACK.Setup();
         BASE._blockSave = true;
         UI2.Hide("top");
         UI2.Hide("wmbar");
         UI2.Hide("bottom");
         UI2.Show("warning");
         UI2._warning.Update("<font size=\"28\">" + KEYS.Get("msg_dontpanic") + "</font>");
         PLANNER.Hide();
         STORE.Hide();
         HATCHERY.Hide();
         HATCHERYCC.Hide();
      }
      
      public static function AttackC() : void
      {
         WMATTACK._queued = null;
      }
      
      public static function setEnd(param1:Function = null) : void
      {
         if(Boolean(param1))
         {
            _cleanUpFunc = param1;
         }
         else
         {
            _cleanUpFunc = CleanUp;
         }
      }
      
      public static function CleanUp() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _inProgress = false;
         UI2.Show("top");
         UI2.Show("bottom");
         UI2.Hide("warning");
         UI2.Hide("scareAway");
         warningPopup = null;
         if(Boolean(_history["s1"]) && _history["s1"][0] == 1)
         {
            _history["s1"][0] = 2;
            _trojan = false;
         }
         if(_isAI)
         {
            ResetWait();
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicibuild");
         }
         else
         {
            SOUNDS.PlayMusic("musicbuild");
         }
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.GridCost(true);
            // if(_loc2_ is BTRAP && _loc2_ is BWALL && _loc2_._repairing != 1) // Revisit this
            if(_loc2_._class != "trap" && _loc2_._class != "wall" && _loc2_._repairing != 1)
            {
               _loc3_ += _loc2_.health;
               _loc4_ += _loc2_.maxHealth;
            }
            if(_loc2_.health < _loc2_.maxHealth && _loc2_._repairing == 0)
            {
               _loc2_.Repair();
            }
         }
         BASE._blockSave = false;
         BASE.Save();
         if(MONSTERBAITER._scaredAway && _loc3_ < _loc4_)
         {
            ATTACK.PoorDefense();
         }
         // The following logic was added from an older SWF which included Wild Monster Invasion 1 specific logic
         // SWF version: game-v120.v7
         // =============================================== //
         else if(SPECIALEVENT_WM1.active)
         {
            // Check if base took massive damage (90%+ destruction)
            if(CREEPS._creepCount > 0 || !SPECIALEVENT_WM1.AllWavesSpawned() || _loc3_ <= _loc4_ * 0.1)
            {
               ATTACK.PoorDefense();
            }
            else
            {
               ATTACK.WellDefended(true);
            }
         }
         // =============================================== //
         else if(_loc3_ < _loc4_ * 0.9 || TUTORIAL._stage < 200)
         {
            ATTACK.PoorDefense();
         }
         else if(_loc3_ >= _loc4_ * 0.9)
         {
            if(!MONSTERBAITER._scaredAway)
            {
               ATTACK.WellDefended(true);
            }
         }
         MONSTERBAITER._scaredAway = false;
         CUSTOMATTACKS._started = false;
         QUESTS.Check();
         MONSTERBAITER._attacking = 0;
         if(_isAI && intelligence > 0)
         {
            WMATTACK.ShowAttackSettings();
         }
      }
      
      public static function CleanUpLite() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BFOUNDATION = null;
         _inProgress = false;
         UI2.Show("top");
         UI2.Show("bottom");
         UI2.Hide("warning");
         UI2.Hide("scareAway");
         warningPopup = null;
         if(Boolean(_history["s1"]) && _history["s1"][0] == 1)
         {
            _history["s1"][0] = 2;
            _trojan = false;
         }
         if(_isAI)
         {
            ResetWait();
         }
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicibuild");
         }
         else
         {
            SOUNDS.PlayMusic("musicbuild");
         }
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc4_ in _loc1_)
         {
            _loc4_.GridCost(true);
            if(_loc4_._repairing != 1)
            {
               if(_loc4_._class != "trap" && _loc4_._class != "wall")
               {
                  _loc2_ += _loc4_.health;
                  _loc3_ += _loc4_.maxHealth;
               }
               if(_loc4_.health < _loc4_.maxHealth)
               {
                  _loc4_.Repair();
               }
            }
         }
         BASE._blockSave = false;
         BASE.Save();
         MONSTERBAITER._scaredAway = false;
         CUSTOMATTACKS._started = false;
         QUESTS.Check();
         MONSTERBAITER._attacking = 0;
      }
      
      public static function End() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:BFOUNDATION = null;
         Tick();
         if(BASE.isInfernoMainYardOrOutpost)
         {
            SOUNDS.PlayMusic("musicibuild");
         }
         else
         {
            SOUNDS.PlayMusic("musicbuild");
         }
         UI2.Show("top");
         UI2.Show("bottom");
         UI2.Hide("warning");
         UI2.Hide("scareAway");
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc4_ in _loc1_)
         {
            _loc4_.GridCost(true);
            if(_loc4_._repairing != 1)
            {
               if(_loc4_._class != "trap" && _loc4_._class != "wall")
               {
                  _loc2_ += _loc4_.health;
                  _loc3_ += _loc4_.maxHealth;
               }
               if(_loc4_.health < _loc4_.maxHealth)
               {
                  _loc4_.Repair();
               }
            }
         }
         BASE._blockSave = false;
         BASE.Save();
         if(MONSTERBAITER._scaredAway && _loc2_ < _loc3_)
         {
            ATTACK.PoorDefense();
         }
         else if(_loc2_ < _loc3_ * 0.9 || TUTORIAL._stage < 200)
         {
            ATTACK.PoorDefense();
         }
         else if(_loc2_ >= _loc3_ * 0.9)
         {
            if(!MONSTERBAITER._scaredAway)
            {
               ATTACK.WellDefended(true);
            }
         }
         MONSTERBAITER._scaredAway = false;
         QUESTS.Check();
         MONSTERBAITER._attacking = 0;
      }
      
      public static function ResetWait() : void
      {
         if(_history.nextAttack)
         {
            delete _history.nextAttack;
         }
         if(_history.queued)
         {
            delete _history.queued;
         }
         _history.sessionsSinceLastAttack = 0;
      }
      
      public static function get _attackPreference() : int
      {
         return attackPreference;
      }
      
      public static function set _attackPreference(param1:int) : void
      {
         switch(param1)
         {
            case -1:
               _history.nextAttack = _history.lastattack + 345600;
               _attackVolumeAmplifier = 0.5;
               _hitsPerCreep = 20;
               _history.attackPreference = -1;
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  LOGGER.Stat([89,"slow"]);
               }
               break;
            case 0:
            default:
               _history.nextAttack = _history.lastattack + 259200;
               _attackVolumeAmplifier = 1;
               _hitsPerCreep = 30;
               _history.attackPreference = 0;
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  LOGGER.Stat([89,"med"]);
               }
               break;
            case 1:
               _history.nextAttack = _history.lastattack + 172800;
               _attackVolumeAmplifier = 1.3;
               _hitsPerCreep = 50;
               _history.attackPreference = 1;
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  LOGGER.Stat([89,"fast"]);
               }
         }
         BASE.Save();
      }
      
      public static function dpsAtPoint(param1:Solution, param2:Point) : Number
      {
         var _loc3_:BTOWER = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc7_:BTOWER = null;
         var _loc6_:Number = 0;
         param2 = GRID.FromISO(param2.x,param2.y);
         var _loc8_:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         for each(_loc3_ in _loc8_)
         {
            if(_loc3_._countdownUpgrade.Get() == 0 && _loc3_._countdownBuild.Get() == 0 && Boolean(_loc3_._countdownFortify.Get()))
            {
               (_loc5_ = GRID.FromISO(_loc3_.x,_loc3_.y)).add(new Point(_loc3_._footprint[0].width * 0.5,_loc3_._footprint[0].height * 0.5));
               if((_loc4_ = Point.distance(_loc5_,param2)) < _loc3_._range)
               {
                  _loc7_ = _loc3_;
                  _loc6_ += _loc3_.damage / _loc3_._rate;
                  param1.towersInPath.push(_loc3_);
               }
            }
         }
         return _loc6_;
      }
   }
}
