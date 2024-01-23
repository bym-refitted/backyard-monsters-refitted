package
{
   import com.cc.utils.SecNum;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class MONSTERLAB extends BFOUNDATION
   {
      
      public static var _open:Boolean = false;
      
      public static var _mcPopup:MONSTERLABPOPUP;
      
      public static var _powerupProps:Object = {};
       
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _frameNumber:int;
      
      public var _animBitmap:BitmapData;
      
      public var _upgradeLevel:int = 0;
      
      public var _upgradeFinishTime:SecNum;
      
      public var _streamUpgradeCache:String = "";
      
      public function MONSTERLAB()
      {
         super();
         _type = 116;
         _footprint = [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         this.SetProps();
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            SOUNDS.Play("close");
            BASE.BuildingDeselect();
            _open = false;
            GLOBAL._layerWindows.removeChild(_mcPopup);
            _mcPopup = null;
         }
      }
      
      public static function GetPuttyCost(param1:String, param2:int) : int
      {
         if(_powerupProps)
         {
            if(_powerupProps[param1])
            {
               return _powerupProps[param1].costs[param2 - 1][0];
            }
         }
         return 0;
      }
      
      public static function GetTimeCost(param1:String, param2:int) : int
      {
         if(_powerupProps)
         {
            if(_powerupProps[param1])
            {
               return _powerupProps[param1].costs[param2 - 1][1];
            }
         }
         return 0;
      }
      
      public static function GetShinyCost(param1:String, param2:int) : int
      {
         var _loc3_:int = STORE.GetTimeCost(GetTimeCost(param1,param2),false);
         var _loc4_:int = Math.ceil(Math.pow(Math.sqrt(GetPuttyCost(param1,param2) / 2),0.75));
         return _loc3_ + _loc4_;
      }
      
      override public function SetProps() : void
      {
         super.SetProps();
         _powerupProps = {
            "C3":{
               "name":"lab_boltname",
               "order":1,
               "description":"lab_boltdesc_main",
               "ability":"Blink Range",
               "upgrade_description":"lab_boltdesc_upgrade",
               "stream":["lab_boltstream","lab_boltstream_unlock","lab_boltstream_upgrade"],
               "streampic":"lab_bolt.png",
               "costs":[[48000,60 * 60 * 24],[72000,60 * 60 * 24],[108000,60 * 60 * 24]],
               "effect":[150,300,450]
            },
            "C4":{
               "name":"lab_finkname",
               "order":2,
               "description":"lab_finkdesc_main",
               "ability":"Extra Target(s)",
               "upgrade_description":"lab_finkdesc_upgrade",
               "stream":["lab_finkstream","lab_finkstream_unlock","lab_finkstream_upgrade"],
               "streampic":"lab_fink5.png",
               "costs":[[96000,60 * 60 * 30],[128000,60 * 60 * 30],[144000,60 * 60 * 30]],
               "effect":[1,2,3]
            },
            "C7":{
               "name":"lab_banditoname",
               "order":3,
               "description":"lab_banditodesc_main",
               "ability":"Whirlwind",
               "upgrade_description":"lab_banditodesc_upgrade",
               "stream":["lab_banditostream","lab_banditostream_unlock","lab_banditostream_upgrade"],
               "streampic":"lab_bandito.png",
               "costs":[[1000000,60 * 60 * 32],[1500000,60 * 60 * 32],[2000000,60 * 60 * 32]],
               "effect":[1,1.5,2]
            },
            "C8":{
               "name":"lab_fangname",
               "order":4,
               "description":"lab_fangdesc_main",
               "ability":"Venom Damage",
               "upgrade_description":"lab_fangdesc_upgrade",
               "stream":["lab_fangstream","lab_fangstream_unlock","lab_fangstream_upgrade"],
               "streampic":"lab_fang5.png",
               "costs":[[2000000,60 * 60 * 36],[3000000,60 * 60 * 36],[4500000,60 * 60 * 36]],
               "effect":[0.1,0.2,0.3]
            },
            "C5":{
               "name":"lab_eyeraname",
               "order":5,
               "description":"lab_eyeradesc_main",
               "ability":"Airburst Bonus",
               "upgrade_description":"lab_eyeradesc_upgrade",
               "stream":["lab_eyerastream","lab_eyerastream_unlock","lab_eyerastream_upgrade"],
               "streampic":"lab_eyera5.png",
               "costs":[[3560000,60 * 60 * 48],[4120000,60 * 60 * 54],[5120000,60 * 60 * 60]],
               "effect":[0.2,0.3,0.4]
            },
            "C9":{
               "name":"lab_brainname",
               "order":6,
               "description":"lab_braindesc_main",
               "ability":"s Cloak Delay",
               "upgrade_description":"lab_braindesc_upgrade",
               "stream":["lab_brainstream","lab_brainstream_unlock","lab_brainstream_upgrade"],
               "streampic":"lab_brain.png",
               "costs":[[3000000,60 * 60 * 48],[4500000,60 * 60 * 48],[6000000,60 * 60 * 48]],
               "effect":[0,4,8]
            },
            "C11":{
               "name":"lab_projectxname",
               "order":7,
               "description":"lab_projectxdesc_main",
               "ability":"Acid Damage",
               "upgrade_description":"lab_projectxdesc_upgrade",
               "stream":["lab_projxstream","lab_projxstream_unlock","lab_projxstream_upgrade"],
               "streampic":"lab_projectx.png",
               "costs":[[8000000,60 * 60 * 72],[12000000,60 * 60 * 72],[18000000,60 * 60 * 72]],
               "effect":[1,2,3]
            },
            "C12":{
               "name":"lab_davename",
               "order":10,
               "description":"lab_davedesc_main",
               "ability":"Rocket Range",
               "upgrade_description":"lab_davedesc_upgrade",
               "stream":["lab_davestream","lab_davestream_unlock","lab_davestream_upgrade"],
               "streampic":"lab_dave.png",
               "costs":[[15000000,60 * 60 * 144],[22500000,60 * 60 * 144],[33750000,60 * 60 * 144]],
               "effect":[140,180,220]
            },
            "C13":{
               "name":"lab_wormzername",
               "order":8,
               "description":"lab_wormzerdesc_main",
               "ability":"Splash Damage",
               "upgrade_description":"lab_wormzerdesc_upgrade",
               "stream":["lab_wormstream","lab_wormstream_unlock","lab_wormstream_upgrade"],
               "streampic":"lab_wormzer.png",
               "costs":[[10000000,60 * 60 * 96],[15000000,60 * 60 * 96],[22500000,60 * 60 * 96]],
               "effect":[1,2,3]
            },
            "C14":{
               "name":"lab_teratornname",
               "order":9,
               "description":"lab_teratorndesc_main",
               "ability":"Fireball Bounces",
               "upgrade_description":"lab_teratorndesc_upgrade",
               "stream":["lab_terastream","lab_terastream_unlock","lab_terastream_upgrade"],
               "streampic":"lab_teratorn.png",
               "costs":[[12000000,60 * 60 * 120],[18000000,60 * 60 * 120],[27000000,60 * 60 * 120]],
               "effect":[1,2,3]
            }
         };
      }
      
      override public function Click(param1:MouseEvent = null) : void
      {
         if(Boolean(_upgrading) && (!this._upgradeFinishTime || this._upgradeFinishTime.Get() == 0))
         {
            _upgrading = null;
         }
         super.Click(param1);
      }
      
      override public function Tick(param1:int) : void
      {
         super.Tick(param1);
         if(Boolean(_upgrading) && GLOBAL.Timestamp() >= this._upgradeFinishTime.Get())
         {
            this.FinishMonsterPowerup();
         }
         if(_open)
         {
            (_mcPopup as MONSTERLABPOPUP).Tick();
         }
      }
      
      override public function TickFast(param1:Event = null) : void
      {
         super.TickFast(param1);
         if(_upgrading && GLOBAL._render && _countdownBuild.Get() + _countdownUpgrade.Get() == 0)
         {
            if((GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == "help" || GLOBAL.mode == "view") && this._frameNumber % 3 == 0 && CREEPS._creepCount == 0)
            {
               AnimFrame(true);
            }
            else if(this._frameNumber % 10 == 0)
            {
               AnimFrame(true);
            }
         }
         ++this._frameNumber;
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         GLOBAL._bLab = this;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function():void
            {
               GLOBAL.CallJS("sendFeed",["monsterlab-construct",KEYS.Get("pop_labbuilt_streamtitle"),KEYS.Get("pop_labbuilt_streambody"),"build-monsterlab.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_labbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_labbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
      
      override public function Upgrade() : Boolean
      {
         if(_upgrading)
         {
            GLOBAL.Message(KEYS.Get("lab_err_cantupgrade"));
            return false;
         }
         return super.Upgrade();
      }
      
      override public function Recycle() : void
      {
         if(_upgrading)
         {
            GLOBAL.Message(KEYS.Get("lab_err_cantrecycle"));
         }
         else
         {
            GLOBAL._bAcademy = null;
            super.Recycle();
         }
      }
      
      public function Show() : void
      {
         if(!_open)
         {
            _open = true;
            GLOBAL.BlockerAdd();
            _mcPopup = GLOBAL._layerWindows.addChild(new MONSTERLABPOPUP()) as MONSTERLABPOPUP;
            _mcPopup.Center();
            _mcPopup.ScaleUp();
         }
      }
      
      public function CanPowerup(param1:String, param2:int) : Object
      {
         if(GLOBAL.player.m_upgrades[param1] == null)
         {
            return {
               "error":true,
               "errorString":"Not Unlocked"
            };
         }
         if(Boolean(GLOBAL.player.m_upgrades[param1]) && GLOBAL.player.m_upgrades[param1].powerup == 3)
         {
            return {
               "error":true,
               "errorString":"Fully Powered Up"
            };
         }
         if(param2 > _lvl.Get())
         {
            return {
               "error":true,
               "errorString":"Upgrade Monster Lab"
            };
         }
         if(CREATURELOCKER._lockerData[param1] == null)
         {
            return {
               "error":true,
               "errorString":"Not Unlocked"
            };
         }
         if(CREATURELOCKER._lockerData[param1].t < 2)
         {
            return {
               "error":true,
               "errorString":"Not Unlocked"
            };
         }
         if(GLOBAL.player.m_upgrades[param1].level < param2 + 1)
         {
            return {
               "error":true,
               "errorString":"Needs Training"
            };
         }
         if(!BASE.Charge(3,_powerupProps[param1].costs[param2 - 1][0],true))
         {
            return {
               "error":true,
               "errorString":KEYS.Get("acad_err_putty")
            };
         }
         return {"error":false};
      }
      
      public function StartMonsterPowerup(param1:String, param2:int) : void
      {
         if(this.CanPowerup(param1,param2).error)
         {
            return;
         }
         BASE.Charge(3,GetPuttyCost(param1,param2));
         _upgrading = param1;
         this._upgradeFinishTime = new SecNum(GLOBAL.Timestamp() + GetTimeCost(param1,param2));
         this._upgradeLevel = param2;
         BASE.Save();
         LOGGER.Stat([49,param1.substr(1),param2]);
      }
      
      public function FinishMonsterPowerup() : void
      {
         var Post:Function;
         var monsterName:String = null;
         var powerName:String = null;
         var popupMC:popup_monster = null;
         var wasUpgrading:String = _upgrading;
         this._upgradeFinishTime = new SecNum(0);
         GLOBAL.player.m_upgrades[_upgrading].powerup = this._upgradeLevel;
         LOGGER.Stat([50,_upgrading.substr(1),this._upgradeLevel]);
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            Post = function():void
            {
               if(_upgradeLevel == 1)
               {
                  GLOBAL.CallJS("sendFeed",["lab-powerup",KEYS.Get(_powerupProps[_streamUpgradeCache].stream[0]),KEYS.Get(_powerupProps[_streamUpgradeCache].stream[1],{"v1":powerName}),_powerupProps[_streamUpgradeCache].streampic,0]);
               }
               else
               {
                  GLOBAL.CallJS("sendFeed",["lab-powerup",KEYS.Get(_powerupProps[_streamUpgradeCache].stream[0]),KEYS.Get(_powerupProps[_streamUpgradeCache].stream[2],{"v1":_upgradeLevel}),_powerupProps[_streamUpgradeCache].streampic,0]);
               }
               POPUPS.Next();
            };
            monsterName = KEYS.Get(CREATURELOCKER._creatures[_upgrading].name);
            powerName = KEYS.Get(_powerupProps[_upgrading].name);
            popupMC = new popup_monster();
            popupMC.tText.htmlText = "<b>" + KEYS.Get("lab_powerup_complete",{
               "v1":powerName,
               "v2":this._upgradeLevel
            }) + "</b>";
            popupMC.bAction.SetupKey("btn_warnyourfriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,Post);
            popupMC.bAction.Highlight = true;
            popupMC.bSpeedup.visible = false;
            POPUPS.Push(popupMC,null,null,null,"" + _upgrading + "-LAB-150.png");
            this._streamUpgradeCache = _upgrading;
         }
         _upgrading = null;
         if(_open)
         {
            (_mcPopup as MONSTERLABPOPUP).Setup(wasUpgrading);
         }
         BASE.Save();
      }
      
      public function CancelMonsterPowerup(param1:MouseEvent) : void
      {
         if(_upgrading)
         {
            GLOBAL.Message(KEYS.Get("lab_confirmcancel",{
               "v1":KEYS.Get(CREATURELOCKER._creatures[_upgrading].name),
               "v2":KEYS.Get(_powerupProps[_upgrading].name)
            }),KEYS.Get("lab_confirmcancel_btn"),this.CancelMonsterPowerupB);
         }
      }
      
      public function CancelMonsterPowerupB() : void
      {
         POPUPS.Next();
         BASE.Charge(3,GetPuttyCost(_upgrading,this._upgradeLevel) * -1);
         var _loc1_:String = _upgrading;
         _upgrading = null;
         this._upgradeLevel = 0;
         this._upgradeFinishTime = new SecNum(0);
         _mcPopup.Setup(_loc1_);
         BASE.Save();
      }
      
      public function InstantMonsterPowerup(param1:String, param2:int) : void
      {
         var Post:Function;
         var powerName:String = null;
         var popupMC:popup_monster = null;
         var id:String = param1;
         var level:int = param2;
         var instantCost:int = GetShinyCost(id,level);
         if(BASE._credits.Get() < instantCost)
         {
            POPUPS.DisplayGetShiny();
            return;
         }
         GLOBAL.player.m_upgrades[id].powerup = level;
         this._upgradeLevel = level;
         LOGGER.Stat([48,id.substr(1),level]);
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            Post = function():void
            {
               if(_upgradeLevel == 1)
               {
                  GLOBAL.CallJS("sendFeed",["lab-powerup",KEYS.Get(_powerupProps[_streamUpgradeCache].stream[0]),KEYS.Get(_powerupProps[_streamUpgradeCache].stream[1],{"v1":powerName}),_powerupProps[_streamUpgradeCache].streampic,0]);
               }
               else
               {
                  GLOBAL.CallJS("sendFeed",["lab-powerup",KEYS.Get(_powerupProps[_streamUpgradeCache].stream[0]),KEYS.Get(_powerupProps[_streamUpgradeCache].stream[2],{"v1":_upgradeLevel}),_powerupProps[_streamUpgradeCache].streampic,0]);
               }
               POPUPS.Next();
            };
            powerName = KEYS.Get(_powerupProps[id].name);
            popupMC = new popup_monster();
            popupMC.tText.htmlText = "<b>" + KEYS.Get("lab_powerup_complete",{
               "v1":powerName,
               "v2":level
            }) + "</b>";
            popupMC.bAction.SetupKey("btn_warnyourfriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,Post);
            popupMC.bAction.Highlight = true;
            popupMC.bSpeedup.visible = false;
            POPUPS.Push(popupMC,null,null,null,"" + id + "-LAB-150.png");
            this._streamUpgradeCache = id;
         }
         if(_upgrading)
         {
            _upgrading = null;
         }
         BASE.Purchase("IPU",instantCost,"monsterlab");
      }
      
      override public function Setup(param1:Object) : void
      {
         super.Setup(param1);
         if(param1.upg)
         {
            _upgrading = param1.upg;
         }
         if(param1.upt)
         {
            this._upgradeFinishTime = new SecNum(param1.upt);
         }
         if(param1.upl)
         {
            this._upgradeLevel = param1.upl;
         }
         if(_countdownBuild.Get() <= 0)
         {
            GLOBAL._bLab = this;
         }
      }
      
      override public function Export() : Object
      {
         var _loc1_:Object = super.Export();
         if(_upgrading)
         {
            _loc1_.upg = _upgrading;
         }
         if(Boolean(this._upgradeFinishTime) && this._upgradeFinishTime.Get() > 0)
         {
            _loc1_.upt = this._upgradeFinishTime.Get();
         }
         if(this._upgradeLevel)
         {
            _loc1_.upl = this._upgradeLevel;
         }
         return _loc1_;
      }
   }
}
