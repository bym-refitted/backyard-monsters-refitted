package utils.exposed
{
   import flash.system.System;
   import flash.utils.getDefinitionByName;
   import utils.debug.Warning;
   
   public class ExposedCollection extends utils.exposed.ExposedObject
   {
       
      
      private var m_Contents:Vector.<utils.exposed.ExposedObject>;
      
      private var m_CachedContentsState:XML = null;
      
      private var m_ContentsLoaded:Boolean = true;
      
      public function ExposedCollection()
      {
         this.m_Contents = new Vector.<utils.exposed.ExposedObject>();
         super();
         this.m_ContentsLoaded = this.AreContentsLoadedByDefault();
      }
      
      public function get contentsLoaded() : Boolean
      {
         return this.m_ContentsLoaded;
      }
      
      public function set contentsLoaded(param1:Boolean) : void
      {
         this.m_ContentsLoaded = param1;
      }
      
      override internal function Init() : void
      {
         super.Init();
         if(this.m_ContentsLoaded)
         {
            this.InitContents();
         }
      }
      
      override public function Destroy() : void
      {
         this.UnloadContents(false);
         super.Destroy();
      }
      
      protected function AreContentsLoadedByDefault() : Boolean
      {
         return true;
      }
      
      protected function SaveContentsSeperately() : Boolean
      {
         return false;
      }
      
      public function FindChildObject(param1:String) : utils.exposed.ExposedObject
      {
         var _loc4_:utils.exposed.ExposedObject = null;
         var _loc2_:uint = this.m_Contents.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = this.m_Contents[_loc3_]).id == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function FindAndRemoveChildObject(param1:String) : utils.exposed.ExposedObject
      {
         var _loc4_:utils.exposed.ExposedObject = null;
         var _loc2_:uint = this.m_Contents.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = this.m_Contents[_loc3_]).id == param1)
            {
               this.m_Contents.splice(_loc3_,1);
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function LoadContents() : void
      {
         if(this.m_ContentsLoaded == true)
         {
            Warning.Show("Trying to load the contents of collection with id \'" + id + "\', but it\'s contents are already loaded.",ExposedCollection);
            return;
         }
         if(this.m_CachedContentsState == null)
         {
            Warning.Show("Trying to load the contents of collection with id \'" + id + "\', but it has no cached contents state.",ExposedCollection);
            return;
         }
         ExposedObjectManager.instance.BeginReferenceLoadingBlock();
         this.LoadContentsState(this.m_CachedContentsState,this.m_CachedContentsState.@exposedFor);
         ExposedObjectManager.instance.EndReferenceLoadingBlock();
         this.InitContents();
         System.disposeXML(this.m_CachedContentsState);
         this.m_CachedContentsState = null;
         this.m_ContentsLoaded = true;
      }
      
      private function InitContents() : void
      {
         var _loc1_:uint = this.m_Contents.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this.m_Contents[_loc2_].Init();
            _loc2_++;
         }
      }
      
      public function UnloadContents(param1:Boolean = true) : void
      {
         if(param1 == true)
         {
            this.m_CachedContentsState = this.SaveContentsState(ExposedDefinition.EXPOSED_FOR_SAVE);
            this.m_CachedContentsState.@exposedFor = ExposedDefinition.EXPOSED_FOR_LOAD;
         }
         var _loc2_:uint = this.m_Contents.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            ExposedObjectManager.instance.DeregisterReferenceableObject(this.m_Contents[_loc3_]);
            this.m_Contents[_loc3_].Destroy();
            _loc3_++;
         }
         this.m_Contents.length = 0;
         this.m_ContentsLoaded = false;
      }
      
      public function SaveInitialContentsStateToXML() : XML
      {
         return this.SaveContentsState(ExposedDefinition.EXPOSED_FOR_EDITOR);
      }
      
      public function SavePersistedContentsStateToXML() : XML
      {
         return this.SaveContentsState(ExposedDefinition.EXPOSED_FOR_SAVE);
      }
      
      override internal function LoadState(param1:XML, param2:String) : void
      {
         var _loc3_:Boolean = this.m_ContentsLoaded;
         super.LoadState(param1,param2);
         var _loc4_:XML = param1.contents[0];
         if(_loc3_ && this.m_ContentsLoaded)
         {
            this.LoadContentsState(_loc4_,param2);
            return;
         }
         if(!_loc3_ && this.m_ContentsLoaded)
         {
            if(this.m_CachedContentsState != null)
            {
               this.LoadContentsState(this.m_CachedContentsState,this.m_CachedContentsState.@exposedFor);
               System.disposeXML(this.m_CachedContentsState);
               this.m_CachedContentsState = null;
            }
            this.LoadContentsState(_loc4_,param2);
            return;
         }
         if(_loc3_ && !this.m_ContentsLoaded)
         {
            this.UnloadContents(false);
            this.m_CachedContentsState = _loc4_.copy();
            this.m_CachedContentsState.@exposedFor = param2;
            return;
         }
         if(!_loc3_ && !this.m_ContentsLoaded)
         {
            this.m_CachedContentsState = _loc4_.copy();
            this.m_CachedContentsState.@exposedFor = param2;
            return;
         }
      }
      
      override internal function SaveState(param1:String) : XML
      {
         var _loc2_:XML = super.SaveState(param1);
         _loc2_.setName("collection");
         if(this.SaveContentsSeperately())
         {
            return _loc2_;
         }
         if(this.m_ContentsLoaded)
         {
            _loc2_.appendChild(this.SaveContentsState(param1));
            return _loc2_;
         }
         if(this.m_CachedContentsState != null && this.m_CachedContentsState.@exposedFor == param1)
         {
            _loc2_.appendChild(this.m_CachedContentsState.copy());
            return _loc2_;
         }
         return _loc2_;
      }
      
      private function LoadContentsState(param1:XML, param2:String) : void
      {
         var _loc8_:XML = null;
         var _loc11_:String = null;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:uint = uint(param1.@length);
         var _loc4_:uint = 0;
         var _loc5_:utils.exposed.ExposedObject = null;
         var _loc6_:Class = null;
         var _loc7_:Vector.<utils.exposed.ExposedObject> = new Vector.<utils.exposed.ExposedObject>(_loc3_);
         for each(_loc8_ in param1.object)
         {
            _loc11_ = String(_loc8_.@id);
            if((_loc5_ = this.FindAndRemoveChildObject(_loc11_)) != null)
            {
               _loc5_.LoadState(_loc8_,param2);
               var _loc14_:*;
               _loc7_[_loc14_ = _loc4_++] = _loc5_;
            }
            else if((_loc6_ = getDefinitionByName(_loc8_.@type) as Class) != null)
            {
               (_loc5_ = new _loc6_()).id = _loc11_;
               _loc5_.LoadState(_loc8_,param2);
               _loc7_[_loc14_ = _loc4_++] = _loc5_;
               ExposedObjectManager.instance.RegisterReferenceableObject(_loc5_);
            }
            else
            {
               Warning.Show("Object \'" + _loc8_.@id + "\' of unknown type \'" + _loc8_.@type + " found while loading the contents state of collection with id \'" + id + "\'.",ExposedCollection);
            }
         }
         if(_loc4_ != _loc3_)
         {
            Warning.Show("While loading the contents state of collection with id \'" + id + "\', we were only able to process \'" + _loc4_ + "\' nodes, but the number of nodes saved was \'" + _loc3_ + "\'.",ExposedCollection);
            _loc7_.length = _loc4_;
         }
         var _loc9_:uint = this.m_Contents.length;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_)
         {
            this.m_Contents[_loc10_].Destroy();
            _loc10_++;
         }
         this.m_Contents.length = 0;
         this.m_Contents = _loc7_;
      }
      
      private function SaveContentsState(param1:String) : XML
      {
         var _loc5_:XML = null;
         var _loc2_:XML = <contents/>;
         var _loc3_:uint = this.m_Contents.length;
         _loc2_.@length = _loc3_;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            (_loc5_ = this.m_Contents[_loc4_].SaveState(param1)).setName("object");
            _loc2_.appendChild(_loc5_);
            _loc4_++;
         }
         return _loc2_;
      }
   }
}
