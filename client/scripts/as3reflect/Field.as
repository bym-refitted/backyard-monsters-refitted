package as3reflect
{
   public class Field extends AbstractMember
   {
       
      
      public function Field(param1:String, param2:Type, param3:Type, param4:Boolean, param5:Array = null)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      public function getValue(param1:* = null) : *
      {
         if(!param1)
         {
            param1 = declaringType.clazz;
         }
         return param1[name];
      }
   }
}
