package com.monsters.maproom_advanced
{
   
   import com.cc.utils.SecNum;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   internal class PopupRelocateMe extends PopupRelocateMe_CLIP
   {
       
      
      private var _cell:MapRoomCell;
      
      private var _oldCell:MapRoomCell;
      
      private var RESOURCECOST:SecNum;
      
      private var SHINYCOST:SecNum;
      
      private var _mode:String;

      private var _onInstantClick:Function;

      private var _onResourcesClick:Function;

      public function PopupRelocateMe()
      {
         super();
      }
      
      public function Setup(param1:MapRoomCell, param2:String = "outpost") : void
      {
         var i:int;
         var resource:MovieClip = null;
         var cell:MapRoomCell = param1;
         var mode:String = param2;
         this._cell = cell;
         if(!MapRoom._open)
         {
            x = 365;
            y = 260;
         }
         else
         {
            x = 395;
            y = 260;
         }
         var self:PopupRelocateMe = this;
         this._mode = mode;
         this.tTitle.htmlText = "<b>" + KEYS.Get("map_relocate") + "</b>";
         if(mode == "invite")
         {
            _onInstantClick = function(param1:MouseEvent):void
            {
               if(self.parent)
               {
                  self.parent.removeChild(self);
               }
               MapRoom.AcceptInvitation(true);
            };
            this.mcInstant.bAction.addEventListener(MouseEvent.CLICK, _onInstantClick);
            this.RESOURCECOST = new SecNum(10000000);
            this.SHINYCOST = new SecNum(1200);
            this.tDescription.htmlText = "<font color=\"#CC0000\">" + KEYS.Get("msg_moveyard_warn") + "</font>";
         }
         else
         {
            _onInstantClick = function(param1:MouseEvent):void
            {
               RelocateConfirm(true);
            };
            this.mcInstant.bAction.addEventListener(MouseEvent.CLICK, _onInstantClick);
            this.RESOURCECOST = new SecNum(30000000);
            this.SHINYCOST = new SecNum(1500);
            this.tDescription.htmlText = "<font color=\"#CC0000\">" + KEYS.Get("msg_movetooutpost_warn") + "</font>";
         }
         this.mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("map_relocateinstant") + "</b>";
         this.mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":GLOBAL.FormatNumber(this.SHINYCOST.Get())}));
         i = 1;
         while(i < 5)
         {
            resource = this.mcResources["mcR" + i];
            resource.gotoAndStop(i);
            resource.tTitle.htmlText = "<b>" + KEYS.Get(GLOBAL._resourceNames[i - 1]) + "</b>";
            resource.tValue.htmlText = "<b>" + GLOBAL.FormatNumber(this.RESOURCECOST.Get()) + "</b>";
            i++;
         }
         this.mcResources.mcTime.visible = false;
         this.mcResources.bAction.SetupKey("btn_useresources");
         if(mode == "invite")
         {
            _onResourcesClick = function(param1:MouseEvent):void
            {
               if(self.parent)
               {
                  self.parent.removeChild(self);
               }
               MapRoom.AcceptInvitation(false);
            };
            this.mcResources.bAction.addEventListener(MouseEvent.CLICK, _onResourcesClick);
         }
         else
         {
            _onResourcesClick = function(param1:MouseEvent):void
            {
               RelocateConfirm(false);
            };
            this.mcResources.bAction.addEventListener(MouseEvent.CLICK, _onResourcesClick);
         }
      }
      
      public function Cleanup() : void
      {
         this.mcInstant.bAction.removeEventListener(MouseEvent.CLICK, _onInstantClick);
         this.mcResources.bAction.removeEventListener(MouseEvent.CLICK, _onResourcesClick);
      }
      
      public function Hide() : void
      {
         GLOBAL.BlockerRemove();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function RelocateConfirm(param1:Boolean) : void
      {
         var RelocateSuccess:Function = null;
         var RelocateFail:Function = null;
         var useShiny:Boolean = param1;
         RelocateSuccess = function(param1:Object):void
         {
            PLEASEWAIT.Hide();
            if(param1.error == 0)
            {
               if(param1.cantMoveTill)
               {
                  GLOBAL.Message(KEYS.Get("movebase_warning",{"v1":GLOBAL.ToTime(param1.cantMoveTill - param1.currenttime)}));
                  Hide();
               }
               else
               {
                  GLOBAL._resources.r1max -= GLOBAL._outpostCapacity.Get();
                  GLOBAL._resources.r2max -= GLOBAL._outpostCapacity.Get();
                  GLOBAL._resources.r3max -= GLOBAL._outpostCapacity.Get();
                  GLOBAL._resources.r4max -= GLOBAL._outpostCapacity.Get();
                  LOGGER.Stat([45,useShiny ? SHINYCOST.Get() : 0]);
                  Hide();
                  MapRoom._mc._popupInfoMine.Hide();
                  MapRoomManager.instance.BookmarksClear();
                  GLOBAL._mapOutpost.shift();
                  if(param1.coords && param1.coords.length == 2 && param1.coords[0] > -1 && param1.coords[1] > -1)
                  {
                     GLOBAL._mapHome = new Point(param1.coords[0],param1.coords[1]);
                     MapRoom._Setup(GLOBAL._mapHome);
                  }
                  if(useShiny)
                  {
                     GLOBAL._credits.Add(-SHINYCOST.Get());
                  }
                  else
                  {
                     GLOBAL._resources.r1.Add(-RESOURCECOST.Get());
                     GLOBAL._resources.r2.Add(-RESOURCECOST.Get());
                     GLOBAL._resources.r3.Add(-RESOURCECOST.Get());
                     GLOBAL._resources.r4.Add(-RESOURCECOST.Get());
                  }
                  _cell._updated = false;
                  _cell._dirty = true;
                  _oldCell = MapRoom._homeCell;
                  if(_oldCell)
                  {
                     _oldCell._updated = false;
                     _oldCell._dirty = false;
                  }
                  else
                  {
                     LOGGER.Log("err","Null home cell when transfering base");
                  }
                  MapRoom.ClearCells();
                  PLEASEWAIT.Show(KEYS.Get("wait_packingyard"));
                  addEventListener(Event.ENTER_FRAME,RelocateComplete);
                  MapRoomManager.instance.Tick();

                  if (MapRoomPopup.instance) 
                  {
                     MapRoomPopup.instance.CloseMapRoomAfterMigration();
                  }
               }
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_err_relocate") + param1.error);
            }
         };
         RelocateFail = function(param1:IOErrorEvent):void
         {
            Hide();
            GLOBAL.Message(KEYS.Get("msg_err_relocate") + param1.text);
         };
         var relocateVars:Array = [["type","outpost"],["baseid",this._cell._baseID]];
         if(useShiny)
         {
            if(GLOBAL._credits.Get() < this.SHINYCOST.Get())
            {
               this.Hide();
               POPUPS.DisplayGetShiny();
               return;
            }
            relocateVars.push(["shiny",this.SHINYCOST.Get()]);
         }
         else
         {
            if(GLOBAL._resources.r1.Get() < this.RESOURCECOST.Get() || GLOBAL._resources.r2.Get() < this.RESOURCECOST.Get() || GLOBAL._resources.r3.Get() < this.RESOURCECOST.Get() || GLOBAL._resources.r4.Get() < this.RESOURCECOST.Get())
            {
               this.Hide();
               GLOBAL.Message(KEYS.Get("map_relocate_notenoughresources"));
               return;
            }
            relocateVars.push(["resources",JSON.stringify({
               "r1":this.RESOURCECOST.Get(),
               "r2":this.RESOURCECOST.Get(),
               "r3":this.RESOURCECOST.Get(),
               "r4":this.RESOURCECOST.Get()
            })]);
         }
         PLEASEWAIT.Show(KEYS.Get("wait_relocating"));
         new URLLoaderApi().load(GLOBAL._baseURL + "migrate",relocateVars,RelocateSuccess,RelocateFail);
      }
      
      private function RelocateComplete(param1:Event) : void
      {
         if(this._cell._updated && this._oldCell._updated)
         {
            removeEventListener(Event.ENTER_FRAME,this.RelocateComplete);
            PLEASEWAIT.Hide();
         }
         this._oldCell._updated = true;
      }
   }
}
