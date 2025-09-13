package com.monsters.maproom_advanced
{
   
   import com.cc.utils.SecNum;
   import com.monsters.alliances.*;
   import com.monsters.maproom_manager.IMapRoomCell;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class MapRoomCell extends MapRoomCell_CLIP implements IMapRoomCell
   {
       
      
      internal var X:int;
      
      internal var Y:int;
      
      internal var _updated:Boolean;
      
      internal var _dataAge:int;
      
      internal var _base:int;
      
      internal var _baseID:Number;
      
      internal var _allianceID:int;
      
      internal var _alliance:AllyInfo;
      
      internal var _height:int;
      
      internal var _mine:int;
      
      internal var _facebookID:Number;
      
      internal var _pic_square:String;
      
      internal var _userID:int;
      
      internal var _online:int;
      
      internal var _friend:int;
      
      internal var _truce:int;
      
      internal var _name:String;
      
      internal var _protected:int;
      
      internal var _resources:Object;
      
      internal var _hpResources:Object;
      
      internal var _monsterData:Object;
      
      internal var _flingerRange:SecNum;
      
      internal var _flingerLevel:SecNum;
      
      internal var _catapult:SecNum;
      
      internal var _level:int;
      
      internal var _destroyed:int;
      
      internal var _damaged:int;
      
      internal var _water:Boolean;
      
      internal var _monsters:Object;
      
      internal var _ticks:int;
      
      internal var _processed:Boolean;
      
      internal var _dirty:Boolean = false;
      
      internal var _locked:int;
      
      internal var _hpMonsterData:Object;
      
      internal var _hpMonsters:Object;
      
      internal var _invitePendingID:int;
      
      internal var _damage:int;
      
      internal var _workerBusy:Boolean = false;
      
      internal var _inRange:Boolean = false;
      
      internal var _over:Boolean = false;
      
      internal var _terrain:String;
      
      internal var _hasWarned:int = 0;
      
      internal var _value:Number = 0;
      
      private var _smokeBMD:BitmapData;
      
      private var _smokeDO:DisplayObject;
      
      private var _smokeRender:Boolean;
      
      private var _smokeParticles:Array;
      
      private var _frame:int;
      
      public var depth:int;
      
      private var inTest:Boolean = false;
      
      private var _inAllianceProps:Object;
      
      private var _soloProps:Object;
      
      private var _picURLs:Object;
      
      private var testAllianceIDs:Array;
      
      public function MapRoomCell()
      {
         this._inAllianceProps = {
            "txtNameX":0,
            "txtNameY":1,
            "txtAllyX":0,
            "txtAllyY":11
         };
         this._soloProps = {
            "txtNameX":0,
            "txtNameY":1,
            "txtAllyX":0,
            "txtAllyY":11
         };
         this._picURLs = {
            "baseURL":"alliances/",
            "sizeL":"_large",
            "sizeM":"_medium",
            "sizeS":"_small",
            "sizeXS":"_xsmall",
            "ally":"A",
            "friendly":"F",
            "hostile":"H",
            "neutral":"N",
            "ext":".png"
         };
         this.testAllianceIDs = [1,2,3,102,111];
         super();
         mc.mcHit.addEventListener(MouseEvent.MOUSE_OVER,this.Over);
         mc.mcHit.addEventListener(MouseEvent.MOUSE_OUT,this.Out);
         mc.mcHit.addEventListener(MouseEvent.MOUSE_UP,this.Click);
         mc.mcPlayer.mouseEnabled = false;
         mc.mcPlayer.mouseChildren = false;
         mc.mcGlow.mouseEnabled = false;
         mc.mcGlow.mouseChildren = false;
         mc.mcGlow.gotoAndStop(1);
         mc.mcEdges.mouseEnabled = false;
         mc.mcEdges.mouseChildren = false;
         mc.mcPlayer.mcWorker.visible = false;
         mc.mcPlayer.mcInvite.visible = false;
         mc.mcPlayer.mcFlag.mouseEnabled = false;
         mc.mcPlayer.mcFlag.mouseChildren = false;
         mc.mcPlayer.mcFlag.gotoAndStop(1);
         mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop(1);
         mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop(1);
         mc.mcPlayer.mcFlag.txtAlliance.visible = false;
         mc.mcPlayer.mcFlag.txtAlliance.htmlText = "";
         mc.mcEdges.enabled = false;
         mc.mcEdges.visible = false;
         mc.mcPrompt.enabled = false;
         mc.mcPrompt.visible = false;
      }
      
      public function set alliance(param1:AllyInfo) : void
      {
         this._alliance = param1;
      }
      
      public function get allianceID() : int
      {
         return this._allianceID;
      }
      
      public function get monsters() : Object
      {
         return this._monsters;
      }
      
      public function get monsterData() : Object
      {
         return this._monsterData;
      }
      
      public function get resources() : Object
      {
         return this._resources;
      }
      
      public function get hpMonsters() : Object
      {
         return this._hpMonsters;
      }
      
      public function get hpMonsterData() : Object
      {
         return this._hpMonsterData;
      }
      
      public function get hpResources() : Object
      {
         return this._hpResources;
      }
      
      public function get terrain() : String
      {
         return this._terrain;
      }
      
      public function get flingerRange() : SecNum
      {
         return this._flingerRange;
      }
      
      public function get baseID() : Number
      {
         return this._baseID;
      }
      
      public function get baseType() : int
      {
         return this._base;
      }
      
      public function set baseType(param1:int) : void
      {
         this._base = param1;
      }
      
      public function get cellX() : int
      {
         return this.X;
      }
      
      public function set cellX(param1:int) : void
      {
         this.X = param1;
      }
      
      public function get cellY() : int
      {
         return this.Y;
      }
      
      public function set cellY(param1:int) : void
      {
         this.Y = param1;
      }
      
      public function get cellHeight() : int
      {
         return this._height;
      }
      
      public function get mine() : int
      {
         return this._mine;
      }
      
      public function get online() : int
      {
         return this._online;
      }
      
      public function get truce() : int
      {
         return this._truce;
      }
      
      public function get isDestroyed() : Boolean
      {
         return !!this._destroyed ? true : false;
      }
      
      public function set destroyed(param1:int) : void
      {
         this._destroyed = param1;
      }
      
      public function get isLocked() : Boolean
      {
         return this._locked != 0 && this._locked != LOGIN._playerID;
      }
      
      public function get isProtected() : int
      {
         return this._protected;
      }
      
      public function set isProtected(param1:int) : void
      {
         this._protected = param1;
      }
      
      public function get isDirty() : Boolean
      {
         return this._dirty;
      }
      
      public function set isDirty(param1:Boolean) : void
      {
         this._dirty = param1;
      }
      
      public function Setup(serverData:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this._dataAge = 10;
         this._updated = true;
         this._processed = false;
         this._base = serverData.b;
         if(serverData.bid)
         {
            if(this._baseID != 0 && this._baseID == GLOBAL._homeBaseID)
            {
               MapRoom._homeCell = this;
            }
            else if(this.X == GLOBAL._mapHome.x && this.Y == GLOBAL._mapHome.y)
            {
               MapRoom._homeCell = this;
            }
            this._baseID = serverData.bid;
         }
         this._value = serverData.v;
         if(serverData.aid)
         {
            this._allianceID = serverData.aid;
         }
         else
         {
            this._allianceID = 0;
            this._alliance = null;
         }
         if(this._alliance)
         {
            mc.mcPlayer.mcFlag.visible = true;
            ALLIANCES.SetCellAlliance(this,true);
         }
         else if(Boolean(this._allianceID) && this._allianceID > 0)
         {
            ALLIANCES.SetCellAlliance(this,true);
            mc.mcPlayer.mcFlag.visible = false;
         }
         mc.mcPlayer.mcLevel.visible = false;
         this._height = serverData.i;
         this._water = this._height < 100;
         this._mine = serverData.mine;
         if(serverData.f)
         {
            this._flingerLevel = new SecNum(serverData.f);
            this._flingerRange = new SecNum(BUILDING5.getFlingerRange(serverData.f,this.isMainBase));
         }
         else
         {
            this._flingerRange = new SecNum(0);
            this._flingerLevel = new SecNum(0);
         }
         if(serverData.c)
         {
            this._catapult = new SecNum(serverData.c);
         }
         else
         {
            this._catapult = new SecNum(0);
         }
         this._userID = serverData.uid;
         this._facebookID = serverData.fbid;
         this._truce = serverData.t;
         this._name = serverData.n;
         this._friend = serverData.fr;
         this._online = serverData.on;
         this._protected = serverData.p;
         if(serverData.pi)
         {
            this._invitePendingID = serverData.pi;
         }
         else
         {
            this._invitePendingID = 0;
         }
         if(serverData.r)
         {
            this._hpResources = {
               "r1":int(serverData.r.r1),
               "r2":int(serverData.r.r2),
               "r3":int(serverData.r.r3),
               "r4":int(serverData.r.r4),
               "r1max":int(serverData.r.r1max),
               "r2max":int(serverData.r.r2max),
               "r3max":int(serverData.r.r3max),
               "r4max":int(serverData.r.r4max)
            };
            this._resources = {
               "r1":new SecNum(int(serverData.r.r1)),
               "r2":new SecNum(int(serverData.r.r2)),
               "r3":new SecNum(int(serverData.r.r3)),
               "r4":new SecNum(int(serverData.r.r4)),
               "r1max":int(serverData.r.r1max),
               "r2max":int(serverData.r.r2max),
               "r3max":int(serverData.r.r3max),
               "r4max":int(serverData.r.r4max)
            };
         }
         else
         {
            this._hpResources = {
               "r1":0,
               "r2":0,
               "r3":0,
               "r4":0,
               "r1max":500000,
               "r2max":500000,
               "r3max":500000,
               "r4max":500000
            };
            this._resources = {
               "r1":new SecNum(0),
               "r2":new SecNum(0),
               "r3":new SecNum(0),
               "r4":new SecNum(0),
               "r1max":500000,
               "r2max":500000,
               "r3max":500000,
               "r4max":500000
            };
         }
         this._dirty = false;
         if(serverData.m && serverData.m.hcc != null && serverData.m.h != null && serverData.m.overdrivepower != null && serverData.m.housed != null)
         {
            this._hpMonsterData = serverData.m;
            if(!this._hpMonsterData.overdrivetime)
            {
               this._hpMonsterData.overdrivetime = 0;
            }
            if(!this._hpMonsterData.saved)
            {
               this._hpMonsterData.saved = 0;
            }
            if(!this._hpMonsterData.space)
            {
               this._hpMonsterData.space = 0;
            }
         }
         else
         {
            this._hpMonsterData = {
               "hcc":[],
               "h":[],
               "hstage":[],
               "hid":[],
               "overdrivepower":1,
               "overdrivetime":0,
               "saved":GLOBAL.Timestamp() - 5,
               "housed":{},
               "space":0
            };
         }
         if(this._hpMonsterData)
         {
            this.SecureMonsterData();
         }
         this._monsters = {};
         if(this._monsterData)
         {
            this._monsters = this._monsterData.housed;
            this._monsterData.finishtime = this._hpMonsterData.finishtime;
         }
         if(this._hpMonsterData)
         {
            this._hpMonsters = this._hpMonsterData.housed;
         }
         this._level = serverData.l;
         if(serverData.d)
         {
            this._destroyed = serverData.d;
         }
         else
         {
            this._destroyed = 0;
         }
         if(serverData.lo)
         {
            this._locked = serverData.lo;
         }
         else
         {
            this._locked = 0;
         }
         this._ticks = 0;
         if(serverData.dm)
         {
            this._damage = serverData.dm;
         }
         else
         {
            this._damage = 0;
         }
         if(serverData.pic_square)
         {
            this._pic_square = serverData.pic_square;
         }
         if(serverData.im)
         {
            this._pic_square = serverData.im;
         }
         this.Update();
         var _loc2_:int = getTimer();
         if(this._monsterData)
         {
            _loc3_ = getTimer();
            _loc4_ = int(this._monsterData.saved);
            _loc5_ = int(this._monsterData.saved);
            while(_loc5_ < GLOBAL.Timestamp())
            {
               if(this.Tick(_loc5_))
               {
                  break;
               }
               _loc5_++;
            }
         }
         this._processed = true;
      }
      
      public function Update() : void
      {
         if(this._height < 100)
         {
            if(this._height < 80)
            {
               mc.gotoAndStop("water1");
            }
            else if(this._height < 90)
            {
               mc.gotoAndStop("water2");
            }
            else
            {
               mc.gotoAndStop("water3");
            }
            mc.y = int(100 - this._height) + 18;
            mc.mcWater.y = -int(100 - this._height);
         }
         else
         {
            if(this._height < 105)
            {
               mc.gotoAndStop("sand1");
               this._terrain = "sand";
            }
            else if(this._height < 110)
            {
               mc.gotoAndStop("sand2");
               this._terrain = "sand";
            }
            else if(this._height < 120)
            {
               mc.gotoAndStop("land1");
               this._terrain = "grass";
            }
            else if(this._height < 140)
            {
               mc.gotoAndStop("land2");
               this._terrain = "grass";
            }
            else if(this._height < 160)
            {
               mc.gotoAndStop("land3");
               this._terrain = "grass";
            }
            else if(this._height < 170)
            {
               mc.gotoAndStop("land4");
               this._terrain = "grass";
            }
            else if(this._height < 175)
            {
               mc.gotoAndStop("land5");
               this._terrain = "rock";
            }
            else
            {
               mc.gotoAndStop("land6");
               this._terrain = "rock";
            }
            mc.y = -int((this._height - 100) * 0.6) + 18;
         }
         if(this._base > 0)
         {
            mc.mcPlayer.visible = true;
            mc.mcPlayer.mcFlag2.visible = false;
            mc.mcPlayer.mcLevel.visible = false;
            this.SetupAlliance();
            if(this._base == 1)
            {
               mc.mcPlayer.gotoAndStop("tribe-" + this._name);
               mc.mcPlayer.mcLevel.gotoAndStop(1);
               mc.mcPlayer.mcLevel.lv_txt.htmlText = "<b>" + this._level + "</b>";
               if(Boolean(this._level) && this._level > 0)
               {
                  mc.mcPlayer.mcLevel.visible = true;
               }
               mc.mcPlayer.mcFlag.txt.htmlText = "" + this._name;
               mc.mcPlayer.mcFlag.txt.y = this._inAllianceProps.txtNameY;
               mc.mcPlayer.mcFlag.txtAlliance.htmlText = "";
               mc.mcPlayer.mcFlag.txtAlliance.y = this._inAllianceProps.txtAllyY;
               mc.mcPlayer.mcFlag.txtAlliance.visible = false;
            }
            else
            {
               mc.mcPlayer.mcLevel.gotoAndStop(2);
               mc.mcPlayer.mcLevel.lv_txt.htmlText = "<b>" + this._level + "</b>";
               if(Boolean(this._level) && this._level > 0)
               {
                  mc.mcPlayer.mcLevel.visible = true;
               }
               if(this._protected)
               {
                  if(this._base == 2)
                  {
                     mc.mcPlayer.gotoAndStop("main-protected");
                  }
                  if(this._base == 3)
                  {
                     mc.mcPlayer.gotoAndStop("outpost-protected");
                  }
               }
               else if(this._base == 2)
               {
                  if(this._destroyed)
                  {
                     mc.mcPlayer.gotoAndStop("main-destroyed");
                  }
                  else if(this._damage)
                  {
                     mc.mcPlayer.gotoAndStop("main-damaged");
                  }
                  else
                  {
                     mc.mcPlayer.gotoAndStop("main");
                  }
               }
               else if(this._base == 3)
               {
                  if(this._destroyed)
                  {
                     mc.mcPlayer.gotoAndStop("outpost-destroyed");
                  }
                  else if(this._damage)
                  {
                     mc.mcPlayer.gotoAndStop("outpost-damaged");
                  }
                  else
                  {
                     mc.mcPlayer.gotoAndStop("outpost");
                  }
               }
               mc.mcPlayer.mcFlag.txt.htmlText = "<b>" + this._name + "</b> ";
               if(this._alliance)
               {
                  mc.mcPlayer.mcFlag.txt.y = this._inAllianceProps.txtNameY;
                  mc.mcPlayer.mcFlag.txtAlliance.visible = false;
                  mc.mcPlayer.mcFlag.txtAlliance.y = this._inAllianceProps.txtAllyY;
                  mc.mcPlayer.mcFlag.txtAlliance.htmlText = "";
               }
               else
               {
                  mc.mcPlayer.mcFlag.txt.y = this._soloProps.txtNameY;
                  mc.mcPlayer.mcFlag.txtAlliance.visible = false;
                  mc.mcPlayer.mcFlag.txtAlliance.y = this._soloProps.txtAllyY;
                  mc.mcPlayer.mcFlag.txtAlliance.htmlText = "";
               }
               mc.mcPlayer.mcTruce.visible = this._truce > GLOBAL.Timestamp();
            }
         }
         else
         {
            mc.mcPlayer.visible = false;
         }
         if(this._damage)
         {
            mc.mcPlayer.mcFlag2.visible = false;
            mc.mcPlayer.mcFlag.nameBar.mcBar.width = 100 / 100 * Math.max(0,100 - this._damage);
            if(this._base == 1)
            {
               mc.mcPlayer.mcFlag.txt.htmlText = "" + this._name + "";
               mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop(!!this._destroyed ? "destroyed" : "wmyard");
               mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop(!!this._destroyed ? "destroyed" : "wmyard");
            }
         }
         else
         {
            mc.mcPlayer.mcFlag.nameBar.mcBar.width = 100;
         }
         if(this._inRange)
         {
            if(this._over)
            {
               mc.mcGlow.gotoAndStop(4);
            }
            else
            {
               mc.mcGlow.gotoAndStop(3);
            }
         }
         else if(this._over)
         {
            mc.mcGlow.gotoAndStop(2);
         }
         else
         {
            mc.mcGlow.gotoAndStop(1);
         }
         if(this._monsterData)
         {
            if(Boolean(this._monsterData.finishtime) && this._monsterData.finishtime > GLOBAL.Timestamp())
            {
               this._workerBusy = true;
            }
            else
            {
               this._workerBusy = false;
            }
         }
         if(!this._workerBusy && this._base == 3 && Boolean(this._mine))
         {
            mc.mcPlayer.mcWorker.visible = true;
         }
         else
         {
            mc.mcPlayer.mcWorker.visible = false;
         }
         if(this._invitePendingID && this._base == 3 && Boolean(this._mine))
         {
            mc.mcPlayer.mcInvite.visible = true;
         }
         else
         {
            mc.mcPlayer.mcInvite.visible = false;
         }
         if(MapRoom._viewOnly && this._baseID == MapRoom._inviteBaseID)
         {
            mc.mcPrompt.bYes.SetupKey("btn_yes");
            mc.mcPrompt.bNo.SetupKey("btn_no");
            mc.mcPrompt.bYes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               MapRoom.PreAcceptInvitation(MapRoom._mc as MovieClip);
            });
            mc.mcPrompt.bNo.addEventListener(MouseEvent.MOUSE_UP,MapRoom.RejectInvitation);
         }
      }
      
      internal function Tick(param1:int = 0) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         if(MapRoom._viewOnly)
         {
            mc.mcPlayer.mcWorker.visible = false;
            if(this._baseID == MapRoom._inviteBaseID)
            {
               if(this._over)
               {
                  mc.mcGlow.gotoAndStop(5);
               }
               else
               {
                  mc.mcGlow.gotoAndStop(6);
               }
               mc.mcPrompt.visible = true;
               mc.mcPrompt.enabled = true;
               mc.mcPrompt.mouseChildren = true;
            }
            else
            {
               mc.mcPrompt.visible = false;
               mc.mcPrompt.enabled = false;
               mc.mcPrompt.mouseChildren = false;
            }
            return true;
         }
         if(this._alliance)
         {
            this._alliance.Relations(ALLIANCES._allianceID);
         }
         --this._dataAge;
         if(this._inRange)
         {
            if(this._over)
            {
               mc.mcGlow.gotoAndStop(4);
            }
            else
            {
               mc.mcGlow.gotoAndStop(3);
            }
         }
         else if(this._over)
         {
            mc.mcGlow.gotoAndStop(2);
         }
         else
         {
            mc.mcGlow.gotoAndStop(1);
         }
         var _loc2_:Boolean = true;
         if(!this._mine)
         {
            mc.mcPlayer.mcWorker.visible = false;
            return true;
         }
         if(!this._updated)
         {
            return true;
         }
         if(Boolean(this._monsterData) && Boolean(this._resources))
         {
            if(Boolean(this._monsterData.finishtime) && this._monsterData.finishtime > GLOBAL.Timestamp())
            {
               this._workerBusy = true;
            }
            else
            {
               this._workerBusy = false;
            }
            if(!this._workerBusy && this._base == 3 && Boolean(this._mine))
            {
               mc.mcPlayer.mcWorker.visible = true;
            }
            else
            {
               mc.mcPlayer.mcWorker.visible = false;
            }
            this._ticks += 1;
            if(param1)
            {
               this._monsterData.saved = param1;
               this._hpMonsterData.saved = param1;
            }
            else
            {
               this._monsterData.saved = GLOBAL.Timestamp();
               this._hpMonsterData.saved = GLOBAL.Timestamp();
            }
            if(this._monsterData.hcount == 0)
            {
               return true;
            }
            if(this._monsterData.overdrivetime.Get() > 0)
            {
               this._monsterData.overdrivetime.Add(-1);
               --this._hpMonsterData.overdrivetime;
            }
            _loc3_ = 0;
            for(_loc4_ in this._monsterData.housed)
            {
               if(this._monsterData.housed[_loc4_].Get() > 0)
               {
                  _loc3_ += this._monsterData.housed[_loc4_].Get() * CREATURES.GetProperty(_loc4_,"cStorage");
               }
               else
               {
                  delete this._monsterData.housed[_loc4_];
                  delete this._hpMonsterData.housed[_loc4_];
               }
            }
            _loc5_ = 0;
            while(_loc5_ < this._monsterData.hcount)
            {
               _loc6_ = this._monsterData.h[_loc5_];
               _loc7_ = this._hpMonsterData.h[_loc5_];
               if(Boolean(this._monsterData.h[_loc5_]) && this._monsterData.h[_loc5_].length > 0)
               {
                  if(this._monsterData.hstage[_loc5_].Get() == 1)
                  {
                     if(this._monsterData.overdrivetime.Get() > 0 && this._monsterData.overdrivepower.Get() > 0)
                     {
                        this._monsterData.h[_loc5_][1].Add(-this._monsterData.overdrivepower.Get());
                        this._hpMonsterData.h[_loc5_][1] -= this._hpMonsterData.overdrivepower;
                        if(this._monsterData.h[_loc5_][1].Get() != this._hpMonsterData.h[_loc5_][1])
                        {
                        }
                        _loc2_ = false;
                     }
                     else
                     {
                        if(this._monsterData.h[_loc5_][1].Get() != this._hpMonsterData.h[_loc5_][1])
                        {
                        }
                        this._monsterData.h[_loc5_][1].Add(-1);
                        this._hpMonsterData.h[_loc5_][1] = this._monsterData.h[_loc5_][1].Get();
                        _loc2_ = false;
                     }
                  }
                  if(_loc6_[0] == "")
                  {
                     if(_loc6_.length > 2)
                     {
                        _loc8_ = this._monsterData.h[_loc5_][2];
                        _loc9_ = this._hpMonsterData.h[_loc5_][2];
                        if(_loc8_.length > 0)
                        {
                           _loc10_ = String(_loc8_[0][0]);
                           this._monsterData.h[_loc5_][2][0][1].Add(-1);
                           this._hpMonsterData.h[_loc5_][2][0][1] -= 1;
                           if(this._monsterData.h[_loc5_][2][0][1].Get() == 0)
                           {
                              this._monsterData.h[_loc5_][2].splice(0,1);
                              this._hpMonsterData.h[_loc5_][2].splice(0,1);
                           }
                           this._monsterData.h[_loc5_] = [_loc10_,new SecNum(CREATURES.GetProperty(_loc10_,"cTime").Get()),_loc8_];
                           this._hpMonsterData.h[_loc5_] = [_loc10_,CREATURES.GetProperty(_loc10_,"cTime").Get(),_loc9_];
                           this._monsterData.hstage[_loc5_].Set(1);
                           this._hpMonsterData.hstage[_loc5_] = 1;
                           _loc2_ = false;
                        }
                        else
                        {
                           this._monsterData.h[_loc5_] = [];
                           this._hpMonsterData.h[_loc5_] = [];
                           this._monsterData.hstage[_loc5_].Set(0);
                           this._hpMonsterData.hstage[_loc5_] = 0;
                        }
                     }
                     else
                     {
                        this._monsterData.h[_loc5_] = [];
                        this._hpMonsterData.h[_loc5_] = [];
                        this._monsterData.hstage[_loc5_].Set(0);
                        this._hpMonsterData.hstage[_loc5_] = 0;
                     }
                  }
                  else if(_loc6_[1].Get() <= 0 && (this._monsterData.hstage[_loc5_].Get() == 1 || this._monsterData.hstage[_loc5_].Get() == 2) && CREATURES.GetProperty(_loc6_[0],"cStorage") <= this._monsterData.space.Get() - _loc3_)
                  {
                     if(this._monsters[_loc6_[0]])
                     {
                        this._monsters[_loc6_[0]].Add(1);
                        this._hpMonsters[_loc6_[0]] += 1;
                        _loc2_ = false;
                     }
                     else
                     {
                        this._monsters[_loc6_[0]] = new SecNum(1);
                        this._hpMonsters[_loc6_[0]] = 1;
                        _loc2_ = false;
                     }
                     _loc3_ += CREATURES.GetProperty(_loc6_[0],"cStorage");
                     this.Indicate();
                     if(_loc6_.length > 2)
                     {
                        _loc8_ = _loc6_[2];
                        _loc9_ = _loc7_[2];
                        if(_loc8_.length > 0)
                        {
                           _loc10_ = String(_loc8_[0][0]);
                           _loc8_[0][1].Add(-1);
                           _loc9_[0][1] -= 1;
                           this._monsterData.h[_loc5_] = [_loc10_,new SecNum(CREATURES.GetProperty(_loc10_,"cTime").Get()),_loc8_];
                           this._hpMonsterData.h[_loc5_] = [_loc10_,CREATURES.GetProperty(_loc10_,"cTime").Get(),_loc9_];
                           if(_loc8_[0][1].Get() == 0)
                           {
                              _loc8_.splice(0,1);
                              _loc9_.splice(0,1);
                           }
                           this._monsterData.hstage[_loc5_].Set(1);
                           this._hpMonsterData.hstage[_loc5_] = 1;
                           _loc2_ = false;
                        }
                        else
                        {
                           this._monsterData.h[_loc5_] = [];
                           this._hpMonsterData.h[_loc5_] = [];
                           this._monsterData.hstage[_loc5_].Set(0);
                           this._hpMonsterData.hstage[_loc5_] = 0;
                        }
                     }
                     else
                     {
                        this._monsterData.h[_loc5_] = [];
                        this._hpMonsterData.h[_loc5_] = [];
                        this._monsterData.hstage[_loc5_].Set(0);
                        this._hpMonsterData.hstage[_loc5_] = 0;
                     }
                  }
                  else if(_loc6_[1].Get() <= 0 && (this._monsterData.hstage[_loc5_].Get() == 1 || this._monsterData.hstage[_loc5_].Get() == 2) && CREATURES.GetProperty(_loc6_[0],"cStorage") > this._monsterData.space.Get() - _loc3_)
                  {
                     this._monsterData.hstage[_loc5_].Set(2);
                     this._hpMonsterData.hstage[_loc5_] = 2;
                  }
               }
               else if(Boolean(this._monsterData.hcc) && this._monsterData.hcc.length > 0)
               {
                  this._monsterData.h[_loc5_] = [this._monsterData.hcc[0][0],new SecNum(CREATURES.GetProperty(this._monsterData.hcc[0][0],"cTime").Get())];
                  this._monsterData.hcc[0][1].Add(-1);
                  this._hpMonsterData.h[_loc5_] = [this._hpMonsterData.hcc[0][0],CREATURES.GetProperty(this._hpMonsterData.hcc[0][0],"cTime").Get()];
                  this._hpMonsterData.hcc[0][1] -= 1;
                  if(this._monsterData.hcc[0][1].Get() <= 0)
                  {
                     (this._monsterData.hcc as Array).shift();
                     (this._hpMonsterData.hcc as Array).shift();
                  }
                  this._monsterData.hstage[_loc5_].Set(1);
                  this._hpMonsterData.hstage[_loc5_] = 1;
                  _loc2_ = false;
               }
               _loc5_++;
            }
            if(_loc2_)
            {
               if(this._monsterData)
               {
                  this._monsterData.saved = GLOBAL.Timestamp();
                  this._hpMonsterData.saved = GLOBAL.Timestamp();
               }
            }
            return _loc2_;
         }
         return true;
      }
      
      private function Over(param1:MouseEvent) : void
      {
         this._over = true;
         if(MapRoom._viewOnly && this._baseID == MapRoom._inviteBaseID)
         {
            mc.mcGlow.gotoAndStop(5);
         }
         else if(this._inRange)
         {
            mc.mcGlow.gotoAndStop(4);
         }
         else
         {
            mc.mcGlow.gotoAndStop(2);
         }
         MapRoom._mc.ShowInfo(this);
      }
      
      private function Out(param1:MouseEvent) : void
      {
         this._over = false;
         if(MapRoom._viewOnly && this._baseID == MapRoom._inviteBaseID)
         {
            mc.mcGlow.gotoAndStop(6);
         }
         else if(this._inRange)
         {
            mc.mcGlow.gotoAndStop(3);
         }
         else
         {
            mc.mcGlow.gotoAndStop(1);
         }
      }
      
      public function Cleanup() : void
      {
         mc.mcHit.removeEventListener(MouseEvent.MOUSE_OVER,this.Over);
         mc.mcHit.removeEventListener(MouseEvent.MOUSE_OUT,this.Out);
         mc.mcHit.removeEventListener(MouseEvent.MOUSE_UP,this.Click);
         this._allianceID = 0;
         this._alliance = null;
      }
      
      private function SecureMonsterData() : void
      {
         var _loc1_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this._monsterData = {};
         this._monsterData.space = new SecNum(this._hpMonsterData.space);
         this._hpMonsterData.overdrivepower = Math.floor(this._hpMonsterData.overdrivepower);
         this._monsterData.overdrivepower = new SecNum(this._hpMonsterData.overdrivepower);
         this._hpMonsterData.overdrivetime = Math.floor(this._hpMonsterData.overdrivetime);
         this._monsterData.overdrivetime = new SecNum(this._hpMonsterData.overdrivetime);
         this._monsterData.saved = this._hpMonsterData.saved;
         this._monsterData.housed = {};
         for(_loc1_ in this._hpMonsterData.housed)
         {
            if(this._hpMonsterData.housed[_loc1_])
            {
               if(this._hpMonsterData.housed[_loc1_] <= 0)
               {
                  delete this._hpMonsterData.housed[_loc1_];
               }
               else
               {
                  this._hpMonsterData.housed[_loc1_] = Math.floor(this._hpMonsterData.housed[_loc1_]);
                  this._monsterData.housed[_loc1_] = new SecNum(this._hpMonsterData.housed[_loc1_]);
               }
            }
         }
         this._monsterData.hcount = this._hpMonsterData.hcount;
         this._monsterData.h = [];
         this._monsterData.hstage = [];
         if(this._hpMonsterData.hstage == null)
         {
            this._hpMonsterData.hstage = [];
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._monsterData.hcount)
         {
            this._monsterData.h[_loc2_] = [];
            if(Boolean(this._hpMonsterData.hstage) && this._hpMonsterData.hstage.length > _loc2_)
            {
               this._monsterData.hstage[_loc2_] = new SecNum(this._hpMonsterData.hstage[_loc2_]);
            }
            else
            {
               this._monsterData.hstage[_loc2_] = new SecNum(0);
               this._hpMonsterData.hstage[_loc2_] = 0;
            }
            if(Boolean(this._hpMonsterData.h) && Boolean(this._hpMonsterData.h[_loc2_]) && this._hpMonsterData.h[_loc2_].length > 0)
            {
               this._monsterData.h[_loc2_][0] = this._hpMonsterData.h[_loc2_][0];
               this._monsterData.h[_loc2_][1] = new SecNum(this._hpMonsterData.h[_loc2_][1]);
               if(this._monsterData.h[_loc2_][1].Get() != this._hpMonsterData.h[_loc2_][1])
               {
               }
               if(this._hpMonsterData.h[_loc2_].length > 2)
               {
                  this._monsterData.h[_loc2_][2] = [];
                  _loc5_ = int(this._hpMonsterData.h[_loc2_][2].length);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_)
                  {
                     this._monsterData.h[_loc2_][2][_loc6_] = [];
                     this._monsterData.h[_loc2_][2][_loc6_][0] = this._hpMonsterData.h[_loc2_][2][_loc6_][0];
                     this._hpMonsterData.h[_loc2_][2][_loc6_][1] = Math.floor(this._hpMonsterData.h[_loc2_][2][_loc6_][1]);
                     this._monsterData.h[_loc2_][2][_loc6_][1] = new SecNum(this._hpMonsterData.h[_loc2_][2][_loc6_][1]);
                     _loc6_++;
                  }
               }
            }
            _loc2_++;
         }
         this._monsterData.hcc = [];
         var _loc3_:int = int(this._hpMonsterData.hcc.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(Boolean(this._hpMonsterData.hcc) && Boolean(this._hpMonsterData.hcc[_loc4_]) && this._hpMonsterData.hcc[_loc4_].length >= 2)
            {
               this._hpMonsterData.hcc[_loc4_][1] = Math.floor(this._hpMonsterData.hcc[_loc4_][1]);
               this._monsterData.hcc[_loc4_] = [this._hpMonsterData.hcc[_loc4_][0],new SecNum(this._hpMonsterData.hcc[_loc4_][1])];
            }
            _loc4_++;
         }
      }
      
      private function Click(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(Boolean(MapRoom._mc) && MapRoom._mc._dragged)
         {
            return;
         }
         if(MapRoom._inviteBaseID == this._baseID)
         {
            return;
         }
         MapRoom._currentPosition = new Point(this.X,this.Y);
         if(GLOBAL._local)
         {
            _loc2_ = "MapRoomCell.Click - X " + this.X + " Y " + this.Y + " H " + this._height + " B " + this._base + " ID " + this._baseID + " UID " + this._userID + " FBID " + this._facebookID + " Mine " + this._mine + " Name " + this._name + " d " + this._destroyed + " dm " + this._damage + " p " + this._protected + " fr " + this._friend + " busy " + this._workerBusy;
            if(this._flingerRange)
            {
               _loc2_ += " f " + this._flingerRange.Get();
            }
            if(this._hpMonsterData)
            {
               _loc2_ += " monsterdata " + JSON.encode(this._hpMonsterData);
            }
            if(this._hpResources)
            {
               _loc2_ += " resources " + JSON.encode(this._hpResources);
            }
         }
         MapRoom.TransferMonstersB(this);
         if(MapRoom._viewOnly && this._base > 0)
         {
            MapRoom._mc.ShowInfoViewOnly(this);
         }
         else if(this._base > 0 && !MapRoom._monsterTransferInProgress)
         {
            if(this._mine)
            {
               MapRoom._mc.ShowInfoMine(this);
            }
            else
            {
               MapRoom._mc.ShowInfoEnemy(this);
            }
         }
      }
      
      public function Check() : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._updated)
         {
            return true;
         }
         if(!this._processed)
         {
            return true;
         }
         if(!this._mine)
         {
            return true;
         }
         if(!this._monsterData || !this._hpMonsterData)
         {
            return true;
         }
         var _loc1_:Boolean = true;
         var _loc2_:String = "err";
         if(this._monsterData.overdrivepower.Get() != this._hpMonsterData.overdrivepower)
         {
            LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") overdrive power " + this._monsterData.overdrivepower.Get() + " " + this._hpMonsterData.overdrivepower);
            _loc1_ = false;
         }
         if(this._monsterData.overdrivetime.Get() != this._hpMonsterData.overdrivetime)
         {
            LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") overdrive time " + this._monsterData.overdrivetime.Get() + " " + this._hpMonsterData.overdrivetime);
            _loc1_ = false;
         }
         for(_loc3_ in this._hpMonsterData.housed)
         {
            if(Boolean(this._monsterData.housed[_loc3_]) && this._monsterData.housed[_loc3_].Get() != this._hpMonsterData.housed[_loc3_])
            {
               LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") housed " + _loc3_ + " " + this._monsterData.housed[_loc3_] + " " + this._hpMonsterData.housed[_loc3_]);
               _loc1_ = false;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < this._monsterData.hcount)
         {
            if(this._monsterData.h[_loc4_].length != this._hpMonsterData.h[_loc4_].length)
            {
               LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") hatchery array length mismatch " + this._monsterData.h[_loc4_].length + " " + this._hpMonsterData.h[_loc4_].length);
               _loc1_ = false;
            }
            else if(this._monsterData.h[_loc4_].length >= 2)
            {
               if(this._monsterData.h[_loc4_][1].Get() != this._hpMonsterData.h[_loc4_][1])
               {
                  LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") num monsters producing (now) " + this._monsterData.h[_loc4_][1].Get() + " " + this._hpMonsterData.h[_loc4_][1]);
                  _loc1_ = false;
               }
               if(this._monsterData.h[_loc4_].length > 2)
               {
                  if(this._monsterData.h[_loc4_][2].length != this._hpMonsterData.h[_loc4_][2].length)
                  {
                     _loc1_ = false;
                  }
                  _loc6_ = int(this._monsterData.h[_loc4_][2].length);
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     if(this._monsterData.h[_loc4_][2][_loc7_][1].Get() != this._hpMonsterData.h[_loc4_][2][_loc7_][1])
                     {
                        LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") num monsters producing (now) " + this._monsterData.h[_loc4_][2][_loc7_][1].Get() + " " + this._hpMonsterData.h[_loc4_][2][_loc7_][1]);
                        _loc1_ = false;
                     }
                     _loc7_++;
                  }
               }
            }
            if(this._monsterData.hstage[_loc4_].Get() != this._hpMonsterData.hstage[_loc4_])
            {
               LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") production stage mismatch");
            }
            _loc4_++;
         }
         var _loc5_:int;
         if((_loc5_ = int(this._monsterData.hcc.length)) != this._hpMonsterData.hcc.length)
         {
            LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") HCC queue length mismatch " + _loc5_ + " " + this._hpMonsterData.hcc.length);
            _loc1_ = false;
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               if(this._monsterData.hcc[_loc8_][1].Get() != this._hpMonsterData.hcc[_loc8_][1])
               {
                  LOGGER.Log(_loc2_,"MapRoomCell.Check (" + this.X + "," + this.Y + ") HCC queue size " + this._monsterData.hcc[_loc8_][1].Get() + " " + this._hpMonsterData.hcc[_loc8_][1]);
                  _loc1_ = false;
               }
               _loc8_++;
            }
         }
         return _loc1_;
      }
      
      private function Indicate() : void
      {
      }
      
      private function SmokeAdd() : void
      {
         this.SmokeRemove();
         var _loc1_:MovieClip = new MovieClip();
         _loc1_.addChild(new Bitmap(MapRoom._smokeBMD));
         _loc1_.x = -10;
         _loc1_.y = -90;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         this._smokeDO = mc.mcPlayer.addChild(_loc1_);
         mc.mcPlayer.mouseChildren = false;
      }
      
      private function SmokeRemove() : void
      {
         if(Boolean(this._smokeDO) && Boolean(this._smokeDO.parent))
         {
            this._smokeDO.parent.removeChild(this._smokeDO);
         }
      }
      
      internal function get isMainBase() : Boolean
      {
         return this._base == 2;
      }
      
      private function SetupAlliance() : void
      {
         var _loc1_:int = 0;
         mc.mcPlayer.mcFlag.visible = false;
         mc.mcPlayer.mcFlag.pic.visible = false;
         mc.mcPlayer.mcFlag.gotoAndStop("noAlliance");
         mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("none");
         mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("none");
         mc.mcPlayer.mcFlag.pic.visible = false;
         if(this._allianceID)
         {
            mc.mcPlayer.mcFlag.gotoAndStop("inAllianceNoPic");
            _loc1_ = int(mc.mcPlayer.mcFlag.pic.mcImage.numChildren);
            while(_loc1_--)
            {
               mc.mcPlayer.mcFlag.pic.mcImage.removeChildAt(_loc1_);
            }
            if(this._alliance)
            {
               mc.mcPlayer.mcFlag.visible = true;
               if(Boolean(this._alliance.relationship) || this._alliance.relationship == 0)
               {
                  switch(this._alliance.relationship)
                  {
                     case -1:
                        mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("hostile");
                        mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("hostile");
                        break;
                     case 1:
                        mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("friendly");
                        mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("friendly");
                        break;
                     case 4:
                        mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("ally");
                        mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("ally");
                        break;
                     case 5:
                        mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("leader");
                        mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("leader");
                        break;
                     default:
                        mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("neutral");
                        mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("neutral");
                  }
               }
            }
         }
         else
         {
            mc.mcPlayer.mcFlag.gotoAndStop("noAlliance");
            mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("none");
            mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("none");
            mc.mcPlayer.mcFlag.pic.visible = false;
            mc.mcPlayer.mcFlag.visible = true;
         }
         if(this._base > 0)
         {
            mc.mcPlayer.mcFlag.gotoAndStop("noAlliance");
            if(this._base == 1)
            {
               mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("wmyard");
               mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("wmyard");
               mc.mcPlayer.mcFlag.pic.visible = false;
            }
            else if(this._base == 2 || this._base == 3)
            {
               if(this._mine)
               {
                  mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("player");
                  mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("player");
               }
               else if(!this._allianceID)
               {
                  mc.mcPlayer.mcFlag.nameBar.mcBar.gotoAndStop("none");
                  mc.mcPlayer.mcFlag.nameBar.mcBG.gotoAndStop("none");
               }
            }
            mc.mcPlayer.mcFlag.visible = true;
         }
      }
   }
}
