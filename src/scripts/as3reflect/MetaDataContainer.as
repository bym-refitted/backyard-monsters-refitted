package as3reflect
{
   public class MetaDataContainer implements IMetaDataContainer
   {
       
      
      private var _metaData:Array;
      
      public function MetaDataContainer(param1:Array = null)
      {
         super();
         _metaData = param1 == null ? [] : param1;
      }
      
      public function addMetaData(param1:MetaData) : void
      {
         _metaData.push(param1);
      }
      
      public function getMetaData(param1:String) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < _metaData.length)
         {
            if(MetaData(_metaData[_loc3_]).name == param1)
            {
               _loc2_.push(_metaData[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get metaData() : Array
      {
         return _metaData.concat();
      }
      
      public function hasMetaData(param1:String) : Boolean
      {
         return getMetaData(param1) != null;
      }
   }
}
