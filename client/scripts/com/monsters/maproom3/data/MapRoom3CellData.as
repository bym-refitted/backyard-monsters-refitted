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

      private var m_PicSquare:String = "";
      
      private var m_AllianceId:int = 0;
      
      private var m_BaseId:Number = 0;
      
      private var m_UserId:int = 0;
      
      private var m_CellDataBitField1:uint = 0;
      
      private var m_CellDataBitField2:uint = 0;
      
      public function MapRoom3CellData(cellData:Object)
      {
         super();
         this.Map(cellData);
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get facebookID() : String
      {
         return this.m_FacebookId;
      }

      public function get pic_square() : String
      {
         return this.m_PicSquare;
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
      
      public function Map(cellData:Object) : void
      {
         this.m_Name = cellData.hasOwnProperty("n") ? String(cellData["n"]) : "";
         this.m_FacebookId = cellData.hasOwnProperty("fbid") ? String(cellData["fbid"]) : "";
         this.m_PicSquare = cellData.hasOwnProperty("pic_square") ? String(cellData["pic_square"]) : "";
         this.m_AllianceId = cellData.hasOwnProperty("aid") ? int(cellData["aid"]) : 0;
         this.m_BaseId = cellData.hasOwnProperty("bid") ? Number(cellData["bid"]) : 0;
         this.m_UserId = cellData.hasOwnProperty("uid") ? int(cellData["uid"]) : 0;
         this.m_CellDataBitField1 = 0;
         var _loc2_:int = cellData.hasOwnProperty("l") ? int(cellData["l"]) : 0;
         var _loc3_:int = cellData.hasOwnProperty("pl") ? int(cellData["pl"]) : 0;
         var _loc4_:int = cellData.hasOwnProperty("r") ? int(cellData["r"]) : 0;
         var _loc5_:int = cellData.hasOwnProperty("dm") ? int(cellData["dm"]) : 0;
         this.m_CellDataBitField1 |= (_loc2_ & MAX_VALUE_BASE_LEVEL) << BIT_SHIFT_BASE_LEVEL;
         this.m_CellDataBitField1 |= (_loc3_ & MAX_VALUE_PLAYER_LEVEL) << BIT_SHIFT_PLAYER_LEVEL;
         this.m_CellDataBitField1 |= (_loc4_ & MAX_VALUE_ATTACK_RANGE) << BIT_SHIFT_ATTACK_RANGE;
         this.m_CellDataBitField1 |= (_loc5_ & MAX_VALUE_DAMAGE) << BIT_SHIFT_DAMAGE;
         this.m_CellDataBitField2 = 0;
         var _loc6_:int = cellData.hasOwnProperty("tid") ? int(cellData["tid"]) : 0;
         var _loc7_:int = cellData.hasOwnProperty("rel") ? int(cellData["rel"]) : EnumBaseRelationship.k_RELATIONSHIP_NONE;
         var _loc8_:int = cellData.hasOwnProperty("lo") ? int(cellData["lo"]) : 0;
         var _loc9_:int = cellData.hasOwnProperty("fr") ? int(cellData["fr"]) : 0;
         var _loc10_:int = cellData.hasOwnProperty("p") ? int(cellData["p"]) : 0;
         var _loc11_:int = cellData.hasOwnProperty("d") ? int(cellData["d"]) : 0;
         var _loc12_:int = cellData.hasOwnProperty("t") ? int(cellData["t"]) : 0;
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
