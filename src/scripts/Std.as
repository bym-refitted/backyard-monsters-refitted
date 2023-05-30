package
{
   import flash.Boot;
   
   public class Std
   {
       
      
      public function Std()
      {
      }
      
      public static function §is§(param1:*, param2:*) : Boolean
      {
         return Boot.__instanceof(param1,param2);
      }
      
      public static function string(param1:*) : String
      {
         return Boot.__string_rec(param1,"");
      }
      
      public static function _int(param1:Number) : int
      {
         return int(param1);
      }
      
      public static function parseInt(param1:String) : Object
      {
         var _loc2_:* = parseInt(param1);
         if(isNaN(_loc2_))
         {
            return null;
         }
         return _loc2_;
      }
      
      public static function parseFloat(param1:String) : Number
      {
         return parseFloat(param1);
      }
      
      public static function random(param1:int) : int
      {
         return int(Math.floor(Math.random() * param1));
      }
   }
}
