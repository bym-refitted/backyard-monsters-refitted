package utils.exposed
{
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class ExposedDefinitionManager
   {
      
      private static var s_Instance:ExposedDefinitionManager = null;
      
      internal static const VECTOR_TYPE_NAME:String = "__AS3__.vec::Vector.<";
       
      
      private var m_ExposedPrimitives:Dictionary;
      
      private var m_ExposedDefinitions:Dictionary;
      
      public function ExposedDefinitionManager(param1:SingletonLock)
      {
         this.m_ExposedPrimitives = new Dictionary();
         this.m_ExposedDefinitions = new Dictionary();
         super();
         this.m_ExposedPrimitives[getQualifiedClassName(false)] = Boolean;
         this.m_ExposedPrimitives[getQualifiedClassName(0)] = int;
         this.m_ExposedPrimitives[getQualifiedClassName(0.1)] = Number;
         this.m_ExposedPrimitives[getQualifiedClassName("")] = String;
         this.m_ExposedPrimitives["uint"] = uint;
      }
      
      public static function get instance() : ExposedDefinitionManager
      {
         return s_Instance = s_Instance || new ExposedDefinitionManager(new SingletonLock());
      }
      
      internal function IsPrimitiveType(param1:String) : Boolean
      {
         return this.m_ExposedPrimitives.hasOwnProperty(param1);
      }
      
      internal function FindOrCacheExposedDefinition(param1:ExposedStructure) : ExposedDefinition
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:ExposedDefinition = this.m_ExposedDefinitions[_loc2_];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         _loc3_ = new ExposedDefinition(param1);
         this.m_ExposedDefinitions[_loc2_] = _loc3_;
         return _loc3_;
      }
      
      internal function DoesInheritFrom(param1:Class, param2:Class) : Boolean
      {
         while(param1 != Object)
         {
            if(param1 == param2)
            {
               return true;
            }
            param1 = this.GetParentClass(param1);
         }
         return false;
      }
      
      internal function GetParentClass(param1:Class) : Class
      {
         return getDefinitionByName(getQualifiedSuperclassName(param1)) as Class;
      }
   }
}

class SingletonLock
{
    
   
   public function SingletonLock()
   {
      super();
   }
}
