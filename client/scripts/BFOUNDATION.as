package
{
   import com.cc.utils.SecNum;
   import com.monsters.GameObject;
   import com.monsters.configs.BYMConfig;
   import com.monsters.configs.BYMDevConfig;
   import com.monsters.debug.Console;
   import com.monsters.display.BuildingAssetContainer;
   import com.monsters.display.BuildingOverlay;
   import com.monsters.display.ImageCache;
   import com.monsters.effects.fire.Fire;
   import com.monsters.effects.smoke.Smoke;
   import com.monsters.enums.EnumYardType;
   import com.monsters.events.BuildingEvent;
   import com.monsters.interfaces.ICoreBuilding;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.inventory.InventoryManager;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.CModifiableProperty;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import com.monsters.utils.ImageCallbackHelper;
   import com.monsters.utils.MovieClipUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BFOUNDATION extends GameObject
   {
      
      public static const TICK_LIMIT:int = 172800;
      
      private static var s_totalBuildingHP:Number;
      
      private static var s_totalBuildingMaxHP:Number;
      
      public static const _IMAGE_NAMES:Array = ["shadow","","top","anim","anim2","anim3"];
      
      public static const _RASTERDATA_SHADOW:uint = 0;
      
      public static const _RASTERDATA_FOOTPRINT:uint = 1;
      
      public static const _RASTERDATA_TOP:uint = 2;
      
      public static const _RASTERDATA_ANIM:uint = 3;
      
      public static const _RASTERDATA_ANIM2:uint = 4;
      
      public static const _RASTERDATA_ANIM3:uint = 5;
      
      public static const _RASTERDATA_FORTFRONT:uint = 6;
      
      public static const _RASTERDATA_FORTBACK:uint = 7;
      
      public static const _RASTERDATA_AMOUNT:uint = 8;
      
      public static const k_STATE_DESTROYED:String = "destroyed";
      
      public static const k_STATE_DAMAGED:String = "damaged";
      
      public static const k_STATE_DEFAULT:String = "";
       
      
      public var _mcBase:MovieClip;
      
      public var _mcFootprint:MovieClip;
      
      public var _mcHit:MovieClip;
      
      public var topContainer:BuildingAssetContainer;
      
      public var animContainer:BuildingAssetContainer;
      
      public var _fortBackContainer:BuildingAssetContainer;
      
      public var _fortFrontContainer:BuildingAssetContainer;
      
      public var _spriteAlert:Sprite;
      
      public var _mcAlert:DisplayObject;
      
      public var _position:Point;
      
      public var _oldPosition:Point;
      
      public var _stopMoveCount:int;
      
      public var _moving:Boolean;
      
      public var _mouseOffset:Point;
      
      public var _footprint:Array;
      
      public var _blockers:Array;
      
      public var _gridCost:Array;
      
      public var _clickTimer:int;
      
      public var _prefab:int = 0;
      
      public var _buildInstant:Boolean = false;
      
      public var _buildInstantCost:SecNum;
      
      public var _fortification:SecNum;
      
      public const _nullPoint:Point = new Point(0,0);
      
      public var _animLoaded:Boolean = false;
      
      public var _animBMD:BitmapData;
      
      public var _animRect:Rectangle;
      
      public var _animContainerBMD:BitmapData;
      
      public var _animTick:int = 0;
      
      public var _animFrames:int = 0;
      
      public var anim2Container:BuildingAssetContainer;
      
      public var _anim2BMD:BitmapData;
      
      public var _anim2ContainerBMD:BitmapData;
      
      public var _anim2Rect:Rectangle;
      
      public var _anim2Frames:int = 0;
      
      public var _anim2Tick:int = 0;
      
      public var _anim2Loaded:Boolean = false;
      
      public var anim3Container:BuildingAssetContainer;
      
      public var _anim3BMD:BitmapData;
      
      public var _anim3ContainerBMD:BitmapData;
      
      public var _anim3Rect:Rectangle;
      
      public var _anim3Frames:int = 0;
      
      public var _anim3Tick:int = 0;
      
      public var _anim3Loaded:Boolean = false;
      
      public var _animRandomStart:Boolean = true;
      
      public var _countdownBuild:SecNum;
      
      public var _countdownUpgrade:SecNum;
      
      public var _countdownRebuild:SecNum;
      
      public var _countdownProduce:SecNum;
      
      public var _countdownFortify:SecNum;
      
      public var _stored:SecNum;
      
      public var _lvl:SecNum;
      
      public var _threadid:int;
      
      public var _subject:String;
      
      public var _senderid:int;
      
      public var _senderName:String;
      
      public var _senderPic:String;
      
      public var _hpCountdownRebuild:int;
      
      public var _hpCountdownProduce:int;
      
      public var _hpStored:int;
      
      public var _hpLvl:int;
      
      public var _repairing:int;
      
      public var _repairTime:int;
      
      public var _productionStage:SecNum;
      
      public var _looted:Boolean = false;
      
      public var _hasWorker:Boolean;
      
      public var _hasResources:Boolean;
      
      public var _counter:Number;
      
      public var _type:int;
      
      public var _attackgroup:int;
      
      public var _class:String;
      
      public var _id:int;
      
      public var _energy:int;
      
      public var _fired:Boolean;
      
      public var _creatures:Array;
      
      public var _buildingTitle:String;
      
      public var _buildingInstructions:String;
      
      public var _buildingStats:String;
      
      public var _buildingDescription:String;
      
      public var _upgradeDescription:String;
      
      public var _recycleDescription:String;
      
      public var _specialDescription:String;
      
      public var _repairDescription:String;
      
      public var _blockRecycle:Boolean;
      
      public var _upgradeCosts:String;
      
      public var _recycleCosts:String;
      
      public var _buildingProps:Object;
      
      public var _resource:Number;
      
      public var _range:int;
      
      public var _rate:int;
      
      public var _splash:int;
      
      public var _speed:int;
      
      public var _producing:int;
      
      public var _constructed:Boolean;
      
      public var _placing:Boolean;
      
      public var _oldY:int;
      
      public var _upgrading:String;
      
      public var _origin:Point;
      
      public var _shake:int;
      
      public var _picking:Boolean;
      
      public var _monsterQueue:Array;
      
      public var _inProduction:String;
      
      public var _taken:SecNum;
      
      public var _spoutPoint:Point;
      
      public var _spoutHeight:int;
      
      public var _canFunction:Boolean;
      
      public var _helpList:Array;
      
      public var _destroyed:Boolean = false;
      
      public var _renderState:String = null;
      
      public var _oldRenderState:String = null;
      
      public var _lastLoadedState:String = null;
      
      public var _renderLevel:int = 0;
      
      public var _renderFortLevel:int = 0;
      
      public var _treat:int;
      
      public var _expireTime:int = 0;
      
      protected var imageData:Object;
      
      private var _lastBarIndex:int = -1;
      
      public var _overlayOffset:Point;
      
      protected var _rasterData:Vector.<RasterData>;
      
      protected var _rasterPt:Vector.<Point>;
      
      protected var _offsets:Vector.<Point>;
      
      protected var _sources:Vector.<DisplayObject>;
      
      protected var _debugRasterData:RasterData;
      
      protected var m_bmd:BitmapData;
      
      protected var m_shadowBMD:BitmapData;
      
      protected var m_footprintBMD:BitmapData;
      
      protected var m_hitBMD:BitmapData;
      
      protected var m_bmHit:Bitmap;
      
      protected var m_hitOffsetIndex:uint;
      
      protected var _imageCallbackHelpers:Vector.<ImageCallbackHelper>;
      
      public var _recycled:Boolean = false;
      
      public var damageProperty:CModifiableProperty;
      
      private var _mouseClicked:Boolean;
      
      public function BFOUNDATION()
      {
         this._overlayOffset = new Point(0,0);
         super();
         this._spoutPoint = new Point(1,-67);
         this._spoutHeight = 135;
         setHealth(1);
         this._energy = 0;
         this._buildingTitle = "";
         this._buildingDescription = "";
         this._buildingInstructions = "";
         this._upgradeDescription = "";
         this._buildingStats = "";
         this._creatures = [];
         this._helpList = [];
         this._rasterData = new Vector.<RasterData>(_RASTERDATA_AMOUNT,true);
         this._rasterPt = new Vector.<Point>(this._rasterData.length,true);
         this._offsets = new Vector.<Point>(this._rasterData.length,true);
         this._sources = new Vector.<DisplayObject>(this._rasterData.length,true);
         var _loc1_:int = int(this._rasterPt.length - 1);
         while(_loc1_ >= 0)
         {
            this._rasterPt[_loc1_] = new Point();
            this._offsets[_loc1_] = new Point();
            _loc1_--;
         }
         this._imageCallbackHelpers = new Vector.<ImageCallbackHelper>();
         this._fortification = new SecNum(0);
         this._countdownBuild = new SecNum(0);
         this._countdownRebuild = new SecNum(0);
         this._countdownUpgrade = new SecNum(0);
         this._countdownProduce = new SecNum(0);
         this._countdownFortify = new SecNum(0);
         this._stored = new SecNum(0);
         this._lvl = new SecNum(0);
         this._hpCountdownRebuild = 0;
         this._hpCountdownProduce = 0;
         this._hpStored = 0;
         this._hpLvl = 0;
         this._inProduction = "";
         this._productionStage = new SecNum(0);
         this._constructed = false;
         this._placing = true;
         this._repairing = 0;
         this._mouseOffset = new Point(0,0);
         this._oldY = 0;
         if(BASE.isOutpostOrInfernoOutpost)
         {
            this._blockRecycle = true;
         }
         InstanceManager.addInstance(this);
         this.damageProperty = new CModifiableProperty();
         graphic.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      }
      
      public static function get totalBuildingHP() : Number
      {
         return s_totalBuildingHP;
      }
      
      public static function get totalBuildingMaxHP() : Number
      {
         return s_totalBuildingMaxHP;
      }
      
      public static function updateAllRasterData() : void
      {
         var _loc2_:BFOUNDATION = null;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            return;
         }
         var _loc1_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.updateRasterData();
         }
      }
      
      public static function redrawAllShadowData() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc3_:int = 0;
      }
      
      private static function sortByDepth(param1:Object, param2:Object) : Number
      {
         if(!(param1 as BFOUNDATION).rasterPt[BFOUNDATION._RASTERDATA_SHADOW])
         {
            return 1;
         }
         if(!(param2 as BFOUNDATION).rasterPt[BFOUNDATION._RASTERDATA_SHADOW])
         {
            return -1;
         }
         return (param1 as BFOUNDATION).rasterPt[BFOUNDATION._RASTERDATA_SHADOW].y - (param2 as BFOUNDATION).rasterPt[BFOUNDATION._RASTERDATA_SHADOW].y;
      }
      
      public static function getBuildingSaveData() : Vector.<Object>
      {
         var exportBuildingData:Object = null;
         var buildingData:BFOUNDATION = null;
         var hasTownHall:Boolean = false;
         var saveData:Vector.<Object> = new Vector.<Object>();
         var building:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         var buildingHealthData:Object = {};
         var buildingDataByID:Object = {};
         var hashString:String = "";
         saveData[0] = buildingDataByID;
         saveData[1] = buildingHealthData;
         s_totalBuildingHP = s_totalBuildingMaxHP = 0;
         for each(buildingData in building)
         {
            if(!(buildingData is BMUSHROOM) && !(GLOBAL._newBuilding === buildingData))
            {
               if(buildingData is ICoreBuilding)
               {
                  hasTownHall = true;
               }
               if(buildingData is BTRAP && buildingData._fired || buildingData._type == 53 && buildingData._expireTime < GLOBAL.Timestamp())
               {
                  Console.warning("Ignored Building" + buildingData + buildingData._type + buildingData._expireTime + " setting buildinghealthdata to 0");
                  buildingHealthData[buildingData._id] = 0;
               }
               else
               {
                  if(buildingData is BWALL === false)
                  {
                     if(BASE.isMainYardOrInfernoMainYard && (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD))
                     {
                        s_totalBuildingHP += buildingData.maxHealth;
                     }
                     else
                     {
                        s_totalBuildingHP += buildingData.health;
                     }
                     s_totalBuildingMaxHP += buildingData.maxHealth;
                  }
                  if(buildingData.health < buildingData.maxHealth)
                  {
                     buildingHealthData[buildingData._id] = int(buildingData.health);
                  }
                  if(exportBuildingData = buildingData.Export())
                  {
                     buildingDataByID[buildingData._id] = exportBuildingData;
                     hashString += (exportBuildingData.X + exportBuildingData.Y).toString();
                  }
               }
            }
         }
         if(!hasTownHall)
         {
            LOGGER.Log("err","User missing TownHall upon save");
            Console.warning("BFOUNDATION::getBuildingSaveData(TownHall missing upon save)");
         }
         BASE._percentDamaged = 100 - 100 / s_totalBuildingMaxHP * s_totalBuildingHP;
         // Comment: This gives an out-of-range index error. The md5.as class is malformed
         //saveData[2] = md5(hashString);
         saveData[2] = hashString;
         return saveData;
      }
      
      override public function get width() : Number
      {
         return this._mcHit.width;
      }
      
      override public function get height() : Number
      {
         return this._mcHit.height;
      }
      
      public function get rasterPt() : Vector.<Point>
      {
         return this._rasterPt;
      }
      
      public function get damage() : int
      {
         return this.damageProperty.value;
      }
      
      public function get isDamaged() : Boolean
      {
         return health < maxHealth;
      }
      
      public function get isCriticallyDamaged() : Boolean
      {
         return health < maxHealth * 0.5;
      }
      
      override public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         if(!isTargetable)
         {
            Console.warning("you are trying to deal damage to a building that isn\'t targetable.... why you doin that bro?");
            return 0;
         }
         var _loc3_:Number = param1;
         param1 = Math.abs(param1);
         if(this._fortification.Get() > 0)
         {
            param1 *= 100 - (this._fortification.Get() * 10 + 10);
            param1 /= 100;
         }
         param1 *= !!armor ? 1 - armor : 1;
         setHealth(health - param1);
         if(health <= 0)
         {
            this._repairing = 0;
            setHealth(0);
            if(!this._destroyed)
            {
               this.Destroyed(param2 != null);
            }
         }
         else if(this._class != "wall")
         {
            ATTACK.Log("b" + this._id,"<font color=\"#990000\">" + KEYS.Get("attack_log_%damaged",{
               "v1":this._lvl.Get(),
               "v2":KEYS.Get(this._buildingProps.name),
               "v3":100 - int(100 / maxHealth * health)
            }) + "</font>");
         }
         if(Boolean(param2) && !this._destroyed)
         {
            _loc4_ = 1;
            if(param2 is MonsterBase)
            {
               _loc4_ = MonsterBase(param2).lootingMultiplier;
            }
            _loc5_ = this.Loot(param1 * _loc4_);
            ATTACK.damage(param1,this,param1 - _loc3_);
         }
         if(k_DOES_PRINT_DETAILED_LOGGING)
         {
            param1 = Math.round(param1);
            _loc3_ = Math.round(_loc3_);
            print(this.name + " was hit for " + param1 + (!!(_loc3_ - param1) ? "(" + _loc3_ + " - " + (_loc3_ - param1) + ")" : "") + " damage(looted " + _loc5_ + "), left with " + health + " out of " + maxHealth + "hp");
         }
         this.Update();
         return param1;
      }
      
      public function SetProps() : void
      {
         try
         {
            this._buildingProps = GLOBAL._buildingProps[this._type - 1];
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  buildingprops | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps buildingprops");
            return;
         }
         try
         {
            this._mcFootprint = BYMConfig.instance.RENDERER_ON ? this.GetFootprintMC() : MAP._BUILDINGFOOTPRINTS.addChild(this.GetFootprintMC()) as MovieClip;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mcfootprint 1 | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps mcfootprint1");
            return;
         }
         try
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               _mc = MAP._BUILDINGTOPS.addChild(new MovieClip()) as MovieClip;
            }
            else
            {
               _mc = new MovieClip();
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mc | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  mc");
            return;
         }
         try
         {
            this.topContainer = new BuildingAssetContainer();
            this.topContainer.mouseChildren = false;
            this.topContainer.mouseEnabled = false;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  topContainer | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  topContainer");
            return;
         }
         try
         {
            this.animContainer = new BuildingAssetContainer();
            this.animContainer.mouseChildren = false;
            this.animContainer.mouseEnabled = false;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  animContainer | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  animContainer");
            return;
         }
         try
         {
            this._fortFrontContainer = new BuildingAssetContainer();
            this._fortFrontContainer.mouseChildren = false;
            this._fortFrontContainer.mouseEnabled = false;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  _fortFrontContainer | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  _fortFrontContainer");
            return;
         }
         try
         {
            this._fortBackContainer = new BuildingAssetContainer();
            this._fortBackContainer.mouseChildren = false;
            this._fortBackContainer.mouseEnabled = false;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  _fortBackContainer | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  _fortBackContainer");
            return;
         }
         try
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               _mc.addChild(this._fortBackContainer);
               _mc.addChild(this.topContainer);
               _mc.addChild(this.animContainer);
               _mc.addChild(this._fortFrontContainer);
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mc.addChildren | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  mc.addChildren");
            return;
         }
         try
         {
            if(!BYMConfig.instance.RENDERER_ON)
            {
               this._mcBase = MAP._BUILDINGBASES.addChild(new BuildingAssetContainer()) as BuildingAssetContainer;
            }
            else
            {
               this._mcBase = new BuildingAssetContainer();
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mcBase | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  mcBase");
            return;
         }
         try
         {
            this._mcHit = this.GetHitMC();
            this._mcHit.gotoAndStop(1);
            if(BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.addChild(this._mcHit);
            }
            else
            {
               _mc.addChild(this._mcHit);
            }
            this._mcHit.cacheAsBitmap = true;
            this._mcHit.alpha = 0;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mcHit | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  mcHit");
            return;
         }
         try
         {
            _size = this._buildingProps.size;
            this._class = this._buildingProps.type;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  size/class | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  size/class");
            return;
         }
         try
         {
            this._mcFootprint.gotoAndStop(1);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  mcFootprint 2 | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  mcFootprint 2");
            return;
         }
         try
         {
            this._attackgroup = this._buildingProps.attackgroup;
            this._mouseOffset = new Point(0,int(this._mcFootprint.height / 20) * 10);
            _middle = this._footprint[0].height * 0.5;
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.SetProps:  end stuff | " + e.message + " | " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.SetProps:  end");
            return;
         }
         this.anim2Container = new BuildingAssetContainer();
         this.anim2Container.mouseChildren = false;
         this.anim2Container.mouseEnabled = false;
         this.anim3Container = new BuildingAssetContainer();
         this.anim3Container.mouseChildren = false;
         this.anim3Container.mouseEnabled = false;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            _mc.addChild(this.anim2Container);
            _mc.addChild(this.anim3Container);
         }
         if(this._buildingProps.isUntargetable)
         {
            targetableStatus = 1;
         }
         if(this._buildingProps.isImmobile)
         {
            moveSpeedProperty.value = 0;
         }
      }
      
      public function Bank() : void
      {
      }
      
      public function Description() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Object = null;
         if(this._buildingProps.names != null && this._buildingProps.names.length >= this._lvl.Get())
         {
            this._buildingTitle = "<b>" + this._buildingProps.names[this._lvl.Get() - 1] + "</b>";
         }
         else
         {
            this._buildingTitle = "<b>" + this._buildingProps.name + "</b>";
            if(this._buildingProps.costs.length > 1)
            {
               this._buildingTitle += " " + KEYS.Get("bdg_level",{"v1":this._lvl.Get()});
            }
         }
         if(health < maxHealth)
         {
            if(this._countdownUpgrade.Get() > 0)
            {
               this._repairDescription = "<font color=\"#FF0000\"><b>" + KEYS.Get("repaironhold_upgrade") + "</b></font>";
            }
            else if(this._countdownFortify.Get() > 0)
            {
               this._repairDescription = "<font color=\"#FF0000\"><b>" + KEYS.Get("repaironhold_fortify") + "</b></font>";
            }
            else
            {
               _loc1_ = 100 - Math.ceil(100 / maxHealth * health);
               this._specialDescription = "<font color=\"#FF0000\"><b>" + KEYS.Get("building_percentdamaged",{"v1":_loc1_}) + "</b></font>";
            }
         }
         else
         {
            if(this._buildingProps.descriptions != null && this._buildingProps.descriptions.length >= this._lvl.Get())
            {
               this._specialDescription = this._buildingProps.descriptions[this._lvl.Get() - 1];
            }
            else
            {
               this._specialDescription = this._buildingProps.description;
            }
            if(!(this._type == 24 || this._type == 25 || this._type == 26))
            {
               if(this._type == 20 || this._type == 21)
               {
                  this._buildingStats = KEYS.Get("building_stats_dps",{
                     "v1":this._range,
                     "v2":this.damage,
                     "v3":int(this.damage * (40 / this._rate)),
                     "v4":this._splash,
                     "v5":int(40 / this._rate * 10) / 10
                  });
                  if(this._type == 20)
                  {
                     this._buildingDescription = KEYS.Get("building_cannon_desc");
                  }
                  if(this._type == 21)
                  {
                     this._buildingDescription = KEYS.Get("building_sniper_desc");
                  }
                  if(this._lvl.Get() < this._buildingProps.costs.length)
                  {
                     this._upgradeDescription = KEYS.Get("building_stats",{
                        "v1":this._buildingProps.stats[this._lvl.Get()].range,
                        "v2":this._buildingProps.stats[this._lvl.Get()].damage,
                        "v3":this._buildingProps.stats[this._lvl.Get()].splash,
                        "v4":int(40 / this._buildingProps.stats[this._lvl.Get()].rate * 10) / 10
                     });
                  }
               }
            }
         }
         this._recycleDescription = "";
         if(this._repairing == 1)
         {
            this._repairDescription = "<font color=\"#FF0000\"><b>" + KEYS.Get("building_damagedinattack") + "</b></font><br>" + KEYS.Get("building_repairinprogress",{
               "v1":Math.floor(100 / maxHealth * health),
               "v2":GLOBAL.ToTime(this.getEstimatedRepairTimeRemaining())
            });
         }
         else
         {
            this._repairDescription = "<font color=\"#FF0000\"><b>" + KEYS.Get("building_damagedinattack") + "</b></font><br>" + KEYS.Get("building_repairfree");
            if(this._countdownBuild.Get() > 0)
            {
               this._repairDescription += "<br>" + KEYS.Get("building_attackdestroy");
            }
            if(this._countdownUpgrade.Get() > 0)
            {
               this._repairDescription += "<br>" + KEYS.Get("building_attacksetback");
            }
         }
         if(this._lvl.Get() >= this._buildingProps.costs.length)
         {
            this._upgradeDescription = KEYS.Get("bdg_fullyupgraded");
            this._upgradeCosts = "";
         }
         else
         {
            this._upgradeCosts = "";
            _loc2_ = this._buildingProps.costs[this._lvl.Get()];
            if(_loc2_.r1.Get() > 0)
            {
               if(_loc2_.r1.Get() > BASE._resources.r1.Get())
               {
                  this._upgradeCosts += "<font color=\"#FF0000\">";
               }
               this._upgradeCosts += GLOBAL.FormatNumber(_loc2_.r1.Get()) + " " + GLOBAL._resourceNames[0] + "</font> - ";
            }
            if(_loc2_.r2.Get() > 0)
            {
               if(_loc2_.r2.Get() > BASE._resources.r2.Get())
               {
                  this._upgradeCosts += "<font color=\"#FF0000\">";
               }
               this._upgradeCosts += GLOBAL.FormatNumber(_loc2_.r2.Get()) + " " + GLOBAL._resourceNames[1] + "</font> - ";
            }
            if(_loc2_.r3.Get() > 0)
            {
               if(_loc2_.r3.Get() > BASE._resources.r3.Get())
               {
                  this._upgradeCosts += "<font color=\"#FF0000\">";
               }
               this._upgradeCosts += GLOBAL.FormatNumber(_loc2_.r3.Get()) + " " + GLOBAL._resourceNames[2] + "</font> - ";
            }
            if(_loc2_.r4.Get() > 0)
            {
               if(_loc2_.r4.Get() > BASE._resources.r4.Get())
               {
                  this._upgradeCosts += "<font color=\"#FF0000\">";
               }
               this._upgradeCosts += GLOBAL.FormatNumber(_loc2_.r4.Get()) + " " + GLOBAL._resourceNames[3] + "</font> - ";
            }
            this._upgradeCosts += GLOBAL.ToTime(_loc2_.time.Get());
            this._upgradeDescription = "";
         }
      }
      
      public function getEstimatedRepairTimeRemaining() : Number
      {
         var _loc1_:int = 0;
         if(this._lvl.Get() == 0)
         {
            _loc1_ = int(this._buildingProps.repairTime[0]);
         }
         else
         {
            _loc1_ = int(this._buildingProps.repairTime[this._lvl.Get() - 1]);
         }
         _loc1_ = Math.min(3600,_loc1_);
         _loc1_ = Math.ceil(maxHealth / _loc1_);
         return int((maxHealth - health) / _loc1_);
      }
      
      public function RenderClear(param1:Boolean = true) : void
      {
         if(m_isCleared)
         {
            return;
         }
         if(param1)
         {
            this._renderState = null;
         }
         this._mcBase.Clear();
         this.topContainer.Clear();
         this.animContainer.Clear();
         this.anim2Container.Clear();
         this.anim3Container.Clear();
      }
      
      public function Render(param1:String = "") : void
      {
         var FortImageCallback:Function;
         var imageDataA:Object = null;
         var imageDataB:Object = null;
         var imageLevel:int = 0;
         var fortImageDataA:Object = null;
         var fortImageDataB:Object = null;
         var fortImageLevel:int = 0;
         var i:int = 0;
         var loadImages:Array = null;
         var length:uint = 0;
         var imageGroupYardType:int = 0;
         var j:int = 0;
         var loadFortImages:Array = null;
         var state:String = param1;
         if(GLOBAL._catchup)
         {
            return;
         }
         if(this._renderState == null || state !== this._renderState || this._lvl.Get() != this._renderLevel)
         {
            this._renderLevel = this._lvl.Get();
            imageDataA = GLOBAL._buildingProps[this._type - 1].imageData;
            if(this._lvl.Get() == 0)
            {
               imageDataB = imageDataA[1];
               imageLevel = 1;
            }
            else if(imageDataA[this._lvl.Get()])
            {
               imageDataB = imageDataA[this._lvl.Get()];
               imageLevel = this._lvl.Get();
            }
            else
            {
               i = this._lvl.Get() - 1;
               while(i > 0)
               {
                  if(imageDataA[i])
                  {
                     imageDataB = imageDataA[i];
                     imageLevel = i;
                     break;
                  }
                  i--;
               }
            }
            this._oldRenderState = this._renderState;
            this._renderState = state;
            if(imageDataB)
            {
               loadImages = [];
               if(!imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state])
               {
                  state = "";
               }
               length = _IMAGE_NAMES.length;
               i = 0;
               while(i < length)
               {
                  if(imageDataB[_IMAGE_NAMES[i] + state])
                  {
                     loadImages.push(imageDataA.baseurl + imageDataB[_IMAGE_NAMES[i] + state][0]);
                  }
                  i++;
               }
               this._animLoaded = false;
               if(state === k_STATE_DAMAGED || state === k_STATE_DESTROYED)
               {
                  this._anim2Loaded = false;
                  this._anim3Loaded = true;
               }
               else
               {
                  this._anim2Loaded = false;
                  this._anim3Loaded = false;
               }
               this._imageCallbackHelpers.push(new ImageCallbackHelper(this.ImageCallback,state,imageLevel,imageDataA,imageDataB));
               imageGroupYardType = BASE.yardType;
               switch(imageGroupYardType)
               {
                  case EnumYardType.PLAYER:
                     imageGroupYardType = int(EnumYardType.MAIN_YARD);
                     break;
                  case EnumYardType.RESOURCE:
                  case EnumYardType.STRONGHOLD:
                  case EnumYardType.FORTIFICATION:
                     imageGroupYardType = int(EnumYardType.OUTPOST);
               }
               ImageCache.GetImageGroupWithCallBack(imageGroupYardType + "b" + this._type + "-" + imageLevel + state,loadImages,this.ImageCallback,true,2,state);
            }
         }
         if(this._fortification.Get() != this._renderFortLevel)
         {
            if(this._fortification.Get() > 4)
            {
               LOGGER.Log("err","Illegal fortification level " + this._fortification.Get());
               throw new Error("ILLEGAL FORTIFICATION LEVEL " + this._fortification.Get());
            }
            this._renderFortLevel = this._fortification.Get();
            fortImageDataA = GLOBAL._buildingProps[this._type - 1].fortImgData;
            if(fortImageDataA[this._fortification.Get()])
            {
               fortImageDataB = fortImageDataA[this._fortification.Get()];
               fortImageLevel = this._fortification.Get();
            }
            else
            {
               j = this._fortification.Get() - 1;
               while(i > 0)
               {
                  if(fortImageDataA[j])
                  {
                     fortImageDataB = fortImageDataA[j];
                     imageLevel = j;
                     break;
                  }
                  i--;
               }
            }
            if(fortImageDataB)
            {
               FortImageCallback = function(param1:Array, param2:String):void
               {
                  var _loc3_:Array = null;
                  var _loc4_:String = null;
                  var _loc5_:BitmapData = null;
                  var _loc6_:BuildingAssetContainer = null;
                  if(param2 == "fort" + _renderFortLevel)
                  {
                     _fortFrontContainer.Clear();
                     _fortBackContainer.Clear();
                     for each(_loc3_ in param1)
                     {
                        _loc4_ = String(_loc3_[0]);
                        _loc5_ = _loc3_[1];
                        if(Boolean(fortImageDataB["front"]) && fortImageDataA.baseurl + fortImageDataB["front"][0] == _loc4_)
                        {
                           if(!BYMConfig.instance.RENDERER_ON)
                           {
                              (_loc6_ = _fortFrontContainer).Clear();
                              _loc6_.addChild(new Bitmap(_loc5_));
                              _loc6_.x = fortImageDataB["front"][1].x;
                              _loc6_.y = fortImageDataB["front"][1].y;
                           }
                           else
                           {
                              _offsets[_RASTERDATA_FORTFRONT].x = fortImageDataB["front"][1].x;
                              _offsets[_RASTERDATA_FORTFRONT].y = fortImageDataB["front"][1].y;
                              _rasterPt[_RASTERDATA_FORTFRONT].x = _mc.x + _offsets[_RASTERDATA_FORTFRONT].x - MAP.instance.offset.x;
                              _rasterPt[_RASTERDATA_FORTFRONT].y = _mc.y + _offsets[_RASTERDATA_FORTFRONT].y - MAP.instance.offset.y;
                              _rasterData[_RASTERDATA_FORTFRONT] ||= new RasterData(_loc5_,_rasterPt[_RASTERDATA_FORTFRONT],int.MAX_VALUE);
                           }
                        }
                        else if(Boolean(fortImageDataB["back"]) && fortImageDataA.baseurl + fortImageDataB["back"][0] == _loc4_)
                        {
                           if(!BYMConfig.instance.RENDERER_ON)
                           {
                              (_loc6_ = _fortBackContainer).Clear();
                              _loc6_.addChild(new Bitmap(_loc5_));
                              _loc6_.x = fortImageDataB["back"][1].x;
                              _loc6_.y = fortImageDataB["back"][1].y;
                           }
                           else
                           {
                              _offsets[_RASTERDATA_FORTBACK].x = fortImageDataB["back"][1].x;
                              _offsets[_RASTERDATA_FORTBACK].y = fortImageDataB["back"][1].y;
                              _rasterPt[_RASTERDATA_FORTBACK].x = _mc.x + _offsets[_RASTERDATA_FORTBACK].x - MAP.instance.offset.x;
                              _rasterPt[_RASTERDATA_FORTBACK].y = _mc.y + _offsets[_RASTERDATA_FORTBACK].y - MAP.instance.offset.y;
                              _rasterData[_RASTERDATA_FORTBACK] ||= new RasterData(_loc5_,_rasterPt[_RASTERDATA_FORTBACK],int.MAX_VALUE);
                           }
                        }
                     }
                     updateRasterData();
                  }
               };
               loadFortImages = [];
               if(fortImageDataB["front"])
               {
                  loadFortImages.push(fortImageDataA.baseurl + fortImageDataB["front"][0]);
               }
               if(fortImageDataB["back"])
               {
                  loadFortImages.push(fortImageDataA.baseurl + fortImageDataB["back"][0]);
               }
               ImageCache.GetImageGroupWithCallBack("fort" + this._type + "-" + fortImageLevel,loadFortImages,FortImageCallback,true,2,"fort" + this._renderFortLevel);
            }
         }
         if(this._renderState == null || state !== this._renderState || this._lvl.Get() != this._renderLevel)
         {
            this.updateRasterData();
         }
      }
      
      protected function ImageCallback(param1:Array, param2:String) : void
      {
         var callbackHelper:ImageCallbackHelper = null;
         var isCorrectHelper:Boolean = false;
         var callbackHelperIndex:int = 0;
         var _loc7_:* = false;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var imageBitmapData:BitmapData = null;
         var buildingAssetContainer:BuildingAssetContainer = null;
         var _loc16_:Rectangle = null;
         var _loc17_:DisplayObject = null;
         if(m_isCleared)
         {
            return;
         }
         callbackHelperIndex = int(this._imageCallbackHelpers.length - 1);
         while(callbackHelperIndex >= 0)
         {
            if((callbackHelper = this._imageCallbackHelpers[callbackHelperIndex]).ref === arguments.callee)
            {
               this._imageCallbackHelpers.splice(callbackHelperIndex,1);
               isCorrectHelper = true;
            }
            callbackHelperIndex--;
         }
         if(!isCorrectHelper)
         {
            return;
         }
         var state:String = callbackHelper.state;
         var _loc9_:int = callbackHelper.level;
         var imageDataA:Object = callbackHelper.imageDataA;
         var imageDataB:Object = callbackHelper.imageDataB;
         callbackHelper.clear();
         if(param2 == this._renderState)
         {
            this.RenderClear(false);
            if(this._lastLoadedState != null)
            {
               if(state === k_STATE_DESTROYED && this._lastLoadedState === k_STATE_DAMAGED)
               {
                  if(this._type == 14)
                  {
                     SOUNDS.Play("destroytownhall");
                     if(this._type != 17 && this._type != 18)
                     {
                        Smoke.CreatePoof(new Point(x,y + _middle),_middle,1);
                     }
                  }
                  else
                  {
                     SOUNDS.Play(SOUNDS.DestroySoundIDForLevel(this._lvl.Get()));
                     if(this._type != 17 && this._type != 18)
                     {
                        Smoke.CreatePoof(new Point(x,y + _middle),_middle,1);
                     }
                  }
                  if(this._class != "wall" && this._class != "trap" && this._type != 15)
                  {
                     Smoke.CreateStream(new Point(x,y + _middle));
                  }
               }
               if(state == "damaged" && this._lastLoadedState == "")
               {
                  SOUNDS.Play(SOUNDS.DamageSoundIDForLevel(this._lvl.Get()));
                  if(this._type != 17 && this._type != 18)
                  {
                     Smoke.CreatePoof(new Point(x,y + _middle),_middle,0.5);
                  }
               }
            }
            this._lastLoadedState = state;
            if(Boolean(_mc) && _mc.hasEventListener(Event.ENTER_FRAME))
            {
               _mc.removeEventListener(Event.ENTER_FRAME,this.TickFast);
            }
            if(BYMConfig.instance.RENDERER_ON)
            {
               _loc7_ = this._rasterData[_RASTERDATA_TOP] === null;
            }
            for each(_loc12_ in param1)
            {
               _loc13_ = String(_loc12_[0]);
               imageBitmapData = _loc12_[1];
               if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state][0] == _loc13_)
               {
                  this.m_shadowBMD = imageBitmapData;
                  if(!BYMConfig.instance.RENDERER_ON)
                  {
                     (buildingAssetContainer = BuildingAssetContainer(this._mcBase)).Clear();
                     (_loc17_ = buildingAssetContainer.addChild(new Bitmap(imageBitmapData))).blendMode = BlendMode.MULTIPLY;
                     _loc17_.x = imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state][1].x;
                     _loc17_.y = imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state][1].y;
                  }
                  else
                  {
                     this._offsets[_RASTERDATA_SHADOW].x = imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state][1].x;
                     this._offsets[_RASTERDATA_SHADOW].y = imageDataB[_IMAGE_NAMES[_RASTERDATA_SHADOW] + state][1].y;
                     this._rasterPt[_RASTERDATA_SHADOW].x = _mc.x + this._offsets[_RASTERDATA_SHADOW].x - MAP.instance.offset.x;
                     this._rasterPt[_RASTERDATA_SHADOW].y = _mc.y + this._offsets[_RASTERDATA_SHADOW].y - MAP.instance.offset.y;
                     this.redrawShadowData();
                     this._rasterData[_RASTERDATA_SHADOW] ||= new RasterData(imageBitmapData,this._rasterPt[_RASTERDATA_SHADOW],MAP.DEPTH_SHADOW,BlendMode.MULTIPLY,true);
                  }
               }
               else if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state][0] == _loc13_)
               {
                  this.setupImage(_RASTERDATA_TOP,state,this.topContainer,imageDataB,imageBitmapData,int.MAX_VALUE);
                  this.setupHit(_RASTERDATA_TOP,_loc9_,state);
                  if(_loc7_)
                  {
                     this.updateRasterData();
                  }
               }
               else if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][0] == _loc13_)
               {
                  this._animBMD = imageBitmapData;
                  this._animLoaded = true;
                  _loc16_ = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][1];
                  this._animRect = new Rectangle(0,0,_loc16_.width,_loc16_.height);
                  this._animFrames = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][2];
                  if(this._animRandomStart)
                  {
                     this._animTick = int(Math.random() * (this._animFrames - 2));
                  }
                  else
                  {
                     this._animTick = 0;
                  }
                  if(this._type == 9 || this._type == 19 || this._type == 25 || this._type == 54)
                  {
                     this._animTick = 0;
                  }
                  this._animContainerBMD = new BitmapData(_loc16_.width,_loc16_.height,true,16777215);
                  this.setupImage(_RASTERDATA_ANIM,state,this.animContainer,imageDataB,this._animContainerBMD,int.MAX_VALUE);
                  this.AnimFrame(false);
                  if(!_mc.hasEventListener(Event.ENTER_FRAME))
                  {
                     _mc.addEventListener(Event.ENTER_FRAME,this.TickFast);
                  }
                  if(!imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state])
                  {
                     this.setupHit(_RASTERDATA_ANIM,_loc9_,state);
                  }
               }
               else if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM2] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM2] + state][0] == _loc13_)
               {
                  this._anim2BMD = imageBitmapData;
                  this._anim2Loaded = true;
                  _loc16_ = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM2] + state][1];
                  this._anim2Rect = new Rectangle(0,0,_loc16_.width,_loc16_.height);
                  this._anim2Frames = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM2] + state][2];
                  if(this._animRandomStart)
                  {
                     this._anim2Tick = int(Math.random() * (this._anim2Frames - 2));
                  }
                  else
                  {
                     this._anim2Tick = 0;
                  }
                  this._anim2ContainerBMD = new BitmapData(_loc16_.width,_loc16_.height,true,16777215);
                  this.setupImage(_RASTERDATA_ANIM2,state,this.anim2Container,imageDataB,this._anim2ContainerBMD,int.MAX_VALUE);
                  if(this._animLoaded && this._anim2Loaded && this._anim3Loaded)
                  {
                     this.AnimFrame(false);
                     if(!_mc.hasEventListener(Event.ENTER_FRAME))
                     {
                        _mc.addEventListener(Event.ENTER_FRAME,this.TickFast);
                     }
                  }
                  if(!imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state])
                  {
                     this.setupHit(_RASTERDATA_ANIM2,_loc9_,state);
                  }
               }
               else if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM3] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM3] + state][0] == _loc13_)
               {
                  this._anim3BMD = imageBitmapData;
                  this._anim3Loaded = true;
                  _loc16_ = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM3] + state][1];
                  this._anim3Rect = new Rectangle(0,0,_loc16_.width,_loc16_.height);
                  this._anim3Frames = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM3] + state][2];
                  if(this._animRandomStart)
                  {
                     this._anim3Tick = int(Math.random() * (this._anim3Frames - 2));
                  }
                  else
                  {
                     this._anim3Tick = 0;
                  }
                  this._anim3ContainerBMD = new BitmapData(_loc16_.width,_loc16_.height,true,16777215);
                  this.setupImage(_RASTERDATA_ANIM3,state,this.anim3Container,imageDataB,this._anim3ContainerBMD,int.MAX_VALUE);
                  if(this._animLoaded && this._anim2Loaded && this._anim3Loaded)
                  {
                     this.AnimFrame(false);
                     if(!_mc.hasEventListener(Event.ENTER_FRAME))
                     {
                        _mc.addEventListener(Event.ENTER_FRAME,this.TickFast);
                     }
                  }
                  if(!imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state])
                  {
                     this.setupHit(_RASTERDATA_ANIM3,_loc9_,state);
                  }
               }
               else if(Boolean(imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state]) && imageDataA.baseurl + imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][0] == _loc13_)
               {
                  this._animBMD = imageBitmapData;
                  this._animLoaded = true;
                  _loc16_ = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][1];
                  this._animRect = new Rectangle(0,0,_loc16_.width,_loc16_.height);
                  this._animFrames = imageDataB[_IMAGE_NAMES[_RASTERDATA_ANIM] + state][2];
                  if(this._animRandomStart)
                  {
                     this._animTick = int(Math.random() * (this._animFrames - 2));
                  }
                  else
                  {
                     this._animTick = 0;
                  }
                  if(this._type == 9 || this._type == 19 || this._type == 25 || this._type == 54)
                  {
                     this._animTick = 0;
                  }
                  this._animContainerBMD = new BitmapData(_loc16_.width,_loc16_.height,true,16777215);
                  this.setupImage(_RASTERDATA_ANIM,state,this.animContainer,imageDataB,this._animContainerBMD,int.MAX_VALUE);
                  this.AnimFrame(false);
                  if(!_mc.hasEventListener(Event.ENTER_FRAME))
                  {
                     _mc.addEventListener(Event.ENTER_FRAME,this.TickFast);
                  }
                  if(!imageDataB[_IMAGE_NAMES[_RASTERDATA_TOP] + state])
                  {
                     this.setupHit(_RASTERDATA_ANIM,_loc9_,state);
                  }
               }
               else if(imageDataB.topdestroyedfire && this._oldRenderState == k_STATE_DAMAGED && !GLOBAL._catchup && imageDataA.baseurl + imageDataB.topdestroyedfire[0] == _loc13_)
               {
                  Fire.Add(_mc,new Bitmap(imageBitmapData),new Point(imageDataB.topdestroyedfire[1].x,imageDataB.topdestroyedfire[1].y));
               }
            }
         }
         if(BYMConfig.instance.RENDERER_ON)
         {
            if(!this._animLoaded && this._rasterData[_RASTERDATA_ANIM] is RasterData)
            {
               this._rasterData[_RASTERDATA_ANIM].clear();
               this._rasterData[_RASTERDATA_ANIM] = null;
            }
            if(!this._anim2Loaded && this._rasterData[_RASTERDATA_ANIM2] is RasterData)
            {
               this._rasterData[_RASTERDATA_ANIM2].clear();
               this._rasterData[_RASTERDATA_ANIM2] = null;
            }
            if(!this._anim3Loaded && this._rasterData[_RASTERDATA_ANIM3] is RasterData)
            {
               this._rasterData[_RASTERDATA_ANIM3].clear();
               this._rasterData[_RASTERDATA_ANIM3] = null;
            }
         }
         this.AnimFrame();
      }
      
      protected function setupImage(param1:uint, param2:String, param3:BuildingAssetContainer, param4:Object, param5:BitmapData, param6:Number) : void
      {
         this._offsets[param1].x = param4[_IMAGE_NAMES[param1] + param2][1].x;
         this._offsets[param1].y = param4[_IMAGE_NAMES[param1] + param2][1].y;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            param3.Clear();
            param3.addChild(new Bitmap(param5));
            param3.x = this._offsets[param1].x;
            param3.y = this._offsets[param1].y;
         }
         else
         {
            this._rasterPt[param1].x = _mc.x + this._offsets[param1].x - MAP.instance.offset.x;
            this._rasterPt[param1].y = _mc.y + this._offsets[param1].y - MAP.instance.offset.y;
            this._rasterData[param1] ||= new RasterData(param5,this._rasterPt[param1],int.MAX_VALUE);
            this._rasterData[param1].data = param5;
            this._rasterData[param1].visible = _mc.visible;
            this._sources[param1] = param3;
         }
      }
      
      protected function setupHit(param1:uint, param2:int, param3:String) : void
      {
         if(MovieClipUtils.validateFrameLabel(this._mcHit as MovieClip,"f" + param2 + param3))
         {
            this._mcHit.gotoAndStop("f" + param2 + param3);
         }
         if(param3 == "destroyed" && this._type !== 14)
         {
            if(MovieClipUtils.validateFrameLabel(this._mcHit as MovieClip,"f" + param3))
            {
               this._mcHit.gotoAndStop("f" + param3);
            }
            else
            {
               print("BFOUNDATION.ImageCallback building has no hit 1 " + this._type + " frame f" + param3);
            }
         }
         this.m_hitOffsetIndex = param1;
         if(BYMConfig.instance.RENDERER_ON)
         {
            this._mcHit.x = _mc.x + this._offsets[param1].x;
            this._mcHit.y = _mc.y + this._offsets[param1].y;
         }
         else
         {
            this._mcHit.x = this._offsets[param1].x;
            this._mcHit.y = this._offsets[param1].y;
         }
      }
      
      public function showFootprint(param1:Boolean, param2:Boolean = false) : void
      {
         if(this._mcFootprint)
         {
            if(BYMConfig.instance.RENDERER_ON && (this._mcFootprint.width | this._mcFootprint.height) !== 0)
            {
               this._offsets[_RASTERDATA_FOOTPRINT].x = -this._mcFootprint.width >> 1;
               this._offsets[_RASTERDATA_FOOTPRINT].y = 0;
               this._rasterPt[_RASTERDATA_FOOTPRINT].x = this._mcFootprint.x - (this._mcFootprint.width >> 1) - MAP.instance.offset.x;
               this._rasterPt[_RASTERDATA_FOOTPRINT].y = this._mcFootprint.y - MAP.instance.offset.y;
               if(!this.m_footprintBMD)
               {
                  this.m_footprintBMD = new BitmapData(this._mcFootprint.width,this._mcFootprint.height,true,0);
                  this.m_footprintBMD.draw(this._mcFootprint,new Matrix(1,0,0,1,this._mcFootprint.width * 0.5,0));
               }
               else if(param2)
               {
                  this.m_footprintBMD.fillRect(this.m_footprintBMD.rect,0);
                  this.m_footprintBMD.draw(this._mcFootprint,new Matrix(1,0,0,1,this._mcFootprint.width * 0.5,0));
               }
               this._rasterData[_RASTERDATA_FOOTPRINT] ||= new RasterData(this.m_footprintBMD,this._rasterPt[_RASTERDATA_FOOTPRINT],MAP.DEPTH_SHADOW + 1);
               if(param2)
               {
                  this._rasterData[_RASTERDATA_FOOTPRINT].data = this.m_footprintBMD;
               }
               if((GLOBAL._selectedBuilding === this || GLOBAL._newBuilding === this) && this._rasterData[_RASTERDATA_SHADOW] is RasterData)
               {
                  this._rasterData[_RASTERDATA_SHADOW].visible = false;
               }
            }
            else
            {
               this._mcFootprint.visible = true;
            }
         }
         if(param1)
         {
            this.BlockClicks();
         }
      }
      
      public function hideFootprint(param1:Boolean) : void
      {
         if(GLOBAL._selectedBuilding != this)
         {
            if(BYMConfig.instance.RENDERER_ON && this._rasterData[_RASTERDATA_FOOTPRINT] is RasterData)
            {
               this._rasterData[_RASTERDATA_FOOTPRINT].clear();
               this._rasterData[_RASTERDATA_FOOTPRINT] = null;
            }
            if(this._mcFootprint)
            {
               this._mcFootprint.visible = false;
            }
         }
         if(this._mcFootprint)
         {
            this._mcFootprint.gotoAndStop(1);
         }
         if(param1)
         {
            this.UnblockClicks();
         }
         this.updateRasterData();
      }
      
      public function get tickLimit() : int
      {
         if(health == 0 && !this._repairing)
         {
            return TICK_LIMIT;
         }
         var _loc1_:int = TICK_LIMIT;
         if(this._countdownBuild.Get() > 0)
         {
            _loc1_ = Math.min(_loc1_,this._countdownBuild.Get());
         }
         if(this._countdownUpgrade.Get() > 0)
         {
            _loc1_ = Math.min(_loc1_,this._countdownUpgrade.Get());
         }
         if(this._countdownFortify.Get() > 0)
         {
            _loc1_ = Math.min(_loc1_,this._countdownFortify.Get());
         }
         return _loc1_;
      }
      
      public function Tick(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() + this._repairing > 0)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            if(this._repairing == 1)
            {
               _loc5_ = this._lvl.Get() == 0 ? 0 : int(this._lvl.Get() - 1);
               _loc4_ = Math.ceil(maxHealth / Math.min(3600,this._buildingProps.repairTime[_loc5_]));
               setHealth(health + _loc4_ * param1);
               if(health >= maxHealth)
               {
                  this.Repaired();
               }
            }
            else if(health == maxHealth)
            {
               if(this._countdownUpgrade.Get() > 0 && this._hasWorker && this._hasResources)
               {
                  this._countdownUpgrade.Add(-param1);
                  if(!Math.max(this._countdownUpgrade.Get(),0))
                  {
                     this.Upgraded();
                  }
               }
               else if(this._countdownBuild.Get() > 0 && this._hasWorker && this._hasResources)
               {
                  this._countdownBuild.Add(-param1);
                  if(!Math.max(this._countdownBuild.Get(),0))
                  {
                     this.Constructed();
                  }
               }
               else if(this._countdownFortify.Get() > 0 && this._hasWorker && this._hasResources)
               {
                  this._countdownFortify.Add(-param1);
                  if(!Math.max(this._countdownFortify.Get(),0))
                  {
                     this.Fortified();
                  }
               }
            }
         }
         this.Update();
      }
      
      override protected function updateRasterData() : void
      {
         var _loc4_:RasterData = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:DisplayObject = null;
         var _loc10_:int = 0;
         if(!BYMConfig.instance.RENDERER_ON || m_isCleared)
         {
            return;
         }
         var _loc1_:Point = MAP.instance.offset;
         var _loc2_:Function = MAP.instance.viewRect.intersects;
         var _loc3_:Rectangle = new Rectangle();
         if(this._mcHit)
         {
            this._mcHit.x = _mc.x + this._offsets[this.m_hitOffsetIndex].x;
            this._mcHit.y = _mc.y + this._offsets[this.m_hitOffsetIndex].y;
         }
         if(_mc)
         {
            _loc6_ = _mc.height * 0.5;
            if(_middle)
            {
               _loc6_ = _middle;
            }
            m_baseDepth = 0;
            _loc7_ = Math.max(MAP.DEPTH_SHADOW + 1,(_mc.y - _loc1_.y + _loc6_) * 1000 + (_mc.x - _loc1_.x));
            _loc10_ = _RASTERDATA_SHADOW + 1;
            while(_loc10_ < _RASTERDATA_AMOUNT)
            {
               _loc4_ = this._rasterData[_loc10_];
               _loc5_ = this._rasterPt[_loc10_];
               if(Boolean(_loc4_) && Boolean(_loc5_))
               {
                  m_baseDepth = _loc10_ - 1;
                  _loc4_.depth = _loc10_ === _RASTERDATA_FORTBACK ? _loc7_ - 1 : _loc7_ + _loc10_ - 1;
                  _loc5_.x = _mc.x + this._offsets[_loc10_].x - _loc1_.x;
                  _loc5_.y = _mc.y + this._offsets[_loc10_].y - _loc1_.y;
                  _loc9_ = this._sources[_loc10_];
                  _loc3_.x = _loc5_.x;
                  _loc3_.y = _loc5_.y;
                  _loc3_.width = _loc4_.rect.width;
                  _loc3_.height = _loc4_.rect.height;
                  _loc4_.visible = _loc2_(_loc3_) && (Boolean(_loc9_) && !_loc9_.visible ? false : _mc.visible);
                  _loc4_.alpha = _mc.alpha;
               }
               _loc10_++;
            }
            _loc4_ = this._rasterData[_RASTERDATA_SHADOW];
            _loc5_ = this._rasterPt[_RASTERDATA_SHADOW];
            if(this._mcBase && _loc4_ && Boolean(_loc5_))
            {
               _loc5_.x = this._mcBase.x + this._offsets[_RASTERDATA_SHADOW].x - _loc1_.x;
               _loc5_.y = this._mcBase.y + this._offsets[_RASTERDATA_SHADOW].y - _loc1_.y;
               if(!this._moving && GLOBAL._newBuilding !== this)
               {
                  _loc3_.x = _loc5_.x;
                  _loc3_.y = _loc5_.y;
                  _loc3_.width = _loc4_.rect.width;
                  _loc3_.height = _loc4_.rect.height;
                  _loc4_.visible = _loc2_(_loc3_) && this._mcBase.visible;
               }
            }
         }
         super.updateRasterData();
      }
      
      protected function redrawShadowData() : void
      {
         var _loc3_:BitmapData = null;
         if(!BYMConfig.instance.RENDERER_ON || !BYMConfig.instance.OPTIMIZED_SHADOWS || !this.m_shadowBMD)
         {
            return;
         }
         var _loc1_:Point = MAP.instance.offset;
         var _loc2_:Point = this._rasterPt[_RASTERDATA_SHADOW];
         if(Boolean(this._mcBase) && Boolean(_loc2_))
         {
            _loc2_.x = this._mcBase.x + this._offsets[_RASTERDATA_SHADOW].x - _loc1_.x;
            _loc2_.y = this._mcBase.y + this._offsets[_RASTERDATA_SHADOW].y - _loc1_.y;
         }
         _loc3_ = new BitmapData(this.m_shadowBMD.width,this.m_shadowBMD.height,true);
         var _loc4_:Rectangle = new Rectangle(this._rasterPt[_RASTERDATA_SHADOW].x,this._rasterPt[_RASTERDATA_SHADOW].y,_loc3_.width,_loc3_.height);
         _loc3_.copyPixels(MAP.effectsBMD,_loc4_,new Point());
         _loc3_.draw(this.m_shadowBMD,null,null,BlendMode.MULTIPLY);
         if(this._rasterData[_RASTERDATA_SHADOW] is RasterData === false)
         {
            this._rasterData[_RASTERDATA_SHADOW] = new RasterData(_loc3_,this._rasterPt[_RASTERDATA_SHADOW],MAP.DEPTH_SHADOW,null,true);
         }
         else
         {
            this._rasterData[_RASTERDATA_SHADOW].data = _loc3_;
         }
         if(!this._moving)
         {
            this._rasterData[_RASTERDATA_SHADOW].visible = this._mcBase.visible;
         }
      }
      
      public function TickFast(param1:Event = null) : void
      {
      }
      
      public function TickAttack() : void
      {
      }
      
      public function AnimFrame(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         if(!GLOBAL._catchup && this._animBMD && Boolean(this._animContainerBMD))
         {
            this._animRect.x = this._animRect.width * this._animTick;
            this._animContainerBMD.copyPixels(this._animBMD,this._animRect,this._nullPoint);
            _loc2_ = true;
            if(param1)
            {
               if(this._class == "resource")
               {
                  if(GLOBAL._harvesterOverdrive >= GLOBAL.Timestamp() && GLOBAL._harvesterOverdrivePower.Get() > 0)
                  {
                     this._animTick += GLOBAL._harvesterOverdrivePower.Get();
                  }
                  else
                  {
                     ++this._animTick;
                  }
               }
               else
               {
                  ++this._animTick;
               }
               if(this._animTick >= this._animFrames)
               {
                  this._animTick = 0;
               }
            }
         }
         if(!GLOBAL._catchup && Boolean(this._anim2BMD))
         {
            this._anim2Rect.x = this._anim2Rect.width * this._anim2Tick;
            this._anim2ContainerBMD.copyPixels(this._anim2BMD,this._anim2Rect,this._nullPoint);
            _loc2_ = true;
            if(param1)
            {
               ++this._anim2Tick;
               if(this._anim2Tick >= this._anim2Frames)
               {
                  this._anim2Tick = 0;
               }
            }
         }
         if(!GLOBAL._catchup && Boolean(this._anim3BMD))
         {
            this._anim3Rect.x = this._anim3Rect.width * this._anim3Tick;
            this._anim3ContainerBMD.copyPixels(this._anim3BMD,this._anim3Rect,this._nullPoint);
            _loc2_ = true;
            if(param1)
            {
               ++this._anim3Tick;
               if(this._anim3Tick >= this._anim3Frames)
               {
                  this._anim3Tick = 0;
               }
            }
         }
         if(_loc2_)
         {
            this.updateRasterData();
         }
      }
      
      public function Instructions() : void
      {
         this._buildingInstructions += KEYS.Get("building_instructions");
      }
      
      public function FollowMouse() : void
      {
         if(BYMConfig.instance.RENDERER_ON)
         {
            this.showFootprint(true);
         }
         this.updateRasterData();
         _mc.addEventListener(Event.ENTER_FRAME,this.FollowMouseB);
         MAP._GROUND.addEventListener(MouseEvent.MOUSE_UP,this.Place);
         _mc.addEventListener(MouseEvent.MOUSE_DOWN,MAP.Click);
         this.Render(k_STATE_DEFAULT);
      }
      
      public function FollowMouseB(param1:Event = null) : void
      {
         var _loc2_:String = BASE.BuildBlockers(this,this._class == "decoration");
         var _loc3_:int = this._mcFootprint.currentFrame;
         _mc.x = int((MAP._GROUND.mouseX - this._mouseOffset.x) / 10) * 10;
         _mc.y = int((MAP._GROUND.mouseY - this._mouseOffset.y) / 5) * 5;
         this._mcBase.x = _mc.x;
         this._mcBase.y = _mc.y;
         this.updateRasterData();
         if(this._mcFootprint)
         {
            this._mcFootprint.x = _mc.x;
            this._mcFootprint.y = _mc.y;
            if(_loc2_ != "")
            {
               this._mcFootprint.gotoAndStop(2);
            }
            else
            {
               this._mcFootprint.gotoAndStop(1);
            }
         }
         this.showFootprint(false,_loc3_ !== this._mcFootprint.currentFrame);
         if(!BYMConfig.instance.RENDERER_ON)
         {
            MAP.SortDepth();
         }
      }
      
      public function Cancel() : void
      {
         if(GLOBAL._newBuilding === this)
         {
            this.clear();
         }
         GLOBAL._newBuilding = null;
         if(_mc)
         {
            _mc.removeEventListener(Event.ENTER_FRAME,this.FollowMouseB);
            _mc.removeEventListener(MouseEvent.MOUSE_DOWN,MAP.Click);
         }
         MAP._GROUND.removeEventListener(MouseEvent.MOUSE_UP,this.Place);
         if(this._mcBase.parent)
         {
            this._mcBase.parent.removeChild(this._mcBase);
         }
         if(_mc.parent)
         {
            _mc.parent.removeChild(_mc);
         }
         if(this._mcHit.parent)
         {
            this._mcHit.parent.removeChild(this._mcHit);
         }
         if(this._mcFootprint.parent)
         {
            this._mcFootprint.parent.removeChild(this._mcFootprint);
         }
         BASE.BuildingDeselect();
         this.clearRasterData();
      }
      
      protected function clearRasterData() : void
      {
         var _loc1_:RasterData = null;
         var _loc2_:int = 0;
         if(!BYMConfig.instance.RENDERER_ON || !this._rasterData)
         {
            return;
         }
         _loc2_ = int(this._rasterData.length - 1);
         while(_loc2_ >= 0)
         {
            _loc1_ = this._rasterData[_loc2_];
            if(_loc1_)
            {
               _loc1_.clear();
            }
            this._rasterData[_loc2_] = null;
            _loc2_--;
         }
      }
      
      public function Place(param1:MouseEvent = null) : void
      {
         var BragBiggulp:Function;
         var BragTotem:Function;
         var tmpBuildTime:int = 0;
         var fromStorage:int = 0;
         var isInfernoBuilding:Boolean = false;
         var mc:MovieClip = null;
         var totemImgUrl:String = null;
         var e:MouseEvent = param1;
         this.Description();
         if(!MAP._dragged)
         {
            if(BASE.BuildBlockers(this,this._class == "decoration") != "")
            {
               this.Cancel();
               return;
            }
            if(BASE.isInfernoMainYardOrOutpost)
            {
               SOUNDS.Play("inf_buildingplace");
            }
            else
            {
               SOUNDS.Play("buildingplace");
            }
            _mc.alpha = 1;
            _mc.removeEventListener(Event.ENTER_FRAME,this.FollowMouseB);
            MAP._GROUND.removeEventListener(MouseEvent.MOUSE_UP,this.Place);
            _mc.removeEventListener(MouseEvent.MOUSE_DOWN,MAP.Click);
            if(BASE.CanBuild(this._type,this._buildInstant).error)
            {
               this.Cancel();
               GLOBAL._newBuilding = null;
               return;
            }
            GLOBAL._newBuilding = null;
            if(this._buildInstant)
            {
               if(!this._buildInstantCost)
               {
                  this.Cancel();
                  return;
               }
               if(BASE._credits.Get() < this._buildInstantCost.Get())
               {
                  this.Cancel();
                  POPUPS.DisplayGetShiny();
                  return;
               }
            }
            this._hasResources = false;
            this._hasWorker = false;
            ++BASE._buildingCount;
            this._id = BASE._buildingCount;
            tmpBuildTime = int(this._buildingProps.costs[0].time.Get());
            if(STORE._storeData.BST)
            {
               tmpBuildTime -= tmpBuildTime * 0.2;
            }
            this._countdownBuild.Set(tmpBuildTime);
            setHealth(this._buildingProps.hp[0]);
            maxHealthProperty.value = health;
            this.PlaceB();
            if(_mc.contains(this._mcHit))
            {
               _mc.removeChild(this._mcHit);
            }
            if(BYMConfig.instance.RENDERER_ON)
            {
               MAP._BUILDINGTOPS.addChild(this._mcHit);
            }
            else
            {
               _mc.addChild(this._mcHit);
            }
            this.Tick(1);
            this.Update();
            this.Description();
            fromStorage = InventoryManager.buildingStorageRemove(this._type);
            if(!fromStorage)
            {
               if(!this._buildInstant)
               {
                  isInfernoBuilding = BASE.isInfernoBuilding(this._type);
                  BASE.Charge(1,this._buildingProps.costs[0].r1.Get(),false,isInfernoBuilding);
                  BASE.Charge(2,this._buildingProps.costs[0].r2.Get(),false,isInfernoBuilding);
                  BASE.Charge(3,this._buildingProps.costs[0].r3.Get(),false,isInfernoBuilding);
                  BASE.Charge(4,this._buildingProps.costs[0].r4.Get(),false,isInfernoBuilding);
                  if(STORE._storeItems["BUILDING" + this._type])
                  {
                     BASE.Purchase("BUILDING" + this._type,1,"building");
                  }
                  if(this._buildingProps.costs[0].time.Get() != 0 && InventoryManager.buildingStorageCount(this._type) == 0)
                  {
                     QUEUE.Add("building" + this._id,this);
                  }
               }
               else
               {
                  if(this._buildInstantCost.Get() > 0)
                  {
                     BASE.Purchase("IB",this._buildInstantCost.Get(),"building");
                  }
                  LOGGER.Stat([71,this._buildInstantCost.Get(),this._type]);
                  this.Constructed();
               }
            }
            else
            {
               this.Constructed();
               if(this._type == 120)
               {
                  LOGGER.Stat([75,"placedgoldenbiggulp"]);
               }
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
               {
                  BragBiggulp = function():void
                  {
                     GLOBAL.CallJS("sendFeed",["biggulp-construct",KEYS.Get("pop_biggulpbuilt_streamtitle"),KEYS.Get("pop_biggulpbuilt_streambody"),"dave_711promo.png"]);
                     POPUPS.Next();
                  };
                  BragTotem = function(param1:int):Function
                  {
                     var totemType:int = param1;
                     return function(param1:MouseEvent = null):void
                     {
                        switch(totemType)
                        {
                           case 121:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave1streamtitle"),KEYS.Get("wmi_wave1streamdesc"),"wmitotemfeed1.1.png"]);
                              break;
                           case 122:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave10streamtitle"),KEYS.Get("wmi_wave10streamdesc"),"wmitotemfeed2.png"]);
                              break;
                           case 123:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave20streamtitle"),KEYS.Get("wmi_wave20streamdesc"),"wmitotemfeed3.png"]);
                              break;
                           case 124:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave30streamtitle"),KEYS.Get("wmi_wave30streamdesc"),"wmitotemfeed4.png"]);
                              break;
                           case 125:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave31streamtitle"),KEYS.Get("wmi_wave31streamdesc"),"wmitotemfeed5.png"]);
                              break;
                           case 126:
                              GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave32streamtitle"),KEYS.Get("wmi_wave32streamdesc"),"wmitotemfeed6.png"]);
                              break;
                           case 131:
                              switch(_lvl.Get())
                              {
                                 case 1:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave1streamtitle"),KEYS.Get("wmi2_wave1streamdesc"),"wmitotemfeed2_1.png"]);
                                    break;
                                 case 2:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave10streamtitle"),KEYS.Get("wmi2_wave10streamdesc"),"wmitotemfeed2_2.png"]);
                                    break;
                                 case 3:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave20streamtitle"),KEYS.Get("wmi2_wave20streamdesc"),"wmitotemfeed2_3.png"]);
                                    break;
                                 case 4:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave30streamtitle"),KEYS.Get("wmi2_wave30streamdesc"),"wmitotemfeed2_4.png"]);
                                    break;
                                 case 5:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave31streamtitle"),KEYS.Get("wmi2_wave31streamdesc"),"wmitotemfeed2_5.png"]);
                                    break;
                                 case 6:
                                    GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave32streamtitle"),KEYS.Get("wmi2_wave32streamdesc"),"wmitotemfeed2_6.png"]);
                              }
                        }
                        POPUPS.Next();
                     };
                  };
                  mc = new popup_biggulp();
                  if(BASE.is711Valid())
                  {
                     if(this._type == 120)
                     {
                        mc.tA.htmlText = "<b>" + KEYS.Get("pop_biggulpbuilt_title") + "</b>";
                        mc.tB.htmlText = KEYS.Get("pop_biggulpbuilt_body");
                        mc.bPost.SetupKey("btn_brag");
                        mc.bPost.addEventListener(MouseEvent.CLICK,BragBiggulp);
                        mc.bPost.Highlight = true;
                        POPUPS.Push(mc,null,null,null,"building-biggulp.png");
                     }
                  }
                  totemImgUrl = "";
                  if(BTOTEM.IsTotem(this._type))
                  {
                     mc.tA.htmlText = "<b>" + KEYS.Get("wmi_totemwon") + "</b>";
                     mc.tB.htmlText = "";
                     mc.bPost.SetupKey("btn_brag");
                     mc.bPost.addEventListener(MouseEvent.CLICK,BragTotem(this._type));
                     mc.bPost.Highlight = true;
                     switch(this._type)
                     {
                        case 121:
                           totemImgUrl = "building-wmitotem1.png";
                           break;
                        case 122:
                           totemImgUrl = "building-wmitotem2.png";
                           break;
                        case 123:
                           totemImgUrl = "building-wmitotem3.png";
                           break;
                        case 124:
                           totemImgUrl = "building-wmitotem4.png";
                           break;
                        case 125:
                           totemImgUrl = "building-wmitotem5.png";
                           break;
                        case 126:
                           totemImgUrl = "building-wmitotem6.png";
                           break;
                        default:
                           totemImgUrl = "building-wmitotem6.png";
                     }
                     POPUPS.Push(mc,null,null,null,totemImgUrl);
                  }
                  else if(BTOTEM.IsTotem2(this._type))
                  {
                     mc.tA.htmlText = "<b>" + KEYS.Get("wmi2_totemwon") + "</b>";
                     mc.tB.htmlText = "";
                     mc.bPost.SetupKey("btn_brag");
                     mc.bPost.addEventListener(MouseEvent.CLICK,BragTotem(this._type));
                     mc.bPost.Highlight = true;
                     switch(this._lvl.Get())
                     {
                        case 1:
                           totemImgUrl = "building-wmi2totem1.png";
                           break;
                        case 2:
                           totemImgUrl = "building-wmi2totem2.png";
                           break;
                        case 3:
                           totemImgUrl = "building-wmi2totem3.png";
                           break;
                        case 4:
                           totemImgUrl = "building-wmi2totem4.png";
                           break;
                        case 5:
                           totemImgUrl = "building-wmi2totem5.png";
                           break;
                        case 6:
                           totemImgUrl = "building-wmi2totem6.png";
                           break;
                        default:
                           totemImgUrl = "building-wmi2totem6.png";
                     }
                     POPUPS.Push(mc,null,null,null,totemImgUrl);
                  }
               }
            }
            if(BASE._pendingPurchase.length == 0)
            {
               BASE.Save();
            }
            UPDATES.Create(["BP",this._type,this.Export()]);
            LOGGER.Stat([5,this._type]);
         }
         this.updateRasterData();
         this.onMove();
      }
      
      public function SetGiftingProps(param1:int, param2:String, param3:int, param4:String, param5:String) : void
      {
         this._threadid = param1;
         this._subject = param2;
         this._senderid = param3;
         this._senderName = param4;
         this._senderPic = param5;
         UPDATES.Create(["BT",this._id,this._threadid,this._subject,this._senderid,this._senderName,this._senderPic]);
      }
      
      protected function setupListeners() : void
      {
         if(!this._mcHit)
         {
            return;
         }
         if(!this._mcHit.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this._mcHit.addEventListener(MouseEvent.MOUSE_DOWN,this.Mousedown);
         }
         if(!this._mcHit.hasEventListener(MouseEvent.MOUSE_UP))
         {
            this._mcHit.addEventListener(MouseEvent.MOUSE_UP,this.Mouseup);
         }
         if(!this._mcHit.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this._mcHit.addEventListener(MouseEvent.MOUSE_OVER,this.Over);
         }
         if(!this._mcHit.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this._mcHit.addEventListener(MouseEvent.MOUSE_OUT,this.Out);
         }
      }
      
      protected function removeListeners() : void
      {
         if(!this._mcHit)
         {
            return;
         }
         if(this._mcHit.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this._mcHit.removeEventListener(MouseEvent.MOUSE_DOWN,this.Mousedown);
         }
         if(this._mcHit.hasEventListener(MouseEvent.MOUSE_UP))
         {
            this._mcHit.removeEventListener(MouseEvent.MOUSE_UP,this.Mouseup);
         }
         if(this._mcHit.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this._mcHit.removeEventListener(MouseEvent.MOUSE_OVER,this.Over);
         }
         if(this._mcHit.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this._mcHit.removeEventListener(MouseEvent.MOUSE_OUT,this.Out);
         }
      }
      
      public function PlaceB() : void
      {
         this._position = new Point(_mc.x,_mc.y);
         _mc.mouseEnabled = false;
         this._mcBase.mouseEnabled = false;
         this._mcBase.x = _mc.x;
         this._mcBase.y = _mc.y;
         _mc.alpha = 1;
         this._mcFootprint.x = _mc.x;
         this._mcFootprint.y = _mc.y;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.ATTACK && GLOBAL.mode != GLOBAL.e_BASE_MODE.WMATTACK || this._senderid == LOGIN._playerID)
         {
            this._mcHit.mouseEnabled = true;
            this._mcHit.buttonMode = true;
            this.setupListeners();
         }
         else
         {
            _mc.mouseEnabled = false;
            _mc.mouseChildren = false;
            this._mcHit.mouseEnabled = false;
            this._mcHit.mouseChildren = false;
            this._mcHit.buttonMode = false;
         }
         if(!(this._destroyed && GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD))
         {
            this.GridCost(true);
         }
         if(this._type == 7)
         {
            BASE._buildingsMushrooms["m" + this._id] = this;
         }
         else
         {
            BASE.buildings.push(this);
            BASE._buildingsAll["b" + this._id] = this;
            if(this._class == "wall")
            {
               BASE._buildingsWalls["b" + this._id] = this;
            }
            else if(this._class == "trap")
            {
               BASE._buildingsTowers["b" + this._id] = this;
            }
            else if(this._class == "tower")
            {
               BASE._buildingsTowers["b" + this._id] = this;
               BASE._buildingsMain["b" + this._id] = this;
               if(MONSTERBUNKER.isBunkerBuilding(this._type))
               {
                  BASE._buildingsBunkers["b" + this._id] = this;
               }
            }
            else if(this._class == "gift" || this._class == "taunt")
            {
               BASE._buildingsGifts["b" + this._id] = this;
            }
            else if(this._class != "cage")
            {
               BASE._buildingsMain["b" + this._id] = this;
            }
         }
         if(!GLOBAL._catchup && !BASE.processing)
         {
            BASE.HideFootprints();
         }
         if(this._class != "mushroom")
         {
            BuildingOverlay.Setup(this);
         }
         this.Description();
         this.Update();
         this._placing = false;
         if(this._class != "wall" && this._class != "trap")
         {
            BUILDINGS._buildingID = 0;
         }
         GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.PLACED_FOR_CONSTRUCTION,this));
         this.updateRasterData();
      }
      
      public function Destroyed(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this._destroyed)
         {
            this._destroyed = true;
            ATTACK.Damage(_mc.x,_mc.y,this._buildingProps.hp[this._lvl.Get() - 1]);
            if(this._repairing == 1)
            {
               this._repairing = 0;
               QUEUE.Remove("building" + this._id,true,this);
               ATTACK.Log("b" + this._id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_downed_repaircancel",{
                  "v1":this._lvl.Get(),
                  "v2":KEYS.Get(this._buildingProps.name)
               }) + "</font>");
            }
            else if(this._countdownBuild.Get() > 0)
            {
               ATTACK.Damage(_mc.x,_mc.y,this._buildingProps.hp[this._lvl.Get()]);
               ATTACK.Log("b" + this._id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_downed_buildcancel",{
                  "v1":this._lvl.Get(),
                  "v2":KEYS.Get(this._buildingProps.name)
               }) + "</font>");
            }
            else if(this._countdownUpgrade.Get())
            {
               ATTACK.Damage(_mc.x,_mc.y,this._buildingProps.hp[this._lvl.Get()]);
               _loc2_ = int(this._buildingProps.costs[this._lvl.Get()].time.Get() * GLOBAL._buildTime);
               _loc3_ = (_loc2_ - this._countdownUpgrade.Get()) * 0.5;
               if(_loc3_ > 60 * 60 * 8)
               {
                  _loc3_ = 60 * 60 * 8;
               }
               if((_loc4_ = this._countdownUpgrade.Get() + _loc3_) < 0)
               {
                  _loc4_ = 0;
               }
               ATTACK.Log("b" + this._id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_downed_upgradecancel",{
                  "v1":this._lvl.Get(),
                  "v2":KEYS.Get(this._buildingProps.name),
                  "v3":this._lvl.Get() + 1
               }) + "</font>");
               this._countdownUpgrade.Set(_loc4_);
            }
            else
            {
               ATTACK.Log("b" + this._id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_downed",{
                  "v1":this._lvl.Get(),
                  "v2":KEYS.Get(this._buildingProps.name)
               }) + "</font>");
            }
            this.Update(true);
            this.GridCost(false);
            PATHING.ResetCosts();
            BASE.Save();
         }
         this._repairing = 0;
      }
      
      public function Repair() : void
      {
         this._repairing = 1;
         this._destroyed = false;
         this.Update();
         BASE.Save();
      }
      
      public function Repaired() : void
      {
         this._repairing = 0;
         setHealth(maxHealth);
         if(this._type == 15 || this._type == 128)
         {
            HOUSING.HousingSpace();
         }
         this.Description();
         UI2.Update();
      }
      
      public function HasWorker() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         this._hasWorker = true;
         if(this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() > 0)
         {
            _loc1_ = uint(BASE.isInfernoBuilding(this._type) || BASE.isInfernoMainYardOrOutpost ? 5 : 1);
            _loc2_ = 1;
            while(_loc2_ < 5)
            {
               _loc3_ = !!this._buildingProps.costs[this._lvl.Get()] ? uint(this._buildingProps.costs[this._lvl.Get()]["r" + _loc2_].Get()) : 0;
               if (!_loc3_)
               {
                  _loc3_ = !!this._buildingProps.fortify_costs[this._fortification.Get()] ? uint(this._buildingProps.fortify_costs[this._fortification.Get()]["r" + _loc2_].Get()) : 0;
               }
               if(_loc3_)
               {
                  ResourcePackages.Create(_loc1_,this,_loc3_,true);
               }
               _loc1_++;
               _loc2_++;
            }
         }
      }
      
      public function Over(param1:MouseEvent) : void
      {
         GLOBAL._buildingMousedOver = this;
      }
      
      public function Out(param1:MouseEvent) : void
      {
      }
      
      public function FinishNowCost() : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Boolean = true;
         if(this._countdownBuild.Get() > 0)
         {
            _loc2_ = this._countdownBuild.Get();
         }
         if(this._countdownUpgrade.Get() > 0)
         {
            _loc2_ = this._countdownUpgrade.Get();
         }
         if(this._countdownFortify.Get() > 0)
         {
            _loc2_ = this._countdownFortify.Get();
         }
         if(_loc1_ && _loc2_ <= 300)
         {
            return 0;
         }
         _loc3_ = Math.ceil(_loc2_ * 20 / 60 / 60);
         _loc4_ = int(Math.sqrt(_loc2_ * 0.8));
         return Math.min(_loc3_,_loc4_);
      }
      
      public function InstantBuildCost() : int
      {
         var _loc1_:Object = GLOBAL._buildingProps[this._type - 1].costs[0];
         var _loc2_:int = int(_loc1_.time.Get());
         if(_loc2_ <= 300)
         {
            _loc2_ = 0;
         }
         var _loc3_:int = _loc1_.r1.Get() + _loc1_.r2.Get() + _loc1_.r3.Get();
         var _loc4_:int = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
         var _loc5_:int = STORE.GetTimeCost(_loc2_);
         var _loc6_:int = _loc4_ + _loc5_;
         return int(_loc6_ * 0.95);
      }
      
      public function InstantFortifyCost() : int
      {
         if(this._buildingProps.fortify_costs.length <= this._fortification.Get())
         {
            return 0;
         }
         var _loc1_:Object = this._buildingProps.fortify_costs[this._fortification.Get()];
         var _loc2_:int = int(_loc1_.time.Get());
         if(_loc2_ <= 300)
         {
            _loc2_ = 0;
         }
         var _loc3_:int = _loc1_.r1.Get() + _loc1_.r2.Get() + _loc1_.r3.Get();
         var _loc4_:int = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
         var _loc5_:int = STORE.GetTimeCost(_loc2_);
         var _loc6_:int = _loc4_ + _loc5_;
         return int(_loc6_ * 0.95);
      }
      
      public function InstantUpgradeCost() : int
      {
         if(this._buildingProps.costs.length <= this._lvl.Get())
         {
            return 0;
         }
         var _loc1_:Object = this._buildingProps.costs[this._lvl.Get()];
         var _loc2_:int = int(_loc1_.time.Get());
         if(_loc2_ <= 300)
         {
            _loc2_ = 0;
         }
         var _loc3_:int = _loc1_.r1.Get() + _loc1_.r2.Get() + _loc1_.r3.Get();
         var _loc4_:int = Math.ceil(Math.pow(Math.sqrt(_loc3_ / 2),0.75));
         var _loc5_:int = STORE.GetTimeCost(_loc2_);
         var _loc6_:int = _loc4_ + _loc5_;
         return int(_loc6_ * 0.95);
      }
      
      public function DoInstantUpgrade() : Boolean
      {
         var _loc1_:int = this.InstantUpgradeCost();
         if(BASE._credits.Get() >= _loc1_)
         {
            this.Upgraded();
            BASE.Purchase("IU",_loc1_,"upgrade");
            LOGGER.Stat([72,_loc1_,this._type,this._lvl.Get()]);
            return true;
         }
         POPUPS.DisplayGetShiny();
         return false;
      }
      
      public function DoInstantFortify() : Boolean
      {
         var _loc1_:int = this.InstantFortifyCost();
         if(BASE._credits.Get() >= _loc1_)
         {
            this.Fortified();
            BASE.Purchase("IF",_loc1_,"fortify");
            return true;
         }
         POPUPS.DisplayGetShiny();
         return false;
      }
      
      public function Fortify() : Boolean
      {
         var _loc1_:Object = null;
         if(!QUEUE.CanDo().error)
         {
            _loc1_ = BASE.CanFortify(this);
            if(!_loc1_.error)
            {
               if(int(this._buildingProps.fortify_costs[this._fortification.Get()].time.Get() * GLOBAL._buildTime) > 3600)
               {
                  UPDATES.Create(["BF",this._id]);
               }
               this.FortifyB();
               BASE.Save();
               return true;
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(_loc1_.errorMessage);
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            POPUPS.DisplayWorker(3,this);
         }
         return false;
      }
      
      public function FortifyB() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this._countdownFortify.Get() == 0)
         {
            _loc1_ = BASE.CanFortify(this);
            if(!_loc1_.error)
            {
               _loc2_ = this.FortifyCost();
               if(_loc2_.r1.Get() > 0)
               {
                  BASE.Charge(1,_loc2_.r1.Get());
               }
               if(_loc2_.r2.Get() > 0)
               {
                  BASE.Charge(2,_loc2_.r2.Get());
               }
               if(_loc2_.r3.Get() > 0)
               {
                  BASE.Charge(3,_loc2_.r3.Get());
               }
               if(_loc2_.r4.Get() > 0)
               {
                  BASE.Charge(4,_loc2_.r4.Get());
               }
               _loc3_ = int(this._buildingProps.fortify_costs[this._fortification.Get()].time.Get() * GLOBAL._buildTime);
               this._countdownFortify.Set(_loc3_);
               this._hasResources = false;
               this._hasWorker = false;
               if(GLOBAL._catchup)
               {
                  this._hasResources = true;
                  this._hasWorker = true;
               }
               QUEUE.Add("building" + this._id,this);
               LOGGER.Stat([64,this._type,this._fortification.Get() + 1]);
               this._helpList = [];
               this.Update();
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && this._class == "tower")
               {
                  GLOBAL._selectedBuilding = this;
                  GLOBAL.Message(KEYS.Get("msg_inactivefortify"),KEYS.Get("btn_speedup"),STORE.SpeedUp,["SP4"]);
               }
            }
            else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(_loc1_.errorMessage);
            }
         }
      }
      
      public function FortifyCancel() : void
      {
         GLOBAL.Message(KEYS.Get("msg_fortifycancelconfirm"),KEYS.Get("msg_stopfortifying_btn"),this.FortifyCancelB);
      }
      
      public function FortifyCancelB(param1:MouseEvent = null) : void
      {
         UPDATES.Create(["BFC",this._id]);
         this.FortifyCancelC();
      }
      
      public function FortifyCancelC() : void
      {
         var _loc1_:Object = null;
         if(this._countdownFortify.Get() > 0)
         {
            QUEUE.Remove("building" + this._id,false,this);
            this._countdownFortify.Set(0);
            _loc1_ = this.FortifyCost();
            if(_loc1_.r1.Get() > 0)
            {
               BASE.Fund(1,int(_loc1_.r1.Get()));
            }
            if(_loc1_.r2.Get() > 0)
            {
               BASE.Fund(2,int(_loc1_.r2.Get()));
            }
            if(_loc1_.r3.Get() > 0)
            {
               BASE.Fund(3,int(_loc1_.r3.Get()));
            }
            if(_loc1_.r4.Get() > 0)
            {
               BASE.Fund(4,int(_loc1_.r4.Get()));
            }
            BASE.Save();
         }
      }
      
      public function Upgrade() : Boolean
      {
         var _loc1_:Object = null;
         if(!QUEUE.CanDo().error)
         {
            _loc1_ = BASE.CanUpgrade(this);
            if(!_loc1_.error)
            {
               if(int(this._buildingProps.costs[this._lvl.Get()].time.Get() * GLOBAL._buildTime) > 3600)
               {
                  UPDATES.Create(["BU",this._id]);
               }
               this.UpgradeB();
               BASE.Save();
               return true;
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(_loc1_.errorMessage);
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            POPUPS.DisplayWorker(1,this);
         }
         return false;
      }
      
      public function UpgradeB() : void
      {
         var GetFriends:Function;
         var canUpgrade:Object = null;
         var o:Object = null;
         var isInfernoBuilding:Boolean = false;
         var tmpUpgradeTime:int = 0;
         var popupMC:popup_helpme = null;
         if(this._countdownUpgrade.Get() == 0)
         {
            canUpgrade = BASE.CanUpgrade(this);
            if(!canUpgrade.error)
            {
               o = this.UpgradeCost();
               isInfernoBuilding = BASE.isInfernoBuilding(this._type);
               if(o.r1.Get() > 0)
               {
                  BASE.Charge(1,o.r1.Get(),false,isInfernoBuilding);
               }
               if(o.r2.Get() > 0)
               {
                  BASE.Charge(2,o.r2.Get(),false,isInfernoBuilding);
               }
               if(o.r3.Get() > 0)
               {
                  BASE.Charge(3,o.r3.Get(),false,isInfernoBuilding);
               }
               if(o.r4.Get() > 0)
               {
                  BASE.Charge(4,o.r4.Get(),false,isInfernoBuilding);
               }
               tmpUpgradeTime = int(this._buildingProps.costs[this._lvl.Get()].time.Get() * GLOBAL._buildTime);
               this._countdownUpgrade.Set(tmpUpgradeTime);
               if(this._type != 14 && this._countdownUpgrade.Get() > 60 * 60 * 2 && TUTORIAL._stage > 200)
               {
                  if(!GLOBAL._promptedInvite && BASE._credits.Get() < 40 && GLOBAL._canInvite && GLOBAL._friendCount == 0)
                  {
                     GetFriends = function():void
                     {
                        if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
                        {
                           GLOBAL.CallJSWithClient("cc.showFeedDialog","callbackgift",["invite"]);
                        }
                        else
                        {
                           GLOBAL.CallJS("cc.showFeedDialog",["invite","callbackgift"]);
                        }
                     };
                     GLOBAL._promptedInvite = true;
                     popupMC = new popup_helpme();
                     popupMC.tB.text = KEYS.Get("pop_helpme");
                     popupMC.bAction.SetupKey("btn_invitefriends");
                     popupMC.bAction.addEventListener(MouseEvent.CLICK,GetFriends);
                     POPUPS.Push(popupMC);
                  }
               }
               this._hasResources = false;
               this._hasWorker = false;
               if(GLOBAL._catchup)
               {
                  this._hasResources = true;
                  this._hasWorker = true;
               }
               QUEUE.Add("building" + this._id,this);
               LOGGER.Stat([7,this._type,this._lvl.Get() + 1]);
               this._helpList = [];
               this.Update();
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && this._class == "tower")
               {
                  GLOBAL._selectedBuilding = this;
                  GLOBAL.Message(KEYS.Get("msg_inactiveupgrade"),KEYS.Get("btn_speedup"),STORE.SpeedUp,["SP4"]);
               }
               GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.UPGRADED,this));
            }
            else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(canUpgrade.errorMessage);
            }
         }
      }
      
      public function Help() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() > 0)
         {
            if(this._helpList.length > 4)
            {
               GLOBAL.Message(KEYS.Get("base_5alreadyhelped"));
               return false;
            }
            for each(_loc1_ in this._helpList)
            {
               if(_loc1_ == LOGIN._playerID)
               {
                  GLOBAL.Message(KEYS.Get("base_alreadyhelped"));
                  return false;
               }
            }
            UPDATES.Create(["BH",this._id,LOGIN._playerID]);
            this._helpList.push(LOGIN._playerID);
            _loc2_ = this.HelpB();
            if(this._countdownBuild.Get() > 0)
            {
               GLOBAL.Message(KEYS.Get("base_thankbuild",{
                  "v1":GLOBAL.ToTime(_loc2_,false,false),
                  "v2":KEYS.Get(this._buildingProps.name)
               }));
               LOGGER.Stat([14,this._type,0,0,_loc2_]);
               _loc3_ = "build";
            }
            if(this._countdownUpgrade.Get() > 0)
            {
               GLOBAL.Message(KEYS.Get("base_thankupgrade",{
                  "v1":GLOBAL.ToTime(_loc2_,false,false),
                  "v2":KEYS.Get(this._buildingProps.name)
               }));
               LOGGER.Stat([15,this._type,this._lvl.Get() + 1,0,_loc2_]);
               _loc3_ = "upgrade";
            }
            if(this._countdownFortify.Get() > 0)
            {
               GLOBAL.Message(KEYS.Get("base_thankfortify",{
                  "v1":GLOBAL.ToTime(_loc2_,false,false),
                  "v2":KEYS.Get(this._buildingProps.name)
               }));
               LOGGER.Stat([66,this._type,this._fortification.Get() + 1,0,_loc2_]);
               _loc3_ = "fortify";
            }
         }
         return true;
      }
      
      public function HelpB() : int
      {
         var _loc1_:int = 0;
         if(this._countdownBuild.Get() > 0)
         {
            _loc1_ = int(this._countdownBuild.Get() * 0.05);
            this._countdownBuild.Add(0 - int(this._countdownBuild.Get() * 0.05));
         }
         else if(this._countdownUpgrade.Get() > 0)
         {
            _loc1_ = int(this._countdownUpgrade.Get() * 0.05);
            this._countdownUpgrade.Add(0 - int(this._countdownUpgrade.Get() * 0.05));
         }
         else if(this._countdownFortify.Get() > 0)
         {
            _loc1_ = int(this._countdownFortify.Get() * 0.05);
            this._countdownFortify.Add(0 - int(this._countdownFortify.Get() * 0.05));
         }
         BASE.Save();
         return _loc1_;
      }
      
      public function UpgradeCancel() : void
      {
         GLOBAL.Message(KEYS.Get("msg_upgradecancelconfirm"),KEYS.Get("msg_stopupgrading_btn"),this.UpgradeCancelB);
      }
      
      public function UpgradeCancelB(param1:MouseEvent = null) : void
      {
         UPDATES.Create(["BUC",this._id]);
         this.UpgradeCancelC();
      }
      
      public function UpgradeCancelC() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         if(this._countdownUpgrade.Get() > 0)
         {
            QUEUE.Remove("building" + this._id,false,this);
            this._countdownUpgrade.Set(0);
            _loc1_ = this.UpgradeCost();
            _loc2_ = BASE.isInfernoBuilding(this._type);
            if(_loc1_.r1.Get())
            {
               BASE.Fund(1,int(_loc1_.r1.Get()),false,null,_loc2_);
            }
            if(_loc1_.r2.Get())
            {
               BASE.Fund(2,int(_loc1_.r2.Get()),false,null,_loc2_);
            }
            if(_loc1_.r3.Get())
            {
               BASE.Fund(3,int(_loc1_.r3.Get()),false,null,_loc2_);
            }
            if(_loc1_.r4.Get())
            {
               BASE.Fund(4,int(_loc1_.r4.Get()),false,null,_loc2_);
            }
            BASE.Save();
         }
      }
      
      public function Upgraded() : void
      {
         var c:Object;
         var a:int;
         try
         {
            if(Math.max(this._countdownUpgrade.Get(),0))
            {
            }
            this._countdownUpgrade.Set(0);
            this._lvl.Add(1);
            ++this._hpLvl;
            maxHealthProperty.value = this._buildingProps.hp[this._lvl.Get() - 1];
            setHealth(maxHealth);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Foundation.Upgraded: " + e.message + " | " + e.getStackTrace());
         }
         QUESTS.Check("blvl",this._lvl.Get());
         if(this._type < 5)
         {
            QUESTS.Check("brlvl",this._lvl.Get());
         }
         QUESTS.Check("b" + this._type + "lvl",this._lvl.Get());
         BASE.CalcResources();
         c = this._buildingProps.costs[this._lvl.Get() - 2];
         a = Math.floor((int(c.time.Get()) + int(c.r1.Get()) + int(c.r2.Get()) + int(c.r3.Get()) + int(c.r4.Get())) / 3);
         BASE.PointsAdd(a);
         this.Description();
         QUEUE.Remove("building" + this._id,true,this);
         LOGGER.Stat([8,this._type,this._lvl.Get()]);
      }
      
      public function downgraded() : void
      {
      }
      
      public function Downgrade_TOTEM_DEBUG() : void
      {
         if(this._type != BTOTEM.BTOTEM_BUILDING_TYPE)
         {
            return;
         }
         if(this._lvl.Get() <= 1)
         {
            return;
         }
         try
         {
            this._countdownUpgrade.Set(0);
            this._lvl.Add(-1);
            --this._hpLvl;
            maxHealthProperty.value = this._buildingProps.hp[this._lvl.Get() - 1];
            setHealth(maxHealth);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Foundation.Downgrade_TOTEM_DEBUG: " + e.message + " | " + e.getStackTrace());
         }
      }
      
      public function Fortified() : void
      {
         var c:Object;
         var a:int;
         try
         {
            if(Math.max(this._countdownFortify.Get(),0))
            {
               LOGGER.Log("log","bdg fort cnt > 0, probable hack");
               GLOBAL.ErrorMessage("BFOUNDATION fortify hack");
               return;
            }
            this._countdownFortify.Set(0);
            this._fortification.Add(1);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Foundation.Fortified: " + e.message + " | " + e.getStackTrace());
         }
         BASE.CalcResources();
         c = this._buildingProps.fortify_costs[this._fortification.Get() - 1];
         a = Math.floor((int(c.time.Get()) + int(c.r1.Get()) + int(c.r2.Get()) + int(c.r3.Get()) + int(c.r4.Get())) / 3);
         BASE.PointsAdd(a);
         this.Description();
         QUEUE.Remove("building" + this._id,true,this);
         LOGGER.Stat([65,this._type,this._fortification.Get()]);
      }
      
      public function Recycle() : void
      {
         var _loc1_:String = null;
         if(this._countdownBuild.Get() > 0)
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               if(BASE.isOutpostOrInfernoOutpost)
               {
                  GLOBAL.Message(KEYS.Get("msg_stopconstructionoutpostbuilding"));
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("msg_stopconstructionconfirm"),KEYS.Get("msg_destroybuilding_btn"),this.RecycleB);
               }
            }
         }
         else if(this._class == "taunt" || this._class == "gift")
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(KEYS.Get("msg_recycleconfirm"),KEYS.Get("msg_recyclebuilding_btn"),this.RecycleC);
            }
         }
         else if(this._class == "decoration")
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.Message(KEYS.Get("ui_placeinstorage"),KEYS.Get("btn_addstorage"),this.RecycleB);
            }
         }
         else if(!this._blockRecycle)
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               _loc1_ = !!GLOBAL._buildingProps[this._type - 1]["recycleconfirmationoverride"] ? String(GLOBAL._buildingProps[this._type - 1]["recycleconfirmationoverride"]) : "msg_recycleconfirm";
               GLOBAL.Message(KEYS.Get(_loc1_),KEYS.Get("msg_recyclebuilding_btn"),this.RecycleB);
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(BASE.isOutpostOrInfernoOutpost)
            {
               GLOBAL.Message(KEYS.Get("msg_recycleoutpostbuilding"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_recycleunavailable"));
            }
         }
         GLOBAL.eventDispatcher.dispatchEvent(new BuildingEvent(BuildingEvent.ATTEMPT_RECYCLE,this));
      }
      
      public function RecycleB(param1:MouseEvent = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         BUILDINGOPTIONS.Hide();
         if(this._class != "decoration" && !this._blockRecycle)
         {
            if(!this._recycled)
            {
               this._recycled = true;
               _loc2_ = this.RecycleCost();
               _loc3_ = BASE.isInfernoBuilding(this._type);
               if(_loc2_.r1.Get())
               {
                  BASE.Fund(1,int(_loc2_.r1.Get()),false,null,_loc3_);
               }
               if(_loc2_.r2.Get())
               {
                  BASE.Fund(2,int(_loc2_.r2.Get()),false,null,_loc3_);
               }
               if(_loc2_.r3.Get())
               {
                  BASE.Fund(3,int(_loc2_.r3.Get()),false,null,_loc3_);
               }
               if(_loc2_.r4.Get())
               {
                  BASE.Fund(4,int(_loc2_.r4.Get()),false,null,_loc3_);
               }
               this.RecycleC();
               LOGGER.Stat([40,this._type,this._lvl.Get()]);
            }
         }
         else if(!this._blockRecycle)
         {
            this.RecycleC();
         }
      }
      
      public function RecycleC() : void
      {
         this.GridCost(false);
         try
         {
            if(MAP._BUILDINGFOOTPRINTS.contains(this._mcBase))
            {
               MAP._BUILDINGBASES.removeChild(this._mcBase);
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(MAP._BUILDINGFOOTPRINTS.contains(this._mcFootprint))
            {
               MAP._BUILDINGFOOTPRINTS.removeChild(this._mcFootprint);
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(MAP._BUILDINGTOPS.contains(_mc))
            {
               MAP._BUILDINGTOPS.removeChild(_mc);
            }
         }
         catch(e:Error)
         {
         }
         GRID.Clear();
         if(!BYMConfig.instance.RENDERER_ON)
         {
            MAP.SortDepth();
         }
         if(this._type != 7)
         {
            QUEUE.Remove("building" + this._id,false,this);
         }
         BASE.BuildingDeselect();
         if(this._class == "decoration")
         {
            InventoryManager.buildingStorageAdd(this._type,this._lvl.Get());
         }
         this.clear();
         BASE.Save();
      }
      
      public function GridCost(param1:Boolean = true) : void
      {
         var _loc2_:Rectangle = null;
         if(this._footprint)
         {
            for each(_loc2_ in this._footprint)
            {
               GRID.Block(new Rectangle(_loc2_.x + _mc.x,_loc2_.y + _mc.y,_loc2_.width,_loc2_.height),param1);
            }
         }
      }
      
      public function RecycleCost() : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc1_:Object = {
            "r1":new SecNum(0),
            "r2":new SecNum(0),
            "r3":new SecNum(0),
            "r4":new SecNum(0),
            "r5":0,
            "time":new SecNum(0)
         };
         if(GLOBAL._buildingProps[this._type - 1].rewarded)
         {
            return _loc1_;
         }
         if(this._lvl.Get() == 0)
         {
            _loc1_.r1.Add(this._buildingProps.costs[0].r1.Get());
            _loc1_.r2.Add(this._buildingProps.costs[0].r2.Get());
            _loc1_.r3.Add(this._buildingProps.costs[0].r3.Get());
            _loc1_.r4.Add(this._buildingProps.costs[0].r4.Get());
            _loc1_.r5 += this._buildingProps.costs[0].r5;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this._lvl.Get())
            {
               _loc3_ = this._buildingProps.costs[_loc2_];
               if(_loc3_)
               {
                  _loc1_.r1.Add(_loc3_.r1.Get());
                  _loc1_.r2.Add(_loc3_.r2.Get());
                  _loc1_.r3.Add(_loc3_.r3.Get());
                  _loc1_.r4.Add(_loc3_.r4.Get());
                  _loc1_.r5 += _loc3_.r5;
               }
               _loc2_++;
            }
            _loc1_.r1.Set(int(_loc1_.r1.Get() * 0.5));
            _loc1_.r2.Set(int(_loc1_.r2.Get() * 0.5));
            _loc1_.r3.Set(int(_loc1_.r3.Get() * 0.5));
            _loc1_.r4.Set(int(_loc1_.r4.Get() * 0.5));
            _loc1_.r5 = int(_loc1_.r5 * 0.5);
         }
         return _loc1_;
      }
      
      public function UpgradeCost() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(this._buildingProps.costs.length > this._lvl.Get())
         {
            _loc1_ = {
               "time":new SecNum(0),
               "r1":new SecNum(this._buildingProps.costs[this._lvl.Get()].r1.Get()),
               "r2":new SecNum(this._buildingProps.costs[this._lvl.Get()].r2.Get()),
               "r3":new SecNum(this._buildingProps.costs[this._lvl.Get()].r3.Get()),
               "r4":new SecNum(this._buildingProps.costs[this._lvl.Get()].r4.Get()),
               "r1over":false,
               "r2over":false,
               "r3over":false,
               "r4over":false
            };
            _loc2_ = this._buildingProps.costs[this._lvl.Get()];
            if(BASE._resources.r1.Get() < _loc2_.r1.Get())
            {
               _loc1_.r1over = true;
            }
            if(BASE._resources.r2.Get() < _loc2_.r2.Get())
            {
               _loc1_.r2over = true;
            }
            if(BASE._resources.r3.Get() < _loc2_.r3.Get())
            {
               _loc1_.r3over = true;
            }
            if(BASE._resources.r4.Get() < _loc2_.r4.Get())
            {
               _loc1_.r4over = true;
            }
            _loc1_.time.Set(_loc2_.time.Get());
            return _loc1_;
         }
         return {};
      }
      
      public function FortifyCost() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(this._buildingProps.can_fortify != true)
         {
            return {};
         }
         if(this._buildingProps.fortify_costs.length > this._fortification.Get())
         {
            _loc1_ = {
               "time":new SecNum(0),
               "r1":new SecNum(this._buildingProps.fortify_costs[this._fortification.Get()].r1.Get()),
               "r2":new SecNum(this._buildingProps.fortify_costs[this._fortification.Get()].r2.Get()),
               "r3":new SecNum(this._buildingProps.fortify_costs[this._fortification.Get()].r3.Get()),
               "r4":new SecNum(this._buildingProps.fortify_costs[this._fortification.Get()].r4.Get()),
               "r1over":false,
               "r2over":false,
               "r3over":false,
               "r4over":false
            };
            _loc2_ = this._buildingProps.fortify_costs[this._fortification.Get()];
            if(BASE._resources.r1.Get() < _loc2_.r1.Get())
            {
               _loc1_.r1over = true;
            }
            if(BASE._resources.r2.Get() < _loc2_.r2.Get())
            {
               _loc1_.r2over = true;
            }
            if(BASE._resources.r3.Get() < _loc2_.r3.Get())
            {
               _loc1_.r3over = true;
            }
            if(BASE._resources.r4.Get() < _loc2_.r4.Get())
            {
               _loc1_.r4over = true;
            }
            _loc1_.time.Set(_loc2_.time.Get());
            return _loc1_;
         }
         return {};
      }
      
      internal function Mousedown(param1:MouseEvent) : void
      {
         if(!this._placing)
         {
            MAP.Click();
            this._mouseClicked = true;
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && UI2._showBottom)
            {
               this._clickTimer = 0;
            }
         }
      }
      
      internal function Mouseup(param1:MouseEvent) : void
      {
         if(this._mouseClicked)
         {
            this._mouseClicked = false;
            if(!MAP._dragged)
            {
               if(this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() > 0)
               {
               }
               this.Click();
            }
         }
      }
      
      public function StartMove() : void
      {
         try
         {
            BASE._blockSave = true;
            BASE.BuildingSelect(this,true);
            this.GridCost(false);
            this._moving = true;
            this._stopMoveCount = 0;
            _mc.mouseEnabled = false;
            if(!PLANNER._open)
            {
               _mc.addEventListener(Event.ENTER_FRAME,this.FollowMouseB);
               MAP._GROUND.addEventListener(MouseEvent.MOUSE_UP,this.StopMove);
               this._mcHit.mouseEnabled = false;
               BASE.ShowFootprints();
            }
            this._oldPosition = new Point(_mc.x,_mc.y);
            this._mouseOffset = new Point(MAP._GROUND.mouseX - _mc.x,MAP._GROUND.mouseY - _mc.y);
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.StartMove: " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.StartMove");
         }
      }
      
      public function StopMove(param1:MouseEvent) : void
      {
         if(this._mouseClicked)
         {
            this._mouseClicked = false;
            if(!MAP._dragged)
            {
               MAP._GROUND.removeEventListener(MouseEvent.MOUSE_UP,this.StopMove);
               _mc.mouseEnabled = true;
               this.StopMoveB();
            }
         }
         this._mouseClicked = true;
      }
      
      public function StopMoveB() : void
      {
         try
         {
            if(this._moving)
            {
               this._moving = false;
               if(BASE.BuildBlockers(this,this._class == "decoration") != "")
               {
                  _mc.x = this._oldPosition.x;
                  _mc.y = this._oldPosition.y;
                  this._mcBase.x = _mc.x;
                  this._mcBase.y = _mc.y;
                  this._mcFootprint.x = _mc.x;
                  this._mcFootprint.y = _mc.y;
                  SOUNDS.Play("error1");
               }
               else
               {
                  SOUNDS.Play("buildingplace");
               }
               this._position = new Point(_mc.x,_mc.y);
               _mc.mouseEnabled = false;
               this._mcHit.mouseEnabled = true;
               _mc.removeEventListener(Event.ENTER_FRAME,this.FollowMouseB);
               this.GridCost(true);
               PATHING.ResetCosts();
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  MAP.SortDepth();
               }
               BASE.BuildingDeselect();
               BASE.HideFootprints();
               BASE._blockSave = false;
               BASE.Save();
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","BFOUNDATION.StartMove: " + e.getStackTrace());
            GLOBAL.ErrorMessage("BFOUNDATION.StartMove 2");
         }
         this.onMove();
      }
      
      public function Click(param1:MouseEvent = null) : void
      {
         if(Boolean(GLOBAL._openBase) || TUTORIAL._stage >= 2 && TUTORIAL._stage != 90)
         {
            this.Description();
            if(!MAP._dragged)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
               {
                  BASE.BuildingSelect(this);
               }
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP && this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() > 0)
               {
                  BASE.BuildingSelect(this);
               }
               if(this._class == "taunt" || this._class == "gift")
               {
                  BASE.BuildingSelect(this);
               }
            }
         }
      }
      
      public function Update(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(GLOBAL._render || param1)
         {
            _loc3_ = [];
            if(this._repairing == 1)
            {
               _loc4_ = 0;
               _loc5_ = this._lvl.Get() == 0 ? 0 : int(this._lvl.Get() - 1);
               _loc4_ = Math.ceil(maxHealth / Math.min(3600,this._buildingProps.repairTime[_loc5_]));
               this._repairTime = int(maxHealth - health) / _loc4_;
               QUEUE.Update("building" + this._id,KEYS.Get("ui_worker_stacktitle_repairing"),GLOBAL.ToTime(this._repairTime,true));
            }
            else if(this._countdownBuild.Get() > 0)
            {
               QUEUE.Update("building" + this._id,KEYS.Get("ui_worker_stacktitle_building"),GLOBAL.ToTime(this._countdownBuild.Get(),true));
            }
            else if(this._countdownUpgrade.Get() > 0)
            {
               QUEUE.Update("building" + this._id,KEYS.Get("ui_worker_stacktitle_upgrading"),GLOBAL.ToTime(this._countdownUpgrade.Get(),true));
            }
            else if(this._countdownFortify.Get() > 0)
            {
               QUEUE.Update("building" + this._id,KEYS.Get("ui_worker_stacktitle_fortifying"),GLOBAL.ToTime(this._countdownFortify.Get(),true));
            }
            if(Boolean(this._class) && this._class != "mushroom")
            {
               BuildingOverlay.Update(this,param1);
            }
            if(health <= 0)
            {
               this.Render(k_STATE_DESTROYED);
            }
            else if(this.isCriticallyDamaged)
            {
               this.Render(k_STATE_DAMAGED);
            }
            else
            {
               this.Render(k_STATE_DEFAULT);
            }
         }
      }
      
      public function Loot(param1:int) : uint
      {
         return param1;
      }
      
      public function Constructed() : void
      {
         if(BASE.isOutpostOrInfernoOutpost)
         {
            this._blockRecycle = true;
         }
         this._countdownBuild.Set(0);
         this._constructed = true;
         if(!this._prefab && !BTOTEM.IsTotem2(this._type))
         {
            this._lvl.Set(1);
            this._hpLvl = 1;
         }
         else
         {
            this._prefab = 0;
         }
         BASE.CalcResources();
         QUESTS.Check("blvl",this._lvl.Get());
         QUESTS.Check("b" + this._type + "lvl",this._lvl.Get());
         if(this._type < 5)
         {
            QUESTS.Check("brlvl",this._lvl.Get());
         }
         var _loc1_:Object = this._buildingProps.costs[0];
         var _loc2_:int = Math.floor(_loc1_.time.Get() / 2 + (int(_loc1_.r1.Get()) + int(_loc1_.r2.Get()) + int(_loc1_.r3.Get()) + int(_loc1_.r4.Get())) / 10);
         if(this._type == 14)
         {
            _loc2_ += 100;
         }
         BASE.PointsAdd(_loc2_);
         this.Description();
         QUEUE.Remove("building" + this._id,true,this);
         LOGGER.Stat([6,this._type]);
         this.Update();
      }
      
      public function BlockClicks() : void
      {
         if(this._mcHit)
         {
            this._mcHit.mouseEnabled = false;
            this._mcHit.buttonMode = false;
         }
         if(_mc)
         {
            _mc.alpha = 0.5;
         }
      }
      
      public function UnblockClicks() : void
      {
         if(this._mcHit)
         {
            this._mcHit.mouseEnabled = true;
            this._mcHit.buttonMode = true;
         }
         if(_mc)
         {
            _mc.alpha = 1;
         }
      }
      
      public function exportLite() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Point = GRID.FromISO(_mc.x,_mc.y);
         _loc1_.X = _loc2_.x;
         _loc1_.Y = _loc2_.y;
         _loc1_.id = this._id;
         _loc1_.t = this._type;
         if(this._lvl.Get() != 1)
         {
            _loc1_.l = this._lvl.Get();
         }
         if(this._countdownRebuild.Get() > 0)
         {
            _loc1_.cR = this._countdownRebuild.Get();
         }
         if(this._repairing > 0)
         {
            _loc1_.rE = this._repairing;
         }
         if(health < maxHealth)
         {
            _loc1_.hp = int(health);
         }
         if(this._fortification.Get() > 0)
         {
            _loc1_.fort = this._fortification.Get();
         }
         return _loc1_;
      }
      
      public function Export() : Object
      {
         var _loc1_:Object = new Object();
         var _loc2_:Point = GRID.FromISO(_mc.x,_mc.y);
         _loc1_.X = _loc2_.x;
         _loc1_.Y = _loc2_.y;
         _loc1_.id = this._id;
         _loc1_.t = this._type;
         if(this._lvl.Get() != 1)
         {
            _loc1_.l = this._lvl.Get();
         }
         if(this._countdownBuild.Get() > 0)
         {
            _loc1_.cB = this._countdownBuild.Get();
            if(this._prefab)
            {
               _loc1_.prefab = this._prefab;
            }
         }
         if(this._countdownUpgrade.Get() > 0)
         {
            _loc1_.cU = this._countdownUpgrade.Get();
         }
         if(this._countdownRebuild.Get() > 0)
         {
            _loc1_.cR = this._countdownRebuild.Get();
         }
         if(this._countdownFortify.Get() > 0)
         {
            _loc1_.cF = this._countdownFortify.Get();
         }
         if(this._repairing > 0)
         {
            _loc1_.rE = this._repairing;
         }
         if(this._fortification.Get() > 0)
         {
            _loc1_.fort = this._fortification.Get();
         }
         if(this._threadid)
         {
            _loc1_.ti = this._threadid;
         }
         if(this._senderid)
         {
            _loc1_.sid = this._senderid;
         }
         if(this._senderName)
         {
            _loc1_.snm = this._senderName;
         }
         if(this._senderPic)
         {
            _loc1_.spc = this._senderPic;
         }
         if(this._subject)
         {
            _loc1_.sbj = this._subject;
         }
         if(this._productionStage.Get() > 0)
         {
            _loc1_.rPS = this._productionStage.Get();
         }
         if(this._countdownProduce.Get() > 0)
         {
            _loc1_.rCP = this._countdownProduce.Get();
         }
         if(this._inProduction != "")
         {
            _loc1_.rIP = this._inProduction;
         }
         if(health < maxHealth && (!MapRoomManager.instance.isInMapRoom3 || BASE.isInfernoMainYardOrOutpost))
         {
            _loc1_.hp = int(health);
         }
         if(this._helpList.length > 0 && this._countdownBuild.Get() + this._countdownUpgrade.Get() + this._countdownFortify.Get() > 0)
         {
            _loc1_.hl = this._helpList;
         }
         return _loc1_;
      }
      
      public function Setup(building:Object) : void
      {
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this._type = building.t;
         this._id = building.id;
         _loc2_ = GRID.ToISO(building.X,building.Y,0);
         if(this._type == 112)
         {
            building.l = 1;
         }
         if(Boolean(building.l) && building.l <= int.MAX_VALUE)
         {
            this._lvl.Set(int(building.l));
         }
         else
         {
            this._lvl.Set(1);
         }
         _mc.x = _loc2_.x;
         _mc.y = _loc2_.y;
         ++BASE._buildingCount;
         this._countdownBuild.Set(int(building.cB));
         if(building.prefab)
         {
            this._prefab = building.prefab;
            this._lvl.Set(building.prefab);
            if(this._countdownBuild.Get() == 0)
            {
               _loc3_ = 0;
               _loc4_ = 0;
               while(_loc4_ < building.prefab)
               {
                  _loc3_ += GLOBAL._buildingProps[this._type - 1].costs[_loc4_].time.Get();
                  _loc4_++;
               }
               this._countdownBuild.Set(_loc3_);
            }
         }
         this._countdownUpgrade.Set(int(building.cU));
         this._countdownRebuild.Set(int(building.cR));
         this._hpCountdownRebuild = this._countdownRebuild.Get();
         if(building.fort)
         {
            this._fortification.Set(Math.min(building.fort,BYMConfig.k_sMAX_FORTIFICATION_LEVEL));
         }
         else
         {
            this._fortification.Set(0);
         }
         if(Boolean(building.cF) && this._fortification.Get() < BYMConfig.k_sMAX_FORTIFICATION_LEVEL)
         {
            this._countdownFortify.Set(int(building.cF));
         }
         else
         {
            this._countdownFortify.Set(0);
         }
         this._repairing = int(building.rE);
         if(this._repairing > 0)
         {
            this._repairing = 1;
         }
         this._productionStage.Set(int(building.rPS));
         this._countdownProduce.Set(int(building.rCP));
         this._hpCountdownProduce = this._countdownProduce.Get();
         if(Boolean(building.rIP) && building.rIP != "")
         {
            this._inProduction = building.rIP;
         }
         if(this._inProduction == "C100")
         {
            this._inProduction = "C12";
         }
         if(building.hl)
         {
            this._helpList = building.hl;
         }
         if(building.ti)
         {
            this._threadid = building.ti;
         }
         if(building.sid)
         {
            this._senderid = building.sid;
         }
         if(building.snm)
         {
            this._senderName = building.snm;
         }
         if(building.spc)
         {
            this._senderPic = building.spc;
         }
         if(building.sbj)
         {
            this._subject = building.sbj;
         }
         if(this._countdownBuild.Get() > 0 && !this._prefab)
         {
            this._lvl.Set(0);
         }
         this._hpLvl = this._lvl.Get();
         if(this._lvl.Get() == 0)
         {
            maxHealthProperty.value = this._buildingProps.hp[0];
         }
         else
         {
            _loc5_ = this._lvl.Get();
            _loc6_ = int(this._buildingProps.hp[_loc5_ - 1]);
            maxHealthProperty.value = _loc6_;
         }
         if(building.hp == null)
         {
            setHealth(maxHealth);
         }
         else
         {
            setHealth(int(building.hp));
            if(health > maxHealth)
            {
               setHealth(maxHealth);
            }
         }
         if(health == 0)
         {
            this._destroyed = true;
            this._fired = true;
         }
         this.Description();
         this._constructed = this._countdownBuild.Get() == 0;
         if(this._lvl.Get() == 0 && this._constructed)
         {
            this._lvl.Set(1);
         }
         if(this._type == 17)
         {
            this._gridCost[1][1] = 100 + this._lvl.Get() * 25;
         }
         this.PlaceB();
         if(this._countdownBuild.Get() > 0)
         {
            if(this._prefab) // Comment: Instantly builds a building
            {
               this._hasResources = true;
               this._hasWorker = true;
            }
            else if(QUEUE.Add("building" + this._id,this)) // Comment: Resources needed to build a building
            {
               this._hasResources = true;
            }
            else
            {
               this.RecycleC(); // Comment: Deletes the building
            }
         }
         else if(this._countdownUpgrade.Get() > 0)
         {
            if(QUEUE.Add("building" + this._id,this))
            {
               this._hasResources = true;
            }
            else
            {
               this.UpgradeCancelB();
            }
         }
         else if(this._countdownFortify.Get() > 0)
         {
            if(QUEUE.Add("building" + this._id,this))
            {
               this._hasResources = true;
            }
            else
            {
               this.FortifyCancelB();
            }
         }
         else
         {
            QUESTS.Check("blvl",this._lvl.Get());
            QUESTS.Check("b" + this._type + "lvl",this._lvl.Get());
            if(this._class == "resource")
            {
               QUESTS.Check("brlvl",this._lvl.Get());
            }
         }
      }
      
      override public function clear() : void
      {
         if(this._type == 7)
         {
            delete BASE._buildingsMushrooms["m" + this._id];
         }
         else
         {
            delete BASE._buildingsAll["b" + this._id];
            delete BASE._buildingsWalls["b" + this._id];
            delete BASE._buildingsTowers["b" + this._id];
            delete BASE._buildingsMain["b" + this._id];
            delete BASE._buildingsGifts["b" + this._id];
         }
         if(_mc.hasEventListener(Event.ENTER_FRAME))
         {
            _mc.removeEventListener(Event.ENTER_FRAME,this.FollowMouseB);
         }
         if(MAP._GROUND.hasEventListener(MouseEvent.MOUSE_UP))
         {
            MAP._GROUND.removeEventListener(MouseEvent.MOUSE_UP,this.Place);
         }
         if(_mc.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            _mc.removeEventListener(MouseEvent.MOUSE_DOWN,MAP.Click);
         }
         if(_mc.hasEventListener(Event.ENTER_FRAME))
         {
            _mc.removeEventListener(Event.ENTER_FRAME,this.TickFast);
         }
         this.removeListeners();
         if(this._mcHit)
         {
            if(this._mcHit.parent)
            {
               this._mcHit.parent.removeChild(this._mcHit);
            }
         }
         if(this._mcFootprint)
         {
            if(this._mcFootprint.parent)
            {
               this._mcFootprint.parent.removeChild(this._mcFootprint);
            }
         }
         BuildingOverlay.clearBuilding(this);
         if(GLOBAL._selectedBuilding === this)
         {
            GLOBAL._selectedBuilding = null;
         }
         if(this._mcBase.parent)
         {
            this._mcBase.parent.removeChild(this._mcBase);
         }
         if(_mc.parent)
         {
            _mc.parent.removeChild(_mc);
         }
         this.topContainer.Clear();
         this.animContainer.Clear();
         this._fortFrontContainer.Clear();
         this._fortBackContainer.Clear();
         this.anim2Container.Clear();
         this.anim3Container.Clear();
         if(this._animContainerBMD)
         {
            this._animContainerBMD.dispose();
         }
         if(this._anim2ContainerBMD)
         {
            this._anim2ContainerBMD.dispose();
         }
         if(this._anim3ContainerBMD)
         {
            this._anim3ContainerBMD.dispose();
         }
         this.clearRasterData();
         this._rasterData = null;
         this._rasterPt = null;
         InstanceManager.removeInstance(this);
         this.m_shadowBMD = null;
         super.clear();
      }
      
      private function GetHitMC() : MovieClip
      {
         var _loc1_:Object = !!GLOBAL._buildingProps[this._type - 1] ? GLOBAL._buildingProps[this._type - 1] : {};
         if(_loc1_.hitCls)
         {
            return new _loc1_.hitCls();
         }
         var _loc2_:Boolean = BASE.isInfernoMainYardOrOutpost;
         if(this._type == 1)
         {
            return _loc2_ ? new boneCrusherHit() : new building1hit();
         }
         if(this._type == 2)
         {
            return _loc2_ ? new coalProducerHit() : new building2hit();
         }
         if(this._type == 3)
         {
            return _loc2_ ? new sulpherProducerHit() : new building3hit();
         }
         if(this._type == 4)
         {
            return _loc2_ ? new magmaProducerHit() : new building4hit();
         }
         if(this._type == 5)
         {
            return new building5hit();
         }
         if(this._type == 6)
         {
            return _loc2_ ? new siloHit() : new building6hit();
         }
         if(this._type == 7)
         {
            return new building7hit();
         }
         if(this._type == 8)
         {
            return _loc2_ ? new monsterLockerHit() : new building8hit();
         }
         if(this._type == 9)
         {
            return new building9hit();
         }
         if(this._type == 10)
         {
            return new building10hit();
         }
         if(this._type == 11)
         {
            return new building11hit();
         }
         if(this._type == 12)
         {
            return new building12hit();
         }
         if(this._type == 13)
         {
            return _loc2_ ? new hatcheryHit() : new building13hit();
         }
         if(this._type == 14)
         {
            return _loc2_ ? new townHallHit() : new building14hit();
         }
         if(this._type == 15)
         {
            return new building15hit();
         }
         if(this._type == 16)
         {
            return new building16hit();
         }
         if(this._type == 17)
         {
            return _loc2_ ? new wallHit() : new building17hit();
         }
         if(this._type == 18)
         {
            return new building18hit();
         }
         if(this._type == 19)
         {
            return new building19hit();
         }
         if(this._type == 20)
         {
            return _loc2_ ? new cannonTowerHit() : new building20hit();
         }
         if(this._type == 21)
         {
            return _loc2_ ? new sniperTowerHit() : new building21hit();
         }
         if(this._type == 22)
         {
            return new building22hit();
         }
         if(this._type == 23)
         {
            return new building23hit();
         }
         if(this._type == 24)
         {
            return new building24hit();
         }
         if(this._type == 25)
         {
            return new building25hit();
         }
         if(this._type == 26)
         {
            return _loc2_ ? new infernoAcademyHit() : new building26hit();
         }
         if(this._type == 27)
         {
            return new building27hit();
         }
         if(this._type == 51)
         {
            return new building51hit();
         }
         if(this._type == 53)
         {
            return new building53hit();
         }
         if(this._type == 54)
         {
            return new building54hit();
         }
         if(this._type == 55)
         {
            return new building55hit();
         }
         if(this._type >= 28 && this._type <= 50)
         {
            return new buildingflaghit();
         }
         if(this._type == 56)
         {
            return new building56hit();
         }
         if(this._type == 57)
         {
            return new building57hit();
         }
         if(this._type >= 60 && this._type <= 62)
         {
            return new buildinggnomehit();
         }
         if(this._type == 63)
         {
            return new building63hit();
         }
         if(this._type == 64)
         {
            return new building64hit();
         }
         if(this._type == 65)
         {
            return new building65hit();
         }
         if(this._type == 66)
         {
            return new building66hit();
         }
         if(this._type == 68)
         {
            return new building68hit();
         }
         if(this._type == 71)
         {
            return new building71hit();
         }
         if(this._type == 72)
         {
            return new building72hit();
         }
         if(this._type == 73)
         {
            return new building73hit();
         }
         if(this._type >= 74 && this._type <= 85 || this._type == 107)
         {
            return new buildingheadhit();
         }
         if(this._type == 86)
         {
            return new building86hit();
         }
         if(this._type == 87)
         {
            return new building87hit();
         }
         if(this._type == 88)
         {
            return new building88hit();
         }
         if(this._type == 89)
         {
            return new building89hit();
         }
         if(this._type == 90)
         {
            return new building90hit();
         }
         if(this._type >= 91 && this._type <= 95)
         {
            return new buildingflowershit();
         }
         if(this._type == 96)
         {
            return new building96hit();
         }
         if(this._type == 97)
         {
            return new building97hit();
         }
         if(this._type == 98)
         {
            return new building98hit();
         }
         if(this._type == 99)
         {
            return new building99hit();
         }
         if(this._type == 100)
         {
            return new building100hit();
         }
         if(this._type == 101)
         {
            return new building101hit();
         }
         if(this._type == 102)
         {
            return new building102hit();
         }
         if(this._type == 103)
         {
            return new building103hit();
         }
         if(this._type == 104)
         {
            return new building104hit();
         }
         if(this._type == 105)
         {
            return new building105hit();
         }
         if(this._type == 106)
         {
            return new building106hit();
         }
         if(this._type >= 108 && this._type <= 109)
         {
            return new buildingcubehit();
         }
         if(this._type == 106)
         {
            return new building106hit();
         }
         if(this._type == 110)
         {
            return new building110hit();
         }
         if(this._type == 111)
         {
            return new building111hit();
         }
         if(this._type == 112)
         {
            return new building112hit();
         }
         if(this._type == 113)
         {
            return new building113hit();
         }
         if(this._type == 114)
         {
            return new building114hit();
         }
         if(this._type == 115)
         {
            return new building115hit();
         }
         if(this._type == 116)
         {
            return new building116hit();
         }
         if(this._type == 117)
         {
            return new building117hit();
         }
         if(this._type == 118)
         {
            return new building118hit();
         }
         if(this._type == 119)
         {
            return new building119hit();
         }
         if(this._type == 120)
         {
            return new building120hit();
         }
         if(this._type == 121)
         {
            return new building121hit();
         }
         if(this._type == 122)
         {
            return new building122hit();
         }
         if(this._type == 123)
         {
            return new building123hit();
         }
         if(this._type == 124)
         {
            return new building124hit();
         }
         if(this._type == 125)
         {
            return new building125hit();
         }
         if(this._type == 126)
         {
            return new building126hit();
         }
         if(this._type == 127)
         {
            return new infernoPortalHit();
         }
         if(this._type == 128)
         {
            return new housingBunkerHit();
         }
         if(this._type == 129)
         {
            return new quakeTowerHit();
         }
         if(this._type == 130)
         {
            return new cannonTowerHit();
         }
         if(this._type == 131)
         {
            return new building131hit();
         }
         if(this._type == 132)
         {
            return new magmaTowerHit();
         }
         if(this._type == 135)
         {
            return new building135hit();
         }
         return !!_loc1_.hitCls ? new _loc1_.hitCls() : new building1hit();
      }
      
      private function GetFootprintMC() : MovieClip
      {
         if(this._footprint[0].width == 20)
         {
            return new buildingFootprint20x20();
         }
         if(this._footprint[0].width == 30)
         {
            return new buildingFootprint30x30();
         }
         if(this._footprint[0].width == 40)
         {
            return new buildingFootprint40x40();
         }
         if(this._footprint[0].width == 70)
         {
            return new buildingFootprint70x70();
         }
         if(this._footprint[0].width == 80)
         {
            return new buildingFootprint80x80();
         }
         if(this._footprint[0].width == 90)
         {
            return new buildingFootprint90x90();
         }
         if(this._footprint[0].width == 100)
         {
            return new buildingFootprint100x100();
         }
         if(this._footprint[0].width == 130)
         {
            return new buildingFootprint130x130();
         }
         if(this._footprint[0].width == 160)
         {
            return new buildingFootprint160x160();
         }
         if(this._footprint[0].width == 190)
         {
            return new buildingFootprint190x160();
         }
         return new MovieClip();
      }
      
      public function highlight(param1:uint) : void
      {
         var _loc2_:Array = null;
         if(_mc)
         {
            _loc2_ = new Array();
            _loc2_ = _loc2_.concat([2,0,0,0,0]);
            _loc2_ = _loc2_.concat([0,2,0,0,0]);
            _loc2_ = _loc2_.concat([0,0,3,0,0]);
            _loc2_ = _loc2_.concat([0,0,0,1,0]);
            _mc.filters = [new ColorMatrixFilter(_loc2_)];
            if(BYMConfig.instance.RENDERER_ON && Boolean(this._rasterData[_RASTERDATA_TOP]))
            {
               this._rasterData[_RASTERDATA_TOP].filter = _mc.filters[0];
            }
         }
      }
      
      public function disableHighlight() : void
      {
         if(_mc)
         {
            _mc.filters = [];
            if(BYMConfig.instance.RENDERER_ON && Boolean(this._rasterData[_RASTERDATA_TOP]))
            {
               this._rasterData[_RASTERDATA_TOP].filter = null;
            }
         }
      }
      
      public function set x(param1:Number) : void
      {
         _mc.x = param1;
         this.onMove();
         this.updateRasterData();
      }
      
      public function set y(param1:Number) : void
      {
         _mc.y = param1;
         this.onMove();
         this.updateRasterData();
      }
      
      public function moveTo(param1:int, param2:int) : void
      {
         this.GridCost(false);
         this.x = param1;
         this.y = param2;
         this._mcBase.x = param1;
         this._mcBase.y = param2;
         this._mcFootprint.x = param1;
         this._mcFootprint.y = param2;
         this.StartMove();
         this.StopMove(null);
         this.updateRasterData();
         redrawAllShadowData();
      }
      
      protected function onMove() : void
      {
      }
      
      public function get name() : String
      {
         return KEYS.Get(this._buildingProps.name);
      }
      
      public function get isUpgrading() : Boolean
      {
         return this._countdownUpgrade.Get() > 0;
      }
      
      public function get isBuilding() : Boolean
      {
         return this._countdownBuild.Get() > 0;
      }
      
      protected function RelocateHousedCreatures() : void
      {
         var _loc4_:MonsterBase = null;
         var _loc1_:BFOUNDATION = BASE.FindClosestHousingToPoint(this.x,this.y,this);
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:uint = this._creatures.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if((_loc4_ = this._creatures[_loc3_])._behaviour != MonsterBase.k_sBHVR_JUICE)
            {
               _loc1_._creatures.push(_loc4_);
               _loc4_._house = _loc1_;
               _loc4_._targetCenter = GRID.FromISO(_loc1_.x,_loc1_.y);
               _loc4_.changeModeHousing();
            }
            _loc3_++;
         }
         this._creatures.length = 0;
      }
      
      protected function UpdateHousedCreatureTargets() : void
      {
         var _loc3_:MonsterBase = null;
         var _loc1_:uint = this._creatures.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._creatures[_loc2_];
            if(!(_loc3_._behaviour == MonsterBase.k_sBHVR_JUICE || _loc3_._behaviour == MonsterBase.k_sBHVR_BUNKER && GLOBAL.InfernoMode() === false))
            {
               _loc3_._targetCenter = GRID.FromISO(x,y);
               _loc3_.changeModeHousing();
            }
            _loc2_++;
         }
      }
      
      public function StartProduction() : void
      {
      }
      
      protected function onEnterFrame(param1:Event) : void
      {
      }
      
      protected function removedFromStage(param1:Event) : void
      {
         graphic.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         graphic.removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      }
   }
}