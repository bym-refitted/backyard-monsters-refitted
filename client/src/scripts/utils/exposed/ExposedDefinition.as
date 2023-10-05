package utils.exposed
{
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   internal class ExposedDefinition
   {
      
      internal static const EXPOSED_FOR_EDITOR:String = "Editor";
      
      internal static const EXPOSED_FOR_LOAD:String = "Load";
      
      internal static const EXPOSED_FOR_SAVE:String = "Save";
       
      
      private var m_QualifiedClassName:String;
      
      private var m_ClassType:Class;
      
      private var m_ExposedAccessors:Dictionary;
      
      public function ExposedDefinition(param1:ExposedStructure)
      {
         this.m_ExposedAccessors = new Dictionary();
         super();
         var _loc2_:XML = describeType(param1);
         this.m_QualifiedClassName = _loc2_.@name;
         this.m_ClassType = getDefinitionByName(this.m_QualifiedClassName) as Class;
         this.m_ExposedAccessors[EXPOSED_FOR_EDITOR] = new Dictionary();
         this.m_ExposedAccessors[EXPOSED_FOR_LOAD] = new Dictionary();
         this.m_ExposedAccessors[EXPOSED_FOR_SAVE] = new Dictionary();
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:ExposedAccessor = null;
         var _loc9_:XMLList = _loc2_.accessor;
         for each(_loc3_ in _loc9_)
         {
            _loc5_ = _loc3_.@name;
            _loc6_ = _loc3_.@type;
            _loc8_ = new ExposedAccessor(_loc5_,_loc6_);
            for each(_loc4_ in _loc3_.metadata)
            {
               _loc7_ = String(_loc4_.@name);
               if(this.m_ExposedAccessors[_loc7_] != null)
               {
                  this.m_ExposedAccessors[_loc7_][_loc5_] = _loc8_;
               }
            }
         }
         System.disposeXML(_loc2_);
      }
      
      internal function get qualifiedClassName() : String
      {
         return this.m_QualifiedClassName;
      }
      
      internal function get classType() : Class
      {
         return this.m_ClassType;
      }
      
      internal function FindExposedAccessor(param1:String, param2:String) : ExposedAccessor
      {
         return this.m_ExposedAccessors[param2][param1] as ExposedAccessor;
      }
      
      internal function GetAccessorsExposedFor(param1:String) : Dictionary
      {
         return this.m_ExposedAccessors[param1] as Dictionary;
      }
   }
}
