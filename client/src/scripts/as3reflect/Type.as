package as3reflect
{
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   public class Type extends MetaDataContainer
   {
      
      public static const UNTYPED:Type = new Type();
      
      public static const PRIVATE:Type = new Type();
      
      public static const VOID:Type = new Type();
      
      private static var _cache:Object = {};
       
      
      private var _class:Class;
      
      private var _accessors:Array;
      
      private var _isStatic:Boolean;
      
      private var _fullName:String;
      
      private var _isFinal:Boolean;
      
      private var _isDynamic:Boolean;
      
      private var _staticConstants:Array;
      
      private var _constants:Array;
      
      private var _fields:Array;
      
      private var _name:String;
      
      private var _methods:Array;
      
      private var _variables:Array;
      
      private var _staticVariables:Array;
      
      public function Type()
      {
         super();
         _methods = new Array();
         _accessors = new Array();
         _staticConstants = new Array();
         _constants = new Array();
         _staticVariables = new Array();
         _variables = new Array();
         _fields = new Array();
      }
      
      public static function forName(param1:String) : Type
      {
         var result:Type = null;
         var name:String = param1;
         switch(name)
         {
            case "void":
               result = Type.VOID;
               break;
            case "*":
               result = Type.UNTYPED;
               break;
            default:
               try
               {
                  result = Type.forClass(Class(getDefinitionByName(name)));
               }
               catch(e:ReferenceError)
               {
                  trace("Type.forName error: " + e.message + " The class \'" + name + "\' is probably an internal class or it may not have been compiled.");
               }
         }
         return result;
      }
      
      public static function forInstance(param1:*) : Type
      {
         var _loc2_:Type = null;
         var _loc3_:Class = ClassUtils.forInstance(param1);
         if(_loc3_ != null)
         {
            _loc2_ = Type.forClass(_loc3_);
         }
         return _loc2_;
      }
      
      public static function forClass(param1:Class) : Type
      {
         var _loc2_:Type = null;
         var _loc4_:XML = null;
         var _loc3_:String = ClassUtils.getFullyQualifiedName(param1);
         if(_cache[_loc3_])
         {
            _loc2_ = _cache[_loc3_];
         }
         else
         {
            _loc4_ = describeType(param1);
            _loc2_ = new Type();
            _cache[_loc3_] = _loc2_;
            _loc2_.fullName = _loc3_;
            _loc2_.name = ClassUtils.getNameFromFullyQualifiedName(_loc3_);
            _loc2_.clazz = param1;
            _loc2_.isDynamic = _loc4_.@isDynamic;
            _loc2_.isFinal = _loc4_.@isFinal;
            _loc2_.isStatic = _loc4_.@isStatic;
            _loc2_.accessors = TypeXmlParser.parseAccessors(_loc2_,_loc4_);
            _loc2_.methods = TypeXmlParser.parseMethods(_loc2_,_loc4_);
            _loc2_.staticConstants = TypeXmlParser.parseMembers(Constant,_loc4_.constant,_loc2_,true);
            _loc2_.constants = TypeXmlParser.parseMembers(Constant,_loc4_.factory.constant,_loc2_,false);
            _loc2_.staticVariables = TypeXmlParser.parseMembers(Variable,_loc4_.variable,_loc2_,true);
            _loc2_.variables = TypeXmlParser.parseMembers(Variable,_loc4_.factory.variable,_loc2_,false);
            TypeXmlParser.parseMetaData(_loc4_.factory[0].metadata,_loc2_);
         }
         return _loc2_;
      }
      
      public function get staticConstants() : Array
      {
         return _staticConstants;
      }
      
      public function set staticConstants(param1:Array) : void
      {
         _staticConstants = param1;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get accessors() : Array
      {
         return _accessors;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function set accessors(param1:Array) : void
      {
         _accessors = param1;
      }
      
      public function set constants(param1:Array) : void
      {
         _constants = param1;
      }
      
      public function get staticVariables() : Array
      {
         return _staticVariables;
      }
      
      public function get methods() : Array
      {
         return _methods;
      }
      
      public function get isDynamic() : Boolean
      {
         return _isDynamic;
      }
      
      public function set clazz(param1:Class) : void
      {
         _class = param1;
      }
      
      public function get isStatic() : Boolean
      {
         return _isStatic;
      }
      
      public function get fullName() : String
      {
         return _fullName;
      }
      
      public function get fields() : Array
      {
         return accessors.concat(staticConstants).concat(constants).concat(staticVariables).concat(variables);
      }
      
      public function getField(param1:String) : Field
      {
         var _loc2_:Field = null;
         var _loc3_:Field = null;
         for each(_loc3_ in fields)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get constants() : Array
      {
         return _constants;
      }
      
      public function set staticVariables(param1:Array) : void
      {
         _staticVariables = param1;
      }
      
      public function getMethod(param1:String) : Method
      {
         var _loc2_:Method = null;
         var _loc3_:Method = null;
         for each(_loc3_ in methods)
         {
            if(_loc3_.name == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function get clazz() : Class
      {
         return _class;
      }
      
      public function set methods(param1:Array) : void
      {
         _methods = param1;
      }
      
      public function set isFinal(param1:Boolean) : void
      {
         _isFinal = param1;
      }
      
      public function set isDynamic(param1:Boolean) : void
      {
         _isDynamic = param1;
      }
      
      public function set variables(param1:Array) : void
      {
         _variables = param1;
      }
      
      public function set isStatic(param1:Boolean) : void
      {
         _isStatic = param1;
      }
      
      public function set fullName(param1:String) : void
      {
         _fullName = param1;
      }
      
      public function get isFinal() : Boolean
      {
         return _isFinal;
      }
      
      public function get variables() : Array
      {
         return _variables;
      }
   }
}

import as3reflect.Accessor;
import as3reflect.AccessorAccess;
import as3reflect.IMember;
import as3reflect.IMetaDataContainer;
import as3reflect.MetaData;
import as3reflect.MetaDataArgument;
import as3reflect.Method;
import as3reflect.Parameter;
import as3reflect.Type;

class TypeXmlParser
{
    
   
   public function TypeXmlParser()
   {
      super();
   }
   
   public static function parseMetaData(param1:XMLList, param2:IMetaDataContainer) : void
   {
      var _loc3_:XML = null;
      var _loc4_:Array = null;
      var _loc5_:XML = null;
      for each(_loc3_ in param1)
      {
         _loc4_ = [];
         for each(_loc5_ in _loc3_.arg)
         {
            _loc4_.push(new MetaDataArgument(_loc5_.@key,_loc5_.@value));
         }
         param2.addMetaData(new MetaData(_loc3_.@name,_loc4_));
      }
   }
   
   public static function parseMembers(param1:Class, param2:XMLList, param3:Type, param4:Boolean) : Array
   {
      var _loc6_:XML = null;
      var _loc7_:IMember = null;
      var _loc5_:Array = [];
      for each(_loc6_ in param2)
      {
         _loc7_ = new param1(_loc6_.@name,Type.forName(_loc6_.@type),param3,param4);
         parseMetaData(_loc6_.metadata,_loc7_);
         _loc5_.push(_loc7_);
      }
      return _loc5_;
   }
   
   private static function parseAccessorsByModifier(param1:Type, param2:XMLList, param3:Boolean) : Array
   {
      var _loc5_:XML = null;
      var _loc6_:Accessor = null;
      var _loc4_:Array = [];
      for each(_loc5_ in param2)
      {
         _loc6_ = new Accessor(_loc5_.@name,AccessorAccess.fromString(_loc5_.@access),Type.forName(_loc5_.@type),param1,param3);
         parseMetaData(_loc5_.metadata,_loc6_);
         _loc4_.push(_loc6_);
      }
      return _loc4_;
   }
   
   public static function parseAccessors(param1:Type, param2:XML) : Array
   {
      var _loc3_:Array = parseAccessorsByModifier(param1,param2.accessor,true);
      var _loc4_:Array = parseAccessorsByModifier(param1,param2.factory.accessor,false);
      return _loc3_.concat(_loc4_);
   }
   
   private static function parseMethodsByModifier(param1:Type, param2:XMLList, param3:Boolean) : Array
   {
      var _loc5_:XML = null;
      var _loc6_:Array = null;
      var _loc7_:XML = null;
      var _loc8_:Method = null;
      var _loc9_:Type = null;
      var _loc10_:Parameter = null;
      var _loc4_:Array = [];
      for each(_loc5_ in param2)
      {
         _loc6_ = [];
         for each(_loc7_ in _loc5_.parameter)
         {
            _loc9_ = Type.forName(_loc7_.@type);
            _loc10_ = new Parameter(_loc7_.@index,_loc9_,_loc7_.@optional);
            _loc6_.push(_loc10_);
         }
         _loc8_ = new Method(param1,_loc5_.@name,param3,_loc6_,Type.forName(_loc5_.@returnType));
         parseMetaData(_loc5_.metadata,_loc8_);
         _loc4_.push(_loc8_);
      }
      return _loc4_;
   }
   
   public static function parseMethods(param1:Type, param2:XML) : Array
   {
      var _loc3_:Array = parseMethodsByModifier(param1,param2.method,true);
      var _loc4_:Array = parseMethodsByModifier(param1,param2.factory.method,false);
      return _loc3_.concat(_loc4_);
   }
}
