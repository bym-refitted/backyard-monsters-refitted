package com.monsters.maproom_advanced
{
   import com.cc.utils.SecNum;
   import com.monsters.display.ImageCache;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.*;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   internal class PopupTakeover extends MapRoomPopup_takeover_CLIP
   {
      
      private static const TAKEOVER_CAP:int = 65000000;
       
      
      private var _resourceCost:SecNum;
      
      private var _shinyCost:SecNum;
      
      private var _costGap:int;
      
      private var _cell:com.monsters.maproom_advanced.MapRoomCell;
      
      public function PopupTakeover(param1:com.monsters.maproom_advanced.MapRoomCell)
      {
         var cellValue:Number;
         var WMBASE:Boolean;
         var WMLEVEL:int;
         var slope:Number;
         var intercept:Number;
         var roundTo:int;
         var half:Boolean;
         var i:int;
         var bonusTower:int;
         var bonusResource:int;
         var ImageLoaded:Function = null;
         var newResource:Number = NaN;
         var bonusStr:String = null;
         var costMC:MovieClip = null;
         var colorString:String = null;
         var cell:com.monsters.maproom_advanced.MapRoomCell = param1;
         super();
         ImageLoaded = function(param1:String, param2:BitmapData):void
         {
            mcImage.addChild(new Bitmap(param2));
         };
         this._cell = cell;
         this.Center();
         ImageCache.GetImageWithCallBack("popups/outpost-takeover.png",ImageLoaded,true,1);
         this._costGap = 0;
         this._resourceCost = new SecNum(1000000);
         cellValue = this._cell._value;
         WMBASE = this._cell._base == 1;
         WMLEVEL = this._cell._level;
         slope = WMBASE ? 562500 : 15820570.7;
         intercept = WMBASE ? -14750000 : -227080916.9;
         roundTo = 250000;
         if(!WMBASE)
         {
            newResource = Math.min(Math.max(Math.round((Math.log(cellValue) * slope + intercept) / roundTo) * roundTo,1000000),TAKEOVER_CAP);
         }
         else
         {
            newResource = Math.max(Math.round((WMLEVEL * slope + intercept) / roundTo) * roundTo,1000000);
         }
         half = false;
         if(Math.abs(GLOBAL._mapHome.x - this._cell.X) == 1)
         {
            if(GLOBAL._mapHome.y + 1 - (GLOBAL._mapHome.x + 1) % 2 * 2 == this._cell.Y || GLOBAL._mapHome.y == this._cell.Y)
            {
               half = true;
            }
         }
         else if(GLOBAL._mapHome.x == this._cell.X)
         {
            if(GLOBAL._mapHome.y + 1 == this._cell.Y || GLOBAL._mapHome.y - 1 == this._cell.Y)
            {
               half = true;
            }
         }
         if(half)
         {
            newResource *= 0.5;
         }
         this._resourceCost.Set(newResource);
         if(POWERUPS.CheckPowers(POWERUPS.ALLIANCE_CONQUEST,"NORMAL"))
         {
            this._resourceCost.Set(POWERUPS.Apply(POWERUPS.ALLIANCE_CONQUEST,[this._resourceCost.Get()]));
         }
         this._shinyCost = new SecNum(Math.ceil(Math.pow(Math.sqrt(this._resourceCost.Get() / 2),0.75) * 4));
         i = 1;
         while(i < 5)
         {
            costMC = this.mcResources["mcR" + i];
            costMC.gotoAndStop(i);
            costMC.tTitle.htmlText = "<b>" + KEYS.Get(GLOBAL._resourceNames[i - 1]) + "</b>";
            colorString = "000000";
            if(GLOBAL._resources["r" + i].Get() <= this._resourceCost)
            {
               colorString = "FF0000";
            }
            else if(GLOBAL._allianceConquestTime.Get() > GLOBAL.Timestamp())
            {
               colorString = "0000FF";
            }
            costMC.tValue.htmlText = "<b><font color=\"#" + (this._resourceCost > GLOBAL._resources["r" + i].Get() ? "FF0000" : "000000") + "\">" + GLOBAL.FormatNumber(this._resourceCost.Get()) + "</font></b>";
            i++;
         }
         bonusTower = this._cell._height * 100 / GLOBAL._averageAltitude.Get() - 100;
         bonusResource = 100 * GLOBAL._averageAltitude.Get() / this._cell._height - 100;
         if(this._cell._height != GLOBAL._averageAltitude.Get())
         {
            if(this._cell._height > GLOBAL._averageAltitude.Get())
            {
               bonusStr = KEYS.Get("bonus_towerrange",{"v1":bonusTower});
            }
            else
            {
               bonusStr = KEYS.Get("bonus_resourceproduction",{"v1":bonusResource});
            }
         }
         if(this._cell._base == 1)
         {
            this.tTitle.htmlText = "<b>" + KEYS.Get("takeover_wildmonsteryard") + "</b>";
         }
         else
         {
            this.tTitle.htmlText = "<b>" + KEYS.Get("takeover_outpost",{"v1":this._cell._name}) + "</b>";
         }
         this.tDescription.htmlText = "<b>" + KEYS.Get("takeover_expand") + (!!bonusStr ? " " + bonusStr : "") + "</b>";
         this.mcResources.mcTime.visible = false;
         this.mcResources.bAction.SetupKey("btn_useresources");
         this.mcResources.bAction.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            TakeOverConfirm(false);
         });
         this.mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":this._shinyCost.Get()}));
         this.mcInstant.tDescription.htmlText = KEYS.Get("takeover_instant");
         this.mcInstant.bAction.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            TakeOverConfirm(true);
         });
      }
      
      public function Hide() : void
      {
         GLOBAL.BlockerRemove();
         this.parent.removeChild(this);
      }
      
      public function TakeOverConfirm(param1:Boolean) : void
      {
         var mapIndex:int;
         var r1:int;
         var r2:int;
         var r3:int;
         var r4:int;
         var takeoverVars:Array = null;
         var takeoverSuccessful:Function = null;
         var takeoverError:Function = null;
         var useShiny:Boolean = param1;
         takeoverSuccessful = function(param1:Object):void
         {
            PLEASEWAIT.Hide();
            if(param1.error == 0)
            {
               BASE._takeoverFirstOpen = _cell._base == 1 ? 1 : 2;
               BASE._takeoverPreviousOwnersName = _cell._name;
               MapRoom.GetCell(_cell.X,_cell.Y,true);
               GLOBAL._mapOutpost.push(new Point(_cell.X,_cell.Y));
               GLOBAL._resources.r1max += GLOBAL._outpostCapacity.Get();
               GLOBAL._resources.r2max += GLOBAL._outpostCapacity.Get();
               GLOBAL._resources.r3max += GLOBAL._outpostCapacity.Get();
               GLOBAL._resources.r4max += GLOBAL._outpostCapacity.Get();
               MapRoom.ClearCells();
               MapRoomManager.instance.Hide();
               GLOBAL._attackerCellsInRange = new Vector.<CellData>(0,true);
               GLOBAL._currentCell = _cell;
               (GLOBAL._currentCell as com.monsters.maproom_advanced.MapRoomCell).baseType = 3;
               BASE.yardType = EnumYardType.OUTPOST;
               BASE.LoadBase(null,0,_cell._baseID,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.OUTPOST);
               LOGGER.Stat([37,BASE._takeoverFirstOpen]);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("err_takeoverproblem") + param1.error);
            }
            Hide();
         };
         takeoverError = function(param1:IOErrorEvent):void
         {
            Hide();
            GLOBAL.Message(KEYS.Get("err_takeoverproblem") + param1.text);
         };
         if(useShiny)
         {
            if(GLOBAL._credits.Get() < this._shinyCost.Get())
            {
               POPUPS.DisplayGetShiny();
               return;
            }
            takeoverVars = [["baseid",this._cell._baseID],["shiny",this._shinyCost.Get()]];
         }
         else
         {
            if(GLOBAL._resources.r1.Get() < this._resourceCost.Get() || GLOBAL._resources.r2.Get() < this._resourceCost.Get() || GLOBAL._resources.r3.Get() < this._resourceCost.Get() || GLOBAL._resources.r4.Get() < this._resourceCost.Get())
            {
               GLOBAL.Message(KEYS.Get("newmap_take4"));
               return;
            }
            takeoverVars = [["baseid",this._cell._baseID],["resources",JSON.encode({
               "r1":this._resourceCost.Get(),
               "r2":this._resourceCost.Get(),
               "r3":this._resourceCost.Get(),
               "r4":this._resourceCost.Get()
            })]];
         }
         mapIndex = 1;
         r1 = this._resourceCost.Get();
         r2 = this._resourceCost.Get();
         r3 = this._resourceCost.Get();
         r4 = this._resourceCost.Get();
         PLEASEWAIT.Show(KEYS.Get("plsw_taking"));
         new URLLoaderApi().load(GLOBAL._mapURL + "takeovercell",takeoverVars,takeoverSuccessful,takeoverError);
      }
      
      private function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
   }
}
