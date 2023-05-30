package com.monsters.maproom3.data
{
   import com.monsters.enums.EnumBaseRelationship;
   
   public class MapRoom3CellData
   {
      
      private static const MAX_BITS_BASE_LEVEL:uint = 8;
      
      private static const MAX_BITS_PLAYER_LEVEL:uint = 8;
      
      private static const MAX_BITS_ATTACK_RANGE:uint = 8;
      
      private static const MAX_BITS_DAMAGE:uint = 8;
      
      private static const MAX_VALUE_BASE_LEVEL:uint = Math.pow(2,MAX_BITS_BASE_LEVEL) - 1;
      
      private static const MAX_VALUE_PLAYER_LEVEL:uint = Math.pow(2,MAX_BITS_PLAYER_LEVEL) - 1;
      
      private static const MAX_VALUE_ATTACK_RANGE:uint = Math.pow(2,MAX_BITS_ATTACK_RANGE) - 1;
      
      private static const MAX_VALUE_DAMAGE:uint = Math.pow(2,MAX_BITS_DAMAGE) - 1;
      
      private static const BIT_SHIFT_BASE_LEVEL:uint = 0;
      
      private static const BIT_SHIFT_PLAYER_LEVEL:uint = BIT_SHIFT_BASE_LEVEL + MAX_BITS_BASE_LEVEL;
      
      private static const BIT_SHIFT_ATTACK_RANGE:uint = BIT_SHIFT_PLAYER_LEVEL + MAX_BITS_PLAYER_LEVEL;
      
      private static const BIT_SHIFT_DAMAGE:uint = BIT_SHIFT_ATTACK_RANGE + MAX_BITS_ATTACK_RANGE;
      
      private static const MAX_BITS_WILD_MONSTER_TRIBE_ID:uint = 3;
      
      private static const MAX_BITS_RELATIONSHIP:uint = 3;
      
      private static const MAX_BITS_LOCKED_INVISIBLE:uint = 2;
      
      private static const MAX_BITS_FACEBOOK_FRIEND:uint = 1;
      
      private static const MAX_BITS_DAMAGE_PROTECTION:uint = 1;
      
      private static const MAX_BITS_DESTROYED:uint = 1;
      
      private static const MAX_BITS_TRUCE:uint = 1;
      
      private static const MAX_VALUE_WILD_MONSTER_TRIBE_ID:uint = Math.pow(2,MAX_BITS_WILD_MONSTER_TRIBE_ID) - 1;
      
      private static const MAX_VALUE_RELATIONSHIP:uint = Math.pow(2,MAX_BITS_RELATIONSHIP) - 1;
      
      private static const MAX_VALUE_LOCKED_INVISIBLE:uint = Math.pow(2,MAX_BITS_LOCKED_INVISIBLE) - 1;
      
      private static const MAX_VALUE_FACEBOOK_FRIEND:uint = Math.pow(2,MAX_BITS_FACEBOOK_FRIEND) - 1;
      
      private static const MAX_VALUE_DAMAGE_PROTECTION:uint = Math.pow(2,MAX_BITS_DAMAGE_PROTECTION) - 1;
      
      private static const MAX_VALUE_DESTROYED:uint = Math.pow(2,MAX_BITS_DESTROYED) - 1;
      
      private static const MAX_VALUE_TRUCE:uint = Math.pow(2,MAX_BITS_TRUCE) - 1;
      
      private static const BIT_SHIFT_WILD_MONSTER_TRIBE_ID:uint = 0;
      
      private static const BIT_SHIFT_RELATIONSHIP:uint = BIT_SHIFT_WILD_MONSTER_TRIBE_ID + MAX_BITS_WILD_MONSTER_TRIBE_ID;
      
      private static const BIT_SHIFT_LOCKED_INVISIBLE:uint = BIT_SHIFT_RELATIONSHIP + MAX_BITS_RELATIONSHIP;
      
      private static const BIT_SHIFT_FACEBOOK_FRIEND:uint = BIT_SHIFT_LOCKED_INVISIBLE + MAX_BITS_LOCKED_INVISIBLE;
      
      private static const BIT_SHIFT_DAMAGE_PROTECTION:uint = BIT_SHIFT_FACEBOOK_FRIEND + MAX_BITS_FACEBOOK_FRIEND;
      
      private static const BIT_SHIFT_DESTROYED:uint = BIT_SHIFT_DAMAGE_PROTECTION + MAX_BITS_DAMAGE_PROTECTION;
      
      private static const BIT_SHIFT_TRUCE:uint = BIT_SHIFT_DESTROYED + MAX_BITS_DESTROYED;
       
      
      private var m_Name:String = "";
      
      private var m_FacebookId:String = "";
      
      private var m_AllianceId:int = 0;
      
      private var m_BaseId:Number = 0;
      
      private var m_UserId:int = 0;
      
      private var m_CellDataBitField1:uint = 0;
      
      private var m_CellDataBitField2:uint = 0;
      
      public function MapRoom3CellData(param1:Object)
      {
         super();
         this.Map(param1);
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get facebookID() : String
      {
         return this.m_FacebookId;
      }
      
      public function get allianceID() : int
      {
         return this.m_AllianceId;
      }
      
      public function get baseID() : Number
      {
         return this.m_BaseId;
      }
      
      public function get userID() : int
      {
         return this.m_UserId;
      }
      
      public function get baseLevel() : int
      {
         return this.m_CellDataBitField1 >> BIT_SHIFT_BASE_LEVEL & MAX_VALUE_BASE_LEVEL;
      }
      
      public function get playerLevel() : int
      {
         return this.m_CellDataBitField1 >> BIT_SHIFT_PLAYER_LEVEL & MAX_VALUE_PLAYER_LEVEL;
      }
      
      public function get attackRange() : int
      {
         return this.m_CellDataBitField1 >> BIT_SHIFT_ATTACK_RANGE & MAX_VALUE_ATTACK_RANGE;
      }
      
      public function get damage() : int
      {
         return this.m_CellDataBitField1 >> BIT_SHIFT_DAMAGE & MAX_VALUE_DAMAGE;
      }
      
      public function get wildMonsterTribeId() : int
      {
         return this.m_CellDataBitField2 >> BIT_SHIFT_WILD_MONSTER_TRIBE_ID & MAX_VALUE_WILD_MONSTER_TRIBE_ID;
      }
      
      public function get relationship() : int
      {
         return this.m_CellDataBitField2 >> BIT_SHIFT_RELATIONSHIP & MAX_VALUE_RELATIONSHIP;
      }
      
      public function get isLocked() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_LOCKED_INVISIBLE & MAX_VALUE_LOCKED_INVISIBLE) == 1;
      }
      
      public function get isInvisible() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_LOCKED_INVISIBLE & MAX_VALUE_LOCKED_INVISIBLE) == 2;
      }
      
      public function get isFacebookFriend() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_FACEBOOK_FRIEND & MAX_VALUE_FACEBOOK_FRIEND) == 1;
      }
      
      public function get hasDamageProtection() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_DAMAGE_PROTECTION & MAX_VALUE_DAMAGE_PROTECTION) == 1;
      }
      
      public function get isDestroyed() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_DESTROYED & MAX_VALUE_DESTROYED) == 1;
      }
      
      public function get hasTruce() : Boolean
      {
         return (this.m_CellDataBitField2 >> BIT_SHIFT_TRUCE & MAX_VALUE_TRUCE) == 1;
      }
      
      public function Map(param1:Object) : void
      {
         this.m_Name = param1.hasOwnProperty("n") ? String(param1["n"]) : "";
         this.m_FacebookId = param1.hasOwnProperty("fbid") ? String(param1["fbid"]) : "";
         this.m_AllianceId = param1.hasOwnProperty("aid") ? int(param1["aid"]) : 0;
         this.m_BaseId = param1.hasOwnProperty("bid") ? Number(param1["bid"]) : 0;
         this.m_UserId = param1.hasOwnProperty("uid") ? int(param1["uid"]) : 0;
         this.m_CellDataBitField1 = 0;
         var _loc2_:int = param1.hasOwnProperty("l") ? int(param1["l"]) : 0;
         var _loc3_:int = param1.hasOwnProperty("pl") ? int(param1["pl"]) : 0;
         var _loc4_:int = param1.hasOwnProperty("r") ? int(param1["r"]) : 0;
         var _loc5_:int = param1.hasOwnProperty("dm") ? int(param1["dm"]) : 0;
         this.m_CellDataBitField1 |= (_loc2_ & MAX_VALUE_BASE_LEVEL) << BIT_SHIFT_BASE_LEVEL;
         this.m_CellDataBitField1 |= (_loc3_ & MAX_VALUE_PLAYER_LEVEL) << BIT_SHIFT_PLAYER_LEVEL;
         this.m_CellDataBitField1 |= (_loc4_ & MAX_VALUE_ATTACK_RANGE) << BIT_SHIFT_ATTACK_RANGE;
         this.m_CellDataBitField1 |= (_loc5_ & MAX_VALUE_DAMAGE) << BIT_SHIFT_DAMAGE;
         this.m_CellDataBitField2 = 0;
         var _loc6_:int = param1.hasOwnProperty("tid") ? int(param1["tid"]) : 0;
         var _loc7_:int = param1.hasOwnProperty("rel") ? int(param1["rel"]) : EnumBaseRelationship.k_RELATIONSHIP_NONE;
         var _loc8_:int = param1.hasOwnProperty("lo") ? int(param1["lo"]) : 0;
         var _loc9_:int = param1.hasOwnProperty("fr") ? int(param1["fr"]) : 0;
         var _loc10_:int = param1.hasOwnProperty("p") ? int(param1["p"]) : 0;
         var _loc11_:int = param1.hasOwnProperty("d") ? int(param1["d"]) : 0;
         var _loc12_:int = param1.hasOwnProperty("t") ? int(param1["t"]) : 0;
         this.m_CellDataBitField2 |= (_loc6_ & MAX_VALUE_WILD_MONSTER_TRIBE_ID) << BIT_SHIFT_WILD_MONSTER_TRIBE_ID;
         this.m_CellDataBitField2 |= (_loc7_ & MAX_VALUE_RELATIONSHIP) << BIT_SHIFT_RELATIONSHIP;
         this.m_CellDataBitField2 |= (_loc8_ & MAX_VALUE_LOCKED_INVISIBLE) << BIT_SHIFT_LOCKED_INVISIBLE;
         this.m_CellDataBitField2 |= (_loc9_ & MAX_VALUE_FACEBOOK_FRIEND) << BIT_SHIFT_FACEBOOK_FRIEND;
         this.m_CellDataBitField2 |= (_loc10_ & MAX_VALUE_DAMAGE_PROTECTION) << BIT_SHIFT_DAMAGE_PROTECTION;
         this.m_CellDataBitField2 |= (_loc11_ & MAX_VALUE_DESTROYED) << BIT_SHIFT_DESTROYED;
         this.m_CellDataBitField2 |= (_loc12_ & MAX_VALUE_TRUCE) << BIT_SHIFT_TRUCE;
      }
   }
}
