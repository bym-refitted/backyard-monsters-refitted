package utils.exposed
{
   internal class ExposedReference
   {
       
      
      private var m_ExposedStructure:ExposedStructure;
      
      private var m_ExposedAccessor:ExposedAccessor;
      
      private var m_ReferencedObjectId:String;
      
      private var m_VectorIndex:int;
      
      public function ExposedReference(param1:ExposedStructure, param2:ExposedAccessor, param3:String, param4:int = -1)
      {
         super();
         this.m_ExposedStructure = param1;
         this.m_ExposedAccessor = param2;
         this.m_ReferencedObjectId = param3;
         this.m_VectorIndex = param4;
      }
      
      internal function get exposedStructure() : ExposedStructure
      {
         return this.m_ExposedStructure;
      }
      
      internal function get exposedAccessor() : ExposedAccessor
      {
         return this.m_ExposedAccessor;
      }
      
      internal function get referencedObjectId() : String
      {
         return this.m_ReferencedObjectId;
      }
      
      internal function get vectorIndex() : int
      {
         return this.m_VectorIndex;
      }
      
      public function Destroy() : void
      {
         this.m_ExposedStructure = null;
         this.m_ExposedAccessor = null;
         this.m_ReferencedObjectId = "";
         this.m_VectorIndex = -1;
      }
   }
}
