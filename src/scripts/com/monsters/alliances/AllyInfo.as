package com.monsters.alliances
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   public class AllyInfo
   {
      
      private static var _forceRelations:Boolean = true;
      
      private static var _useIconRelations:Boolean = false;
      
      private static var _relationProps:Object = {
         "hostile":-1,
         "hostileleader":-2,
         "neutral":0,
         "friendly":1,
         "friendlyleader":2,
         "member":4,
         "leader":5
      };
      
      private static var _picPropsL:Object = {
         "picX":0,
         "picY":0,
         "picW":75,
         "picH":75,
         "relW":75,
         "relH":75,
         "relX":0,
         "relY":0
      };
      
      private static var _picPropsM:Object = {
         "picX":2,
         "picY":2,
         "picW":46,
         "picH":46,
         "relW":50,
         "relH":50,
         "relX":0,
         "relY":0
      };
      
      private static var _picPropsS:Object = {
         "picX":0,
         "picY":0,
         "picW":25,
         "picH":25,
         "relW":25,
         "relH":25,
         "relX":0,
         "relY":0
      };
      
      private static var _picPropsXS:Object = {
         "picX":0,
         "picY":0,
         "picW":12,
         "picH":12,
         "relW":12,
         "relH":12,
         "relX":0,
         "relY":0
      };
      
      public static var _picURLs:Object = {
         "baseURL":"alliances/",
         "sizeL":"_large",
         "sizeM":"_medium",
         "sizeS":"_small",
         "sizeXS":"_xsmall",
         "ally":"A",
         "friendly":"F",
         "hostile":"H",
         "neutral":"N",
         "playerHex":3704807,
         "allyHex":11327481,
         "friendlyHex":1301765,
         "hostileHex":16729640,
         "neutralHex":16776960,
         "noneHex":16777215,
         "ext":".png"
      };
       
      
      private var alliance_id:int;
      
      public var name:String;
      
      public var image:int;
      
      public var relationship:int = 0;
      
      private var relationships:Object;
      
      private var _relCheckSelf:Boolean = true;
      
      private var _relCheckThem:Boolean = false;
      
      public function AllyInfo(param1:Object)
      {
         super();
         this.alliance_id = param1.alliance_id;
         this.name = param1.name;
         this.image = param1.image;
         this.relationships = param1.relationships;
         if(_forceRelations)
         {
            if(ALLIANCES._allianceID && ALLIANCES._allianceID != 0 && this.alliance_id && !this.relationship)
            {
               this.Relations(ALLIANCES._allianceID);
            }
         }
      }
      
      public function Relations(param1:int) : int
      {
         if(this.alliance_id)
         {
            this.relationship = AllyInfo._relationProps.neutral;
         }
         if(!this.relationships || !ALLIANCES._myAlliance)
         {
            return 0;
         }
         var _loc2_:int = 0;
         if(param1 == this.alliance_id)
         {
            _loc2_ = int(AllyInfo._relationProps.member);
            this.relationship = _loc2_;
            return 0;
         }
         if(this._relCheckThem)
         {
            if(Boolean(this.relationships) && Boolean(this.relationships[param1]))
            {
               _loc2_ = int(this.relationships[param1]);
            }
         }
         if(this._relCheckSelf)
         {
            if(ALLIANCES._myAlliance && ALLIANCES._myAlliance.relationships && Boolean(ALLIANCES._myAlliance.relationships[this.alliance_id]))
            {
               _loc2_ = int(ALLIANCES._myAlliance.relationships[this.alliance_id]);
            }
         }
         this.relationship = _loc2_;
         return _loc2_;
      }
      
      public function AlliancePic(param1:String, param2:MovieClip, param3:MovieClip = null, param4:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         var _loc11_:Shape = null;
         var _loc12_:uint = 0;
         if(this.alliance_id && this.alliance_id > 0 && Boolean(this.image))
         {
            _loc5_ = this.image;
            _loc6_ = "" + _picURLs.baseURL + _loc5_;
            _loc7_ = new Object();
            if(param1 == _picURLs.sizeL || param1 == "large")
            {
               _loc6_ += _picURLs.sizeL;
               _loc7_ = _picPropsL;
            }
            else if(param1 == _picURLs.sizeM || param1 == "medium")
            {
               _loc6_ += _picURLs.sizeM;
               _loc7_ = _picPropsM;
            }
            else
            {
               if(!(param1 == _picURLs.sizeS || param1 == "small"))
               {
                  return;
               }
               _loc6_ += _picURLs.sizeS;
               _loc7_ = _picPropsS;
            }
            _loc6_ += _picURLs.ext;
            ImageCache.GetImageWithCallBack(_loc6_,this.IconLoaded,true,1,"",[param2,_loc7_]);
            if(param4)
            {
               if(_useIconRelations)
               {
                  _loc8_ = "" + _picURLs.baseURL;
                  _loc9_ = new Object();
                  if(this.relationship == _relationProps.neutral)
                  {
                     _loc8_ += _picURLs.neutral;
                  }
                  else if(this.relationship >= _relationProps.member)
                  {
                     _loc8_ += _picURLs.ally;
                  }
                  else if(this.relationship > _relationProps.neutral && this.relationship < _relationProps.member)
                  {
                     _loc8_ += _picURLs.friendly;
                  }
                  else
                  {
                     if(this.relationship > _relationProps.hostile)
                     {
                        return;
                     }
                     _loc8_ += _picURLs.hostile;
                  }
                  if(param1 == _picURLs.sizeL || param1 == "large")
                  {
                     _loc8_ += _picURLs.sizeS;
                     _loc9_ = _picPropsL;
                  }
                  else if(param1 == _picURLs.sizeM || param1 == "medium")
                  {
                     _loc8_ += _picURLs.sizeS;
                     _loc9_ = _picPropsM;
                  }
                  else
                  {
                     if(!(param1 == _picURLs.sizeS || param1 == "small"))
                     {
                        return;
                     }
                     _loc8_ += _picURLs.sizeXS;
                     _loc9_ = _picPropsS;
                  }
                  _loc8_ += _picURLs.ext;
                  ImageCache.GetImageWithCallBack(_loc8_,this.IconRelationLoaded,true,1,"",[param2,_loc9_]);
               }
               else if(param3)
               {
                  _loc10_ = param3.numChildren;
                  while(_loc10_--)
                  {
                     param3.removeChildAt(_loc10_);
                  }
                  _loc11_ = new Shape();
                  _loc12_ = 16777215;
                  if(this.relationship == _relationProps.neutral)
                  {
                     _loc12_ = uint(_picURLs.neutralHex);
                  }
                  else if(this.relationship >= _relationProps.member)
                  {
                     _loc12_ = uint(_picURLs.allyHex);
                  }
                  else if(this.relationship > _relationProps.neutral && this.relationship < _relationProps.member)
                  {
                     _loc12_ = uint(_picURLs.friendlyHex);
                  }
                  else if(this.relationship <= _relationProps.hostile)
                  {
                     _loc12_ = uint(_picURLs.hostileHex);
                  }
                  else
                  {
                     _loc12_ = uint(_picURLs.noneHex);
                  }
                  _loc11_.graphics.beginFill(_loc12_);
                  _loc11_.graphics.drawRect(_loc7_.relX,_loc7_.relY,_loc7_.relW,_loc7_.relH);
                  _loc11_.graphics.endFill();
                  param3.addChild(_loc11_);
               }
            }
         }
      }
      
      private function IconLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap = new Bitmap(param2);
         if(param3[0])
         {
            param3[0].addChild(_loc4_);
            param3[0].setChildIndex(_loc4_,0);
            _loc4_.x = param3[1].picX;
            _loc4_.y = param3[1].picY;
         }
      }
      
      private function IconRelationLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc4_:Bitmap = null;
         _loc4_ = new Bitmap(param2);
         if(param3[0])
         {
            param3[0].addChild(_loc4_);
            _loc4_.x = param3[1].relX;
            _loc4_.y = param3[1].relY;
         }
      }
   }
}
