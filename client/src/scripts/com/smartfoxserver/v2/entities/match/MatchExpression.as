package com.smartfoxserver.v2.entities.match
{
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   
   public class MatchExpression
   {
       
      
      private var _varName:String;
      
      private var _condition:IMatcher;
      
      private var _value:*;
      
      internal var _logicOp:LogicOperator;
      
      internal var _parent:MatchExpression;
      
      internal var _next:MatchExpression;
      
      public function MatchExpression(param1:String, param2:IMatcher, param3:*)
      {
         super();
         this._varName = param1;
         this._condition = param2;
         this._value = param3;
      }
      
      internal static function chainedMatchExpression(param1:String, param2:IMatcher, param3:*, param4:LogicOperator, param5:MatchExpression) : MatchExpression
      {
         var _loc6_:MatchExpression;
         (_loc6_ = new MatchExpression(param1,param2,param3))._logicOp = param4;
         _loc6_._parent = param5;
         return _loc6_;
      }
      
      public function and(param1:String, param2:IMatcher, param3:*) : MatchExpression
      {
         this._next = chainedMatchExpression(param1,param2,param3,LogicOperator.AND,this);
         return this._next;
      }
      
      public function or(param1:String, param2:IMatcher, param3:*) : MatchExpression
      {
         this._next = chainedMatchExpression(param1,param2,param3,LogicOperator.OR,this);
         return this._next;
      }
      
      public function get varName() : String
      {
         return this._varName;
      }
      
      public function get condition() : IMatcher
      {
         return this._condition;
      }
      
      public function get value() : *
      {
         return this._value;
      }
      
      public function get logicOp() : LogicOperator
      {
         return this._logicOp;
      }
      
      public function hasNext() : Boolean
      {
         return this._next != null;
      }
      
      public function get next() : MatchExpression
      {
         return this._next;
      }
      
      public function rewind() : MatchExpression
      {
         var _loc1_:MatchExpression = this;
         while(_loc1_._parent != null)
         {
            _loc1_ = _loc1_._parent;
         }
         return _loc1_;
      }
      
      public function asString() : String
      {
         var _loc1_:* = "";
         if(this._logicOp != null)
         {
            _loc1_ += " " + this.logicOp.id + " ";
         }
         _loc1_ += "(";
         _loc1_ += this._varName + " " + this._condition.symbol + " " + (this.value is String ? "\'" + this.value + "\'" : this.value);
         return _loc1_ + ")";
      }
      
      public function toString() : String
      {
         var _loc1_:MatchExpression = this.rewind();
         var _loc2_:String = _loc1_.asString();
         while(_loc1_.hasNext())
         {
            _loc1_ = _loc1_.next;
            _loc2_ += _loc1_.asString();
         }
         return _loc2_;
      }
      
      public function toSFSArray() : ISFSArray
      {
         var _loc1_:MatchExpression = this.rewind();
         var _loc2_:ISFSArray = new SFSArray();
         _loc2_.addSFSArray(_loc1_.expressionAsSFSArray());
         while(_loc1_.hasNext())
         {
            _loc1_ = _loc1_.next;
            _loc2_.addSFSArray(_loc1_.expressionAsSFSArray());
         }
         return _loc2_;
      }
      
      private function expressionAsSFSArray() : ISFSArray
      {
         var _loc1_:ISFSArray = new SFSArray();
         if(this._logicOp != null)
         {
            _loc1_.addUtfString(this._logicOp.id);
         }
         else
         {
            _loc1_.addNull();
         }
         _loc1_.addUtfString(this._varName);
         _loc1_.addByte(this._condition.type);
         _loc1_.addUtfString(this._condition.symbol);
         if(this._condition.type == 0)
         {
            _loc1_.addBool(this._value);
         }
         else if(this._condition.type == 1)
         {
            _loc1_.addDouble(this._value);
         }
         else
         {
            _loc1_.addUtfString(this._value);
         }
         return _loc1_;
      }
   }
}
