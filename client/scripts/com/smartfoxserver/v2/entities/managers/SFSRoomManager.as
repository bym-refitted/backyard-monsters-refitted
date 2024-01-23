package com.smartfoxserver.v2.entities.managers
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.Room;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.kernel;
   import com.smartfoxserver.v2.util.ArrayUtil;
   import de.polygonal.ds.HashMap;
   import de.polygonal.ds.Itr;
   
   public class SFSRoomManager implements IRoomManager
   {
       
      
      private var _ownerZone:String;
      
      private var _groups:Array;
      
      private var _roomsById:HashMap;
      
      private var _roomsByName:HashMap;
      
      protected var _smartFox:SmartFox;
      
      public function SFSRoomManager(param1:SmartFox)
      {
         super();
         this._groups = new Array();
         this._roomsById = new HashMap();
         this._roomsByName = new HashMap();
      }
      
      public function get ownerZone() : String
      {
         return this._ownerZone;
      }
      
      public function set ownerZone(param1:String) : void
      {
         this._ownerZone = param1;
      }
      
      public function get smartFox() : SmartFox
      {
         return this._smartFox;
      }
      
      public function addRoom(param1:Room, param2:Boolean = true) : void
      {
         this._roomsById.set(param1.id,param1);
         this._roomsByName.set(param1.name,param1);
         if(param2)
         {
            if(!this.containsGroup(param1.groupId))
            {
               this.addGroup(param1.groupId);
            }
         }
         else
         {
            param1.isManaged = false;
         }
      }
      
      public function replaceRoom(param1:Room, param2:Boolean = true) : Room
      {
         var _loc3_:Room = this.getRoomById(param1.id);
         if(_loc3_ != null)
         {
            _loc3_.kernel::merge(param1);
            return _loc3_;
         }
         this.addRoom(param1,param2);
         return param1;
      }
      
      public function changeRoomName(param1:Room, param2:String) : void
      {
         var _loc3_:String = param1.name;
         param1.name = param2;
         this._roomsByName.set(param2,param1);
         this._roomsByName.clr(_loc3_);
      }
      
      public function changeRoomPasswordState(param1:Room, param2:Boolean) : void
      {
         param1.setPasswordProtected(param2);
      }
      
      public function changeRoomCapacity(param1:Room, param2:int, param3:int) : void
      {
         param1.maxUsers = param2;
         param1.maxSpectators = param3;
      }
      
      public function getRoomGroups() : Array
      {
         return this._groups;
      }
      
      public function addGroup(param1:String) : void
      {
         this._groups.push(param1);
      }
      
      public function removeGroup(param1:String) : void
      {
         var _loc3_:Room = null;
         ArrayUtil.removeElement(this._groups,param1);
         var _loc2_:Array = this.getRoomListFromGroup(param1);
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.isJoined)
            {
               this.removeRoom(_loc3_);
            }
            else
            {
               _loc3_.isManaged = false;
            }
         }
      }
      
      public function containsGroup(param1:String) : Boolean
      {
         return this._groups.indexOf(param1) > -1;
      }
      
      public function containsRoom(param1:*) : Boolean
      {
         if(typeof param1 == "number")
         {
            return this._roomsById.hasKey(param1);
         }
         return this._roomsByName.hasKey(param1);
      }
      
      public function containsRoomInGroup(param1:*, param2:String) : Boolean
      {
         var _loc6_:Room = null;
         var _loc3_:Array = this.getRoomListFromGroup(param2);
         var _loc4_:Boolean = false;
         var _loc5_:* = typeof param1 == "number";
         for each(_loc6_ in _loc3_)
         {
            if(_loc5_)
            {
               if(_loc6_.id == param1)
               {
                  _loc4_ = true;
                  break;
               }
            }
            else if(_loc6_.name == param1)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      public function getRoomById(param1:int) : Room
      {
         return this._roomsById.get(param1) as Room;
      }
      
      public function getRoomByName(param1:String) : Room
      {
         return this._roomsByName.get(param1) as Room;
      }
      
      public function getRoomList() : Array
      {
         return this._roomsById.toArray();
      }
      
      public function getRoomCount() : int
      {
         return this._roomsById.size();
      }
      
      public function getRoomListFromGroup(param1:String) : Array
      {
         var _loc4_:Room = null;
         var _loc2_:Array = new Array();
         var _loc3_:Itr = this._roomsById.iterator();
         while(_loc3_.hasNext())
         {
            if((_loc4_ = _loc3_.next() as Room).groupId == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function removeRoom(param1:Room) : void
      {
         this._removeRoom(param1.id,param1.name);
      }
      
      public function removeRoomById(param1:int) : void
      {
         var _loc2_:Room = this._roomsById.get(param1) as Room;
         if(_loc2_ != null)
         {
            this._removeRoom(param1,_loc2_.name);
         }
      }
      
      public function removeRoomByName(param1:String) : void
      {
         var _loc2_:Room = this._roomsByName.get(param1) as Room;
         if(_loc2_ != null)
         {
            this._removeRoom(_loc2_.id,param1);
         }
      }
      
      public function getJoinedRooms() : Array
      {
         var _loc3_:Room = null;
         var _loc1_:Array = [];
         var _loc2_:Itr = this._roomsById.iterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next() as Room;
            if(_loc3_.isJoined)
            {
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function getUserRooms(param1:User) : Array
      {
         var _loc4_:Room = null;
         var _loc2_:Array = [];
         var _loc3_:Itr = this._roomsById.iterator();
         while(_loc3_.hasNext())
         {
            if((_loc4_ = _loc3_.next() as Room).containsUser(param1))
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      public function removeUser(param1:User) : void
      {
         var _loc3_:Room = null;
         var _loc2_:Itr = this._roomsById.iterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next() as Room;
            if(_loc3_.containsUser(param1))
            {
               _loc3_.removeUser(param1);
            }
         }
      }
      
      private function _removeRoom(param1:int, param2:String) : void
      {
         this._roomsById.clr(param1);
         this._roomsByName.clr(param2);
      }
   }
}
