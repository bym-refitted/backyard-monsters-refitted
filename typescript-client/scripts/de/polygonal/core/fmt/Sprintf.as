package de.polygonal.core.fmt
{
   import flash.Boot;
   
   public class Sprintf
   {
      
      public static var BIT_MINUS:int;
      
      public static var BIT_PLUS:int;
      
      public static var BIT_SPACE:int;
      
      public static var BIT_SHARP:int;
      
      public static var BIT_ZERO:int;
      
      public static var BIT_h:int;
      
      public static var BIT_l:int;
      
      public static var BIT_L:int;
      
      public static var BIT_c:int;
      
      public static var BIT_d:int;
      
      public static var BIT_i:int;
      
      public static var BIT_e:int;
      
      public static var BIT_E:int;
      
      public static var BIT_f:int;
      
      public static var BIT_g:int;
      
      public static var BIT_G:int;
      
      public static var BIT_o:int;
      
      public static var BIT_s:int;
      
      public static var BIT_u:int;
      
      public static var BIT_x:int;
      
      public static var BIT_X:int;
      
      public static var BIT_p:int;
      
      public static var BIT_n:int;
      
      public static var BIT_b:int;
      
      public static var MASK_SPECIFIERS:int;
      
      public static var _I:Sprintf;
       
      
      public var _bits:Array;
      
      public function Sprintf()
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Boot.skip_constructor)
         {
            return;
         }
         _bits = [];
         var _loc1_:String = "-+ #0hlLcdieEfgGosuxXpnb";
         var _loc2_:int = 0;
         while(_loc2_ < 255)
         {
            _loc3_ = _loc2_++;
            _bits[_loc3_] = 0;
         }
         _loc2_ = 0;
         _loc3_ = _loc1_.length;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc2_++;
            _bits[int(_loc1_.charCodeAt(_loc4_))] = 1 << _loc4_;
         }
      }
      
      public static function get() : Sprintf
      {
         if(Sprintf._I == null)
         {
            Sprintf._I = new Sprintf();
         }
         return Sprintf._I;
      }
      
      public static function format(param1:String, param2:Array) : String
      {
         if(Sprintf._I == null)
         {
            Sprintf._I = new Sprintf();
         }
         return Sprintf._I._format(param1,param2);
      }
      
      public function cca(param1:String, param2:int) : int
      {
         return int(param1.charCodeAt(param2));
      }
      
      public function _rpad(param1:String, param2:String, param3:int) : String
      {
         var _loc7_:int = 0;
         var _loc4_:String = param2;
         var _loc5_:int = 0;
         var _loc6_:* = param3 - 1;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc4_ += param2;
         }
         return param1 + _loc4_;
      }
      
      public function _padNumber(param1:String, param2:Number, param3:int, param4:int) : String
      {
         var _loc6_:* = null as String;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null as String;
         var _loc5_:int = param1.length;
         if(param4 > 0 && _loc5_ < param4)
         {
            param4 -= _loc5_;
            if((param3 & 1) != 0)
            {
               _loc6_ = " ";
               _loc7_ = 0;
               _loc8_ = param4 - 1;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc7_++;
                  _loc6_ += " ";
               }
               param1 += _loc6_;
            }
            else if(param2 >= 0)
            {
               _loc10_ = _loc6_ = (param3 & 16) != 0 ? "0" : " ";
               _loc7_ = 0;
               _loc8_ = param4 - 1;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc7_++;
                  _loc10_ += _loc6_;
               }
               param1 = _loc10_ + param1;
            }
            else if((param3 & 16) != 0)
            {
               _loc6_ = "0";
               _loc7_ = 0;
               _loc8_ = param4 - 1;
               // Comment: Obfuscated code
               // §§push("-");
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc7_++;
                  _loc6_ += "0";
               }
               // param1 = §§pop() + (_loc6_ + param1.substr(1));
            }
            else
            {
               _loc6_ = " ";
               _loc7_ = 0;
               _loc8_ = param4 - 1;
               while(_loc7_ < _loc8_)
               {
                  _loc9_ = _loc7_++;
                  _loc6_ += " ";
               }
               param1 = _loc6_ + param1;
            }
         }
         return param1;
      }
      
      public function _lpad(param1:String, param2:String, param3:int) : String
      {
         var _loc7_:int = 0;
         var _loc4_:String = param2;
         var _loc5_:int = 0;
         var _loc6_:* = param3 - 1;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc4_ += param2;
         }
         return _loc4_ + param1;
      }
      
      public function _format(param1:String, param2:Array) : String
      {
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:Boolean = false;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:* = null as String;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:* = null as String;
         var _loc18_:* = 0;
         var _loc19_:* = 0;
         var _loc20_:* = null as String;
         var _loc21_:* = 0;
         var _loc22_:* = 0;
         var _loc23_:* = 0;
         var _loc24_:* = null as String;
         var _loc25_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         var _loc6_:int = param1.length;
         while(_loc5_ < _loc6_)
         {
            if((_loc7_ = param1.charCodeAt(_loc5_++)) == 37)
            {
               if((_loc7_ = param1.charCodeAt(_loc5_++)) == 37)
               {
                  _loc4_ += "%";
               }
               else
               {
                  _loc8_ = 0;
                  while((int(_bits[_loc7_]) & 31) != 0)
                  {
                     _loc8_ |= int(_bits[_loc7_]);
                     _loc7_ = param1.charCodeAt(_loc5_++);
                  }
                  if((_loc8_ & 17) == 17)
                  {
                     _loc8_ &= -17;
                  }
                  if((_loc8_ & 6) == 6)
                  {
                     _loc8_ &= -5;
                  }
                  _loc9_ = false;
                  _loc10_ = 0;
                  if(_loc7_ == 42)
                  {
                     _loc9_ = true;
                     _loc7_ = param1.charCodeAt(_loc5_++);
                  }
                  else if(_loc7_ >= 48 && _loc7_ <= 57)
                  {
                     _loc10_ = _loc7_ - 48;
                     _loc7_ = param1.charCodeAt(_loc5_++);
                     if(_loc7_ >= 48 && _loc7_ <= 57)
                     {
                        _loc10_ = _loc7_ - 48 + _loc10_ * 10;
                        _loc7_ = param1.charCodeAt(_loc5_++);
                        if(_loc7_ >= 48 && _loc7_ <= 57)
                        {
                           while(_loc7_ >= 48 && _loc7_ <= 57)
                           {
                              _loc7_ = param1.charCodeAt(_loc5_++);
                           }
                        }
                     }
                  }
                  _loc11_ = -1;
                  if(_loc7_ == 46)
                  {
                     if((_loc7_ = param1.charCodeAt(_loc5_++)) == 42)
                     {
                        _loc11_ = Number(param2[_loc3_++]);
                        _loc7_ = param1.charCodeAt(_loc5_++);
                     }
                     else if(_loc7_ >= 48 && _loc7_ <= 57)
                     {
                        _loc11_ = _loc7_ - 48;
                        _loc7_ = param1.charCodeAt(_loc5_++);
                        if(_loc7_ >= 48 && _loc7_ <= 57)
                        {
                           _loc11_ = _loc7_ - 48 + _loc11_ * 10;
                           _loc7_ = param1.charCodeAt(_loc5_++);
                           if(_loc7_ >= 48 && _loc7_ <= 57)
                           {
                              while(_loc7_ >= 48 && _loc7_ <= 57)
                              {
                                 _loc7_ = param1.charCodeAt(_loc5_++);
                              }
                           }
                        }
                     }
                     else
                     {
                        _loc11_ = 0;
                     }
                  }
                  while((int(_bits[_loc7_]) & 224) != 0)
                  {
                     _loc8_ |= int(_bits[_loc7_]);
                     _loc7_ = param1.charCodeAt(_loc5_++);
                  }
                  _loc12_ = "";
                  if(_loc9_)
                  {
                     _loc10_ = int(param2[_loc3_++]);
                  }
                  if(((_loc13_ = int(_bits[_loc7_])) & 16776960) == 0)
                  {
                     Boot.lastError = new Error();
                     throw "malformed format string: no specifier found";
                  }
                  if((_loc13_ & 8192) != 0)
                  {
                     if(_loc11_ == -1)
                     {
                        _loc11_ = 6;
                     }
                     _loc14_ = Number(param2[_loc3_++]);
                     if(_loc11_ == 0)
                     {
                        _loc12_ = Std.string(int(_loc14_ > 0 ? _loc14_ + 0.5 : (_loc14_ < 0 ? _loc14_ - 0.5 : 0)));
                        if((_loc8_ & 8) != 0)
                        {
                           _loc12_ += ".";
                        }
                     }
                     else
                     {
                        _loc15_ = Math.pow(0.1,_loc11_);
                        _loc14_ = (int((_loc16_ = _loc14_ / _loc15_) > 0 ? _loc16_ + 0.5 : (_loc16_ < 0 ? _loc16_ - 0.5 : 0))) * _loc15_;
                        _loc12_ = NumberFormat.toFixed(_loc14_,_loc11_);
                     }
                     if((_loc8_ & 2) != 0 && _loc14_ >= 0)
                     {
                        _loc12_ = "+" + _loc12_;
                     }
                     else if((_loc8_ & 4) != 0 && _loc14_ >= 0)
                     {
                        _loc12_ = " " + _loc12_;
                     }
                     _loc17_ = _loc12_;
                     _loc18_ = _loc10_;
                     _loc19_ = _loc17_.length;
                      // Comment: Obfuscated code
                     // §§push(_loc4_);
                     if(_loc18_ > 0 && _loc19_ < _loc18_)
                     {
                        _loc18_ -= _loc19_;
                        if((_loc8_ & 1) != 0)
                        {
                           _loc20_ = " ";
                           _loc21_ = 0;
                           _loc22_ = _loc18_ - 1;
                           while(_loc21_ < _loc22_)
                           {
                              _loc23_ = _loc21_++;
                              _loc20_ += " ";
                           }
                           _loc17_ += _loc20_;
                        }
                        else if(_loc14_ >= 0)
                        {
                           _loc24_ = _loc20_ = (_loc8_ & 16) != 0 ? "0" : " ";
                           _loc21_ = 0;
                           _loc22_ = _loc18_ - 1;
                           while(_loc21_ < _loc22_)
                           {
                              _loc23_ = _loc21_++;
                              _loc24_ += _loc20_;
                           }
                           _loc17_ = _loc24_ + _loc17_;
                        }
                        else if((_loc8_ & 16) != 0)
                        {
                           _loc20_ = "0";
                           _loc21_ = 0;
                           _loc22_ = _loc18_ - 1;
                            // Comment: Obfuscated code
                           // §§push("-");
                           while(_loc21_ < _loc22_)
                           {
                              _loc23_ = _loc21_++;
                              _loc20_ += "0";
                           }
                            // Comment: Obfuscated code
                           //_loc17_ = §§pop() + (_loc20_ + _loc17_.substr(1));
                        }
                        else
                        {
                           _loc20_ = " ";
                           _loc21_ = 0;
                           _loc22_ = _loc18_ - 1;
                           while(_loc21_ < _loc22_)
                           {
                              _loc23_ = _loc21_++;
                              _loc20_ += " ";
                           }
                           _loc17_ = _loc20_ + _loc17_;
                        }
                     }
                      // Comment: Obfuscated code
                     //_loc4_ = §§pop() + _loc17_;
                  }
                  else if((_loc13_ & 131328) != 0)
                  {
                     if((_loc8_ & 2) != 0)
                     {
                        _loc8_ &= -3;
                     }
                     if((_loc8_ & 4) != 0)
                     {
                        _loc8_ &= -5;
                     }
                     else if((_loc8_ & 16) != 0)
                     {
                        _loc8_ &= -17;
                     }
                     else if((_loc8_ & 8) != 0)
                     {
                        _loc8_ &= -9;
                     }
                     if(_loc13_ == 131072)
                     {
                        _loc12_ = Std.string(param2[_loc3_++]);
                        if(_loc11_ > 0)
                        {
                           _loc12_ = _loc12_.substr(0,_loc11_);
                        }
                     }
                     else
                     {
                        _loc12_ = String.fromCharCode(int(param2[_loc3_++]));
                     }
                     _loc18_ = _loc12_.length;
                     if(_loc10_ > 0 && _loc18_ < _loc10_)
                     {
                        _loc10_ -= _loc18_;
                        if((_loc8_ & 1) != 0)
                        {
                           _loc17_ = " ";
                           _loc19_ = 0;
                           _loc21_ = _loc10_ - 1;
                           while(_loc19_ < _loc21_)
                           {
                              _loc22_ = _loc19_++;
                              _loc17_ += " ";
                           }
                           _loc12_ += _loc17_;
                        }
                        else
                        {
                           _loc17_ = " ";
                           _loc19_ = 0;
                           _loc21_ = _loc10_ - 1;
                           while(_loc19_ < _loc21_)
                           {
                              _loc22_ = _loc19_++;
                              _loc17_ += " ";
                           }
                           _loc12_ = _loc17_ + _loc12_;
                        }
                     }
                     _loc4_ += _loc12_;
                  }
                  else if((_loc13_ & 10290688) != 0)
                  {
                     if(_loc11_ == -1)
                     {
                        _loc11_ = 1;
                     }
                     _loc18_ = int(param2[_loc3_++]);
                     if(_loc11_ == 0 && _loc18_ == 0)
                     {
                        _loc12_ = "";
                     }
                     else
                     {
                        if((_loc13_ & 32) != 0)
                        {
                           _loc18_ &= 65535;
                        }
                        else if((_loc13_ & 65536) != 0)
                        {
                           _loc12_ = NumberFormat.toOct(_loc18_);
                           if((_loc8_ & 8) != 0)
                           {
                              _loc12_ = "0" + _loc12_;
                           }
                        }
                        else if((_loc13_ & 524288) != 0)
                        {
                           _loc12_ = NumberFormat.toHex(_loc18_).toLowerCase();
                           if((_loc8_ & 8) != 0 && _loc18_ != 0)
                           {
                              _loc12_ = "0x" + _loc12_;
                           }
                        }
                        else if((_loc13_ & 1048576) != 0)
                        {
                           _loc12_ = NumberFormat.toHex(_loc18_).toUpperCase();
                           if((_loc8_ & 8) != 0 && _loc18_ != 0)
                           {
                              _loc12_ = "0X" + _loc12_;
                           }
                        }
                        else if((_loc13_ & 8388608) != 0)
                        {
                           _loc12_ = NumberFormat.toBin(_loc18_);
                           if(_loc11_ > 1)
                           {
                              if(_loc12_.length < _loc11_)
                              {
                                 _loc11_ -= _loc12_.length;
                                 _loc19_ = 0;
                                 while(_loc19_ < _loc11_)
                                 {
                                    _loc21_ = _loc19_++;
                                    _loc12_ = "0" + _loc12_;
                                 }
                              }
                              _loc11_ = 0;
                           }
                           if((_loc8_ & 8) != 0)
                           {
                              _loc12_ = "b" + _loc12_;
                           }
                        }
                        else
                        {
                           _loc12_ = Std.string(_loc18_);
                        }
                        if(_loc11_ > 1 && _loc12_.length < _loc11_)
                        {
                           if(_loc18_ > 0)
                           {
                              _loc19_ = 0;
                              _loc21_ = _loc11_ - 1;
                              while(_loc19_ < _loc21_)
                              {
                                 _loc22_ = _loc19_++;
                                 _loc12_ = "0" + _loc12_;
                              }
                           }
                           else
                           {
                              _loc12_ = "0" + -_loc18_;
                              _loc19_ = 0;
                              _loc21_ = _loc11_ - 2;
                              while(_loc19_ < _loc21_)
                              {
                                 _loc22_ = _loc19_++;
                                 _loc12_ = "0" + _loc12_;
                              }
                              _loc12_ = "-" + _loc12_;
                           }
                        }
                     }
                     if(_loc18_ >= 0)
                     {
                        if((_loc8_ & 2) != 0)
                        {
                           _loc12_ = "+" + _loc12_;
                        }
                        else if((_loc8_ & 4) != 0)
                        {
                           _loc12_ = " " + _loc12_;
                        }
                     }
                     _loc17_ = _loc12_;
                     _loc19_ = _loc10_;
                     _loc21_ = _loc17_.length;
                      // Comment: Obfuscated code
                     //§§push(_loc4_);
                     if(_loc19_ > 0 && _loc21_ < _loc19_)
                     {
                        _loc19_ -= _loc21_;
                        if((_loc8_ & 1) != 0)
                        {
                           _loc20_ = " ";
                           _loc22_ = 0;
                           _loc23_ = _loc19_ - 1;
                           while(_loc22_ < _loc23_)
                           {
                              _loc25_ = _loc22_++;
                              _loc20_ += " ";
                           }
                           _loc17_ += _loc20_;
                        }
                        else if(_loc18_ >= 0)
                        {
                           _loc24_ = _loc20_ = (_loc8_ & 16) != 0 ? "0" : " ";
                           _loc22_ = 0;
                           _loc23_ = _loc19_ - 1;
                           while(_loc22_ < _loc23_)
                           {
                              _loc25_ = _loc22_++;
                              _loc24_ += _loc20_;
                           }
                           _loc17_ = _loc24_ + _loc17_;
                        }
                        else if((_loc8_ & 16) != 0)
                        {
                           _loc20_ = "0";
                           _loc22_ = 0;
                           _loc23_ = _loc19_ - 1;
                            // Comment: Obfuscated code
                           //§§push("-");
                           while(_loc22_ < _loc23_)
                           {
                              _loc25_ = _loc22_++;
                              _loc20_ += "0";
                           }
                            // Comment: Obfuscated code
                           //_loc17_ = §§pop() + (_loc20_ + _loc17_.substr(1));
                        }
                        else
                        {
                           _loc20_ = " ";
                           _loc22_ = 0;
                           _loc23_ = _loc19_ - 1;
                           while(_loc22_ < _loc23_)
                           {
                              _loc25_ = _loc22_++;
                              _loc20_ += " ";
                           }
                           _loc17_ = _loc20_ + _loc17_;
                        }
                     }
                      // Comment: Obfuscated code
                     //_loc4_ = §§pop() + _loc17_;
                  }
                  else if((_loc13_ & 6144) != 0)
                  {
                     if(_loc11_ == -1)
                     {
                        _loc11_ = 6;
                     }
                     _loc18_ = (_loc14_ = Number(param2[_loc3_++])) > 0 ? 1 : (_loc14_ < 0 ? -1 : 0);
                     _loc14_ = _loc14_ < 0 ? -_loc14_ : _loc14_;
                     _loc19_ = 0;
                     if(_loc14_ > 1)
                     {
                        while(_loc14_ > 10)
                        {
                           _loc14_ /= 10;
                           _loc19_++;
                        }
                     }
                     else
                     {
                        while(_loc14_ < 1)
                        {
                           _loc14_ *= 10;
                           _loc19_--;
                        }
                     }
                     _loc15_ = 0.1;
                     _loc21_ = 0;
                     _loc22_ = _loc11_ - 1;
                     while(_loc21_ < _loc22_)
                     {
                        _loc23_ = _loc21_++;
                        _loc15_ *= 0.1;
                     }
                     _loc14_ = (int((_loc16_ = _loc14_ / _loc15_) > 0 ? _loc16_ + 0.5 : (_loc16_ < 0 ? _loc16_ - 0.5 : 0))) * _loc15_;
                     _loc12_ = (_loc12_ = (_loc12_ += (_loc18_ < 0 ? "-" : ((_loc8_ & 2) != 0 ? "+" : "")) + Std.string(_loc14_).substr(0,_loc11_ + 2)) + ((_loc13_ & 2048) != 0 ? "e" : "E")) + (_loc19_ > 0 ? "+" : "-");
                     if(_loc19_ < 10)
                     {
                        _loc17_ = "0";
                        _loc21_ = 0;
                        _loc22_ = 1;
                        while(_loc21_ < _loc22_)
                        {
                           _loc23_ = _loc21_++;
                           _loc17_ += "0";
                        }
                        _loc12_ += _loc17_;
                     }
                     else if(_loc19_ < 100)
                     {
                        _loc17_ = "0";
                        _loc21_ = 0;
                        _loc22_ = 0;
                        while(_loc21_ < _loc22_)
                        {
                           _loc23_ = _loc21_++;
                           _loc17_ += "0";
                        }
                        _loc12_ += _loc17_;
                     }
                     _loc12_ += Std.string(_loc19_ < 0 ? -_loc19_ : _loc19_);
                     _loc4_ += _loc12_;
                  }
                  else if((_loc13_ & 49152) != 0)
                  {
                     _loc11_ = 0;
                     _loc17_ = "";
                     if((_loc8_ & 1) != 0)
                     {
                        _loc17_ += "-";
                     }
                     if((_loc8_ & 2) != 0)
                     {
                        _loc17_ += "+";
                     }
                     if((_loc8_ & 4) != 0)
                     {
                        _loc17_ += " ";
                     }
                     if((_loc8_ & 16) != 0)
                     {
                        _loc17_ += "0";
                     }
                     _loc14_ = Number(param2[_loc3_++]);
                     _loc20_ = _format("%" + _loc17_ + "." + _loc11_ + "f",[_loc14_]);
                     _loc24_ = _format("%" + _loc17_ + "." + _loc11_ + (_loc7_ == 71 ? "E" : "e"),[_loc14_]);
                     if((_loc8_ & 8) != 0)
                     {
                        if(_loc20_.indexOf(".") != -1)
                        {
                           _loc18_ = _loc20_.length - 1;
                           while(int(_loc20_.charCodeAt(_loc18_)) == 48)
                           {
                              _loc18_--;
                           }
                           _loc20_ = _loc20_.substr(0,_loc18_);
                        }
                     }
                     _loc4_ += _loc20_.length < _loc24_.length ? _loc20_ : _loc24_;
                  }
                  else if((_loc13_ & 6291456) != 0)
                  {
                     Boot.lastError = new Error();
                     throw "warning: specifier \'p\' and \'n\' are not supported";
                  }
               }
            }
            else
            {
               _loc4_ += param1.charAt(_loc5_ - 1);
            }
         }
         return _loc4_;
      }
   }
}
