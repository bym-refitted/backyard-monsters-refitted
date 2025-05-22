package com.monsters.maproom_advanced
{
   
   import com.cc.utils.SecNum;
   import com.monsters.alliances.ALLIANCES;
   import com.monsters.chat.Chat;
   import com.monsters.effects.smoke.Smoke;
   import com.monsters.enums.EnumYardType;
   import com.monsters.mailbox.FriendPicker;
   import com.monsters.mailbox.MailBox;
   import com.monsters.mailbox.Thread;
   import com.monsters.maproom_manager.IMapRoom;
   import com.monsters.maproom_manager.IMapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.*;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flash.xml.XMLDocument;
   
   public class MapRoom implements IMapRoom
   {
      
      internal static var _homePoint:Point;
      
      private static var _zoneWidth:int = 10;
      
      private static var _zoneHeight:int = 10;
      
      internal static var _mapWidth:int = 100;
      
      internal static var _mapHeight:int = 100;
      
      internal static var _mc:MapRoomPopup;
      
      internal static var _bookmarks:Array = [];
      
      internal static var _currentPosition:Point;
      
      internal static var _open:Boolean;
      
      internal static var _monsterTransferInProgress:Boolean = false;
      
      internal static var _resourceTransferInProgress:Boolean = false;
      
      internal static var _homeCell:MapRoomCell;
      
      private static var _resourceTransfer:Object = {};
      
      internal static var _monsterTransfer:Object = {};
      
      private static var _bookmarkData:Object = {};
      
      private static var _saveErrors:int;
      
      private static var _zones:Object = {};
      
      private static var _bubbleSelectTarget:bubble_selecttarget;
      
      private static var _monsterSource:MapRoomCell;

      private static var _monsterSourceRef:MapRoomCell;

      private static var _monsterTarget:MapRoomCell;

      private static var _requestedZones:Array;
      
      private static var _showEnemyWait:Boolean = false;
      
      private static var _resourceCounter:int = 0;
      
      private static var _monstersTransferred:int = 0;
      
      private static var _allMonstersTransferred:Boolean = false;
      
      internal static var _flingerInRange:Boolean = false;
      
      private static var _worldID:int = 0;
      
      internal static var _inviteBaseID:int = 0;
      
      internal static var _inviteLocation:Point = new Point();
      
      internal static var _viewOnly:Boolean = false;
      
      private static var _bubbleAcceptInvite:bubble_acceptInvite;
      
      private static var _migrateThread:Thread = null;
      
      private static var _reposition:Boolean = false;
      
      private static var _popupRelocateMe:PopupRelocateMe;
      
      private static var _empiredestroyed:Boolean = false;
      
      private static var _showAttackWait:Boolean = false;
      
      private static var _pendingMapCellDataRequests:Array = [];
      
      internal static var _smokeBMD:BitmapData;
      
      internal static var _smokeParticles:Array;
      
      internal static var _frame:int;
       
      
      public function MapRoom()
      {
         super();
      }
      
      public static function get homeCell() : IMapRoomCell
      {
         return _homeCell;
      }
      
      public static function set migrateThread(param1:Thread) : void
      {
         _migrateThread = param1;
      }
      
      public static function set inviteBaseID(param1:int) : void
      {
         _inviteBaseID = param1;
      }
      
      public static function set showAttackWait(param1:Boolean) : void
      {
         _showAttackWait = param1;
      }
      
      public static function set showEnemyWait(param1:Boolean) : void
      {
         _showEnemyWait = param1;
      }
      
      public static function set empireDestroyed(param1:Boolean) : void
      {
         _empiredestroyed = param1;
      }
      
      public static function _Setup(param1:Point, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:Thread = null) : void
      {
         _homePoint = param1;
         _worldID = param2;
         _inviteBaseID = param3;
         _viewOnly = param4;
         if(_viewOnly)
         {
            _inviteLocation = new Point(param1.x,param1.y);
            if(param5)
            {
               _migrateThread = param5;
            }
         }
         else
         {
            _migrateThread = param5;
         }
         _bubbleSelectTarget = new bubble_selecttarget();
         _bubbleSelectTarget.tDesc.htmlText = "<b>" + KEYS.Get("bubble_selecttarget_desc") + "</b>";
         _bubbleSelectTarget.bCancel.SetupKey("btn_cancel");
         _bubbleSelectTarget.bCancel.addEventListener(MouseEvent.CLICK,TransferCancel);
         _bubbleSelectTarget.x = 270;
         _bubbleSelectTarget.y = 415;
         _saveErrors = 0;
         _showEnemyWait = false;
         _showAttackWait = false;
         _requestedZones = [];
         FriendPicker.ClearContacts();
      }
      
      internal static function HideFromViewOnly() : void
      {
         if(_open && GLOBAL.mode != GLOBAL.e_BASE_MODE.ATTACK && GLOBAL.mode != GLOBAL.e_BASE_MODE.WMATTACK)
         {
            SOUNDS.Play("close");
            _worldID = 0;
            _inviteBaseID = 0;
            _viewOnly = false;
            GLOBAL._currentCell = null;
            _Setup(GLOBAL._mapHome);
            if(_mc.parent)
            {
               _mc.parent.removeChild(_mc);
            }
            ClearCells();
            _mc.Cleanup();
            _mc = null;
         }
         _open = false;
      }
      
      internal static function ClearCells() : void
      {
         _zones = {};
      }
      
      internal static function JumpTo(param1:Point) : void
      {
         if(_mc.parent)
         {
            _mc.JumpTo(param1);
         }
      }
      
      public static function SetPendingInvitation() : void
      {
         _mc._popupInfoMine.PendingInvite();
      }
      
      public static function PreAcceptInvitation(param1:DisplayObjectContainer) : void
      {
         if(ALLIANCES._myAlliance)
         {
            GLOBAL.Message(KEYS.Get("msg_mustleavealliance"));
            return;
         }
         _popupRelocateMe = new PopupRelocateMe();
         _popupRelocateMe.Setup(null,"invite");
         if(param1)
         {
            GLOBAL.BlockerAdd(param1 as Sprite);
            param1.addChild(_popupRelocateMe);
         }
      }
      
      internal static function AcceptInvitation(param1:Boolean = false) : void
      {
         var handleAcceptSuccessful:Function;
         var handleAcceptError:Function;
         var url:String = null;
         var loadvars:Array = null;
         var SHINYCOST:SecNum = null;
         var RESOURCECOST:SecNum = null;
         var useShiny:Boolean = param1;
         if(ALLIANCES._myAlliance)
         {
            GLOBAL.Message(KEYS.Get("msg_mustleavealliance"));
            return;
         }
         if(Boolean(_migrateThread) && _inviteBaseID != 0)
         {
            handleAcceptSuccessful = function(param1:Object):void
            {
               PLEASEWAIT.Hide();
               if(param1.error == 0)
               {
                  if(param1.cantMoveTill)
                  {
                     if(_open)
                     {
                        GLOBAL.Message(KEYS.Get("movebase_warning",{"v1":GLOBAL.ToTime(param1.cantMoveTill - param1.currenttime)}),KEYS.Get("btn_returnhome"),ReturnFromFailedInvite);
                     }
                     else
                     {
                        GLOBAL.Message(KEYS.Get("movebase_warning",{"v1":GLOBAL.ToTime(param1.cantMoveTill - param1.currenttime)}));
                        GLOBAL.BlockerRemove();
                     }
                  }
                  else
                  {
                     if(param1.coords && param1.coords.length == 2 && param1.coords[0] > -1 && param1.coords[1] > -1)
                     {
                        GLOBAL._mapHome = new Point(param1.coords[0],param1.coords[1]);
                        _Setup(GLOBAL._mapHome);
                     }
                     MapRoomManager.instance.BookmarksClear();
                     BASE._loadedFriendlyBaseID = 0;
                     GLOBAL._homeBaseID = 0;
                     GLOBAL._currentCell = null;
                     GLOBAL._mapOutpost = [];
                     if(_open)
                     {
                        MapRoomManager.instance.Hide();
                     }
                     ClearCells();
                     _Setup(GLOBAL._mapHome);
                     _reposition = true;
                     GLOBAL._showMapWaiting = 1;
                  }
               }
               else
               {
                  GLOBAL.Message(param1.error);
               }
            };
            handleAcceptError = function(param1:IOErrorEvent):void
            {
               LOGGER.Log("err","MapRoom.AcceptInvitation HTTP");
            };
            url = GLOBAL._baseURL + "migratetofriend";
            loadvars = [["baseid",_inviteBaseID],["threadid",_migrateThread.data.threadid]];
            SHINYCOST = new SecNum(1200);
            RESOURCECOST = new SecNum(10000000);
            if(_popupRelocateMe)
            {
               _popupRelocateMe.Cleanup();
               _popupRelocateMe.Hide();
               _popupRelocateMe = null;
            }
            if(useShiny)
            {
               if(GLOBAL._credits.Get() < SHINYCOST.Get())
               {
                  POPUPS.DisplayGetShiny();
                  return;
               }
               loadvars.push(["shiny",SHINYCOST.Get()]);
            }
            else
            {
               if(GLOBAL._resources.r1.Get() < RESOURCECOST.Get() || GLOBAL._resources.r2.Get() < RESOURCECOST.Get() || GLOBAL._resources.r3.Get() < RESOURCECOST.Get() || GLOBAL._resources.r4.Get() < RESOURCECOST.Get())
               {
                  GLOBAL.Message(KEYS.Get("map_rel_res"));
                  return;
               }
               loadvars.push(["resources",JSON.encode({
                  "r1":RESOURCECOST.Get(),
                  "r2":RESOURCECOST.Get(),
                  "r3":RESOURCECOST.Get(),
                  "r4":RESOURCECOST.Get()
               })]);
            }
            PLEASEWAIT.Show(KEYS.Get("wait_movebase"));
            MailBox.Hide();
            if(_migrateThread.parent)
            {
               if(_migrateThread.numChildren > 0)
               {
                  _migrateThread.removeChildAt(1);
               }
               _migrateThread.parent.removeChild(_migrateThread);
            }
            new URLLoaderApi().load(url,loadvars,handleAcceptSuccessful,handleAcceptError);
         }
      }
      
      internal static function ReturnFromFailedInvite() : void
      {
         MapRoomManager.instance.Hide();
         BASE.Load();
      }
      
      public static function RejectInvitation(param1:MouseEvent = null) : void
      {
         var handleRejectSuccessful:Function;
         var handleRejectError:Function;
         var url:String = null;
         var loadvars:Array = null;
         var e:MouseEvent = param1;
         if(Boolean(_migrateThread) && _inviteBaseID != 0)
         {
            handleRejectSuccessful = function(param1:Object):void
            {
               PLEASEWAIT.Hide();
               if(param1.error == 0)
               {
                  GLOBAL._currentCell = null;
                  if(_open)
                  {
                     MapRoomManager.instance.Hide();
                     ClearCells();
                     _Setup(GLOBAL._mapHome);
                     BASE.LoadBase(null,0,GLOBAL._homeBaseID,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.MAIN_YARD);
                  }
                  else
                  {
                     MAILBOX.Show();
                  }
               }
               else
               {
                  LOGGER.Log("err","MapRoom.RejectInvitation",param1.error);
               }
            };
            handleRejectError = function(param1:IOErrorEvent):void
            {
               LOGGER.Log("err","MapRoom.RejectInvitation HTTP");
            };
            PLEASEWAIT.Show(KEYS.Get("wait_rejecting"));
            url = GLOBAL._baseURL + "rejectmigratetofriend";
            loadvars = [["baseid",_inviteBaseID],["threadid",_migrateThread.data.threadid]];
            if(_migrateThread.parent)
            {
               if(_migrateThread.numChildren > 0)
               {
                  _migrateThread.removeChildAt(1);
               }
               _migrateThread.data.Changed();
               _migrateThread.parent.removeChild(_migrateThread);
               _migrateThread = null;
               MAILBOX.Hide();
            }
            new URLLoaderApi().load(url,loadvars,handleRejectSuccessful,handleRejectError);
         }
      }
      
      internal static function BookmarkDataGet(param1:String) : int
      {
         var _loc2_:int = 0;
         if(_bookmarkData[param1])
         {
            _loc2_ = int(_bookmarkData[param1]);
         }
         return _loc2_;
      }
      
      internal static function BookmarkDataSet(param1:String, param2:int, param3:Boolean = true) : void
      {
         var _loc4_:Boolean = false;
         if(!_bookmarkData)
         {
            _bookmarkData = {};
         }
         if(param2 == 0 && Boolean(_bookmarkData[param1]))
         {
            delete _bookmarkData[param1];
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
         else if(!_bookmarkData[param1])
         {
            _bookmarkData[param1] = param2;
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
         else if(_bookmarkData[param1] != param2)
         {
            _bookmarkData[param1] = param2;
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
      }
      
      internal static function BookmarkDataGetStr(param1:String) : String
      {
         var _loc2_:String = "";
         if(_bookmarkData[param1])
         {
            _loc2_ = String(_bookmarkData[param1]);
         }
         return _loc2_;
      }
      
      internal static function BookmarkDataSetStr(param1:String, param2:String, param3:Boolean = true) : void
      {
         var _loc4_:Boolean = false;
         if(!_bookmarkData)
         {
            _bookmarkData = {};
         }
         if(param2.length > 0 && Boolean(_bookmarkData[param1]))
         {
            delete _bookmarkData[param1];
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
         else if(!_bookmarkData[param1])
         {
            _bookmarkData[param1] = param2;
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
         else if(_bookmarkData[param1] != param2)
         {
            _bookmarkData[param1] = param2;
            if(param3)
            {
               BookmarksSave();
            }
            _loc4_ = true;
         }
      }
      
      internal static function BookmarksSave() : void
      {
         var handleBMSaveSuccessful:Function = null;
         var handleBMSaveError:Function = null;
         handleBMSaveSuccessful = function(param1:Object):void
         {
            if(param1.error != 0)
            {
               LOGGER.Log("err","MapRoom.BookmarksSave",param1.error);
            }
         };
         handleBMSaveError = function(param1:IOErrorEvent):void
         {
            LOGGER.Log("err","MapRoom.BookmarksSave HTTP");
         };
         var url:String = GLOBAL._apiURL + "player/savebookmarks";
         var loadvars:Array = [["bookmarks",JSON.encode(_bookmarkData)]];
         new URLLoaderApi().load(url,loadvars,handleBMSaveSuccessful,handleBMSaveError);
      }
      
      internal static function AddBookmark(param1:String, param2:Boolean = true) : Object
      {
         var _loc3_:Object = null;
         param1 = param1.replace(/\<.*?>/g,"");
         var _loc4_:XMLDocument;
         if((_loc4_ = new XMLDocument(param1)) && _loc4_.firstChild && Boolean(_loc4_.firstChild.nodeValue))
         {
            param1 = _loc4_.firstChild.nodeValue;
         }
         else
         {
            param1 = KEYS.Get("str_blank");
         }
         if(param1.length == 0)
         {
            return {
               "hide":false,
               "message":KEYS.Get("newmap_bm_name")
            };
         }
         if(param1.length > 20)
         {
            return {
               "hide":false,
               "message":KEYS.Get("newmap_bm_long")
            };
         }
         if(_currentPosition.x < 0 || _currentPosition.x >= _mapWidth || _currentPosition.y < 0 || _currentPosition.y >= _mapHeight)
         {
            return {
               "hide":true,
               "message":"ERROR: Bookmark point is not on the map."
            };
         }
         if(_bookmarks.length >= 8)
         {
            return {
               "hide":true,
               "message":KEYS.Get("newmap_bm_full")
            };
         }
         var _loc5_:int = int(_bookmarks.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_bookmarks[_loc6_].location.x == _currentPosition.x && _bookmarks[_loc6_].location.y == _currentPosition.y)
            {
               return {
                  "hide":true,
                  "message":KEYS.Get("newmap_bm_done")
               };
            }
            _loc6_++;
         }
         if(param2)
         {
            BookmarkDataSet("mbm" + _loc5_,_currentPosition.x * 10000 + _currentPosition.y,false);
            BookmarkDataSetStr("mbmn" + _loc5_,param1,false);
            BookmarkDataSet("mbms",_loc5_ + 1);
         }
         _bookmarks.push({
            "name":param1,
            "location":_currentPosition
         });
         return {
            "hide":true,
            "message":"SUCCESS"
         };
      }
      
      private static function RequestData(point:Point, hasForce:Boolean = false) : void
      {
         var z:objZone = null;
         var loadvars:Array = null;
         var dataRequest:Object = null;
         var handleLoadSuccessful:Function = null;
         var handleLoadError:Function = null;
         var zonePoint:Point = point;
         var force:Boolean = hasForce;
         var zoneID:int = zonePoint.x * 10000 + zonePoint.y;
         var getAreaURL:String = GLOBAL._mapURL + "getarea";
         var t:int = getTimer();
         var getResources:int = 0;
         if(force || GLOBAL.Timestamp() > _resourceCounter + 20)
         {
            getResources = 1;
            _resourceCounter = GLOBAL.Timestamp();
            force = true;
         }
         if(_zones[zoneID])
         {
            z = _zones[zoneID];
         }
         else
         {
            z = new objZone();
            _zones[zoneID] = z;
         }
         if(force || GLOBAL.Timestamp() - z.updated > 30)
         {
            handleLoadSuccessful = function(serverData:Object):void
            {
               var getCellData:Object = null;
               var zoneId:int = 0;
               var resourceIndex:int = 0;
               var allianceData:Array = null;
               var cell:Object = null;
               var _loc2_:Object = _pendingMapCellDataRequests.shift();
               if(_loc2_ == null)
               {
               }
               if(_pendingMapCellDataRequests.length > 0)
               {
                  getCellData = _pendingMapCellDataRequests[0];
                  new URLLoaderApi().load(getCellData.url,getCellData.loadvars,handleLoadSuccessful,handleLoadError);
               }
               if(!_open && !BASE._needCurrentCell)
               {
                  return;
               }
               if(serverData && !serverData.error && Boolean(serverData.data))
               {
                  zoneId = serverData.x * 10000 + serverData.y;
                  if(!_zones[zoneId])
                  {
                     _zones[zoneId] = new objZone();
                  }
                  _zones[zoneId].data = serverData.data;
                  if(serverData.resources)
                  {
                     resourceIndex = 1;
                     while(resourceIndex < 5)
                     {
                        GLOBAL._resources["r" + resourceIndex].Set(serverData.resources["r" + resourceIndex]);
                        GLOBAL._hpResources["r" + resourceIndex] = GLOBAL._resources["r" + resourceIndex].Get();
                        GLOBAL._resources["r" + resourceIndex + "max"] = serverData.resources["r" + resourceIndex + "max"];
                        GLOBAL._hpResources["r" + resourceIndex + "max"] = serverData.resources["r" + resourceIndex + "max"];
                        resourceIndex++;
                     }
                  }
                  if(serverData.alliancedata)
                  {
                     allianceData = serverData.alliancedata;
                     ALLIANCES.ProcessAlliances(allianceData);
                  }
                  if(MapRoom._open)
                  {
                     MapRoom._mc.Update(true);
                  }
                  else if(BASE._needCurrentCell)
                  {
                     if(_zones && _zones[zoneId] && Boolean(_zones[zoneId].data) && Boolean(_zones[zoneId].data[BASE._currentCellLoc.x]))
                     {
                        cell = _zones[zoneId].data[BASE._currentCellLoc.x][BASE._currentCellLoc.y];
                        GLOBAL._currentCell = new MapRoomCell();
                        (GLOBAL._currentCell as MapRoomCell).Setup(cell);
                        (GLOBAL._currentCell as MapRoomCell).cellX = BASE._currentCellLoc.x;
                        (GLOBAL._currentCell as MapRoomCell).cellY = BASE._currentCellLoc.y;
                        _zones = {};
                     }
                  }
               }
               else if(Boolean(serverData) && !serverData.data)
               {
                  LOGGER.Log("err","MapRoom.Data NO DATA");
               }
               else
               {
                  LOGGER.Log("err","MapRoom.Data",serverData.error);
               }
            };
            handleLoadError = function(param1:IOErrorEvent):void
            {
               ++_saveErrors;
               if(_saveErrors >= 3)
               {
                  LOGGER.Log("err","MapRoom.RequestData HTTP");
                  GLOBAL.ErrorMessage("WorldMapRoom.RequestData HTTP");
               }
            };
            z.updated = GLOBAL.Timestamp() + int(Math.random() * 10);
            loadvars = [["x",int(zonePoint.x)],["y",int(zonePoint.y)],["width",_zoneWidth],["height",_zoneHeight],["sendresources",getResources]];
            _saveErrors = 0;
            if(_viewOnly)
            {
               loadvars.push(["worldid",_worldID]);
            }
            dataRequest = {
               "url":getAreaURL,
               "loadvars":loadvars
            };
            _pendingMapCellDataRequests.push(dataRequest);
            if(_pendingMapCellDataRequests.length == 1)
            {
               new URLLoaderApi().load(getAreaURL,loadvars,handleLoadSuccessful,handleLoadError);
            }
         }
      }
      
      internal static function GetCell(cellX:int, cellY:int, param3:Boolean = false) : Object
      {
         var point:Point;
         var zoneId:int = (point = new Point(int(cellX / _zoneWidth) * _zoneWidth,int(cellY / _zoneHeight) * _zoneHeight)).x * 10000 + point.y;
         RequestData(point,param3);
         if(_zones && _zones[zoneId] && Boolean(_zones[zoneId].data) && Boolean(_zones[zoneId].data[cellX]))
         {
            return _zones[zoneId].data[cellX][cellY];
         }
         return null;
      }
      
      internal static function Update() : void
      {
         if(_open && _mc && Boolean(_mc.parent))
         {
            _mc.Update(true);
         }
      }
      
      internal static function Cleanup() : void
      {
      }
      
      internal static function TransferMonstersA(cell:MapRoomCell, monsters:Object) : void
      {
         var monsterId:String = null;
         _monsterTransfer = {};
         var hasMonsters:Boolean = false;
         for(monsterId in monsters)
         {
            _monsterTransfer[monsterId] = new SecNum(monsters[monsterId].Get());
            if(monsters[monsterId].Get() > 0)
            {
               hasMonsters = true;
            }
         }
         if(hasMonsters)
         {
            // Preserve map room cell
            var foundCell:Object = GetCell(cell.X,cell.Y)
            if (foundCell)
            {
               _monsterSource = new MapRoomCell();
               _monsterSource.Setup(foundCell);
               _monsterSource.Cleanup(); // remove event listeners
               _monsterSource.cellX = cell.X;
               _monsterSource.cellY = cell.Y;
               _monsterSourceRef = cell;
            }
            if(_bubbleSelectTarget.parent)
            {
               _bubbleSelectTarget.parent.removeChild(_bubbleSelectTarget);
            }
            _mc.addChild(_bubbleSelectTarget);
            _monsterTransferInProgress = true;
         }
         else
         {
            _monsterTransfer = {};
            _monsterTransferInProgress = false;
         }
      }
      
      internal static function TransferMonstersB(cell:MapRoomCell) : void
      {
         if(_monsterTransferInProgress)
         {
            if(cell._mine)
            {
               if(cell._baseID == _monsterSource._baseID)
               {
                  if(_bubbleSelectTarget.parent)
                  {
                     _bubbleSelectTarget.parent.removeChild(_bubbleSelectTarget);
                  }
                  _mc.ShowMonstersA(_monsterSource,true);
                  return;
               }
               _mc.ShowMonstersB(_monsterTransfer,cell);
            }
         }
      }
      
      internal static function TransferMonstersC(targetCell:MapRoomCell) : String
      {
         var transferSuccessful:Function;
         var transferError:Function;
         var actualTransfer:Object = null;
         var finalMonsters:Object = null;
         var finalSrcMonsters:Object = null;
         var dst:String = null;
         var src:String = null;
         var spaceRemaining:int = 0;
         var baseUpdateFrom:Array = null;
         var baseUpdateTo:Array = null;
         var srcMonsterData:Object = null;
         var targetMonsterData:Object = null;
         var transferVars:Array = null;
         var cost:int = 0;
         _monsterTarget = targetCell;
         if(_monsterTransferInProgress)
         {
            if(_monsterTarget._mine && _monsterSource._mine)
            {
               PLEASEWAIT.Show(KEYS.Get("wait_processing"));
               _mc.HideMonstersB();
               if(_monsterTarget._monsters && _monsterSource && _monsterTarget._monsterData.space.Get() > 0)
               {
                  transferSuccessful = function(param1:Object):void
                  {
                     PLEASEWAIT.Hide();
                     if(param1.error == 0)
                     {
                        if(_allMonstersTransferred)
                        {
                           GLOBAL.Message(KEYS.Get("newmap_tr_done"));
                        }
                        else
                        {
                           GLOBAL.Message(KEYS.Get("newmap_tr_space",{"v1":_monstersTransferred}));
                           if (_monstersTransferred == 0)
                           {
                              _monsterTransfer = {};
                              return;
                           }
                        }
                        // update target cell monsters
                        for(dst in finalMonsters)
                        {
                           if(_monsterTarget._monsters[dst])
                           {
                              _monsterTarget._monsters[dst].Set(finalMonsters[dst]);
                              _monsterTarget._hpMonsters[dst] = finalMonsters[dst];
                           }
                           else
                           {
                              _monsterTarget._monsters[dst] = new SecNum(finalMonsters[dst]);
                              _monsterTarget._hpMonsters[dst] = finalMonsters[dst];
                           }
                        }
                        // update source cell monsters
                        if(_monsterSourceRef.cellX == _monsterSource.cellX && _monsterSourceRef.cellY == _monsterSource.cellY)
                        {
                           // source cell is rendered on map
                           for(src in finalSrcMonsters)
                           {
                              if(finalSrcMonsters[src] > 0)
                              {
                                 _monsterSourceRef._monsters[src].Set(finalSrcMonsters[src]);
                                 _monsterSourceRef._hpMonsters[src] = finalSrcMonsters[src];
                              }
                              else
                              {
                                 delete _monsterSourceRef._monsters[src];
                                 delete _monsterSourceRef._hpMonsters[src];
                              }
                           }
                        }
                     }
                     else
                     {
                        GLOBAL.Message(KEYS.Get("msg_err_transfer") + param1.error);
                     }
                     _monsterTransfer = {};
                  };
                  transferError = function(param1:IOErrorEvent):void
                  {
                     PLEASEWAIT.Hide();
                     GLOBAL.Message(KEYS.Get("msg_err_transfer") + param1.text);
                     _monsterTransfer = {};
                  };
                  actualTransfer = {};
                  finalMonsters = {};
                  finalSrcMonsters = {};
                  spaceRemaining = int(_monsterTarget._monsterData.space.Get());
                  baseUpdateFrom = ["BMU"];
                  baseUpdateTo = ["BMU"];
                  if(_bubbleSelectTarget.parent)
                  {
                     _bubbleSelectTarget.parent.removeChild(_bubbleSelectTarget);
                  }
                  _monsterTransferInProgress = false;
                  for(dst in _monsterTarget._monsters)
                  {
                     finalMonsters[dst] = _monsterTarget._monsters[dst].Get();
                     spaceRemaining -= _monsterTarget._monsters[dst].Get() * CREATURES.GetProperty(dst,"cStorage");
                  }
                  for(src in _monsterSource._monsters)
                  {
                     finalSrcMonsters[src] = _monsterSource._monsters[src].Get();
                  }
                  _monstersTransferred = 0;
                  _allMonstersTransferred = true;
                  for(src in _monsterTransfer)
                  {
                     if (_monsterTransfer[src].Get() > 0)
                     {
                        cost = CREATURES.GetProperty(src,"cStorage");
                        if(spaceRemaining >= _monsterTransfer[src].Get() * cost)
                        {
                           actualTransfer[src] = _monsterTransfer[src].Get();
                           _monstersTransferred += _monsterTransfer[src].Get();
                        }
                        else
                        {
                           _allMonstersTransferred = false;
                           actualTransfer[src] = int(spaceRemaining / cost);
                           _monstersTransferred += int(spaceRemaining / cost);
                        }
                        if(_monsterTarget._monsters[src])
                        {
                           finalMonsters[src] = _monsterTarget._monsters[src].Get() + actualTransfer[src];
                        }
                        else
                        {
                           finalMonsters[src] = actualTransfer[src];
                        }
                        if(_monsterSource._monsters[src])
                        {
                           finalSrcMonsters[src] = _monsterSource._monsters[src].Get() - actualTransfer[src];
                        }
                        spaceRemaining -= actualTransfer[src] * cost;
                        baseUpdateFrom.push({
                           "creatureID":src,
                           "count":actualTransfer[src]
                        });
                        baseUpdateTo.push({
                           "creatureID":src,
                           "count":-actualTransfer[src]
                        });
                        if(spaceRemaining <= 0)
                        {
                           break;
                        }
                     }
                  }
                  if(!_monsterTarget.Check())
                  {
                     LOGGER.Log("err","BASE.Save:  transfer target Cell " + _monsterTarget.X + "," + _monsterTarget.Y + "does not check out before doing monster transfer!  " + JSON.encode(_monsterTarget._hpMonsterData));
                  }
                  if(!_monsterSource.Check())
                  {
                     LOGGER.Log("err","BASE.Save:  transfer source Cell " + _monsterSource.X + "," + _monsterSource.Y + "does not check out before doing monster transfer!  " + JSON.encode(_monsterSource._hpMonsterData));
                  }
                  srcMonsterData = {
                     "hcount":_monsterSource._hpMonsterData.hcount,
                     "overdrivepower":_monsterSource._monsterData.overdrivepower.Get(),
                     "hcc":_monsterSource._hpMonsterData.hcc,
                     "space":_monsterSource._monsterData.space.Get(),
                     "h":_monsterSource._hpMonsterData.h,
                     "finishtime":_monsterSource._hpMonsterData.finishtime,
                     "overdrivetime":_monsterSource._monsterData.overdrivetime.Get(),
                     "housed":finalSrcMonsters,
                     "hid":_monsterSource._hpMonsterData.hid,
                     "hstage":_monsterSource._hpMonsterData.hstage,
                     "saved":GLOBAL.Timestamp()
                  };
                  targetMonsterData = {
                     "hcount":_monsterTarget._hpMonsterData.hcount,
                     "overdrivepower":_monsterTarget._monsterData.overdrivepower.Get(),
                     "hcc":_monsterTarget._hpMonsterData.hcc,
                     "space":_monsterTarget._monsterData.space.Get(),
                     "h":_monsterTarget._hpMonsterData.h,
                     "finishtime":_monsterTarget._hpMonsterData.finishtime,
                     "overdrivetime":_monsterTarget._monsterData.overdrivetime.Get(),
                     "housed":finalMonsters,
                     "hid":_monsterTarget._hpMonsterData.hid,
                     "hstage":_monsterTarget._hpMonsterData.hstage,
                     "saved":GLOBAL.Timestamp()
                  };
                  transferVars = [["frombaseid",_monsterSource._baseID],["tobaseid",_monsterTarget._baseID],["monsters",JSON.encode([srcMonsterData,targetMonsterData])]];
                  new URLLoaderApi().load(GLOBAL._mapURL + "transferassets",transferVars,transferSuccessful,transferError);
                  return "";
               }
               if(_monsterTarget._monsterData.space.Get() == 0)
               {
                  GLOBAL.Message(KEYS.Get("newmap_tr_err1"));
               }
               PLEASEWAIT.Hide();
               return KEYS.Get("newmap_tr_err1");
            }
            GLOBAL.Message(KEYS.Get("newmap_tr_err2"));
            PLEASEWAIT.Hide();
            return KEYS.Get("newmap_tr_err2");
         }
         PLEASEWAIT.Hide();
         return KEYS.Get("newmap_tr_err3");
      }
      
      internal static function TransferCancel(param1:MouseEvent = null) : void
      {
         if(_bubbleSelectTarget.parent)
         {
            _bubbleSelectTarget.parent.removeChild(_bubbleSelectTarget);
         }
         _resourceTransfer = {};
         _monsterTransfer = {};
         _resourceTransferInProgress = false;
         _monsterTransferInProgress = false;
      }
      
      internal static function Resize() : void
      {
         _mc.x = 0;
         _mc.y = 0;
         MapRoomManager.instance.ResizeHandler();
      }
      
      internal static function SmokeAdd() : void
      {
         if(_smokeBMD)
         {
            return;
         }
         SmokeRemove();
         _smokeBMD = new BitmapData(100,100,true,16777215);
         _smokeParticles = [];
      }
      
      internal static function SmokeRemove() : void
      {
         _smokeBMD = null;
      }
      
      internal static function SmokeTick(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:BitmapData = null;
         if(!_smokeBMD)
         {
            return;
         }
         _frame += 1;
         if(_frame == 1000)
         {
            _frame = 0;
         }
         if(_frame % 2 == 0)
         {
            if(_smokeParticles.length < 200)
            {
               _smokeParticles.push({
                  "position":new Point(2 + Math.random() * 15,90),
                  "speed":3 + Math.random(),
                  "wind":0.6 + Math.random() * 0.4
               });
            }
            _smokeBMD.fillRect(_smokeBMD.rect,16777215);
            _loc2_ = 0;
            while(_loc2_ < _smokeParticles.length)
            {
               _loc3_ = _smokeParticles[_loc2_];
               _loc3_.position.x += _loc3_.wind * 0.4;
               _loc3_.position.y -= _loc3_.speed * 0.2;
               if(_loc3_.speed > 0.1)
               {
                  _loc3_.speed -= 0.02;
               }
               if((_loc4_ = int(100 - 100 / 4 * _loc3_.speed)) < 60)
               {
                  _loc4_ = 60;
               }
               _loc5_ = Smoke._smokeParticleBMD[_loc4_];
               _smokeBMD.copyPixels(_loc5_,_loc5_.rect,_loc3_.position,null,null,true);
               if(_loc4_ >= 95)
               {
                  _smokeParticles[_loc2_] = {
                     "position":new Point(2 + Math.random() * 15,90),
                     "speed":3 + Math.random(),
                     "wind":0.6 + Math.random() * 0.5
                  };
               }
               _loc2_++;
            }
         }
      }
      
      public static function ShowInfoEnemy(param1:IMapRoomCell, param2:Boolean = false) : void
      {
         _mc.ShowInfoEnemy(param1 as MapRoomCell,param2);
      }
      
      public static function HideInfoMine() : void
      {
         _mc.HideInfoMine();
      }
      
      public function set bookmarkData(param1:Object) : void
      {
         _bookmarkData = param1;
      }
      
      public function set mapWidth(param1:int) : void
      {
         _mapWidth = param1;
      }
      
      public function set mapHeight(param1:int) : void
      {
         _mapHeight = param1;
      }
      
      public function get worldID() : int
      {
         return _worldID;
      }
      
      public function set worldID(param1:int) : void
      {
         _worldID = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return _open;
      }
      
      public function get flingerInRange() : Boolean
      {
         return _flingerInRange;
      }
      
      public function get viewOnly() : Boolean
      {
         return _viewOnly;
      }
      
      public function get playerOwnedCells() : Vector.<IMapRoomCell>
      {
         return null;
      }
      
      public function get allianceDataById() : Dictionary
      {
         return null;
      }
      
      public function Setup() : void
      {
         _Setup(GLOBAL._mapHome,this.worldID,_inviteBaseID,this.viewOnly);
      }
      
      public function ReadyToShow() : Boolean
      {
         return true;
      }
      
      public function ShowDelayed(param1:Boolean = false) : void
      {
         if(GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD)
         {
            GLOBAL.m_mapRoomFunctional = true;
         }
         if(param1 || _reposition || (!BASE.isMainYard || GLOBAL._bMap && GLOBAL._bMap._canFunction || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD) && (GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP || !_open))
         {
            SOUNDS.Play("click1");
            _open = true;
            _reposition = false;
            if(_mc != null)
            {
               _mc.Cleanup();
               _mc = null;
            }
            _mc = new MapRoomPopup();
            _mc.Setup();
            BASE.Cleanup();
            GLOBAL._layerUI.addChild(_mc);
            UI2.SetupHUD();
            if(GLOBAL._currentCell)
            {
               GetCell(GLOBAL._currentCell.cellX,GLOBAL._currentCell.cellY,true);
               _mc.JumpTo(new Point(GLOBAL._currentCell.cellX,GLOBAL._currentCell.cellY));
               if(_showEnemyWait)
               {
                  _mc.ShowInfoEnemy(GLOBAL._currentCell as MapRoomCell,true);
                  _showEnemyWait = false;
               }
               else if(_showAttackWait)
               {
                  _mc.ShowAttack(GLOBAL._currentCell as MapRoomCell);
                  _showAttackWait = false;
               }
            }
            if(_empiredestroyed)
            {
               GLOBAL.Message(KEYS.Get("empiredestroyed_newbase"));
               _empiredestroyed = false;
            }
            if(GLOBAL._ROOT.stage.displayState == StageDisplayState.NORMAL)
            {
               if(Chat._bymChat)
               {
                  Chat._bymChat.show();
               }
               if(UI_BOTTOM._missions)
               {
                  UI_BOTTOM._missions.visible = true;
               }
            }
            else
            {
               if(Chat._bymChat)
               {
                  Chat._bymChat.hide();
               }
               if(UI_BOTTOM._missions)
               {
                  UI_BOTTOM._missions.visible = false;
               }
            }
         }
         Tutorial.ShowIfNeeded();
      }
      
      public function Hide() : void
      {
         if(_open && GLOBAL.mode != GLOBAL.e_BASE_MODE.ATTACK && GLOBAL.mode != GLOBAL.e_BASE_MODE.WMATTACK)
         {
            SOUNDS.Play("close");
            if(_mc.parent)
            {
               _mc.parent.removeChild(_mc);
            }
            ClearCells();
            _mc.Cleanup();
            _mc = null;
         }
         _open = false;
      }
      
      public function BookmarksClear() : void
      {
         MapRoom._bookmarkData = {};
         MapRoom._bookmarks = [];
         MapRoom.BookmarksSave();
      }
      
      public function FindCell(param1:int, param2:int) : IMapRoomCell
      {
         return GetCell(param1,param2) as IMapRoomCell;
      }
      
      public function LoadCell(param1:int, param2:int, param3:Boolean = false) : void
      {
         GetCell(param1,param2,param3);
      }
      
      public function CalculateCellId(param1:int, param2:int) : int
      {
         return param2 * _mapWidth + param1 + 1;
      }
      
      public function Tick() : void
      {
         if(_open && _mc && Boolean(_mc.parent))
         {
            _mc.Tick();
         }
         if(_open && (!_mc || _mc && !_mc.parent) && BASE._saveCounterA == BASE._saveCounterB)
         {
            PLEASEWAIT.Hide();
            if(_mc)
            {
               _mc.Cleanup();
               _mc = null;
            }
            _mc = new MapRoomPopup();
            _mc.Setup();
            BASE.Cleanup();
            GLOBAL._layerWindows.addChild(_mc);
         }
      }
      
      public function TickFast() : void
      {
      }
      
      public function ResizeHandler() : void
      {
         if(!_viewOnly)
         {
            MapRoomManager.instance.Hide();
         }
         else
         {
            HideFromViewOnly();
         }
         MapRoomManager.instance.ShowDelayed(true);
      }
   }
}
