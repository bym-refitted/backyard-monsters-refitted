package as3reflect
{
   public final class AccessorAccess
   {
      
      private static const READ_ONLY_VALUE:String = "readonly";
      
      private static const READ_WRITE_VALUE:String = "readwrite";
      
      public static const READ_ONLY:AccessorAccess = new AccessorAccess(READ_ONLY_VALUE);
      
      public static const READ_WRITE:AccessorAccess = new AccessorAccess(READ_WRITE_VALUE);
      
      private static const WRITE_ONLY_VALUE:String = "writeonly";
      
      public static const WRITE_ONLY:AccessorAccess = new AccessorAccess(WRITE_ONLY_VALUE);
       
      
      private var _name:String;
      
      public function AccessorAccess(param1:String)
      {
         super();
         _name = param1;
      }
      
      public static function fromString(param1:String) : AccessorAccess
      {
         var _loc2_:AccessorAccess = null;
         switch(param1)
         {
            case READ_ONLY_VALUE:
               _loc2_ = READ_ONLY;
               break;
            case WRITE_ONLY_VALUE:
               _loc2_ = WRITE_ONLY;
               break;
            case READ_WRITE_VALUE:
               _loc2_ = READ_WRITE;
         }
         return _loc2_;
      }
      
      public function get name() : String
      {
         return _name;
      }
   }
}
