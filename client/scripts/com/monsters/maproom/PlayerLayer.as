package com.monsters.maproom
{
   import com.monsters.maproom.model.BaseObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class PlayerLayer extends Sprite
   {
       
      
      private var _lastUpdated:int = 0;
      
      private var _getting:Boolean = false;
      
      private var _gets:uint = 0;
      
      public var basesForeign:Array;
      
      public var basesWM:Array;
      
      public var basesAll:Array;
      
      public var baseData:Array;
      
      private var divisor:uint = 85;
      
      public var lastOpened:ForeignBase;
      
      private var _frameNumber:int = 0;
      
      private var jitter:uint = 2;
      
      public var obstructions:Array;
      
      public var _playersLimit:uint = 180;
      
      public var mapWidth:uint = 1500;
      
      public var player:PlayerBase;
      
      public var _wmbToDisplay:int = 3;
      
      private var wmBasesUsed:int = 0;
      
      public var faked:Boolean = false;
      
      public function PlayerLayer()
      {
         super();
         this.basesForeign = [].concat();
         this.baseData = [].concat();
         this.basesAll = [].concat();
         this.basesWM = [].concat();
         this.player = new PlayerBase(MapRoom.BRIDGE.playerBaseID,MapRoom.BRIDGE.playerBaseSeed);
         this.player.addEventListener(MouseEvent.MOUSE_OVER,this.sortToTop);
         this.basesAll.push(this.player);
         addChild(this.player);
         this.setMapCoords(this.player);
         this.wmBasesUsed = 0;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.basesAll.length)
         {
            if(this.basesAll[_loc1_].parent)
            {
               this.basesAll[_loc1_].removeEventListener("over",this.onBaseStateChange);
               this.basesAll[_loc1_].removeEventListener("off",this.onBaseStateChange);
               this.basesAll[_loc1_].removeEventListener("down",this.onBaseStateChange);
               this.basesAll[_loc1_].parent.removeChild(this.basesAll[_loc1_]);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.baseData.length)
         {
            this.baseData[_loc1_].Clear();
            _loc1_++;
         }
         this.basesForeign = [];
         this.baseData = [];
         this.basesAll = [];
         this.basesWM = [];
         this.player = null;
      }
      
      public function Tick(... rest) : void
      {
         var _loc2_:String = null;
         if(this._lastUpdated > 0 && MapRoom.BRIDGE.GLOBAL.Timestamp() - this._lastUpdated > 15 && !this._getting)
         {
            this.Get();
         }
         if(this._frameNumber % 40 == 0)
         {
            _loc2_ = "";
            if(MapRoom.BRIDGE.GLOBAL._flags.attacking == 0)
            {
               _loc2_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_attackingdisabled"));
            }
            if(!_loc2_)
            {
            }
         }
         ++this._frameNumber;
      }
      
      public function Get() : void
      {
         var loadVars:Array;
         var r:Object;
         var handleLoadSuccessful:Function = null;
         var handleLoadError:Function = null;
         handleLoadSuccessful = function(param1:Object):void
         {
            var aib:Object = null;
            var ai:String = null;
            var _o:Object = null;
            var start:int = 0;
            var obj:Object = param1;
            try
            {
               MapRoom.BRIDGE.GLOBAL.WaitHide();
               if(obj.error == 0)
               {
                  obj.wmbases = [];
                  aib = MapRoom.BRIDGE.WMBASE._bases;
                  try
                  {
                     if(aib)
                     {
                        for(ai in aib)
                        {
                           if(aib[ai])
                           {
                              if(aib[ai].destroyed == false)
                              {
                                 _o = {};
                                 if(aib[ai].tribe)
                                 {
                                    _o.baseid = aib[ai].baseid;
                                    _o.level = aib[ai].level;
                                    _o.type = aib[ai].tribe.type;
                                    _o.description = aib[ai].tribe.description;
                                    _o.wm = 1;
                                    _o.friend = 0;
                                    _o.pic = aib[ai].tribe.profilepic;
                                    _o.basename = MapRoom.BRIDGE.KEYS.Get("ai_tribe",{"v1":aib[ai].tribe.name});
                                    if(_o.level >= MapRoom.BRIDGE.BASE._baseLevel - 10)
                                    {
                                       obj.wmbases.push(_o);
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
                  catch(e:Error)
                  {
                     LOGGER.Log("err","PlayerLayer WM: " + e.message);
                  }
                  try
                  {
                     start = getTimer();
                     Create(obj);
                     _getting = false;
                     _lastUpdated = MapRoom.BRIDGE.GLOBAL.Timestamp() + int(Math.random() * 5);
                     dispatchEvent(new Event(Event.COMPLETE));
                  }
                  catch(e:Error)
                  {
                     LOGGER.Log("err","PlayerLayer Create: " + e.message);
                  }
               }
               else
               {
                  MapRoom.BRIDGE.Log("err","MAPROOMPOPUP.Get: " + obj.error);
                  MapRoom.BRIDGE.GLOBAL.ErrorMessage("MAPROOMPOPUP.Get 1");
               }
               if(MiniMap.getInstance())
               {
                  MiniMap.getInstance().Update(basesForeign,basesWM);
               }
            }
            catch(e:Error)
            {
               LOGGER.Log("err","PlayerLayer: " + e.message);
            }
         };
         handleLoadError = function(param1:IOErrorEvent):void
         {
            GLOBAL.Message("Failed to load map neighbours");
            MapRoom.BRIDGE.GLOBAL.WaitHide();
            MapRoom.BRIDGE.Log("err","MAPROOMPOPUP.Get HTTP");
            MapRoom.BRIDGE.GLOBAL.ErrorMessage("MAPROOMPOPUP.Get 2");
         };
         this._getting = true;
         ++this._gets;
         if(this._gets > 12)
         {
         }
         loadVars = [["baseid",0]];
         r = new URLLoaderApi();
         r.load(MapRoom.BRIDGE.GLOBAL._apiURL + "bm/neighbours/get",loadVars,handleLoadSuccessful,handleLoadError);
      }
      
      public function Create(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc4_:BaseObject = null;
         var _loc5_:BaseObject = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:WildMonsterBase = null;
         var _loc9_:ForeignBase = null;
         var _loc3_:Boolean = false;
         if(this.basesForeign == null)
         {
            this.basesForeign = [];
         }
         if(this.basesWM == null)
         {
            this.basesWM = [];
         }
         if(this.basesAll == null)
         {
            this.basesAll = [];
         }
         if(this.baseData == null)
         {
            this.baseData = [];
         }
         if(Boolean(param1) && Boolean(param1.wmbases))
         {
            _loc7_ = 0;
            while(_loc7_ < param1.wmbases.length)
            {
               if(this.wmBasesUsed < this._wmbToDisplay)
               {
                  _loc2_ = param1.wmbases[_loc7_];
                  _loc3_ = false;
                  for each(_loc4_ in this.baseData)
                  {
                     if(int(_loc4_.baseid.Get()) == _loc2_.baseid)
                     {
                        _loc3_ = true;
                     }
                  }
                  if(!_loc3_)
                  {
                     _loc5_ = new BaseObject(_loc2_);
                     (_loc8_ = new WildMonsterBase()).Setup(_loc5_);
                     _loc8_.useHandCursor = true;
                     _loc8_.buttonMode = true;
                     _loc8_.addEventListener("over",this.onBaseStateChange);
                     _loc8_.addEventListener("off",this.onBaseStateChange);
                     _loc8_.addEventListener("down",this.onBaseStateChange);
                     if(this.setMapCoords(_loc8_,true))
                     {
                        this.baseData.push(_loc5_);
                        addChild(_loc8_);
                        this.basesAll.push(_loc8_);
                        this.basesWM.push(_loc8_);
                        ++this.wmBasesUsed;
                     }
                  }
               }
               _loc7_ += 1;
            }
         }
         if(this.basesForeign.length < this._playersLimit && param1 && Boolean(param1.bases))
         {
            if(this.basesForeign.length + param1.bases.length >= this._playersLimit)
            {
               _loc6_ = uint(this._playersLimit - this.basesForeign.length);
            }
            else
            {
               _loc6_ = uint(param1.bases.length);
            }
            if(param1 && param1.bases && param1.bases.length > 0)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc2_ = param1.bases[_loc7_];
                  _loc3_ = false;
                  for each(_loc4_ in this.baseData)
                  {
                     if(int(_loc4_.baseid.Get()) == _loc2_.baseid)
                     {
                        _loc4_.Update(_loc2_);
                        _loc4_.online = _loc2_.saved >= MapRoom.BRIDGE.GLOBAL.Timestamp() - 62;
                        _loc3_ = true;
                        break;
                     }
                  }
                  if(!_loc3_)
                  {
                     _loc5_ = new BaseObject(_loc2_);
                     (_loc9_ = new ForeignBase()).Setup(_loc5_);
                     _loc9_.useHandCursor = true;
                     _loc9_.buttonMode = true;
                     _loc9_.addEventListener("over",this.onBaseStateChange);
                     _loc9_.addEventListener("off",this.onBaseStateChange);
                     _loc9_.addEventListener("down",this.onBaseStateChange);
                     this.baseData.push(_loc5_);
                     if(this.setMapCoords(_loc9_))
                     {
                        addChild(_loc9_);
                        this.basesForeign.push(_loc9_);
                        this.basesAll.push(_loc9_);
                     }
                  }
                  _loc7_ += 1;
               }
            }
            setChildIndex(this.player,this.numChildren - 1);
            return;
         }
      }
      
      private function onBaseStateChange(param1:Event) : void
      {
         var _loc2_:ForeignBase = param1.target as ForeignBase;
         if(this.lastOpened && this.lastOpened.state != "off" && this.lastOpened != _loc2_)
         {
            this.lastOpened.setState("off");
         }
         this.sortToTop(param1);
         this.lastOpened = _loc2_;
         if(param1.type == "down")
         {
            dispatchEvent(param1.clone());
         }
      }
      
      private function sortToTop(param1:*) : void
      {
         setChildIndex(param1.target,this.numChildren - 1);
      }
      
      public function setMapCoords(param1:*, param2:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:WildMonsterBase = null;
         var _loc10_:uint = 0;
         var _loc11_:Point = null;
         var _loc3_:Boolean = true;
         if(param2)
         {
            _loc8_ = int((_loc7_ = {
               "l":0,
               "k":1,
               "a":2,
               "d":3
            })[param1.data.basename.charAt(0).toLowerCase()]);
            _loc4_ = Obstruction.Reserved[_loc8_].x / this.divisor;
            _loc5_ = (Obstruction.Reserved[_loc8_].y - 130) / this.divisor;
            for each(_loc9_ in this.basesWM)
            {
               if(_loc9_.mapX == _loc4_ && _loc9_.mapY == _loc5_)
               {
                  return false;
               }
            }
            param1.mapX = _loc4_;
            param1.mapY = _loc5_;
            _loc6_ = 0;
         }
         else
         {
            _loc10_ = this.mapWidth / this.divisor - 2;
            _loc4_ = 1 + param1.data.baseid.Get() % _loc10_;
            _loc5_ = 1 + param1.data.baseseed.Get() % _loc10_;
            if(!(_loc11_ = this.getNonConflictingCoords(new Point(_loc4_,_loc5_),new Rectangle(2,2,_loc10_ - 2,_loc10_ - 2),10)))
            {
               return false;
            }
            param1.mapX = _loc11_.x;
            param1.mapY = _loc11_.y;
            _loc6_ = param1.data.baseid.Get() % (this.divisor * 0.5);
         }
         param1.x = 130 + this.divisor * param1.mapX + _loc6_;
         param1.y = 130 + this.divisor * param1.mapY + _loc6_;
         return _loc3_;
      }
      
      private function getNonConflictingCoords(param1:Point, param2:Rectangle, param3:uint = 3) : Point
      {
         var _loc7_:int = 0;
         if(!this.baseExistsAt(param1.x,param1.y) && !Obstruction.pointIsBlocked(param1.x * this.divisor,param1.y * this.divisor))
         {
            return param1;
         }
         var _loc4_:Object = {};
         var _loc5_:int = -param3;
         while(_loc5_ <= param3)
         {
            _loc4_[_loc5_] = {};
            _loc7_ = -param3;
            while(_loc7_ <= param3)
            {
               _loc4_[_loc5_][_loc7_] = 0;
               _loc7_++;
            }
            _loc5_++;
         }
         var _loc6_:uint = 1;
         while(_loc6_ <= param3)
         {
            _loc5_ = -_loc6_;
            while(_loc5_ <= _loc6_)
            {
               _loc7_ = -_loc6_;
               while(_loc7_ <= _loc6_)
               {
                  if(_loc4_[_loc5_][_loc7_] == 0 && param1.x + _loc5_ > param2.x && param1.x + _loc5_ < param2.x + param2.width && param1.y + _loc7_ > param2.y && param1.y + _loc7_ < param2.y + param2.height)
                  {
                     if(!(this.baseExistsAt(param1.x + _loc5_,param1.y + _loc7_) || Obstruction.pointIsBlocked((param1.x + _loc5_) * this.divisor,(param1.y + _loc7_) * this.divisor)))
                     {
                        return new Point(param1.x + _loc5_,param1.y + _loc7_);
                     }
                     _loc4_[_loc5_][_loc7_] == 1;
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
            _loc6_++;
         }
         return null;
      }
      
      public function baseExistsAt(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in this.basesAll)
         {
            if(_loc3_.mapX == param1 && _loc3_.mapY == param2)
            {
               return true;
            }
         }
         return false;
      }
   }
}
