package com.monsters.maproom3.data
{
   public class MapRoom3FriendData
   {
       
      
      private var m_FacebookId:String;
      
      private var m_Name:String;
      
      private var m_UserId:int;
      
      private var m_Level:int;
      
      private var m_World:int;
      
      private var m_BaseX:int;
      
      private var m_BaseY:int;
      
      private var m_IsInPlayersWorld:Boolean;
      
      public function MapRoom3FriendData(param1:Object)
      {
         super();
         this.Map(param1);
      }
      
      public function get facebookId() : String
      {
         return this.m_FacebookId;
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get userId() : int
      {
         return this.m_UserId;
      }
      
      public function get level() : int
      {
         return this.m_Level;
      }
      
      public function get world() : int
      {
         return this.m_World;
      }
      
      public function get baseX() : int
      {
         return this.m_BaseX;
      }
      
      public function get baseY() : int
      {
         return this.m_BaseY;
      }
      
      public function get isInPlayersWorld() : Boolean
      {
         return this.m_IsInPlayersWorld;
      }
      
      public function Map(param1:Object) : void
      {
         this.m_FacebookId = param1.hasOwnProperty("fbid") ? String(param1["fbid"]) : "";
         this.m_Name = param1.hasOwnProperty("name") ? String(param1["name"]) : "";
         this.m_UserId = param1.hasOwnProperty("userid") ? int(param1["userid"]) : -1;
         this.m_Level = param1.hasOwnProperty("level") ? int(param1["level"]) : 0;
         this.m_World = param1.hasOwnProperty("worldid") ? int(param1["worldid"]) : 0;
         this.m_BaseX = param1.hasOwnProperty("x") ? int(param1["x"]) : 0;
         this.m_BaseY = param1.hasOwnProperty("y") ? int(param1["y"]) : 0;
         this.m_IsInPlayersWorld = param1.hasOwnProperty("x") && param1.hasOwnProperty("y");
      }
   }
}
