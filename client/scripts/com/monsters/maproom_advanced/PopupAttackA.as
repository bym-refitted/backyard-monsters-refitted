package com.monsters.maproom_advanced
{

   import com.cc.utils.SecNum;
   import com.monsters.alliances.*;
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSet;
   import com.monsters.effects.ResourceBombs;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;

   internal class PopupAttackA extends PopupAttackA_CLIP
   {
      private var _cell:MapRoomCell;

      private var _mcResources:MovieClip;

      private var _attackResources:Object = {};

      private var _monstersInRange:Boolean = false;

      private var _cellsInRange:Vector.<CellData> = new Vector.<CellData>(0, true);

      private var _enabled:Boolean = false;

      private var _profilePic:Loader;

      private var _profileBmp:Bitmap;

      private var _protectedInRange:Boolean;

      private var _scroller:ScrollSet;

      public function PopupAttackA()
      {
         super();
         mMonsters.mask = mMonstersMask;
         this._scroller = new ScrollSet();
         this._scroller.isHiddenWhileUnnecessary = true;
         this._scroller.AutoHideEnabled = false;
         this._scroller.width = scroll.width;
         this._scroller.x = scroll.x;
         this._scroller.y = scroll.y;
         addChild(this._scroller);
         this._scroller.Init(mMonsters, mMonstersMask, 0, scroll.y, scroll.height);
         this.bAttack.SetupKey("map_attack_btn");
         this.bAttack.addEventListener(MouseEvent.CLICK, this.Attack);
         this.bAttack.enabled = false;
         this.bAttack.buttonMode = true;
         this.bCancel.SetupKey("btn_cancel");
         this.bCancel.addEventListener(MouseEvent.CLICK, this.Hide);
         this.bCancel.buttonMode = true;
         tCatapult.htmlText = "<b>" + KEYS.Get("newmap_catapultrange") + "</b>";
         tMonsters.htmlText = "<b>" + KEYS.Get("newmap_monstersrange") + "</b>";
      }

      public function Hide(param1:MouseEvent = null):void
      {
         var profilePics:int = int(mcProfilePic.mcBG.numChildren);
         while (profilePics--)
         {
            mcProfilePic.mcBG.removeChildAt(profilePics);
         }
         MapRoom._mc.HideAttack();
      }

      public function Setup(param1:MapRoomCell):void
      {
         this._cell = param1;
         if (this._cell._base == 3)
         {
            this.tAttackText.htmlText = "<b>" + KEYS.Get("newmap_att1", {"v1": this._cell._name}) + "</b>";
         }
         else if (this._cell._base == 2)
         {
            this.tAttackText.htmlText = "<b>" + KEYS.Get("newmap_att2", {"v1": this._cell._name}) + "</b>";
         }
         else if (this._cell._base == 1)
         {
            this.tAttackText.htmlText = "<b>" + KEYS.Get("newmap_att3", {"v1": this._cell._name}) + "</b>";
         }
         else
         {
            LOGGER.Log("err", "Cell at (" + this._cell.X + "," + this._cell.Y + ") has invalid base type " + this._cell._base + " when being attacked");
            this.tAttackText.htmlText = "<b>Attack</b>";
         }
         this._enabled = false;
         this.bAttack.Enabled = false;
         this.ProfilePic();
         if (this._cell._alliance)
         {
            this.AlliancePic(AllyInfo._picURLs.sizeM, this.mcAlliancePic.mcImage, this.mcAlliancePic.mcBG, true);
         }
         else
         {
            this.mcAlliancePic.visible = false;
         }
         this.Update();
      }

      public function Cleanup():void
      {
         this.bAttack.removeEventListener(MouseEvent.CLICK, this.Attack);
         this.bCancel.removeEventListener(MouseEvent.CLICK, this.Hide);
         this._cellsInRange = new Vector.<CellData>(0, true);
      }

      private function Attack(param1:MouseEvent):void
      {
         var baseType:int = 0;
         if (!this._enabled)
         {
            return;
         }
         MapRoom._mc.HideAttack();
         if (!this._cell._protected && !(this._cell._truce && this._cell._truce > GLOBAL.Timestamp()) && this._monstersInRange)
         {
            if (this._protectedInRange)
            {
               GLOBAL.Message(KEYS.Get("newmap_attack"), KEYS.Get("confirm_btn"), this.DoAttack);
               return;
            }
            GLOBAL._attackerMapResources = this._attackResources;
            GLOBAL._attackerCellsInRange = this._cellsInRange;
            MapRoomManager.instance.Hide();
            MapRoom.ClearCells();
            GLOBAL._currentCell = this._cell;
            if (this._cell._base == 1)
            {
               BASE.LoadBase(null, 0, this._cell._baseID, "wmattack", false, EnumYardType.MAIN_YARD);
            }
            else
            {
               baseType = this._cell._base == 3 ? int(EnumYardType.OUTPOST) : int(EnumYardType.MAIN_YARD);
               BASE.LoadBase(null, 0, this._cell._baseID, GLOBAL.e_BASE_MODE.ATTACK, false, baseType);
            }
         }
         else if (this._cell._protected)
         {
            if (!MapRoom._open)
            {
               POPUPS.Next();
            }
            GLOBAL.Message(KEYS.Get("newmap_dp"));
         }
         else if (Boolean(this._cell._truce) && this._cell._truce > GLOBAL.Timestamp())
         {
            if (!MapRoom._open)
            {
               POPUPS.Next();
            }
            GLOBAL.Message(KEYS.Get("newmap_truce"));
         }
         else if (!MapRoom._flingerInRange)
         {
            if (!MapRoom._open)
            {
               POPUPS.Next();
            }
            GLOBAL.Message(KEYS.Get("newmap_range"));
         }
         else
         {
            if (!MapRoom._open)
            {
               POPUPS.Next();
            }
            GLOBAL.Message(KEYS.Get("newmap_nomonsters"));
         }
      }

      public function DoAttack():void
      {
         this._protectedInRange = false;
         this.Attack(null);
      }

      public function Update():Boolean
      {
         var powerUpBonus:Number = 0;
         var cellData:CellData = null;
         var mapRoomCell:MapRoomCell = null;
         var twigBombLevel:int = 0;
         var pebbleBombLevel:int = 0;
         var puttyBombLevel:int = 0;
         var maxBombLevel:int = 0;
         var catapultItem:CATAPULTITEM = null;
         var siegeWeapon:SiegeWeapon = null;
         var cellRange:int = 0;
         var monsterType:String = null;
         var monsterQuantity:int = 0;
         var guardianIndex:int = 0;
         var xPos:int = 0;
         var yPos:int = 0;
         var guardianData:Object = null;
         var isNormalChampion:Boolean = false;
         var guardianDataIndex:int = 0;
         var popupInfoMonster:PopupInfoMonster = null;
         var attackingMonsterInfo:PopupInfoMonster = null;
         var creepType:String = null;
         var attackingPlayerMonsterCount:int = 0;
         var attackingPlayerMonsterIndex:int = 0;
         var attackingPlayerHealthyCreepCount:int = 0;

         if (POWERUPS.CheckPowers(POWERUPS.ALLIANCE_DECLAREWAR, "NORMAL"))
         {
            powerUpBonus = POWERUPS.Apply(POWERUPS.ALLIANCE_DECLAREWAR, [0]);
         }
         if (MapRoom._open)
         {
            this._cellsInRange = MapRoom._mc.GetCellsInRange(this._cell.X, this._cell.Y, 10 + powerUpBonus);
            for each (cellData in this._cellsInRange)
            {
               mapRoomCell = cellData.cell as MapRoomCell;
               if (Boolean(mapRoomCell) && !mapRoomCell._processed)
               {
                  return false;
               }
            }
         }
         else
         {
            this._cellsInRange = GLOBAL._attackerCellsInRange;
         }
         if (!this._enabled)
         {
            this._monstersInRange = false;
            this._protectedInRange = false;
            MapRoom._flingerInRange = false;
            this._attackResources = {
                  "r1": GLOBAL._resources.r1.Get(),
                  "r2": GLOBAL._resources.r2.Get(),
                  "r3": GLOBAL._resources.r3.Get(),
                  "catapult": new SecNum(0),
                  "flinger": new SecNum(0)
               };
            if (!MapRoomManager.instance.isInMapRoom3)
            {
               ATTACK._curCreaturesAvailable = new Array();
               for each (cellData in this._cellsInRange)
               {
                  mapRoomCell = cellData["cell"];
                  cellRange = int(cellData["range"]);
                  if (Boolean(mapRoomCell) && Boolean(mapRoomCell._mine))
                  {
                     if (mapRoomCell._flingerRange.Get() + powerUpBonus >= cellRange)
                     {
                        for (monsterType in mapRoomCell._monsters)
                        {
                           monsterQuantity = int(mapRoomCell._monsters[monsterType].Get());
                           this._monstersInRange = true;
                           if (monsterQuantity > 0 && Boolean(mapRoomCell._protected))
                           {
                              this._protectedInRange = true;
                           }
                           if (ATTACK._curCreaturesAvailable[monsterType])
                           {
                              ATTACK._curCreaturesAvailable[monsterType] += monsterQuantity;
                           }
                           else
                           {
                              ATTACK._curCreaturesAvailable[monsterType] = monsterQuantity;
                           }
                        }
                        MapRoom._flingerInRange = true;
                     }
                     if (mapRoomCell._flingerRange.Get() >= this._attackResources.flinger.Get())
                     {
                        this._attackResources.flinger.Set(mapRoomCell._flingerLevel.Get());
                     }
                  }
               }
            }
            else
            {
               this._monstersInRange = true;
               if (mapRoomCell._flingerRange.Get() >= this._attackResources.flinger.Get())
               {
                  this._attackResources.flinger.Set(mapRoomCell._flingerLevel.Get());
               }
            }
            if (MapRoom._flingerInRange)
            {
               if (GLOBAL._playerCatapultLevel)
               {
                  this._attackResources.catapult.Set(GLOBAL._playerCatapultLevel.Get());
               }
               guardianIndex = 0;
               while (guardianIndex < GLOBAL._playerGuardianData.length)
               {
                  if (GLOBAL._playerGuardianData[guardianIndex] && GLOBAL._playerGuardianData[guardianIndex].hp.Get() > 0 && GLOBAL._playerGuardianData[guardianIndex].status == ChampionBase.k_CHAMPION_STATUS_NORMAL)
                  {
                     this._monstersInRange = true;
                  }
                  guardianIndex++;
               }
            }
            while (mMonsters.numChildren)
            {
               mMonsters.removeChildAt(0);
            }
            if (this._monstersInRange)
            {
               xPos = 0;
               yPos = 0;
               isNormalChampion = false;
               guardianDataIndex = 0;
               while (guardianDataIndex < GLOBAL._playerGuardianData.length)
               {
                  guardianData = GLOBAL._playerGuardianData[guardianDataIndex];
                  if (guardianData && guardianData.hp.Get() > 0 && guardianData.status == ChampionBase.k_CHAMPION_STATUS_NORMAL && (!isNormalChampion || guardianData.t == 5))
                  {
                     if (guardianData.t != 5)
                     {
                        isNormalChampion = true;
                     }
                     attackingMonsterInfo = new PopupInfoMonster();
                     attackingMonsterInfo.Setup(xPos * 125, yPos * 30, "G" + GLOBAL._playerGuardianData[guardianDataIndex].t + "_L" + GLOBAL._playerGuardianData[guardianDataIndex].l.Get(), 1);
                     mMonsters.addChild(attackingMonsterInfo);
                     xPos += 1;
                     if (xPos == 3)
                     {
                        xPos = 0;
                        yPos += 1;
                     }
                  }
                  else if (guardianData && guardianData.hp.Get() > 0 && guardianData.status == ChampionBase.k_CHAMPION_STATUS_NORMAL && isNormalChampion && guardianData.t != 5)
                  {
                     LOGGER.Log("log", "User has capacity to initialize combat with more than one normal champ.");
                  }
                  guardianDataIndex++;
               }
               if (!MapRoomManager.instance.isInMapRoom3)
               {
                  for (creepType in ATTACK._curCreaturesAvailable)
                  {
                     popupInfoMonster = new PopupInfoMonster();
                     popupInfoMonster.Setup(xPos * 125, yPos * 30, creepType, ATTACK._curCreaturesAvailable[creepType]);
                     xPos += 1;
                     mMonsters.addChild(popupInfoMonster);
                     if (xPos == 3)
                     {
                        xPos = 0;
                        yPos += 1;
                     }
                  }
               }
               else
               {
                  attackingPlayerMonsterCount = int(GLOBAL.attackingPlayer.monsterList.length);
                  attackingPlayerMonsterIndex = 0;
                  attackingPlayerHealthyCreepCount = 0;
                  while (attackingPlayerHealthyCreepCount < attackingPlayerMonsterCount)
                  {
                     attackingPlayerMonsterIndex = GLOBAL.attackingPlayer.monsterList[attackingPlayerHealthyCreepCount].numHealthyHousedCreeps;
                     if (attackingPlayerMonsterIndex)
                     {
                        popupInfoMonster = new PopupInfoMonster();
                        popupInfoMonster.Setup(xPos * 125, yPos * 30, GLOBAL.attackingPlayer.monsterList[attackingPlayerHealthyCreepCount].m_creatureID, attackingPlayerMonsterIndex);
                        xPos += 1;
                        mMonsters.addChild(popupInfoMonster);
                        if (xPos == 3)
                        {
                           xPos = 0;
                           yPos += 1;
                        }
                     }
                     attackingPlayerHealthyCreepCount++;
                  }
               }
               this.addChild(mMonsters);
            }
            pebbleBombLevel = -1;
            puttyBombLevel = -1;
            maxBombLevel = -1;
            if (Boolean(this._mcResources) && Boolean(this._mcResources.parent))
            {
               this._mcResources.parent.removeChild(this._mcResources);
               this._mcResources = null;
            }
            this._mcResources = new MovieClip();
            this._mcResources.x = -175;
            this._mcResources.y = -75;
            if (this._attackResources.catapult.Get() >= 1)
            {
               twigBombLevel = 0;
               while (twigBombLevel < 3)
               {
                  if (this._attackResources.r1 < ResourceBombs._bombs["tw" + twigBombLevel].cost.Get())
                  {
                     break;
                  }
                  pebbleBombLevel = twigBombLevel;
                  twigBombLevel++;
               }
            }
            if (this._attackResources.catapult.Get() >= 2)
            {
               twigBombLevel = 0;
               while (twigBombLevel < 4)
               {
                  if (this._attackResources.r2 < ResourceBombs._bombs["pb" + twigBombLevel].cost.Get())
                  {
                     break;
                  }
                  puttyBombLevel = twigBombLevel;
                  twigBombLevel++;
               }
            }
            if (this._attackResources.catapult.Get() >= 3)
            {
               twigBombLevel = 0;
               while (twigBombLevel < 4)
               {
                  if (this._attackResources.r3 < ResourceBombs._bombs["pu" + twigBombLevel].cost.Get())
                  {
                     break;
                  }
                  maxBombLevel = twigBombLevel;
                  twigBombLevel++;
               }
            }
            catapultItem = new CATAPULTITEM();
            if (pebbleBombLevel >= 0)
            {
               catapultItem.Setup("tw" + pebbleBombLevel, true, true);
            }
            else
            {
               catapultItem.Setup("tw0", true, false);
            }
            catapultItem.x = 0;
            catapultItem.y = 0;
            this._mcResources.addChild(catapultItem);
            catapultItem = new CATAPULTITEM();
            if (puttyBombLevel >= 0)
            {
               catapultItem.Setup("pb" + puttyBombLevel, true, true);
            }
            else
            {
               catapultItem.Setup("pb0", true, false);
            }
            catapultItem.x = 65;
            catapultItem.y = 0;
            this._mcResources.addChild(catapultItem);
            catapultItem = new CATAPULTITEM();
            if (maxBombLevel >= 0)
            {
               catapultItem.Setup("pu" + maxBombLevel, true, true);
            }
            else
            {
               catapultItem.Setup("pu0", true, false);
            }
            catapultItem.x = 130;
            catapultItem.y = 0;
            this._mcResources.addChild(catapultItem);
            if (Boolean(siegeWeapon = SiegeWeapons.availableWeapon) && MapRoom._flingerInRange)
            {
               catapultItem = new CATAPULTITEM();
               catapultItem._props = siegeWeapon;
               catapultItem._bombid = siegeWeapon.weaponID;
               catapultItem._txtMC._tA.htmlText = "<b>" + siegeWeapon.name + "</b>";
               catapultItem._image = new MovieClip();
               catapultItem.addChild(catapultItem._image);
               catapultItem._popup = new bubblepopup3();
               catapultItem._popup.x = 44;
               catapultItem._popup.y = 29;
               catapultItem.addChild(catapultItem._popup);
               catapultItem._popX = catapultItem._popup.x;
               catapultItem._popY = catapultItem._popup.y;
               catapultItem.Enabled = true;
               catapultItem.Hide();
               catapultItem.setChildIndex(catapultItem._image, 1);
               catapultItem.setChildIndex(catapultItem._txtMC, 2);
               catapultItem.setChildIndex(catapultItem._popup, 3);
               ImageCache.GetImageWithCallBack(siegeWeapon.image, this.onSiegeIconComplete, true, 1, "", [catapultItem._image]);
               catapultItem.mouseEnabled = false;
               catapultItem.x = 195;
               catapultItem.y = 0;
               this._mcResources.addChild(catapultItem);
            }
            this.addChild(this._mcResources);
            this.bAttack.Enabled = true;
            this._enabled = true;
         }
         var cellInfo:String = "";
         cellInfo = "X:" + this._cell.X + " Y:" + this._cell.Y + "<br>_base:" + this._cell._base + "<br>_height:" + this._cell._height + "<br>_water:" + this._cell._water + "<br>_mine:" + this._cell._mine + "<br>_flinger:" + this._cell._flingerRange + "<br>_catapult:" + this._cell._catapult + "<br>_userID:" + this._cell._userID + "<br>_truce:" + this._cell._truce + "<br>_name:" + this._cell._name + "<br>_protected:" + this._cell._protected + "<br>_resources:" + JSON.encode(this._cell._resources) + "<br>_ticks:" + JSON
            .encode(this._cell._ticks) + "<br>_monsters:" + JSON.encode(this._cell._monsters);
         if (this._cell._monsterData)
         {
            cellInfo += "<br>_monsterData:" + JSON.encode(this._cell._monsterData);
            cellInfo = cellInfo + ("<br>_monsterData.saved:" + JSON.encode(this._cell._monsterData.saved));
            cellInfo = cellInfo + ("<br>_monsterData.h:" + JSON.encode(this._cell._monsterData.h));
            cellInfo = cellInfo + ("<br>_monsterData.hcount:" + this._cell._monsterData.hcount);
         }
         if (this._scroller)
         {
            this._scroller.Update();
         }
         return this._enabled;
      }

      private function onSiegeIconComplete(param1:String, param2:BitmapData, param3:Array = null):void
      {
         var _loc4_:MovieClip = null;
         if (param3[0])
         {
            _loc4_ = param3[0];
            while (_loc4_.numChildren > 0)
            {
               _loc4_.removeChildAt(0);
            }
         }
         var _loc5_:Bitmap = new Bitmap(param2);
         _loc5_.height = 60;
         _loc5_.width = 60;
         if (_loc4_)
         {
            _loc4_.addChild(_loc5_);
         }
      }

      private function ProfilePic():void
      {
         var onImageLoad:Function = null;
         var imageComplete:Function = null;
         var LoadImageError:Function = null;
         onImageLoad = function(param1:Event):void
         {
            if (_profilePic)
            {
               _profilePic.height = 50;
               _profilePic.width = 50;
            }
         };
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            _profileBmp = new Bitmap(param2);
            mcProfilePic.mcBG.addChild(_profileBmp);
         };
         LoadImageError = function(param1:IOErrorEvent):void
         {
         };
         if (!this._cell._facebookID && this._cell._base != 1 && !this._cell._pic_square)
         {
            return;
         }
         if (this._cell._base > 1)
         {
            this._profilePic = new Loader();
            this._profilePic.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LoadImageError, false, 0, true);
            this._profilePic.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoad);
            if (Boolean(!GLOBAL._flags.viximo) && Boolean(this._cell._pic_square))
            {
               this._profilePic.load(new URLRequest(this._cell._pic_square));
            }
            else
            {
               this._profilePic.load(new URLRequest("http://graph.facebook.com/" + this._cell._facebookID + "/picture"));
            }
            this.mcProfilePic.mcBG.addChild(this._profilePic);
         }
         else
         {
            switch (this._cell._name)
            {
               case "Dreadnought":
               case "Dreadnaut":
                  ImageCache.GetImageWithCallBack("monsters/tribe_dreadnaut_50.v2.jpg", imageComplete);
                  break;
               case "Kozu":
                  ImageCache.GetImageWithCallBack("monsters/tribe_kozu_50.v2.jpg", imageComplete);
                  break;
               case "Legionnaire":
                  ImageCache.GetImageWithCallBack("monsters/tribe_legionnaire_50.v2.jpg", imageComplete);
                  break;
               case "Abunakki":
                  ImageCache.GetImageWithCallBack("monsters/tribe_abunakki_50.v2.jpg", imageComplete);
            }
         }
      }

      private function AlliancePic(param1:String, param2:MovieClip, param3:MovieClip = null, param4:Boolean = false):void
      {
         var k:int = 0;
         var allyinfo:AllyInfo = null;
         var size:String = param1;
         var container:MovieClip = param2;
         var containerBG:MovieClip = param3;
         var showRel:Boolean = param4;
         var AllianceIconLoaded:Function = function(param1:String, param2:BitmapData, param3:Array = null):void
         {
            var _loc4_:Bitmap = new Bitmap(param2);
            if (param3[0])
            {
               param3[0].addChild(_loc4_);
               param3[0].setChildIndex(_loc4_, 0);
               if (param3[0].parent)
               {
                  param3[0].parent.visible = true;
               }
            }
         };
         var AllianceIconRelationLoaded:Function = function(param1:String, param2:BitmapData, param3:Array = null):void
         {
            var _loc4_:Bitmap = new Bitmap(param2);
            if (param3[0])
            {
               param3[0].addChild(_loc4_);
               param3[0].visible = true;
            }
         };
         if (!this._cell._facebookID || this._cell._base <= 1)
         {
            this.mcAlliancePic.visible = false;
            return;
         }
         if (this._cell._base > 1 && Boolean(this._cell._alliance))
         {
            k = int(this.mcAlliancePic.mcImage.numChildren);
            while (k--)
            {
               this.mcAlliancePic.mcImage.removeChildAt(k);
            }
            this.mcAlliancePic.visible = true;
            allyinfo = this._cell._alliance;
            allyinfo.AlliancePic(size, container, containerBG, true);
         }
         else
         {
            this.mcAlliancePic.visible = false;
         }
      }
   }
}
