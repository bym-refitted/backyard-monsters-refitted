package de.polygonal.core.fmt
{
   public class NumberFormat
   {
      
      public static var _hexLUT:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
       
      
      public function NumberFormat()
      {
      }
      
      public static function toBin(param1:int, param2:String = undefined, param3:Boolean = false) : String
      {
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc8_:int = 0;
         if(param2 == null)
         {
            param2 = "";
         }
         var _loc4_:* = 32 - ((_loc5_ = param1) < 0 ? 0 : (_loc5_ |= _loc5_ >> 1, _loc5_ |= _loc5_ >> 2, _loc5_ |= _loc5_ >> 4, _loc5_ |= _loc5_ >> 8, _loc5_ |= _loc5_ >> 16, _loc6_ = _loc5_, _loc6_ = ((_loc6_ = ((_loc6_ -= _loc6_ >> 1 & 1431655765) >> 2 & 858993459) + (_loc6_ & 858993459)) >> 4) + _loc6_ & 252645135, _loc6_ += _loc6_ >> 8, 32 - ((_loc6_ += _loc6_ >> 16) & 63)));
         var _loc7_:String = (param1 & 1) > 0 ? "1" : "0";
         param1 >>= 1;
         _loc5_ = 1;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc5_++;
            _loc7_ = ((param1 & 1) > 0 ? "1" : "0") + ((_loc6_ & 7) == 0 ? param2 : "") + _loc7_;
            param1 >>= 1;
         }
         if(param3)
         {
            _loc5_ = 0;
            _loc6_ = 32 - _loc4_;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = _loc5_++;
               _loc7_ = "0" + _loc7_;
            }
         }
         return _loc7_;
      }
      
      public static function toHex(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = NumberFormat._hexLUT;
         while(param1 != 0)
         {
            _loc2_ = String(_loc3_[param1 & 15]) + _loc2_;
            param1 >>>= 4;
         }
         return _loc2_;
      }
      
      public static function toOct(param1:int) : String
      {
         var _loc4_:* = 0;
         var _loc2_:String = "";
         var _loc3_:* = param1;
         while(_loc3_ > 0)
         {
            _loc2_ = (_loc4_ = _loc3_ & 7) + _loc2_;
            _loc3_ >>= 3;
         }
         return _loc2_;
      }
      
      public static function toRadix(param1:int, param2:int) : String
      {
         var _loc5_:int = 0;
         var _loc3_:String = "";
         var _loc4_:int = param1;
         while(_loc4_ > 0)
         {
            _loc3_ = (_loc5_ = _loc4_ % param2) + _loc3_;
            _loc4_ /= param2;
         }
         return _loc3_;
      }
      
      public static function toFixed(param1:Number, param2:int) : String
      {
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as String;
         if(Math.isNaN(param1))
         {
            return "NaN";
         }
         _loc4_ = 10;
         _loc5_ = param2;
         _loc6_ = 1;
         _loc7_ = 0;
         while(true)
         {
            if((_loc5_ & 1) != 0)
            {
               _loc6_ = _loc4_ * _loc6_;
            }
            if((_loc5_ >>= 1) == 0)
            {
               break;
            }
            _loc4_ *= _loc4_;
         }
         _loc7_ = _loc6_;
         _loc3_ = _loc7_;
         if((_loc4_ = (_loc8_ = Std.string(int(param1 * _loc3_) / _loc3_)).indexOf(".")) != -1)
         {
            _loc5_ = _loc8_.substr(_loc4_ + 1).length;
            while(_loc5_ < param2)
            {
               _loc6_ = _loc5_++;
               _loc8_ += "0";
            }
         }
         else
         {
            _loc8_ += ".";
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc6_ = _loc5_++;
               _loc8_ += "0";
            }
         }
         return _loc8_;
      }
      
      public static function toMMSS(param1:int) : String
      {
         var _loc2_:int = param1 % 1000;
         var _loc3_:Number = (param1 - _loc2_) / 1000;
         var _loc4_:Number = _loc3_ % 60;
         return ("0" + (_loc3_ - _loc4_) / 60).substr(-2) + ":" + ("0" + _loc4_).substr(-2);
      }
      
      public static function groupDigits(param1:int, param2:String = undefined) : String
      {
         var _loc6_:* = null as String;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         if(param2 == null)
         {
            param2 = ".";
         }
         var _loc3_:Number = param1;
         var _loc4_:int = 0;
         while(_loc3_ > 1)
         {
            _loc3_ /= 10;
            _loc4_++;
         }
         _loc4_ /= 3;
         var _loc5_:String = Std.string(param1);
         if(_loc4_ == 0)
         {
            return _loc5_;
         }
         _loc6_ = "";
         _loc7_ = 0;
         _loc8_ = _loc5_.length - 1;
         while(_loc8_ >= 0)
         {
            if(_loc7_ == 3)
            {
               _loc6_ = _loc5_.charAt(_loc8_--) + param2 + _loc6_;
               _loc7_ = 0;
               _loc4_--;
            }
            else
            {
               _loc6_ = _loc5_.charAt(_loc8_--) + _loc6_;
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      public static function centToEuro(param1:int, param2:String = undefined, param3:String = undefined) : String
      {
         var _loc5_:* = null as String;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         if(param2 == null)
         {
            param2 = ",";
         }
         if(param3 == null)
         {
            param3 = ".";
         }
         var _loc4_:int;
         if((_loc4_ = param1 / 100) == 0)
         {
            if(param1 < 10)
            {
               return "0" + param2 + "0" + param1;
            }
            return "0" + param2 + param1;
         }
         if((_loc6_ = param1 - _loc4_ * 100) < 10)
         {
            _loc5_ = param2 + "0" + _loc6_;
         }
         else
         {
            _loc5_ = param2 + _loc6_;
         }
         if(_loc4_ >= 1000)
         {
            _loc7_ = _loc4_;
            while(_loc7_ >= 1000)
            {
               _loc7_ = _loc4_ / 1000;
               if((_loc8_ = _loc4_ - _loc7_ * 1000) < 10)
               {
                  _loc5_ = param3 + "00" + _loc8_ + _loc5_;
               }
               else if(_loc8_ < 100)
               {
                  _loc5_ = param3 + "0" + _loc8_ + _loc5_;
               }
               else
               {
                  _loc5_ = param3 + _loc8_ + _loc5_;
               }
               _loc4_ = _loc7_;
            }
            return _loc7_ + _loc5_;
         }
         return _loc4_ + _loc5_;
      }
   }
}
