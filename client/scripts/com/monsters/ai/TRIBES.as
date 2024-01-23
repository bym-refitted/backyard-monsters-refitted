package com.monsters.ai
{
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class TRIBES
   {
      
      private static var _tribes:Object;
      
      private static var _infernotribes:Object;
      
      private static var _eventtribes:Object;
      
      private static var _assoc:Object;
      
      public static const L_IDS:Array = [1,2,3,4,5,6,7,8,9,10,41,42];
      
      public static const K_IDS:Array = [11,12,13,14,15,16,17,18,19,20,43,44];
      
      public static const A_IDS:Array = [21,22,23,24,25,26,27,28,29,30,45,46];
      
      public static const D_IDS:Array = [31,32,33,34,35,36,37,38,39,40,47,48,101,102,103,104,105,106,107,108,109,110];
      
      public static const k_DIGIT_LEVEL:uint = 0;
      
      public static const k_DIGIT_TRIBE:uint = 1;
      
      public static const k_DIGIT_CELLTYPE:uint = 2;
      
      public static var B_IDS:Array = [];
       
      
      public function TRIBES()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _tribes = {};
         _assoc = {
            "l":L_IDS,
            "k":K_IDS,
            "a":A_IDS,
            "d":D_IDS,
            "b":B_IDS
         };
         _tribes.l = {
            "id":1,
            "name":KEYS.Get("ai_legion_name"),
            "process":PROCESS3,
            "type":WMATTACK.TYPE_TOWERS,
            "taunt":KEYS.Get("ai_legion_taunt"),
            "splash":"popups/tribe_legionnaire.v2.png",
            "description":KEYS.Get("ai_legion_description"),
            "succ":KEYS.Get("ai_legion_succ"),
            "succ_stream":KEYS.Get("ai_legion_succstream"),
            "fail":KEYS.Get("ai_legion_fail"),
            "profilepic":"monsters/tribe_legionnaire_50.v2.jpg",
            "streampostpic":"tribe-legionnaire.v2.png"
         };
         _tribes.k = {
            "id":2,
            "name":KEYS.Get("ai_kozu_name"),
            "process":PROCESS4,
            "type":WMATTACK.TYPE_SWARM,
            "taunt":KEYS.Get("ai_kozu_taunt"),
            "splash":"popups/tribe_kozu.v2.png",
            "description":KEYS.Get("ai_kozu_description"),
            "succ":KEYS.Get("ai_kozu_succ"),
            "succ_stream":KEYS.Get("ai_kozu_succstream"),
            "fail":KEYS.Get("ai_kozu_fail"),
            "profilepic":"monsters/tribe_kozu_50.v2.jpg",
            "streampostpic":"tribe-kozu.v2.png"
         };
         _tribes.a = {
            "id":3,
            "name":KEYS.Get("ai_abunakki_name"),
            "process":PROCESS5,
            "type":WMATTACK.TYPE_KAMIKAZE,
            "taunt":KEYS.Get("ai_abunakki_taunt"),
            "splash":"popups/tribe_abunakki.v2.png",
            "description":KEYS.Get("ai_abunakki_description"),
            "succ":KEYS.Get("ai_abunakki_succ"),
            "succ_stream":KEYS.Get("ai_abunakki_succstream"),
            "fail":KEYS.Get("ai_abunakki_fail"),
            "profilepic":"monsters/tribe_abunakki_50.v2.jpg",
            "streampostpic":"tribe-abunakki.v2.png",
            "behaviour":"juice"
         };
         _tribes.d = {
            "id":4,
            "name":KEYS.Get("ai_dread_name"),
            "process":PROCESS7,
            "type":WMATTACK.TYPE_NERD,
            "taunt":KEYS.Get("ai_dread_taunt"),
            "splash":"popups/tribe_dreadnaut.v2.png",
            "description":KEYS.Get("ai_dread_description"),
            "succ":KEYS.Get("ai_dread_succ"),
            "succ_stream":KEYS.Get("ai_dread_succstream"),
            "fail":KEYS.Get("ai_dread_fail"),
            "profilepic":"monsters/tribe_dreadnaut_50.v2.jpg",
            "streampostpic":"tribe-dreadnaut.v2.png"
         };
         _infernotribes = {};
         _infernotribes.d = {
            "id":1,
            "name":KEYS.Get("ai_descenttribe_name"),
            "process":PROCESS7,
            "type":WMATTACK.TYPE_NERD,
            "taunt":KEYS.Get("ai_descenttribe_taunt"),
            "splash":"popups/tribe_moloch.png",
            "description":KEYS.Get("ai_descenttribe_description"),
            "succ":KEYS.Get("ai_descenttribe_succ"),
            "succ_stream":KEYS.Get("ai_descenttribe_succstream"),
            "fail":KEYS.Get("ai_descenttribe_fail"),
            "profilepic":"monsters/tribe_moloch_50.jpg",
            "streampostpic":"tribe-moloch.v2.png"
         };
         _eventtribes = {};
         _eventtribes.b = {
            "id":1,
            "name":KEYS.Get("ai_brukkarg_name"),
            "process":PROCESS7,
            "type":WMATTACK.TYPE_NERD,
            "taunt":KEYS.Get("ai_brukkarg_taunt"),
            "splash":"popups/tribe_brukkarg.png",
            "description":KEYS.Get("ai_brukkarg_description"),
            "succ":KEYS.Get("ai_brukkarg_succ"),
            "succ_stream":KEYS.Get("ai_brukkarg_succstream"),
            "fail":KEYS.Get("ai_brukkarg_fail"),
            "profilepic":"monsters/tribe_brukkarg_50.jpg",
            "streampostpic":"tribe_brukkarg.png"
         };
      }
      
      public static function TribeForID(param1:int, param2:int = 0) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         if(GLOBAL._loadmode !== GLOBAL.mode)
         {
            return _infernotribes.d;
         }
         var _loc3_:Object = ChooseTribesTable(param2);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.nid == param1)
            {
               return _loc4_;
            }
         }
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _loc6_ = (_loc5_ = separateDigitsFromInt(param1))[k_DIGIT_TRIBE];
            for each(_loc4_ in _tribes)
            {
               if(_loc4_.id === _loc6_)
               {
                  return _loc4_;
               }
            }
         }
         return null;
      }
      
      public static function TribeForBaseID(param1:int, param2:int = 0) : Object
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         if(GLOBAL._loadmode != GLOBAL.mode)
         {
            return _infernotribes.d;
         }
         if(B_IDS.length && param1 >= B_IDS[0] || param1 === 0)
         {
            return _eventtribes.b;
         }
         for(_loc3_ in _assoc)
         {
            _loc4_ = 0;
            while(_loc4_ < _assoc[_loc3_].length)
            {
               if(param1 == _assoc[_loc3_][_loc4_])
               {
                  return _tribes[_loc3_];
               }
               _loc4_++;
            }
         }
         if(MapRoomManager.instance.isInMapRoom3)
         {
            _loc6_ = (_loc5_ = separateDigitsFromInt(param1))[k_DIGIT_TRIBE];
            for each(_loc7_ in _tribes)
            {
               if(_loc7_.id === _loc6_)
               {
                  return _loc7_;
               }
            }
            return _loc7_;
         }
         return null;
      }
      
      private static function separateDigitsFromInt(param1:int) : Vector.<int>
      {
         var _loc2_:Vector.<int> = new Vector.<int>();
         while(param1)
         {
            _loc2_[_loc2_.length] = param1 % 10;
            param1 = Math.floor(param1 * 0.1);
         }
         return _loc2_;
      }
      
      public static function ChooseTribesTable(param1:int = 0) : Object
      {
         var _loc2_:int = param1;
         if(_loc2_ <= 0)
         {
            _loc2_ = BASE.isInfernoMainYardOrOutpost ? 2 : 1;
         }
         switch(_loc2_)
         {
            case 0:
            case 1:
               return _tribes;
            case 2:
               return _infernotribes;
            default:
               return _tribes;
         }
      }
   }
}
