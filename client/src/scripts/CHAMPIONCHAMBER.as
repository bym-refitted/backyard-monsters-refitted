package
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.monsters.champions.ChampionBase;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import gs.easing.*;
   
   public class CHAMPIONCHAMBER extends BFOUNDATION
   {
      
      public static const TYPE:uint = 119;
      
      public static var _open:Boolean = false;
      
      public static var _popup:CHAMPIONCHAMBERPOPUP;
       
      
      public var _frozen:Array;
      
      public function CHAMPIONCHAMBER()
      {
         this._frozen = [];
         super();
         _type = 119;
         _footprint = [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         SetProps();
      }
      
      public static function HasFrozen(param1:int) : Boolean
      {
         var _loc2_:CHAMPIONCHAMBER = null;
         var _loc3_:int = 0;
         if(GLOBAL._bChamber)
         {
            _loc2_ = GLOBAL._bChamber as CHAMPIONCHAMBER;
            _loc3_ = 0;
            while(_loc3_ < _loc2_._frozen.length)
            {
               if(_loc2_._frozen[_loc3_].t == param1)
               {
                  return true;
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      public static function Show() : void
      {
         var _loc2_:int = 0;
         var _loc1_:CHAMPIONCHAMBER = GLOBAL._bChamber as CHAMPIONCHAMBER;
         if(CREATURES._guardian == null && (_loc1_ && _loc1_._frozen.length == 0))
         {
            GLOBAL.Message(KEYS.Get("msg_chamber_nochamp"));
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < BASE._guardianData.length)
         {
            _loc2_ = !!BASE._guardianData[_loc3_].status ? int(BASE._guardianData[_loc3_].status) : ChampionBase.k_CHAMPION_STATUS_NORMAL;
            if(BASE._guardianData[_loc3_] && _loc2_ == ChampionBase.k_CHAMPION_STATUS_NORMAL && CREATURES._guardian == null)
            {
               GLOBAL._bCage.SpawnGuardian(BASE._guardianData[_loc3_].l.Get(),BASE._guardianData[_loc3_].fd,BASE._guardianData[_loc3_].ft,BASE._guardianData[_loc3_].t,BASE._guardianData[_loc3_].hp.Get(),BASE._guardianData[_loc3_].nm,BASE._guardianData[_loc3_].fb.Get(),BASE._guardianData[_loc3_].pl.Get());
            }
            _loc3_++;
         }
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            _popup = GLOBAL._layerWindows.addChild(new CHAMPIONCHAMBERPOPUP()) as CHAMPIONCHAMBERPOPUP;
            _popup.Center();
            _popup.ScaleUp();
         }
      }
      
      public static function Hide() : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            _open = false;
            if(_popup)
            {
               GLOBAL._layerWindows.removeChild(_popup);
               _popup = null;
            }
         }
      }
      
      override public function PlaceB() : void
      {
         super.PlaceB();
         GLOBAL._bChamber = this;
      }
      
      override public function Constructed() : void
      {
         super.Constructed();
         GLOBAL._bChamber = this;
      }
      
      override public function Recycle() : void
      {
         if(Boolean(this._frozen) && this._frozen.length > 0)
         {
            GLOBAL.Message(KEYS.Get("bdg_chamber_recycle"));
         }
         else
         {
            GLOBAL._bChamber = null;
            super.Recycle();
         }
      }
      
      public function FreezeGuardian() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(CREATURES._guardian)
         {
            if(CREATURES._guardian.health < CREATURES._guardian.maxHealth)
            {
               GLOBAL.Message(KEYS.Get("bdg_chamber_injured"));
               return;
            }
            if(CREATURES._guardian._feedTime.Get() < GLOBAL.Timestamp())
            {
               GLOBAL.Message(KEYS.Get("bdg_chamber_hungry"));
               return;
            }
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < BASE._guardianData.length)
            {
               if(BASE._guardianData[_loc2_].t == CREATURES._guardian._type)
               {
                  _loc1_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            LOGGER.Stat([69,BASE._guardianData[_loc1_].t,BASE._guardianData[_loc1_].l.Get()]);
            BASE._guardianData[_loc1_].ft -= GLOBAL.Timestamp();
            CREATURES._guardian.export();
            CREATURES._guardian.changeModeFreeze();
            this._frozen.push(BASE._guardianData[_loc1_]);
            BASE._guardianData[_loc1_].status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
            BASE._guardianData[_loc1_].log += "," + ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               _loc3_ = GLOBAL.getPlayerGuardianIndex(CREATURES._guardian._type);
               if(_loc3_ != -1 && GLOBAL._playerGuardianData[_loc3_] != BASE._guardianData[_loc1_])
               {
                  GLOBAL._playerGuardianData[_loc3_].status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
                  GLOBAL._playerGuardianData[_loc3_].log += "," + ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
                  GLOBAL._playerGuardianData[_loc3_].ft -= GLOBAL.Timestamp();
               }
            }
            CREATURES._guardian = null;
            BASE.Save();
         }
      }
      
      public function ThawGuardian(param1:int) : void
      {
         var i:int;
         var StreamPost:Function;
         var p:Point = null;
         var level:int = 0;
         var target:Point = null;
         var newFrozen:Array = null;
         var j:int = 0;
         var spawnClass:Class = null;
         var obj:Object = null;
         var mc:popup_monster = null;
         var type:int = param1;
         if(health < maxHealth)
         {
            GLOBAL.Message(KEYS.Get("bdg_chamber_damaged"));
            return;
         }
         if(CREATURES._guardian)
         {
            GLOBAL.Message(KEYS.Get("bdg_chamber_freeze"));
            return;
         }
         i = 0;
         while(i < this._frozen.length)
         {
            if(this._frozen[i].t == type)
            {
               p = new Point(x,y + 80);
               level = int(this._frozen[i].l.Get());
               target = GRID.FromISO(GLOBAL._bCage.x,GLOBAL._bCage.y + 20);
               newFrozen = [];
               j = 0;
               while(j < this._frozen.length)
               {
                  if(i != j)
                  {
                     newFrozen.push(this._frozen[j]);
                  }
                  j++;
               }
               spawnClass = CHAMPIONCAGE.getGuardianSpawnClass(type);
               CREATURES._guardian = new spawnClass("cage",p,0,target,true,this,this._frozen[i].l.Get(),this._frozen[i].fd,this._frozen[i].ft + GLOBAL.Timestamp(),this._frozen[i].t,this._frozen[i].hp.Get(),this._frozen[i].fb.Get(),this._frozen[i].pl.Get());
               for each(obj in BASE._guardianData)
               {
                  if(obj.t == type)
                  {
                     obj.status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
                     obj.log += "," + ChampionBase.k_CHAMPION_STATUS_NORMAL.toString();
                     break;
                  }
               }
               for each(obj in GLOBAL._playerGuardianData)
               {
                  if(obj.t == type)
                  {
                     obj.status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
                     obj.log += "," + ChampionBase.k_CHAMPION_STATUS_NORMAL.toString();
                     break;
                  }
               }
               CREATURES._guardian.export();
               CREATURES._guardian.changeModeCage();
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  MAP._BUILDINGTOPS.addChild(CREATURES._guardian.graphic);
               }
               this._frozen = newFrozen;
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  StreamPost = function(param1:String, param2:String, param3:String):Function
                  {
                     var st:String = param1;
                     var sd:String = param2;
                     var im:String = param3;
                     return function(param1:MouseEvent = null):void
                     {
                        GLOBAL.CallJS("sendFeed",["unlock-end",st,sd,im,0]);
                        POPUPS.Next();
                     };
                  };
                  mc = new popup_monster();
                  mc.bSpeedup.SetupKey("btn_warnyourfriends");
                  mc.bSpeedup.addEventListener(MouseEvent.CLICK,StreamPost(KEYS.Get("chamber_thawstreamtitle",{"v1":CHAMPIONCAGE._guardians["G" + type].name}),KEYS.Get("chamber_thawstreamdesc",{"v1":CHAMPIONCAGE._guardians["G" + type].name}),"G" + type + "_L6-90.png"));
                  mc.bSpeedup.Highlight = true;
                  mc.bAction.visible = false;
                  mc.tText.htmlText = KEYS.Get("chamber_thawstreamdesc",{"v1":CHAMPIONCAGE._guardians["G" + type].name});
                  POPUPS.Push(mc,null,null,null,"G" + type + "_L" + level + "-150.png");
               }
               LOGGER.Stat([70,CREATURES._guardian._type,CREATURES._guardian._level.Get()]);
               BASE.Save();
               break;
            }
            i++;
         }
      }
      
      override public function Setup(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:Dictionary = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super.Setup(param1);
         if(param1.fz)
         {
            _loc3_ = decodeJson(param1.fz) as Array;
            this._frozen = [];
            _loc4_ = new Dictionary();
            _loc5_ = null;
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc8_];
               for each(_loc2_ in BASE._guardianData)
               {
                  if(_loc2_.t == _loc6_.t)
                  {
                     _loc5_ = _loc2_;
                     break;
                  }
               }
               if(_loc5_ == null)
               {
                  _loc5_ = {};
                  if(_loc6_.nm)
                  {
                     _loc5_.nm = _loc6_.nm;
                  }
                  _loc5_.t = _loc6_.t;
                  if(_loc6_.ft)
                  {
                     _loc5_.ft = _loc6_.ft;
                  }
                  if(_loc6_.fd)
                  {
                     _loc5_.fd = _loc6_.fd;
                  }
                  else
                  {
                     _loc5_.fd = 0;
                  }
                  if(_loc6_.l)
                  {
                     _loc5_.l = new SecNum(_loc6_.l);
                  }
                  else
                  {
                     _loc5_.l = new SecNum(0);
                  }
                  if(_loc6_.hp)
                  {
                     _loc5_.hp = new SecNum(_loc6_.hp);
                  }
                  else
                  {
                     _loc5_.hp = new SecNum(0);
                  }
                  if(_loc6_.fb)
                  {
                     _loc5_.fb = new SecNum(_loc6_.fb);
                  }
                  else
                  {
                     _loc5_.fb = new SecNum(0);
                  }
                  if(_loc6_.pl)
                  {
                     _loc5_.pl = new SecNum(_loc6_.pl);
                  }
                  else
                  {
                     _loc5_.pl = new SecNum(0);
                  }
                  _loc5_.status = ChampionBase.k_CHAMPION_STATUS_FROZEN;
                  _loc5_.log = ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
                  BASE._guardianData.push(_loc5_);
                  if(GLOBAL.getPlayerGuardianIndex(_loc5_.t) == -1)
                  {
                     GLOBAL._playerGuardianData.push(_loc5_);
                  }
               }
               _loc4_[_loc5_.t] = true;
               if(_loc5_.status == ChampionBase.k_CHAMPION_STATUS_FROZEN)
               {
                  this._frozen.push(_loc5_);
               }
               _loc5_ = null;
               _loc8_++;
            }
            for each(_loc2_ in BASE._guardianData)
            {
               if(_loc2_.status == ChampionBase.k_CHAMPION_STATUS_FROZEN && !_loc4_[_loc2_.t])
               {
                  this._frozen.push(_loc2_);
               }
            }
         }
         else
         {
            for each(_loc2_ in BASE._guardianData)
            {
               if(_loc2_.status == ChampionBase.k_CHAMPION_STATUS_FROZEN)
               {
                  this._frozen.push(_loc2_);
               }
            }
         }
      }
      
      override public function Export() : Object
      {
         var _loc4_:Object = null;
         var _loc6_:Object = null;
         var _loc1_:Object = super.Export();
         var _loc2_:Boolean = false;
         var _loc3_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < this._frozen.length)
         {
            for each(_loc4_ in BASE._guardianData)
            {
               if(_loc4_.t == this._frozen[_loc5_].t)
               {
                  _loc2_ = true;
                  break;
               }
            }
            if(!_loc2_)
            {
               _loc4_ = null;
            }
            _loc6_ = {};
            if(this._frozen[_loc5_].nm)
            {
               _loc6_.nm = this._frozen[_loc5_].nm;
            }
            if(this._frozen[_loc5_].t)
            {
               _loc6_.t = this._frozen[_loc5_].t;
            }
            if(this._frozen[_loc5_].hp)
            {
               _loc6_.hp = this._frozen[_loc5_].hp.Get();
            }
            else
            {
               _loc6_.hp = 0;
            }
            if(this._frozen[_loc5_].l)
            {
               _loc6_.l = this._frozen[_loc5_].l.Get();
            }
            if(this._frozen[_loc5_].ft)
            {
               _loc6_.ft = this._frozen[_loc5_].ft;
            }
            if(this._frozen[_loc5_].fd)
            {
               _loc6_.fd = this._frozen[_loc5_].fd;
            }
            else
            {
               _loc6_.fd = 0;
            }
            if(this._frozen[_loc5_].fb)
            {
               _loc6_.fb = this._frozen[_loc5_].fb.Get();
            }
            else
            {
               _loc6_.fb = 0;
            }
            if(this._frozen[_loc5_].pl)
            {
               if(this._frozen[_loc5_].pl is SecNum)
               {
                  _loc6_.pl = this._frozen[_loc5_].pl.Get();
               }
               else
               {
                  _loc6_.pl = this._frozen[_loc5_].pl;
               }
            }
            else
            {
               _loc6_.pl = 0;
            }
            _loc6_.status = !!_loc4_ ? ChampionBase.k_CHAMPION_STATUS_MIGRATED : ChampionBase.k_CHAMPION_STATUS_FROZEN;
            _loc6_.log = !!_loc4_ ? _loc4_.log : ChampionBase.k_CHAMPION_STATUS_FROZEN.toString();
            _loc3_.push(_loc6_);
            _loc5_++;
         }
         _loc1_.fz = encodeJson(_loc3_);
         return _loc1_;
      }
   }
}
