package
{
   
   import com.monsters.configs.BYMDevConfig;
   import com.monsters.display.ImageCache;
   import com.monsters.frontPage.FrontPageGraphic;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import gs.TweenLite;
   
   public class POPUPS
   {
      
      public static const k_TOP_LEFT:int = 1;
      
      public static const k_CENTER:int = 2;
      
      private static var _popups:Object;
      
      private static var _mc:MovieClip;
      
      private static var _mcBG:MovieClip;
      
      private static var _lastGroup:String = "alerts";
      
      public static var _open:Boolean = false;
      
      public static var _timer:Timer;
       
      private static var _academy:ACADEMY = ACADEMY.getInstance();
      
      public function POPUPS()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _popups = {
            "now":[],
            "alerts":[],
            "gifts":[],
            "wait":[],
            "tip":[]
         };
         _open = false;
      }
      
      public static function Push(param1:*, param2:Function = null, param3:Array = null, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "now") : void
      {
         if(param5)
         {
            ImageCache.GetImageWithCallBack("popups/" + param5,null,true,0);
         }
         if(GLOBAL._catchup && param7 == "now" && !param6)
         {
            param7 = "alerts";
         }
         if(param7 == "now" && _lastGroup != "now")
         {
            _lastGroup = "now";
         }
         _popups[param7].push([param1,param2,param3,param4,param5]);
         if(param6)
         {
            Next();
         }
         else if(!_open && !NewPopupSystem.dialogShowing)
         {
            Show();
         }
      }
      
      public static function Next(param1:MouseEvent = null) : void
      {
         if(GLOBAL.isHalted)
         {
            GLOBAL.CallJS("reloadPage");
         }
         if(!GLOBAL._catchup || _lastGroup == "tip")
         {
            Hide();
         }
      }
      
      private static function Hide() : void
      {
         if(_mc)
         {
            HideB();
         }
         else
         {
            Show("now");
         }
      }
      
      private static function HideB() : void
      {
         _open = false;
         RemoveBG();
         if(Boolean(_mc) && Boolean(_mc.parent))
         {
            _mc.parent.removeChild(_mc);
         }
         _mc = null;
         if(_lastGroup == "alerts" || _lastGroup == "wait" || _lastGroup == "tip")
         {
            if(_lastGroup == "tip")
            {
               _lastGroup = "now";
            }
            NextDelayed();
         }
         else
         {
            Show(_lastGroup);
         }
      }
      
      public static function hasPopupsOpen() : Boolean
      {
         var _loc1_:Boolean = Boolean(GLOBAL._newBuilding) && (GLOBAL._newBuilding as BFOUNDATION)._placing == true;
         return BUILDINGS._open || STORE._open || BUILDINGOPTIONS._open || _academy._open || CREATURELOCKER._open || _loc1_ || Boolean(_mc) || _open;
      }
      
      private static function NextDelayed(param1:int = 200) : void
      {
         _timer = new Timer(param1,1);
         _timer.addEventListener(TimerEvent.TIMER,TimerDone);
         _timer.start();
      }
      
      private static function TimerDone(param1:TimerEvent) : void
      {
         if(_timer)
         {
            _timer.removeEventListener(TimerEvent.TIMER,TimerDone);
            _timer.stop();
            _timer = null;
            if(hasPopupsOpen())
            {
               NextDelayed(100);
            }
            else
            {
               Show(_lastGroup);
            }
         }
      }
      
      public static function Add(param1:DisplayObject, param2:int = 0) : void
      {
         GLOBAL._layerTop.addChild(param1);
         switch(param2)
         {
            case 0:
               break;
            case 1:
               assignAlignToUpperLeft(param1);
               break;
            case 2:
               assignAlignToCenter(param1);
         }
      }
      
      public static function Remove(param1:DisplayObject = null) : void
      {
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.removeEventListener(Event.ENTER_FRAME,onResize);
            param1.removeEventListener(Event.ENTER_FRAME,onResizeCenter);
            param1.parent.removeChild(param1);
         }
      }
      
      public static function assignAlignToUpperLeft(param1:DisplayObject = null) : void
      {
         POPUPSETTINGS.AlignToUpperLeft(param1,true);
         param1.addEventListener(Event.ENTER_FRAME,onResize,false,0,true);
      }
      
      public static function assignAlignToCenter(param1:DisplayObject = null) : void
      {
         POPUPSETTINGS.AlignToCenter(param1);
         param1.addEventListener(Event.ENTER_FRAME,onResizeCenter,false,0,true);
      }
      
      protected static function onResize(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         POPUPSETTINGS.AlignToUpperLeft(_loc2_,true);
      }
      
      protected static function onResizeCenter(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         POPUPSETTINGS.AlignToCenter(_loc2_);
      }
      
      public static function Show(param1:String = "now") : void
      {
         var ImageLoaded:Function;
         var message:Array = null;
         var group:String = param1;
         if(!GLOBAL._catchup || group == "tip")
         {
            _lastGroup = group;
            message = _popups[group].shift();
            if(Boolean(message) && !_open)
            {
               _open = true;
               AddBG();
               _mc = GLOBAL._layerTop.addChild(message[0]) as MovieClip;
               POPUPSETTINGS.AlignToCenter(_mc);
               POPUPSETTINGS.ScaleUp(_mc);
               try
               {
                  if(_mc.bMessage)
                  {
                     _mc.bMessage.selectable = true;
                     _mc.bMessage.stage.focus = _mc.bMessage;
                     _mc.bMessage.setSelection(0,_mc.bMessage.text.length);
                  }
               }
               catch(e:Error)
               {
               }
               if(message[3])
               {
                  SOUNDS.Play(message[3]);
               }
               if(message[1])
               {
                  if(message[2])
                  {
                     if(message[2].length == 1)
                     {
                        message[1](message[2][0]);
                     }
                     if(message[2].length == 2)
                     {
                        message[1](message[2][0],message[2][1]);
                     }
                     if(message[2].length == 3)
                     {
                        message[1](message[2][0],message[2][1],message[2][2]);
                     }
                     if(message[2].length == 4)
                     {
                        message[1](message[2][0],message[2][1],message[2][2],message[2][3]);
                     }
                  }
                  else
                  {
                     message[1]();
                  }
               }
               if(message[4])
               {
                  ImageLoaded = function(param1:String, param2:BitmapData):void
                  {
                     try
                     {
                        if(Boolean(_mc) && Boolean(_mc.mcImage))
                        {
                           while(_mc.mcImage.numChildren)
                           {
                              _mc.mcImage.removeChildAt(0);
                           }
                           _mc.mcImage.addChild(new Bitmap(param2));
                           _mc.mcImage.mouseEnabled = false;
                           _mc.mcImage.mouseChildren = false;
                           if(_mc.mcImageFrame)
                           {
                              _mc.mcImage.x = _mc.mcImageFrame.x + (_mc.mcImageFrame.width - _mc.mcImage.width) * 0.5;
                              _mc.mcImage.y = _mc.mcImageFrame.y + (_mc.mcImageFrame.height - _mc.mcImage.height) * 0.5;
                           }
                        }
                     }
                     catch(e:Error)
                     {
                     }
                  };
                  ImageCache.GetImageWithCallBack("popups/" + message[4],ImageLoaded,true,0);
               }
            }
            else if(_lastGroup == "now" && QueueCount("now") == 0 && QueueCount("wait") > 0)
            {
               _lastGroup = "wait";
               if(_popups["wait"][0] is FrontPageGraphic)
               {
                  NextDelayed(100);
               }
               else
               {
                  NextDelayed(500);
               }
            }
            else
            {
               if(_timer)
               {
                  _timer.removeEventListener(TimerEvent.TIMER,TimerDone);
                  _timer.stop();
                  _timer = null;
               }
               if(QueueCount("wait") > 0)
               {
                  _lastGroup = "wait";
                  if(_popups["wait"][0] is FrontPageGraphic)
                  {
                     NextDelayed(100);
                  }
                  else
                  {
                     NextDelayed(500);
                  }
               }
            }
         }
         else if(QueueCount("wait") > 0)
         {
            _lastGroup = "wait";
            if(_popups["wait"][0] is FrontPageGraphic)
            {
               NextDelayed(100);
            }
            else
            {
               NextDelayed(500);
            }
         }
      }
      
      public static function QueueCount(param1:String = "now") : int
      {
         return _popups[param1].length;
      }
      
      public static function AddBG() : void
      {
         RemoveBG();
         GLOBAL.RefreshScreen();
         _mcBG = GLOBAL._layerTop.addChild(new popup_bg()) as popup_bg;
         _mcBG.width = GLOBAL._SCREEN.width;
         _mcBG.height = GLOBAL._SCREEN.height;
         _mcBG.x = GLOBAL._SCREEN.x;
         _mcBG.y = GLOBAL._SCREEN.y;
      }
      
      public static function RemoveBG(param1:MovieClip = null) : void
      {
         if(Boolean(_mcBG) && Boolean(_mcBG.parent))
         {
            _mcBG.parent.removeChild(_mcBG);
         }
         _mcBG = null;
      }
      
      public static function Resize() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < _popups.length)
         {
            _loc2_ = 0;
            while(_loc2_ < _popups[_loc1_].length)
            {
               _popups[_loc1_][_loc2_].x = GLOBAL._SCREENCENTER.x;
               _popups[_loc1_][_loc2_].x = GLOBAL._SCREENCENTER.y;
               _loc2_++;
            }
            _loc1_++;
         }
      }

      public static function NoConnection() : void {
         var movie:MovieClip = null;
         SOUNDS.StopAll();
         _mcBG = GLOBAL._layerTop.addChild(new popup_bg2()) as popup_bg2;
         _mcBG.x = GLOBAL._SCREEN.x;
         _mcBG.y = GLOBAL._SCREEN.y;
         _mcBG.width = GLOBAL._SCREEN.width;
         _mcBG.height = GLOBAL._SCREEN.height;
         _mcBG.cacheAsBitmap = true;
         movie = new popup_timeout();
         movie.tA.htmlText = "<b>" + KEYS.Get("pop_noconnect_title") + "</b>";
         movie.tB.htmlText = KEYS.Get("pop_noconnect_body");
         movie.bGift.visible = false;
         movie.x = GLOBAL._SCREENCENTER.x;
         movie.y = GLOBAL._SCREENCENTER.y;
         GLOBAL._layerTop.addChild(movie);
         GLOBAL.Halt();
      }
      
      public static function Timeout() : void
      {
         var _loc1_:MovieClip = null;
         SOUNDS.StopAll();
         if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
         {
            print("game timed out, kicking the client out of fullscreen");
            GLOBAL._ROOT.stage.displayState = StageDisplayState.NORMAL;
         }
         _mcBG = GLOBAL._layerTop.addChild(new popup_bg2()) as popup_bg2;
         _mcBG.x = GLOBAL._SCREEN.x;
         _mcBG.y = GLOBAL._SCREEN.y;
         _mcBG.width = GLOBAL._SCREEN.width;
         _mcBG.height = GLOBAL._SCREEN.height;
         _mcBG.cacheAsBitmap = true;
         _loc1_ = new popup_timeout();
         _loc1_.tA.htmlText = "<b>" + KEYS.Get("pop_timeout_title") + "</b>";
         _loc1_.tB.htmlText = KEYS.Get("pop_timeout_body");
         if(!GLOBAL._flags.kongregate)
         {
            if(GLOBAL._canGift)
            {
               _loc1_.bGift.SetupKey("btn_sendfreegifts");
               _loc1_.bGift.addEventListener(MouseEvent.CLICK,DisplayGiftSelect);
            }
            else
            {
               _loc1_.bGift.SetupKey("btn_invitefriendstoplay");
               _loc1_.bGift.addEventListener(MouseEvent.CLICK,DisplayInviteSelect);
            }
            _loc1_.bGift.Highlight = true;
         }
         else
         {
            _loc1_.bGift.visible = false;
         }
         _loc1_.x = GLOBAL._SCREENCENTER.x;
         _loc1_.y = GLOBAL._SCREENCENTER.y;
         GLOBAL._layerTop.addChild(_loc1_);
         GLOBAL.Halt();
      }
      
      public static function AFK() : void
      {
         if(!GLOBAL._promptedAFK && TUTORIAL._stage > 200)
         {
            if(GLOBAL._canGift || Boolean(GLOBAL._flags.kongregate))
            {
               Gift(true);
            }
            else
            {
               Invite(true);
            }
         }
         GLOBAL._promptedAFK = true;
      }
      
      public static function Gift(param1:Boolean = false) : void
      {
         var SendGift:Function;
         var GetFriends:Function;
         var popupMC:MovieClip = null;
         var showingamepopup:Boolean = param1;
         if(GLOBAL._canGift || Boolean(GLOBAL._flags.kongregate))
         {
            if(showingamepopup)
            {
               SendGift = function(param1:MouseEvent):void
               {
                  POPUPS.Next(param1);
                  DisplayGiftSelect();
               };
               popupMC = new popup_afk_gift();
               popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_afk_title") + "</b>";
               popupMC.tB.htmlText = KEYS.Get("pop_afk_body");
               if(GLOBAL._canGift)
               {
                  popupMC.bAction.SetupKey("btn_sendfreegifts");
                  popupMC.bAction.addEventListener(MouseEvent.CLICK,SendGift);
                  popupMC.bAction.Highlight = true;
               }
               else
               {
                  popupMC.bAction.visible = false;
               }
               POPUPS.Push(popupMC,null,null,"","resourcetwigs.png");
            }
            else
            {
               DisplayGiftSelect();
            }
         }
         else
         {
            GetFriends = function(param1:MouseEvent):void
            {
               POPUPS.Next(param1);
               Invite();
            };
            popupMC = new popup_invite_friends();
            if(GLOBAL._friendCount > 0)
            {
               popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_invitefriends_title") + "</b>";
               popupMC.tB.htmlText = KEYS.Get("pop_invitefriends_body");
            }
            else
            {
               popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_invitenofriends_title") + "</b>";
               popupMC.tB.htmlText = KEYS.Get("pop_invitenofriends_body");
            }
            popupMC.bAction.SetupKey("btn_invitefriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,GetFriends);
            popupMC.bAction.Highlight = true;
            POPUPS.Push(popupMC);
         }
         GLOBAL.StatSet("pg",GLOBAL.Timestamp());
      }
      
      public static function Invite(param1:Boolean = false) : void
      {
         var GetFriends:Function;
         var popupMC:popup_invite_friends = null;
         var showingamepopup:Boolean = param1;
         if(showingamepopup)
         {
            GetFriends = function(param1:MouseEvent):void
            {
               POPUPS.Next(param1);
               DisplayInviteSelect();
            };
            popupMC = new popup_invite_friends();
            popupMC.tA.htmlText = KEYS.Get("pop_invitefriends_title");
            popupMC.tB.htmlText = KEYS.Get("pop_invitefriends_body");
            popupMC.bAction.SetupKey("btn_invitefriends");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,GetFriends);
            popupMC.bAction.Highlight = true;
            POPUPS.Push(popupMC);
         }
         else
         {
            DisplayInviteSelect();
         }
         GLOBAL.StatSet("pi",GLOBAL.Timestamp());
      }
      
      public static function Done() : Boolean
      {
         return _open == false;
      }
      
      public static function DisplaySR(param1:MouseEvent = null) : void
      {
         AddBG();
         GLOBAL.CallJS("cc.showSrOverlay",["callbackshiny"]);
         LOGGER.Stat([20,1]);
      }
      
      public static function DisplayGiftSelect(param1:MouseEvent = null) : void
      {
         AddBG();
         if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
         {
            GLOBAL.CallJSWithClient("cc.showFeedDialog","callbackgift",["gift"]);
         }
         else
         {
            GLOBAL.CallJS("cc.showFeedDialog",["gift","callbackgift"]);
         }
         LOGGER.Stat([20,1]);
      }
      
      public static function DisplayInviteSelect(param1:MouseEvent = null) : void
      {
         AddBG();
         if(BYMDevConfig.instance.USE_CLIENT_WITH_CALLBACK)
         {
            GLOBAL.CallJSWithClient("cc.showFeedDialog","callbackgift",["invite"]);
         }
         else
         {
            GLOBAL.CallJS("cc.showFeedDialog",["invite","callbackgift"]);
         }
         LOGGER.Stat([21,1]);
      }
      
      public static function DisplayWelcome(param1:MouseEvent = null) : void
      {
         var Share:Function;
         var popupMC:MovieClip = null;
         var e:MouseEvent = param1;
         if(GLOBAL._flags.fanfriendbookmarkquests)
         {
            Share = function():void
            {
               LOGGER.Stat([23,1]);
               GLOBAL.CallJS("sendFeed",["started-aggressive",KEYS.Get("pop_displaywelcome_streamtitle"),KEYS.Get("pop_displaywelcome_streambody"),"aggressive.png",0,null,"aggressive.v3.swf"]);
               Next();
            };
            LOGGER.Stat([23]);
            popupMC = new popup_welcome();
            popupMC.bAction.SetupKey("btn_share");
            popupMC.tA.htmlText = KEYS.Get("pop_displaywelcome_title");
            popupMC.tB.htmlText = KEYS.Get("pop_displaywelcome_body");
            popupMC.bAction.addEventListener(MouseEvent.CLICK,Share);
            popupMC.bAction.Highlight = true;
            POPUPS.Push(popupMC);
         }
      }
      
      public static function DisplayGetShiny(param1:MouseEvent = null) : void
      {
         POPUPS.Push(GetShinyPopup(),null,null,"error1","aintgotnoshiny.png");
      }
      
      public static function GetShinyPopup() : MovieClip
      {
         var _loc1_:MovieClip = new popup_noshiny();
         _loc1_.tA.htmlText = "<b>" + KEYS.Get("pop_noshiny_title") + "</b>";
         _loc1_.tB.htmlText = KEYS.Get("pop_noshiny_body");
         _loc1_.bGet.SetupKey("str_getmore_btn");
         _loc1_.bGet.addEventListener(MouseEvent.CLICK,BUY.Show);
         _loc1_.bGet.Highlight = true;
         return _loc1_;
      }
      
      public static function DisplayWorker(param1:int, param2:*) : void
      {
         var getWorker:Function = null;
         var n:int = param1;
         var b:* = param2;
         getWorker = function(param1:MouseEvent):void
         {
            STORE.ShowB(1,0,["BEW"]);
            POPUPS.Next();
         };
         var DisplayWorkerNext:Function = function(param1:int, param2:*):void
         {
            var _loc4_:BFOUNDATION = null;
            var _loc3_:int = QUEUE.GetFinishCost();
            GLOBAL._selectedBuilding = QUEUE.GetBuilding();
            if(_loc3_ > BASE._credits.Get())
            {
               POPUPS.Next();
               POPUPS.DisplayGetShiny();
               return;
            }
            if(GLOBAL._selectedBuilding)
            {
               STORE._storeItems.SP4.c = [_loc3_];
               STORE.BuyB("SP4");
               POPUPS.Next();
            }
            if(param1 == 0)
            {
               BUILDINGS.Hide();
               BASE.addBuildingB(param2 as int);
            }
            else
            {
               _loc4_ = param2 as BFOUNDATION;
               if(param1 == 1 && Boolean(_loc4_))
               {
                  if(int(_loc4_._buildingProps.costs[_loc4_._lvl.Get()].time.Get() * GLOBAL._buildTime) > 3600)
                  {
                     UPDATES.Create(["BU",_loc4_._id]);
                  }
                  BUILDINGOPTIONS.Hide();
                  _loc4_.UpgradeB();
                  BASE.Save();
               }
               else if(param1 == 2 && Boolean(_loc4_))
               {
                  BUILDINGINFO.Hide();
                  MUSHROOMS.PickWorker(_loc4_);
               }
               else if(param1 == 3 && Boolean(_loc4_))
               {
                  if(int(_loc4_._buildingProps.fortify_costs[_loc4_._fortification.Get()].time.Get() * GLOBAL._buildTime) > 3600)
                  {
                     UPDATES.Create(["BF",_loc4_._id]);
                  }
                  BUILDINGOPTIONS.Hide();
                  _loc4_.FortifyB();
                  BASE.Save();
               }
            }
            POPUPS.Next();
         };
         var workerImage:String = BASE.isInfernoMainYardOrOutpost ? "BYM_WorkerGuy2.png" : "helpinghand.png";
         var mc:MovieClip = new popup_noworker();
         if(!BASE.isMainYard)
         {
            mc.tA.htmlText = KEYS.Get("worker_busy");
            mc.tB.htmlText = KEYS.Get("worker_speedupoutpost",{"v1":QUEUE.GetFinishCost()});
            mc.bGet.SetupKey("btn_speedup");
            mc.bGet.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               DisplayWorkerNext(n,b);
            });
            mc.bGet.Highlight = true;
         }
         else
         {
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_hireanother_title") + "</b>";
            if(QUEUE.GetBuilding())
            {
               mc.tB.htmlText = KEYS.Get("worker_speedup",{"v1":QUEUE.GetFinishCost()});
               mc.bGet.SetupKey("btn_speedup");
               mc.bGet.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  DisplayWorkerNext(n,b);
               });
            }
            else
            {
               mc.bGet.SetupKey("btn_hireanother");
               mc.tB.htmlText = KEYS.Get("pop_hireanother_body");
               mc.bGet.addEventListener(MouseEvent.CLICK,getWorker);
            }
            mc.bGet.Highlight = true;
         }
         POPUPS.Push(mc,null,null,null,workerImage);
      }
      
      public static function DisplayPleaseBuy(param1:String) : void
      {
         var popupMC:popup_pleasebuy = null;
         var Action:Function = null;
         var key:String = param1;
         Action = function():void
         {
            popupMC.bAction.Enabled = false;
            popupMC.bAction.removeEventListener(MouseEvent.CLICK,Action);
            BUY.Show();
         };
         popupMC = new popup_pleasebuy();
         popupMC.bAction.SetupKey("str_getmore_btn");
         popupMC.bAction.addEventListener(MouseEvent.CLICK,Action);
         popupMC.tMessage.htmlText = KEYS.Get("pop_marketing_getshiny");
         POPUPS.Push(popupMC,null,null,null,"purchased.png");
      }
      
      public static function DisplayGeneric(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var _loc6_:popup_generic;
         (_loc6_ = new popup_generic()).tA.autoSize = TextFieldAutoSize.LEFT;
         _loc6_.tB.autoSize = TextFieldAutoSize.LEFT;
         _loc6_.tA.htmlText = "<b>" + param1 + "</b>";
         _loc6_.tB.htmlText = param2;
         _loc6_.bAction.Setup(param3);
         _loc6_.bAction.addEventListener(MouseEvent.CLICK,param5);
         _loc6_.bAction.Highlight = true;
         _loc6_.tB.y = _loc6_.tA.y + _loc6_.tA.height + 5;
         _loc6_.mcBG.height = 0 - _loc6_.mcBG.y + _loc6_.tB.y + _loc6_.tB.height + 50;
         if(_loc6_.mcBG.height < 190)
         {
            _loc6_.mcBG.height = 190;
         }
         _loc6_.bAction.y = _loc6_.mcBG.y + _loc6_.mcBG.height - 45;
         _loc6_.mcBG.Setup();
         POPUPS.Push(_loc6_,null,null,"",param4);
      }
      
      public static function DisplayDialogue(param1:String, param2:String, param3:String, param4:String, param5:Point, param6:Function) : MovieClip
      {
         var dialogueMC:popup_dialogue = null;
         var imageCompleteDialogue:Function = null;
         var title:String = param1;
         var message:String = param2;
         var button:String = param3;
         var image:String = param4;
         var imageOffset:Point = param5;
         var action:Function = param6;
         imageCompleteDialogue = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = null;
            _loc3_ = new Bitmap(param2);
            _loc3_.x = imageOffset.x;
            _loc3_.y = -_loc3_.height + imageOffset.y;
            dialogueMC.mcImage.addChild(_loc3_);
         };
         dialogueMC = new popup_dialogue();
         dialogueMC.tTitle.htmlText = "<b>" + title + "</b>";
         dialogueMC.tBody.htmlText = message;
         dialogueMC.bAction.Setup(button);
         if(Boolean(action))
         {
            dialogueMC.bAction.addEventListener(MouseEvent.CLICK,action);
            dialogueMC.bAction.Highlight = true;
         }
         dialogueMC.tBody.y = dialogueMC.tTitle.y + dialogueMC.tTitle.height + 5;
         dialogueMC.mcBG.height = 0 - dialogueMC.mcBG.y + dialogueMC.tTitle.y + dialogueMC.tTitle.height + 50;
         if(dialogueMC.mcBG.height < 190)
         {
            dialogueMC.mcBG.height = 190;
         }
         dialogueMC.bAction.y = dialogueMC.mcBG.y + dialogueMC.mcBG.height - 35;
         dialogueMC.mcBG.Setup();
         if(image)
         {
            ImageCache.GetImageWithCallBack("popups/" + image,imageCompleteDialogue);
         }
         POPUPS.Push(dialogueMC,null,null,"");
         return dialogueMC;
      }
      
      public static function DisplayRate() : void
      {
         var popupMCrate:popup_pleaserate = null;
         var ActionB:Function = null;
         var ActionC:Function = null;
         ActionB = function():void
         {
            popupMCrate.bAction.Enabled = false;
            popupMCrate.bAction.removeEventListener(MouseEvent.CLICK,ActionB);
            TweenLite.to(popupMCrate,1,{"onComplete":ActionC});
         };
         ActionC = function():void
         {
            GLOBAL.CallJS("cc.showRating");
         };
         popupMCrate = new popup_pleaserate();
         popupMCrate.tA.htmlText = KEYS.Get("pop_pleaserate");
         popupMCrate.bAction.SetupKey("pop_rategame_btn");
         popupMCrate.bAction.addEventListener(MouseEvent.CLICK,ActionB);
         POPUPS.Push(popupMCrate,null,null,null,"fivestarbob.png");
      }
      
      public static function CallbackGift(param1:String) : void
      {
         RemoveBG();
         if(GLOBAL.isHalted)
         {
            GLOBAL.CallJS("reloadPage");
         }
      }
      
      public static function CallbackShiny(param1:String) : void
      {
         var obj:Object = null;
         var o:String = param1;
         RemoveBG();
         Next();
         try
         {
            if(o)
            {
               obj = JSON.parse(o);
               BASE._credits.Set(int(obj.credits));
               BASE._hpCredits = int(obj.credits);
               GLOBAL._credits.Set(int(obj.credits));
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","POPUPS.CallbackShiny " + o + " | " + e.message);
         }
         if(GLOBAL.isHalted)
         {
            GLOBAL.CallJS("reloadPage");
         }
      }
   }
}