package utils.exposed
{
   import flash.utils.Dictionary;
   import utils.debug.Warning;
   
   public class ExposedObjectManager
   {
      
      private static var s_Instance:utils.exposed.ExposedObjectManager = null;
       
      
      private var m_ReferenceableObjects:Dictionary;
      
      private var m_ReferencesToResolve:Vector.<ExposedReference>;
      
      private var m_ReferenceLoadingBlockCounter:int = 0;
      
      public function ExposedObjectManager(param1:SingletonLock)
      {
         this.m_ReferenceableObjects = new Dictionary();
         this.m_ReferencesToResolve = new Vector.<ExposedReference>();
         super();
      }
      
      public static function get instance() : utils.exposed.ExposedObjectManager
      {
         return s_Instance = s_Instance || new utils.exposed.ExposedObjectManager(new SingletonLock());
      }
      
      public function LoadExposedCollection(param1:XML, param2:XML = null) : ExposedCollection
      {
         var _loc3_:ExposedCollection = new ExposedCollection();
         this.BeginReferenceLoadingBlock();
         _loc3_.LoadState(param1,ExposedDefinition.EXPOSED_FOR_EDITOR);
         if(param2 != null)
         {
            _loc3_.LoadState(param2,ExposedDefinition.EXPOSED_FOR_LOAD);
         }
         this.EndReferenceLoadingBlock();
         _loc3_.Init();
         return _loc3_;
      }
      
      internal function RegisterReferenceableObject(param1:ExposedObject) : void
      {
         if(this.m_ReferenceableObjects[param1.id] != null)
         {
            Warning.Show("Trying to registering referenceable object \'" + param1.id + "\' that has already been registered.",utils.exposed.ExposedObjectManager);
            return;
         }
         this.m_ReferenceableObjects[param1.id] = param1;
      }
      
      internal function DeregisterReferenceableObject(param1:ExposedObject) : void
      {
         this.m_ReferenceableObjects[param1.id] = null;
         delete this.m_ReferenceableObjects[param1.id];
      }
      
      internal function FindReferenceableObject(param1:String) : ExposedObject
      {
         return this.m_ReferenceableObjects[param1] as ExposedObject;
      }
      
      internal function BeginReferenceLoadingBlock() : void
      {
         ++this.m_ReferenceLoadingBlockCounter;
      }
      
      internal function EndReferenceLoadingBlock() : void
      {
         --this.m_ReferenceLoadingBlockCounter;
         if(this.m_ReferenceLoadingBlockCounter < 0)
         {
            Warning.Show("Reference loading block mis-match.",utils.exposed.ExposedObjectManager);
            this.m_ReferenceLoadingBlockCounter = 0;
         }
         if(this.m_ReferenceLoadingBlockCounter == 0)
         {
            this.ResolveReferences();
         }
      }
      
      internal function AddReferenceToResolve(param1:ExposedReference) : void
      {
         if(this.m_ReferenceLoadingBlockCounter <= 0)
         {
            Warning.Show("AddReferenceToResolve called outside of a reference loading block.",utils.exposed.ExposedObjectManager);
            return;
         }
         this.m_ReferencesToResolve.push(param1);
      }
      
      private function ResolveReferences() : void
      {
         var _loc3_:ExposedReference = null;
         var _loc4_:ExposedObject = null;
         var _loc1_:uint = this.m_ReferencesToResolve.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.m_ReferencesToResolve[_loc2_];
            if(_loc3_.referencedObjectId == null || _loc3_.referencedObjectId == "")
            {
               _loc3_.exposedStructure[_loc3_.exposedAccessor.name] = null;
               _loc3_.Destroy();
            }
            else if((_loc4_ = this.FindReferenceableObject(_loc3_.referencedObjectId)) == null)
            {
               Warning.Show("Resolving reference \'" + _loc3_.referencedObjectId + "\' for accessor \'" + _loc3_.exposedAccessor.name + "\' of type \'" + _loc3_.exposedAccessor.qualifiedClassName + "\' but we couldn\'t find the referenced object.",utils.exposed.ExposedObjectManager);
               _loc3_.exposedStructure[_loc3_.exposedAccessor.name] = null;
               _loc3_.Destroy();
            }
            else if(_loc3_.vectorIndex >= 0)
            {
               if(_loc3_.vectorIndex >= _loc3_.exposedStructure[_loc3_.exposedAccessor.name].length)
               {
                  Warning.Show("Resolving reference \'" + _loc3_.referencedObjectId + "\' for accessor \'" + _loc3_.exposedAccessor.name + "\' of type \'" + _loc3_.exposedAccessor.qualifiedClassName + "\' at index \'" + _loc3_.vectorIndex + "\' that is greater than length \'" + this[_loc3_.exposedAccessor.name].length + "\'.",utils.exposed.ExposedObjectManager);
                  _loc3_.exposedStructure[_loc3_.exposedAccessor.name][_loc3_.vectorIndex] = null;
               }
               else
               {
                  _loc3_.exposedStructure[_loc3_.exposedAccessor.name][_loc3_.vectorIndex] = _loc4_;
               }
               _loc3_.Destroy();
            }
            else if(!(_loc4_ is _loc3_.exposedAccessor.classType))
            {
               Warning.Show("Resolving reference \'" + _loc3_.referencedObjectId + "\' for accessor \'" + _loc3_.exposedAccessor.name + "\' that is not of type \'" + _loc3_.exposedAccessor.qualifiedClassName + "\'.",utils.exposed.ExposedObjectManager);
               _loc3_.exposedStructure[_loc3_.exposedAccessor.name] = null;
               _loc3_.Destroy();
            }
            else
            {
               _loc3_.exposedStructure[_loc3_.exposedAccessor.name] = _loc4_;
               _loc3_.Destroy();
            }
            _loc2_++;
         }
         this.m_ReferencesToResolve.length = 0;
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
