package de.polygonal.core.util
{
   import flash.Boot;
   
   public class Instance
   {
       
      
      public function Instance()
      {
      }
      
      public static function create(param1:Class, param2:Array = undefined) : Object
      {
         if(param2 == null)
         {
            return new param1();
         }
         switch(int(param2.length))
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
               break;
            default:
               Boot.lastError = new Error();
               new param1();
               new param1(param2[0]);
               new param1(param2[0],param2[1]);
               new param1(param2[0],param2[1],param2[2]);
               new param1(param2[0],param2[1],param2[2],param2[3]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11],param2[12]);
               new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11],param2[12],param2[13]);
               throw "too many arguments";
         }
         return §§pop();
      }
      
      public static function createEmpty(param1:Class) : Object
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null;
         try
         {
            Boot.skip_constructor = true;
            _loc3_ = new param1();
            Boot.skip_constructor = false;
            return _loc3_;
         }
         catch(_loc_e_:*)
         {
            Boot.skip_constructor = false;
            Boot.lastError = new Error();
            throw _loc4_;
         }
      }
   }
}
