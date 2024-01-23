package as3reflect
{
   public interface IMetaDataContainer
   {
       
      
      function addMetaData(param1:MetaData) : void;
      
      function hasMetaData(param1:String) : Boolean;
      
      function getMetaData(param1:String) : Array;
      
      function get metaData() : Array;
   }
}
