package utils.exposed
{
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import utils.debug.Warning;
   
   public class ExposedStructure
   {
      
      private static const REFERENCE_TYPE_TEMPLATE_NAME:String = "utils.exposed::ExposedReference.<";
      
      private static const VECTOR_TYPE_TEMPLATE_NAME:String = "__AS3__.vec::Vector.<";
       
      
      private var m_Definition:ExposedDefinition;
      
      public function ExposedStructure()
      {
         super();
         this.m_Definition = ExposedDefinitionManager.instance.FindOrCacheExposedDefinition(this);
      }
      
      protected function _Init() : void
      {
      }
      
      protected function _Destroy() : void
      {
      }
      
      internal function Init() : void
      {
         var _loc2_:String = null;
         var _loc3_:ExposedAccessor = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc1_:Dictionary = this.m_Definition.GetAccessorsExposedFor(ExposedDefinition.EXPOSED_FOR_EDITOR);
         for(_loc2_ in _loc1_)
         {
            if(this[_loc2_] != null)
            {
               if(this[_loc2_] is ExposedStructure)
               {
                  this[_loc2_].Init();
               }
               else
               {
                  _loc3_ = _loc1_[_loc2_];
                  if((_loc4_ = _loc3_.qualifiedClassName).indexOf(VECTOR_TYPE_TEMPLATE_NAME) != -1)
                  {
                     _loc5_ = uint(this[_loc2_].length);
                     _loc6_ = 0;
                     while(_loc6_ < _loc5_)
                     {
                        if(this[_loc2_][_loc6_] != null && this[_loc2_][_loc6_] is ExposedStructure)
                        {
                           this[_loc2_][_loc6_].Init();
                        }
                        _loc6_++;
                     }
                  }
               }
            }
         }
         this._Init();
      }
      
      public function Destroy() : void
      {
         var _loc2_:String = null;
         var _loc3_:ExposedAccessor = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.m_Definition == null)
         {
            return;
         }
         this._Destroy();
         var _loc1_:Dictionary = this.m_Definition.GetAccessorsExposedFor(ExposedDefinition.EXPOSED_FOR_EDITOR);
         for(_loc2_ in _loc1_)
         {
            if(this[_loc2_] != null)
            {
               if(this[_loc2_] is ExposedStructure)
               {
                  this.DestroyExposedStructureProperty(this[_loc2_]);
                  this[_loc2_] = null;
               }
               else
               {
                  _loc3_ = _loc1_[_loc2_];
                  if((_loc4_ = _loc3_.qualifiedClassName).indexOf(VECTOR_TYPE_TEMPLATE_NAME) != -1)
                  {
                     _loc5_ = uint(this[_loc2_].length);
                     _loc6_ = 0;
                     while(_loc6_ < _loc5_)
                     {
                        if(this[_loc2_][_loc6_] != null && this[_loc2_][_loc6_] is ExposedStructure)
                        {
                           this.DestroyExposedStructureProperty(this[_loc2_][_loc6_]);
                        }
                        _loc6_++;
                     }
                     this[_loc2_].length = 0;
                     this[_loc2_] = null;
                  }
               }
            }
         }
         this.m_Definition = null;
      }
      
      private function DestroyExposedStructureProperty(param1:ExposedStructure) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 is ExposedObject && ExposedObjectManager.instance.FindReferenceableObject((param1 as ExposedObject).id) != null)
         {
            return;
         }
         param1.Destroy();
      }
      
      public function SaveInitialStateToXML() : XML
      {
         return this.SaveState(ExposedDefinition.EXPOSED_FOR_EDITOR);
      }
      
      public function SavePersistedStateToXML() : XML
      {
         return this.SaveState(ExposedDefinition.EXPOSED_FOR_SAVE);
      }
      
      internal function LoadState(param1:XML, param2:String) : void
      {
         var propertyNode:XML = null;
         var propertyName:String = null;
         var propertyType:String = null;
         var exposedAccessor:ExposedAccessor = null;
         var propertyClass:Class = null;
         var isVector:Boolean = false;
         var propertyX:Number = NaN;
         var propertyY:Number = NaN;
         var propertyValue:String = null;
         var structureProperty:ExposedStructure = null;
         var savedLength:uint = 0;
         var elementNode:XML = null;
         var elementClass:Class = null;
         var elementType:String = null;
         var vectorLength:uint = 0;
         var i:uint = 0;
         var elementX:Number = NaN;
         var elementY:Number = NaN;
         var elementIndex:uint = 0;
         var structureElement:ExposedStructure = null;
         var a_State:XML = param1;
         var a_ExposedFor:String = param2;
         if(a_State.@type != this.m_Definition.qualifiedClassName)
         {
            Warning.Show("Loading structure of type \'" + this.m_Definition.qualifiedClassName + "\' with state of type \'" + a_State.@type + "\'.",ExposedStructure);
         }
         for each(propertyNode in a_State.property)
         {
            propertyName = propertyNode.@name;
            propertyType = propertyNode.@type;
            exposedAccessor = this.m_Definition.FindExposedAccessor(propertyName,a_ExposedFor);
            if(exposedAccessor == null)
            {
               Warning.Show("Loading property \'" + propertyName + "\' of type \'" + propertyType + "\' but it\'s accessor has not been exposed for " + a_ExposedFor,ExposedStructure);
            }
            else
            {
               propertyClass = exposedAccessor.classType;
               if(ExposedDefinitionManager.instance.IsPrimitiveType(propertyType) == true)
               {
                  switch(propertyClass)
                  {
                     case uint:
                        this[propertyName] = Math.max(Number(propertyNode),0);
                        break;
                     case Boolean:
                        this[propertyName] = propertyNode == "true";
                        break;
                     default:
                        this[propertyName] = propertyNode;
                  }
               }
               else if(propertyClass == Point)
               {
                  propertyX = propertyNode.property.(@name == "x");
                  propertyY = propertyNode.property.(@name == "y");
                  if(this[propertyName] == null)
                  {
                     this[propertyName] = new Point(propertyX,propertyY);
                  }
                  else
                  {
                     this[propertyName].x = propertyX;
                     this[propertyName].y = propertyY;
                  }
               }
               else if(propertyType.indexOf(REFERENCE_TYPE_TEMPLATE_NAME) != -1)
               {
                  ExposedObjectManager.instance.AddReferenceToResolve(new ExposedReference(this,exposedAccessor,propertyNode));
               }
               else
               {
                  isVector = propertyType.indexOf(VECTOR_TYPE_TEMPLATE_NAME) != -1;
                  if(!isVector && ExposedDefinitionManager.instance.DoesInheritFrom(propertyClass,ExposedStructure))
                  {
                     propertyValue = propertyNode;
                     if(propertyValue == null || propertyValue == "")
                     {
                        this[propertyName] = null;
                     }
                     else
                     {
                        if(this[propertyName] == null)
                        {
                           this[propertyName] = new propertyClass();
                        }
                        structureProperty = this[propertyName] as ExposedStructure;
                        if(structureProperty is propertyClass || ExposedDefinitionManager.instance.DoesInheritFrom(propertyClass,structureProperty.m_Definition.classType))
                        {
                           structureProperty.LoadState(propertyNode,a_ExposedFor);
                        }
                        else
                        {
                           Warning.Show("Loading structure property \'" + propertyName + "\' of type \'" + propertyType + "\' but it\'s existing structure is of unrelated type \'" + structureProperty.m_Definition.qualifiedClassName + "\'.",ExposedStructure);
                        }
                     }
                  }
                  else if(isVector)
                  {
                     savedLength = uint(propertyNode.@length);
                     if(savedLength != 0)
                     {
                        if(this[propertyName] == null || this[propertyName].length == 0)
                        {
                           this[propertyName] = new propertyClass(savedLength);
                        }
                        else if(this[propertyName].length != savedLength)
                        {
                           Warning.Show("Loading vector of properties \'" + propertyName + "\' of type \'" + propertyType + "\' with current length \'" + this[propertyName].length + "\' that was saved with length \'" + savedLength + "\'.",ExposedStructure);
                           vectorLength = uint(this[propertyName].length);
                           i = 0;
                           while(i < vectorLength)
                           {
                              if(this[propertyName][i] != null && this[propertyName][i] is ExposedStructure)
                              {
                                 this.DestroyExposedStructureProperty(this[propertyName][i]);
                              }
                              i++;
                           }
                           this[propertyName].length = 0;
                           this[propertyName] = new propertyClass(savedLength);
                        }
                        elementNode = null;
                        elementClass = null;
                        elementType = propertyType.replace(VECTOR_TYPE_TEMPLATE_NAME,"").replace(">","");
                        if(ExposedDefinitionManager.instance.IsPrimitiveType(elementType) == true)
                        {
                           if(propertyType != exposedAccessor.qualifiedClassName)
                           {
                              Warning.Show("Loading vector of primitive properties \'" + propertyName + "\' of type \'" + propertyType + "\' but it\'s accessor is of type \'" + exposedAccessor.qualifiedClassName + "\'.",ExposedStructure);
                           }
                           else
                           {
                              elementClass = getDefinitionByName(elementType) as Class;
                              switch(elementClass)
                              {
                                 case uint:
                                    for each(elementNode in propertyNode.element)
                                    {
                                       this[propertyName][elementNode.@index] = Math.max(Number(elementNode),0);
                                    }
                                    break;
                                 case Boolean:
                                    for each(elementNode in propertyNode.element)
                                    {
                                       this[propertyName][elementNode.@index] = elementNode == "true";
                                    }
                                    break;
                                 default:
                                    for each(elementNode in propertyNode.element)
                                    {
                                       this[propertyName][elementNode.@index] = elementNode;
                                    }
                              }
                           }
                        }
                        else if(elementType.indexOf(REFERENCE_TYPE_TEMPLATE_NAME) != -1)
                        {
                           for each(elementNode in propertyNode.element)
                           {
                              ExposedObjectManager.instance.AddReferenceToResolve(new ExposedReference(this,exposedAccessor,elementNode,elementNode.@index));
                           }
                        }
                        else
                        {
                           elementClass = getDefinitionByName(elementType) as Class;
                           if(elementClass == Point)
                           {
                              for each(elementNode in propertyNode.element)
                              {
                                 elementX = elementNode.property.(@name == "x");
                                 elementY = elementNode.property.(@name == "y");
                                 if(this[propertyName][elementNode.@index] == null)
                                 {
                                    this[propertyName][elementNode.@index] = new Point(elementX,elementY);
                                 }
                                 else
                                 {
                                    this[propertyName][elementNode.@index].x = elementX;
                                    this[propertyName][elementNode.@index].y = elementY;
                                 }
                              }
                           }
                           else if(elementClass == null)
                           {
                              Warning.Show("Loading vector of properties \'" + propertyName + "\' of type \'" + propertyType + "\' that cannot be found.",ExposedStructure);
                           }
                           else if(!ExposedDefinitionManager.instance.DoesInheritFrom(elementClass,ExposedStructure))
                           {
                              Warning.Show("Loading vector of properties \'" + propertyName + "\' of type \'" + propertyType + "\' that is not currently supported.",ExposedStructure);
                           }
                           else
                           {
                              for each(elementNode in propertyNode.element)
                              {
                                 elementIndex = uint(elementNode.@index);
                                 if(this[propertyName][elementIndex] == null)
                                 {
                                    this[propertyName][elementIndex] = new elementClass();
                                 }
                                 structureElement = this[propertyName][elementIndex] as ExposedStructure;
                                 if(structureElement is elementClass || ExposedDefinitionManager.instance.DoesInheritFrom(elementClass,structureElement.m_Definition.classType))
                                 {
                                    structureElement.LoadState(elementNode,a_ExposedFor);
                                 }
                                 else
                                 {
                                    Warning.Show("Loading structure property in vector \'" + propertyName + "\' of type \'" + propertyType + "\' at index \'" + elementIndex + "\' but the existing structure at that index is of unrelated type \'" + structureElement.m_Definition.qualifiedClassName + "\'.",ExposedStructure);
                                 }
                              }
                           }
                        }
                     }
                  }
                  else
                  {
                     Warning.Show("Loading property \'" + propertyName + "\' of type \'" + propertyType + "\' that is not currently supported.",ExposedStructure);
                  }
               }
            }
         }
      }
      
      internal function SaveState(param1:String) : XML
      {
         var _loc4_:ExposedAccessor = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         var _loc8_:ExposedObject = null;
         var _loc9_:ExposedObject = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:XML = null;
         var _loc13_:String = null;
         var _loc14_:* = null;
         var _loc15_:ExposedObject = null;
         var _loc16_:ExposedObject = null;
         var _loc2_:XML = <structure/>;
         _loc2_.@type = this.m_Definition.qualifiedClassName;
         var _loc3_:Dictionary = this.m_Definition.GetAccessorsExposedFor(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = String(_loc4_.name);
            _loc6_ = _loc4_.qualifiedClassName;
            (_loc7_ = <property/>).@name = _loc5_;
            _loc7_.@type = _loc6_;
            if(this[_loc5_] == null)
            {
               _loc2_.appendChild(_loc7_);
               if(ExposedDefinitionManager.instance.DoesInheritFrom(_loc4_.classType,ExposedObject))
               {
                  _loc7_.@type = REFERENCE_TYPE_TEMPLATE_NAME + _loc6_ + ">";
               }
            }
            else if(ExposedDefinitionManager.instance.IsPrimitiveType(_loc6_) == true)
            {
               _loc7_.setChildren(this[_loc5_]);
               _loc2_.appendChild(_loc7_);
            }
            else if(this[_loc5_] is Point)
            {
               _loc7_.appendChild(new XML("<property name=\'x\' type=\'Number\'>" + (!!this[_loc5_] ? this[_loc5_].x : 0) + "</property>"));
               _loc7_.appendChild(new XML("<property name=\'y\' type=\'Number\'>" + (!!this[_loc5_] ? this[_loc5_].y : 0) + "</property>"));
               _loc2_.appendChild(_loc7_);
            }
            else
            {
               if(this[_loc5_] is ExposedObject)
               {
                  _loc8_ = this[_loc5_] as ExposedObject;
                  if((_loc9_ = ExposedObjectManager.instance.FindReferenceableObject(_loc8_.id)) != null)
                  {
                     if(_loc8_ != _loc9_)
                     {
                        Warning.Show("Saving reference property \'" + _loc5_ + "\' of type \'" + _loc6_ + "\' but the referenceable object found does not match.",ExposedStructure);
                     }
                     else
                     {
                        _loc7_.@type = REFERENCE_TYPE_TEMPLATE_NAME + _loc6_ + ">";
                        _loc7_.appendChild(_loc8_.id);
                        _loc2_.appendChild(_loc7_);
                     }
                     continue;
                  }
               }
               if(this[_loc5_] is ExposedStructure)
               {
                  (_loc7_ = this[_loc5_].SaveState(param1)).setName("property");
                  _loc7_.@name = _loc5_;
                  _loc2_.appendChild(_loc7_);
               }
               else if(_loc6_.indexOf(VECTOR_TYPE_TEMPLATE_NAME) != -1)
               {
                  _loc10_ = uint(this[_loc5_].length);
                  _loc7_.@length = _loc10_;
                  if(_loc10_ == 0)
                  {
                     _loc2_.appendChild(_loc7_);
                  }
                  else
                  {
                     _loc11_ = 0;
                     _loc12_ = null;
                     _loc13_ = _loc6_.replace(VECTOR_TYPE_TEMPLATE_NAME,"").replace(">","");
                     if(ExposedDefinitionManager.instance.IsPrimitiveType(_loc13_) == true)
                     {
                        _loc11_ = 0;
                        while(_loc11_ < _loc10_)
                        {
                           (_loc12_ = <element/>).@type = _loc13_;
                           _loc12_.@index = _loc11_;
                           _loc12_.setChildren(this[_loc5_][_loc11_]);
                           _loc7_.appendChild(_loc12_);
                           _loc11_++;
                        }
                        _loc2_.appendChild(_loc7_);
                     }
                     else
                     {
                        if(this[_loc5_][0] is Point)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc10_)
                           {
                              (_loc12_ = <element/>).@type = _loc13_;
                              _loc12_.@index = _loc11_;
                              _loc12_.appendChild(new XML("<property name=\'x\' type=\'Number\'>" + (!!this[_loc5_][_loc11_] ? this[_loc5_][_loc11_].x : 0) + "</property>"));
                              _loc12_.appendChild(new XML("<property name=\'y\' type=\'Number\'>" + (!!this[_loc5_][_loc11_] ? this[_loc5_][_loc11_].y : 0) + "</property>"));
                              _loc7_.appendChild(_loc12_);
                              _loc11_++;
                           }
                           _loc2_.appendChild(_loc7_);
                        }
                        if(this[_loc5_][0] is ExposedObject)
                        {
                           _loc14_ = REFERENCE_TYPE_TEMPLATE_NAME + _loc13_ + ">";
                           _loc11_ = 0;
                           while(_loc11_ < _loc10_)
                           {
                              if(this[_loc5_][_loc11_] == null)
                              {
                                 Warning.Show("Saving reference property in vector \'" + _loc5_ + "\' of type \'" + _loc6_ + "\' at index \'" + _loc11_ + "\' but the element is null.",ExposedStructure);
                              }
                              else
                              {
                                 _loc15_ = this[_loc5_][_loc11_] as ExposedObject;
                                 _loc16_ = ExposedObjectManager.instance.FindReferenceableObject(_loc15_.id);
                                 if(_loc15_ != _loc16_)
                                 {
                                    Warning.Show("Saving reference property in vector \'" + _loc5_ + "\' of type \'" + _loc6_ + "\' at index \'" + _loc11_ + "\' but the referenceable object found does not match.",ExposedStructure);
                                 }
                                 else
                                 {
                                    (_loc12_ = <element/>).@type = _loc14_;
                                    _loc12_.@index = _loc11_;
                                    _loc12_.appendChild(_loc15_.id);
                                    _loc7_.appendChild(_loc12_);
                                 }
                              }
                              _loc11_++;
                           }
                           _loc2_.appendChild(_loc7_);
                        }
                        else if(this[_loc5_][0] is ExposedStructure)
                        {
                           _loc11_ = 0;
                           while(_loc11_ < _loc10_)
                           {
                              if(this[_loc5_][_loc11_] == null)
                              {
                                 Warning.Show("Saving strcture property in vector \'" + _loc5_ + "\' of type \'" + _loc6_ + "\' at index \'" + _loc11_ + "\' but the element is null.",ExposedStructure);
                              }
                              else
                              {
                                 (_loc12_ = this[_loc5_][_loc11_].SaveState(param1)).setName("element");
                                 _loc12_.@index = _loc11_;
                                 _loc7_.appendChild(_loc12_);
                              }
                              _loc11_++;
                           }
                           _loc2_.appendChild(_loc7_);
                        }
                        else
                        {
                           Warning.Show("Saving vector property \'" + _loc5_ + "\' of type \'" + _loc6_ + "\' with elements of unknown type \'" + _loc13_,ExposedStructure);
                        }
                     }
                  }
               }
               else
               {
                  Warning.Show("Saving property \'" + _loc5_ + "\' of unknown type \'" + _loc6_,ExposedStructure);
               }
            }
         }
         return _loc2_;
      }
   }
}
