package com.monsters.effects
{
   
   import com.cc.utils.SecNum;
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.display.ImageCache;
   import com.monsters.managers.InstanceManager;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ResourceBombs
   {
      
      public static var _activeBombs:Object = {};
      
      public static var bombcounter:int = 0;
      
      public static var bmd_pebble:BitmapData;
      
      public static var bmd_pebblehit:BitmapData;
      
      public static var bmd_twigs:BitmapData;
      
      public static var bmd_putty:BitmapData;
      
      public static var _bombs:Object;
      
      public static var _bombid:String;
      
      public static var _setup:Boolean;
      
      public static var _doneData:Boolean;
      
      public static var _mc:CATAPULTPOPUP;
      
      public static var _state:int;
      
      protected static var _launchedBomb:Boolean;
       
      
      public function ResourceBombs()
      {
         super();
      }
      
      public static function get launchedBomb() : Boolean
      {
         return _launchedBomb;
      }
      
      public static function Data() : void
      {
         _bombs = {
            "tw0":{
               "used":false,
               "group":0,
               "particles":200,
               "name":KEYS.Get("bomb_tw0_name"),
               "description":"",
               "radius":200,
               "damage":2200,
               "cost":10000,
               "resource":1,
               "image":"bombbuttons/twigs1.png",
               "col":0,
               "dropTarget":2,
               "catapultLevel":1
            },
            "tw1":{
               "used":false,
               "group":0,
               "particles":200,
               "name":KEYS.Get("bomb_tw1_name"),
               "description":"",
               "radius":200,
               "damage":7000,
               "cost":100000,
               "resource":1,
               "image":"bombbuttons/twigs2.png",
               "col":1,
               "dropTarget":2,
               "catapultLevel":1
            },
            "tw2":{
               "used":false,
               "group":0,
               "particles":200,
               "name":KEYS.Get("bomb_tw2_name"),
               "description":"",
               "radius":200,
               "damage":50000,
               "cost":5000000,
               "resource":1,
               "image":"bombbuttons/twigs3.png",
               "col":2,
               "dropTarget":2,
               "catapultLevel":1
            },
            "pb0":{
               "used":false,
               "group":1,
               "particles":200,
               "name":KEYS.Get("bomb_pb0_name"),
               "description":"",
               "radius":200,
               "damage":2400,
               "cost":10000,
               "resource":2,
               "image":"bombbuttons/pebbles1.png",
               "col":0,
               "dropTarget":2,
               "catapultLevel":2
            },
            "pb1":{
               "used":false,
               "group":1,
               "particles":200,
               "name":KEYS.Get("bomb_pb1_name"),
               "description":"",
               "radius":300,
               "damage":9000,
               "cost":100000,
               "resource":2,
               "image":"bombbuttons/pebbles2.png",
               "col":1,
               "dropTarget":2,
               "catapultLevel":2
            },
            "pb2":{
               "used":false,
               "group":1,
               "particles":200,
               "name":KEYS.Get("bomb_pb2_name"),
               "description":"",
               "radius":350,
               "damage":30000,
               "cost":2000000,
               "resource":2,
               "image":"bombbuttons/pebbles3.png",
               "col":2,
               "dropTarget":2,
               "catapultLevel":2
            },
            "pb3":{
               "used":false,
               "group":1,
               "particles":200,
               "name":KEYS.Get("bomb_pb3_name"),
               "description":"",
               "radius":400,
               "damage":75000,
               "cost":10000000,
               "resource":2,
               "image":"bombbuttons/pebbles4.png",
               "col":3,
               "dropTarget":2,
               "catapultLevel":2
            },
            "pu0":{
               "used":false,
               "group":2,
               "particles":25,
               "name":KEYS.Get("bomb_pu0_name"),
               "description":"bomb_pu_description",
               "damageMult":0.2,
               "radius":150,
               "damage":0,
               "speed":1.2,
               "speedlength":10,
               "cost":10000,
               "resource":3,
               "image":"bombbuttons/putty1.png",
               "col":0,
               "dropTarget":3,
               "catapultLevel":3
            },
            "pu1":{
               "used":false,
               "group":2,
               "particles":37,
               "name":KEYS.Get("bomb_pu1_name"),
               "description":"bomb_pu_description",
               "damageMult":0.4,
               "radius":150,
               "damage":0,
               "speed":1.4,
               "speedlength":15,
               "cost":100000,
               "resource":3,
               "image":"bombbuttons/putty2.png",
               "col":1,
               "dropTarget":3,
               "catapultLevel":3
            },
            "pu2":{
               "used":false,
               "group":2,
               "particles":43,
               "name":KEYS.Get("bomb_pu2_name"),
               "description":"bomb_pu_description",
               "damageMult":0.7,
               "radius":300,
               "damage":0,
               "speed":1.8,
               "speedlength":30,
               "cost":5000000,
               "resource":3,
               "image":"bombbuttons/putty3.png",
               "col":2,
               "dropTarget":3,
               "catapultLevel":3
            },
            "pu3":{
               "used":false,
               "group":2,
               "particles":50,
               "name":KEYS.Get("bomb_pu3_name"),
               "description":"bomb_pu_description",
               "damageMult":0.9,
               "radius":500,
               "damage":0,
               "speed":2,
               "speedlength":40,
               "cost":10000000,
               "resource":3,
               "image":"bombbuttons/putty4.png",
               "col":3,
               "dropTarget":3,
               "catapultLevel":3
            }
         };
      }
      
      public static function Setup() : void
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         ImageCache.GetImageWithCallBack("effects/twigs.png",onAssetLoaded,true,6);
         ImageCache.GetImageWithCallBack("effects/pebble.png",onAssetLoaded,true,6);
         ImageCache.GetImageWithCallBack("effects/pebblehit.png",onAssetLoaded,true,6);
         ImageCache.GetImageWithCallBack("effects/putty.png",onAssetLoaded,true,6);
         var _loc1_:int = 0;
         var _loc2_:String = "tw0";
         _bombid = "tw0";
         _launchedBomb = false;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK)
         {
            for(_loc4_ in _bombs)
            {
               _loc3_ = _bombs[_loc4_];
               if(GLOBAL._attackersResources["r" + _loc3_.resource].Get() >= _loc3_.cost && GLOBAL._attackersCatapult >= _loc3_.catapultLevel && _loc3_.cost <= 2000000)
               {
                  if(_loc3_.cost > _loc1_)
                  {
                     _loc1_ = int(_loc3_.cost);
                     _loc2_ = _loc4_;
                  }
               }
            }
            _bombid = _loc2_;
         }
      }
      
      public static function Clear() : void
      {
         _mc = null;
         _launchedBomb = false;
      }
      
      public static function onAssetLoaded(param1:String, param2:BitmapData) : void
      {
         if(param1 == "effects/pebble.png")
         {
            bmd_pebble = param2;
         }
         else if(param1 == "effects/pebblehit.png")
         {
            bmd_pebblehit = param2;
         }
         else if(param1 == "effects/twigs.png")
         {
            bmd_twigs = param2;
         }
         else if(param1 == "effects/putty.png")
         {
            bmd_putty = param2;
         }
      }
      
      public static function BombAdd(param1:Object) : void
      {
         _state = 1;
         ATTACK.DropZone(param1.radius,param1.dropTarget);
         if(_mc)
         {
            _mc.Update();
         }
      }
      
      public static function BombRemove() : void
      {
         if(_state == 1)
         {
            ATTACK.RemoveDropZone();
            _state = 0;
            if(_mc)
            {
               _mc.Update();
            }
         }
      }
      
      public static function BombDrop() : void
      {
         var _loc4_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:Object = _bombs[_bombid];
         var _loc3_:Boolean = false;
         if(Boolean(_mc) && _mc.waitTime > GLOBAL.Timestamp())
         {
            return;
         }
         ATTACK.RemoveDropZone();
         if(GLOBAL._attackersResources)
         {
            if(GLOBAL._attackersResources["r" + _loc2_.resource].Get() >= _loc2_.cost)
            {
               GLOBAL._resources["r" + _loc2_.resource].Add(-_loc2_.cost);
               GLOBAL._hpResources["r" + _loc2_.resource] -= _loc2_.cost;
               GLOBAL._attackersDeltaResources["r" + _loc2_.resource] = new SecNum(-_loc2_.cost);
               GLOBAL._attackersDeltaResources.dirty = true;
               _loc3_ = true;
            }
         }
         if(_loc3_)
         {
            for each(_loc4_ in _bombs)
            {
               if(_loc4_.resource == _loc2_.resource)
               {
                  _loc4_.used = true;
               }
            }
            Trigger(MAP._BUILDINGBASES,new Point(MAP._GROUND.mouseX,MAP._GROUND.mouseY),_loc2_,2);
         }
         if(_bombid == "pu3")
         {
            ACHIEVEMENTS.Check("hugerage",1);
         }
         ATTACK.Log("bomb" + ResourceBombs._bombid,"<font color=\"#A800FF\">" + KEYS.Get("attack_log_catapulted",{
            "v1":GLOBAL.FormatNumber(_loc2_.cost),
            "v2":GLOBAL._resourceNames[_loc2_.resource - 1]
         }) + "</font>");
         _state = 0;
         if(_mc)
         {
            _mc.Update();
         }
      }
      
      public static function Trigger(param1:MovieClip, param2:Point, param3:Object, param4:int = 2) : void
      {
         _activeBombs[bombcounter] = new ResourceBomb(param1,param2,param3,param4);
         if(param3.resource == 1)
         {
            SOUNDS.Play("twigbomb");
         }
         else if(param3.resource == 2)
         {
            SOUNDS.Play("pebblebomb");
         }
         else if(param3.resource == 3)
         {
            SOUNDS.Play("puttybomb");
         }
         ++bombcounter;
         _launchedBomb = true;
         if(_mc)
         {
            _mc.fired();
         }
         if(ALLIANCES._myAlliance)
         {
            LOGGER.Stat([27,param3.resource,param3.col,param3.cost,ALLIANCES._allianceID]);
         }
         else
         {
            LOGGER.Stat([27,param3.resource,param3.col,param3.cost]);
         }
      }
      
      public static function Tick() : void
      {
         var _loc1_:String = null;
         var _loc3_:* = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:BFOUNDATION = null;
         var _loc2_:int = 0;
         for(_loc1_ in _activeBombs)
         {
            _loc3_ = _activeBombs[_loc1_];
            _loc2_++;
            if(_loc3_.Tick())
            {
               BASE.Save();
               _loc3_.Freeze();
               delete _activeBombs[_loc1_];
               _loc2_--;
               if(_loc2_ == 0 && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  _loc4_ = InstanceManager.getInstancesByClass(BFOUNDATION);
                  for each(_loc5_ in _loc4_)
                  {
                     if(_loc5_.health < _loc5_.maxHealth && _loc5_._repairing == 0)
                     {
                        _loc5_.Repair();
                     }
                  }
                  MARKETING.Show("catapult");
                  BASE.Save();
               }
            }
         }
      }
      
      public static function Check() : String
      {
         var _loc3_:String = null;
         var _loc1_:Array = [];
         var _loc2_:Array = ["tw0","tw1","tw2","pb0","pb1","pb2","pb3","pu0","pu1","pu2","pu3"];
         for each(_loc3_ in _loc2_)
         {
            if(_bombs[_loc3_].radius)
            {
               _loc1_.push(_bombs[_loc3_].radius);
            }
            if(_bombs[_loc3_].damage)
            {
               _loc1_.push(_bombs[_loc3_].damage);
            }
            if(_bombs[_loc3_].cost)
            {
               _loc1_.push(_bombs[_loc3_].cost);
            }
            if(_bombs[_loc3_].resource)
            {
               _loc1_.push(_bombs[_loc3_].resource);
            }
            if(_bombs[_loc3_].damageMult)
            {
               _loc1_.push(_bombs[_loc3_].damageMult);
            }
            if(_bombs[_loc3_].speed)
            {
               _loc1_.push(_bombs[_loc3_].speed);
            }
            if(_bombs[_loc3_].speedlength)
            {
               _loc1_.push(_bombs[_loc3_].speedlength);
            }
         }
         return md5(JSON.encode(_loc1_));
      }
   }
}
