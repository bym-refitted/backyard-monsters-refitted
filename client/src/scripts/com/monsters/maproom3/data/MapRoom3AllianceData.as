package com.monsters.maproom3.data
{
   public class MapRoom3AllianceData
   {
       
      
      private var m_Name:String;
      
      private var m_AllianceId:int;
      
      private var m_ImageId:int;
      
      public function MapRoom3AllianceData(param1:Object)
      {
         super();
         this.Map(param1);
      }
      
      public function get name() : String
      {
         return this.m_Name;
      }
      
      public function get allianceId() : int
      {
         return this.m_AllianceId;
      }
      
      public function get imageId() : int
      {
         return this.m_ImageId;
      }
      
      public function Map(param1:Object) : void
      {
         this.m_Name = param1.hasOwnProperty("name") ? String(param1["name"]) : "";
         this.m_AllianceId = param1.hasOwnProperty("alliance_id") ? int(param1["alliance_id"]) : -1;
         this.m_ImageId = param1.hasOwnProperty("image") ? int(param1["image"]) : 1;
      }
   }
}
