package utils.exposed
{
   import flash.utils.getDefinitionByName;
   
   internal class ExposedAccessor
   {
       
      
      private var m_Name:String;
      
      private var m_QualifiedClassName:String;
      
      private var m_ClassType:Class;
      
      public function ExposedAccessor(param1:String, param2:String)
      {
         super();
         this.m_Name = param1;
         this.m_QualifiedClassName = param2;
         this.m_ClassType = getDefinitionByName(param2) as Class;
      }
      
      internal function get name() : String
      {
         return this.m_Name;
      }
      
      internal function get qualifiedClassName() : String
      {
         return this.m_QualifiedClassName;
      }
      
      internal function get classType() : Class
      {
         return this.m_ClassType;
      }
      
      public function Destroy() : void
      {
         this.m_Name = "";
         this.m_QualifiedClassName = "";
         this.m_ClassType = null;
      }
   }
}
