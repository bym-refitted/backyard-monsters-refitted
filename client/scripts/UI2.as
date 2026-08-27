package
{
   import com.cc.tests.ABTest;
   import com.monsters.chat.Chat;
   import com.monsters.ui.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gs.*;
   import gs.easing.*;
   
   public class UI2
   {

      public static var _top:UI_TOP;
      
      public static var _visitor:UI_VISITOR;
      
      public static var _warning:UI_WARNING;
      
      public static var _tutorial:MovieClip;
      
      public static var _bottomName:String;
      
      public static var _scareAway:UI_BAITERSCAREAWAY;
      
      public static var _showTop:Boolean;
      
      public static var _showBottom:Boolean;
      
      public static var _showWarning:Boolean;
      
      public static var _scrollMap:Boolean;
      
      public static var _showProtected:Boolean;
      
      public static var _wildMonsterBar:UI_WILDMONSTERBAR;
      
      private static var _timers:Array = new Array();
      
      public static var _debugWarningTxt:TextField;
      
      public static var _debugWarningTxtVal:String = "DEBUG MODE";

      public static var activeEvent:*;
       
      
      public function UI2()
      {
         super();
      }
      
      public static function Setup() : void
      {
         activeEvent = SPECIALEVENT.getActiveSpecialEvent();

         _tutorial = GLOBAL._layerUI.addChild(new MovieClip()) as MovieClip;
         try { _top = GLOBAL._layerUI.addChild(new UI_TOP()) as UI_TOP; } catch (ce:Error) { GAME.logDiag("UI_TOP ctor: "+ce.getStackTrace()); }
         try { _warning = GLOBAL._layerUI.addChild(new UI_WARNING()) as UI_WARNING; } catch (ce:Error) { GAME.logDiag("UI_WARNING: "+ce.getStackTrace()); }
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != GLOBAL.e_BASE_MODE.IBUILD)
         {
            try { _visitor = GLOBAL._layerUI.addChild(new UI_VISITOR()) as UI_VISITOR; } catch (ce:Error) { GAME.logDiag("UI_VISITOR: "+ce.getStackTrace()); }
         }
         else
         {
            _visitor = null;
         }
         if(_top.mc)
         {
            _top.mc.x = 0;
            _top.mc.y = 4;
         }
         _showTop = true;
         _showBottom = false;
         _showProtected = false;
         _showWarning = false;
         try { UI_BOTTOM.Setup(); } catch (ce:Error) { GAME.logDiag("UI_BOTTOM.Setup: "+ce.getStackTrace()); }
         if(BASE.isMainYardOrInfernoMainYard)
         {
            try { UI_WORKERS.Setup(); } catch (ce:Error) { GAME.logDiag("UI_WORKERS.Setup: "+ce.getStackTrace()); }
         }
         if (_top) try { _top.Setup(); } catch (ce:Error) { GAME.logDiag("_top.Setup: "+ce.getStackTrace()); }
         if(Chat.flagsShouldChatExist() && Chat._bymChat._open)
         {
            Chat.initChat();
         }
         if(Chat.flagsShouldChatDisplay())
         {
            Chat.setChatPosition(GLOBAL._layerUI,10,300);
         }
         _timers = new Array();
         if(_top.mcProtected)
         {
            _timers.push(_top.mcProtected);
         }
         if(_top.mcReinforcements)
         {
            _timers.push(_top.mcReinforcements);
         }
         if(!GLOBAL._flags.viximo && !GLOBAL._flags.kongregate)
         {
            if(_top.mcSpecialEvent)
            {
               _timers.push(_top.mcSpecialEvent);
            }
            if(GLOBAL._countryCode != "ph" && _top.mcSpecialEvent)
            {
               _top.mcSpecialEvent.buttonMode = true;
               _top.mcSpecialEvent.mouseChildren = false;
               _top.mcSpecialEvent.addEventListener(MouseEvent.CLICK, activeEvent.TimerClicked);
            }
         }
         if(GLOBAL._aiDesignMode)
         {
            DebugWarning();
         }
      }
      
      public static function SetupHUD() : void
      {
         _tutorial = GLOBAL._layerUI.addChild(new MovieClip()) as MovieClip;
         UI_BOTTOM.Setup();
         UI_BOTTOM.Hide();
         if(Chat.flagsShouldChatExist() && Chat._bymChat._open)
         {
            Chat.initChat();
         }
         if(Chat.flagsShouldChatDisplay())
         {
            Chat.setChatPosition(GLOBAL._layerUI,10,300);
         }
      }
      
      public static function Show(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == "top" && !_showTop)
         {
            _showTop = true;
            if(_top.mc)
            {
               _top.mc.visible = true;
            }
         }
         else if(param1 == "bottom" && !_showBottom)
         {
            _showBottom = true;
            UI_BOTTOM.Show();
            if(TUTORIAL._stage >= 200)
            {
               UI_WORKERS.Show();
            }
         }
         else if(param1 == "warning" && !_showWarning)
         {
            _showWarning = true;
            if(_warning.mc)
            {
               if(GLOBAL._render)
               {
                  TweenLite.to(_warning.mc,1,{
                     "y":0,
                     "ease":Elastic.easeOut
                  });
               }
               else
               {
                  _warning.mc.y = 0;
               }
            }
         }
         else if(param1 == "scareAway" || param1 == "surrender")
         {
            if(GLOBAL._render && !_scareAway)
            {
               _scareAway = GLOBAL._layerUI.addChild(new UI_BAITERSCAREAWAY(param1 == "scareAway")) as UI_BAITERSCAREAWAY;
               ResizeHandler();
            }
         }
         else if(param1 == "wmbar")
         {
            if(GLOBAL._render)
            {
               _wildMonsterBar = new UI_WILDMONSTERBAR();
               GLOBAL._layerUI.addChild(_wildMonsterBar);
               _wildMonsterBar.y = 0;
               ResizeHandler();
            }
         }
      }
      
      public static function Clear() : void
      {
         if(_top)
         {
            _top.Clear();
            if(_top.parent)
            {
               _top.parent.removeChild(_top);
            }
            _top = null;
         }
         UI_BOTTOM.Clear();
         if(_warning)
         {
            if(_warning.parent)
            {
               _warning.parent.removeChild(_warning);
            }
            _warning = null;
         }
         if(_scareAway)
         {
            if(_scareAway.parent)
            {
               _scareAway.parent.removeChild(_scareAway);
            }
            _scareAway = null;
         }
         if(Boolean(_wildMonsterBar) && Boolean(_wildMonsterBar.parent))
         {
            _wildMonsterBar.parent.removeChild(_wildMonsterBar);
            _wildMonsterBar = null;
         }
         if(Boolean(_debugWarningTxt) && Boolean(_debugWarningTxt.parent))
         {
            _debugWarningTxt.parent.removeChild(_debugWarningTxt);
            _debugWarningTxt = null;
         }
      }
      
      public static function Hide(param1:String) : void
      {
         var what:String = param1;
         if(what == "top" && _showTop)
         {
            _showTop = false;
            if(_top.mc)
            {
               _top.mc.visible = false;
            }
         }
         else if(what == "bottom" && _showBottom)
         {
            _showBottom = false;
            UI_BOTTOM.Hide();
            UI_WORKERS.Hide();
         }
         else if(what == "warning" && _showWarning)
         {
            _showWarning = false;
            if(Chat._bymChat)
            {
               Chat._bymChat.show();
            }
            if(_warning.mc)
            {
               if(GLOBAL._render)
               {
                  TweenLite.to(_warning.mc,0.5,{
                     "y":-100,
                     "ease":Back.easeIn
                  });
               }
               else
               {
                  _warning.mc.y = -100;
               }
            }
         }
         else if(what == "scareAway" && Boolean(_scareAway))
         {
            if(GLOBAL._layerUI.contains(_scareAway))
            {
               GLOBAL._layerUI.removeChild(_scareAway);
               if(Chat._bymChat)
               {
                  Chat._bymChat.show();
               }
               _scareAway = null;
            }
         }
         else if(what == "wmbar")
         {
            if(_wildMonsterBar != null)
            {
               if(GLOBAL._render)
               {
                  TweenLite.to(_wildMonsterBar,0.5,{
                     "y":_wildMonsterBar.y - 22,
                     "onComplete":function():void
                     {
                        // Guard: if the bar (or its parent) was already removed, touching
                        // _wildMonsterBar.parent throws #1009 every frame from TweenLite's
                        // updateAll, freezing the game in a refresh loop (WMI event bug).
                        if(_wildMonsterBar != null && _wildMonsterBar.parent != null)
                        {
                           _wildMonsterBar.parent.removeChild(_wildMonsterBar);
                        }
                        _wildMonsterBar = null;
                        ResizeHandler();
                     }
                  });
               }
               else
               {
                  try
                  {
                     _wildMonsterBar.parent.removeChild(_wildMonsterBar);
                  }
                  catch(e:*)
                  {
                  }
                  _wildMonsterBar.y -= 20;
                  _wildMonsterBar = null;
               }
            }
         }
         if(GLOBAL._render)
         {
            ResizeHandler();
         }
      }
      
      public static function Disable() : void
      {
      }
      
      public static function Enable() : void
      {
      }
      
      public static function Update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!GLOBAL._catchup)
         {
            if(_top)
            {
               _top.Update();
               if(TUTORIAL._stage < TUTORIAL.k_STAGE_DAMAGE_PROTECT)
               {
                  if(_top.mcProtected && _top.mcProtected.visible)
                  {
                     _top.mcProtected.visible = false;
                  }
                  if(_top.mcReinforcements && _top.mcReinforcements.visible)
                  {
                     _top.mcReinforcements.visible = false;
                  }
                  if(Boolean(_top.mcSpecialEvent) && _top.mcSpecialEvent.visible)
                  {
                     _top.mcSpecialEvent.visible = false;
                  }
                  if(_top.mcSave && _top.mcSave.visible)
                  {
                     _top.mcSave.visible = false;
                  }
                  if(_top.mcZoom && _top.mcZoom.visible)
                  {
                     _top.mcZoom.visible = false;
                  }
                  if(_top.mcFullscreen && _top.mcFullscreen.visible)
                  {
                     _top.mcFullscreen.visible = ABTest.isInTestGroup("fst",128);
                  }
                  if(_top.mcBuffHolder && _top.mcBuffHolder.visible)
                  {
                     _top.mcBuffHolder.visible = false;
                  }
               }
               else
               {
                  if(GLOBAL._iosViewport)
                  {
                     // iOS: the embedded protection/reinforcement badge symbols are null (never
                     // instantiated), so draw self-contained pills straight from the timers. NOTE: do
                     // NOT push these into _timers — that fed TimersVisible()/UI_WORKERS.Resize() and
                     // the _timers stacking loop, which broke the worker column (invisible + unclickable).
                     // SyncIOSBadge positions the badge itself, clear of the worker column.
                     var _iosBuild:Boolean = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD;
                     GLOBAL.SyncIOSBadge(_top,"iosBadgeProt","shield",_iosBuild ? (BASE._isProtected - GLOBAL.Timestamp()) : 0);
                     GLOBAL.SyncIOSBadge(_top,"iosBadgeReinf","creep",_iosBuild ? (BASE._isReinforcements - GLOBAL.Timestamp()) : 0);
                  }
                  if(_top.mcProtected)
                  {
                     if(BASE._isProtected - GLOBAL.Timestamp() > 0 && (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD))
                     {
                        if(!_top.mcProtected.visible)
                        {
                           _top.mcProtected.visible = true;
                        }
                        if(_top.mcProtected.tCountdown)
                        {
                           if(BASE._isProtected - GLOBAL.Timestamp() > 86400)
                           {
                              _top.mcProtected.tCountdown.htmlText = GLOBAL.ToTime(BASE._isProtected - GLOBAL.Timestamp(),true,false);
                           }
                           else
                           {
                              _top.mcProtected.tCountdown.htmlText = GLOBAL.ToTime(BASE._isProtected - GLOBAL.Timestamp(),true);
                           }
                        }
                     }
                     else if(_top.mcProtected.visible)
                     {
                        _top.mcProtected.visible = false;
                     }
                  }
                  if(_top.mcReinforcements)
                  {
                     if(BASE._isReinforcements - GLOBAL.Timestamp() > 0 && (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD))
                     {
                        if(!_top.mcReinforcements.visible)
                        {
                           _top.mcReinforcements.visible = true;
                        }
                        if(_top.mcReinforcements.tCountdown)
                        {
                           if(BASE._isReinforcements - GLOBAL.Timestamp() > 86400)
                           {
                              _top.mcReinforcements.tCountdown.htmlText = GLOBAL.ToTime(BASE._isReinforcements - GLOBAL.Timestamp(),true,false);
                           }
                           else
                           {
                              _top.mcReinforcements.tCountdown.htmlText = GLOBAL.ToTime(BASE._isReinforcements - GLOBAL.Timestamp(),true);
                           }
                        }
                     }
                     else if(_top.mcReinforcements.visible)
                     {
                        _top.mcReinforcements.visible = false;
                     }
                  }
                  var activeEvent:* = SPECIALEVENT.getActiveSpecialEvent();
                  var isBuildMode:Boolean = GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD;
                  var isMainYard:Boolean = !BASE.isOutpost && !BASE.isInfernoMainYardOrOutpost;
                  var isAllowedPlatform:Boolean = !GLOBAL._flags.viximo && !GLOBAL._flags.kongregate;
                  var isWMI1Active:Boolean = activeEvent == SPECIALEVENT_WM1 && (SPECIALEVENT_WM1.invasionpop == 4 || SPECIALEVENT_WM1.invasionpop == 5);
                  var isWMI2Active:Boolean = activeEvent == SPECIALEVENT && SPECIALEVENT.invasionpop == 4;
                  var isEventActive:Boolean = isWMI1Active || isWMI2Active;
                  
                  if(!activeEvent || (activeEvent == SPECIALEVENT && SPECIALEVENT.GetTimeUntilEnd() < 0) || 
                     (activeEvent == SPECIALEVENT_WM1 && (SPECIALEVENT_WM1.GetTimeUntilEnd() < 0 || SPECIALEVENT_WM1.wave > SPECIALEVENT_WM1.numWaves || SPECIALEVENT_WM1.invasionpop == 4 && SPECIALEVENT_WM1.wave > SPECIALEVENT_WM1.BONUSWAVE2)))
                  {
                     if(Boolean(_top.mcSpecialEvent) && _top.mcSpecialEvent.visible)
                     {
                        _top.mcSpecialEvent.visible = false;
                     }
                     SPECIALEVENT.updateNextWaveUI(); // This will hide all nextwave UIs
                     if(activeEvent == SPECIALEVENT_WM1 && SPECIALEVENT_WM1.GetTimeUntilEnd() < 0 && SPECIALEVENT_WM1.GetTimeUntilEnd() > -86400 && GLOBAL.StatGet("wmi_end") == 0)
                     {
                        SPECIALEVENT_WM1.ShowEventEndPopup();
                     }
                  }
                  else if(activeEvent && isBuildMode && isAllowedPlatform && isEventActive)
                  {
                     if(_top.mcSpecialEvent && !_top.mcSpecialEvent.visible)
                     {
                        _top.mcSpecialEvent.visible = true;
                     }
                     SPECIALEVENT.updateNextWaveUI(); // This will show the appropriate nextwave UI
                     if(activeEvent == SPECIALEVENT_WM1)
                     {
                        _loc3_ = SPECIALEVENT_WM1.GetTimeUntilExtension();
                        if(_loc3_ < 0 || SPECIALEVENT_WM1.invasionpop == 5)
                        {
                           _loc3_ = SPECIALEVENT_WM1.GetTimeUntilEnd();
                           if(_loc3_ > 0)
                           {
                              if(SPECIALEVENT_WM1.invasionpop == 4)
                              {
                                 if(Boolean(_top.mcSpecialEvent) && _top.mcSpecialEvent.visible)
                                 {
                                    _top.mcSpecialEvent.visible = false;
                                 }
                                 SPECIALEVENT.updateNextWaveUI(); // This will hide nextwave UIs
                              }
                           }
                        }
                        if(_top.mcSpecialEvent && _top.mcSpecialEvent.tCountdown)
                        {
                           if(_loc3_ > 86400)
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = GLOBAL.ToTime(_loc3_,true,false);
                           }
                           else
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = GLOBAL.ToTime(_loc3_,true);
                           }
                        }
                     }
                     else if(activeEvent == SPECIALEVENT)
                     {
                        _loc3_ = SPECIALEVENT.GetTimeUntilEnd();
                        if(_top.mcSpecialEvent && _top.mcSpecialEvent.tCountdown)
                        {
                           if(_loc3_ > 86400)
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = GLOBAL.ToTime(_loc3_,true,false);
                           }
                           else
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = GLOBAL.ToTime(_loc3_,true);
                           }
                        }
                     }
                  }
                  else if(isBuildMode && isMainYard && isAllowedPlatform)
                  {
                     // This section handles pre-event timing for both WM1 and WM2
                     if(activeEvent == SPECIALEVENT_WM1)
                     {
                        if(SPECIALEVENT_WM1.invasionpop != 1)
                        {
                           if(_top.mcSpecialEvent && !_top.mcSpecialEvent.visible)
                           {
                              _top.mcSpecialEvent.visible = true;
                           }
                        }
                        else
                        {
                           if(_top.mcSpecialEvent && _top.mcSpecialEvent.visible)
                           {
                              _top.mcSpecialEvent.visible = false;
                           }
                        }
                        SPECIALEVENT.updateNextWaveUI();
                        _loc4_ = SPECIALEVENT_WM1.GetTimeUntilStart();
                        _loc5_ = Math.ceil(_loc4_ / 86400);
                        if(_top.mcSpecialEvent && _top.mcSpecialEvent.tCountdown)
                        {
                           if(_loc5_ > 1)
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = _loc5_ + " " + KEYS.Get("global_days");
                           }
                           else
                           {
                              _loc6_ = Math.ceil(_loc4_ / 3600);
                              if(_loc6_ > 1)
                              {
                                 _top.mcSpecialEvent.tCountdown.htmlText = _loc6_ + " " + KEYS.Get("global_hours");
                              }
                              else
                              {
                                 _top.mcSpecialEvent.tCountdown.htmlText = "&lt; 1 " + KEYS.Get("global_hour");
                              }
                           }
                        }
                     }
                     else if(activeEvent == SPECIALEVENT)
                     {
                        if(SPECIALEVENT.invasionpop >= 0 && SPECIALEVENT.invasionpop <= 3)
                        {
                           if(_top.mcSpecialEvent && !_top.mcSpecialEvent.visible)
                           {
                              _top.mcSpecialEvent.visible = true;
                           }
                        }
                        else
                        {
                           if(_top.mcSpecialEvent && _top.mcSpecialEvent.visible)
                           {
                              _top.mcSpecialEvent.visible = false;
                           }
                        }
                        SPECIALEVENT.updateNextWaveUI();
                        _loc4_ = SPECIALEVENT.GetTimeUntilStart();
                        _loc5_ = Math.ceil(_loc4_ / 86400);
                        if(_top.mcSpecialEvent && _top.mcSpecialEvent.tCountdown)
                        {
                           if(_loc5_ > 1)
                           {
                              _top.mcSpecialEvent.tCountdown.htmlText = _loc5_ + " " + KEYS.Get("global_days");
                           }
                           else
                           {
                              _loc6_ = Math.ceil(_loc4_ / 3600);
                              if(_loc6_ > 1)
                              {
                                 _top.mcSpecialEvent.tCountdown.htmlText = _loc6_ + " " + KEYS.Get("global_hours");
                              }
                              else
                              {
                                 _top.mcSpecialEvent.tCountdown.htmlText = "&lt; 1 " + KEYS.Get("global_hour");
                              }
                           }
                        }
                     }
                  }
                  else
                  {
                     if(Boolean(_top.mcSpecialEvent) && _top.mcSpecialEvent.visible)
                     {
                        _top.mcSpecialEvent.visible = false;
                     }
                     SPECIALEVENT.updateNextWaveUI(); // This will hide all nextwave UIs
                  }
                  if(_top.mcSave && !_top.mcSave.visible)
                  {
                     _top.mcSave.visible = true;
                  }
                  if(_top.mcZoom && !_top.mcZoom.visible)
                  {
                     _top.mcZoom.visible = true;
                  }
                  if(_top.mcFullscreen && !_top.mcFullscreen.visible)
                  {
                     _top.mcFullscreen.visible = true;
                  }
                  if(_top.mcBuffHolder && _top.mcBuffHolder.visible)
                  {
                     _top.mcBuffHolder.visible = true;
                  }
                  if(!Chat._chatInited || !Chat._bymChat.IsConnected)
                  {
                     Chat.initChat();
                  }
                  if(Chat._bymChat && Chat._chatInited && Chat._bymChat.IsConnected)
                  {
                     Chat._bymChat.toggleVisibleB();
                  }
               }
               if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD && GLOBAL.mode != GLOBAL.e_BASE_MODE.IBUILD || !GLOBAL._flags.saveicon)
               {
                  if(_top.mcSave)
                  {
                     _top.mcSave.visible = false;
                  }
               }
               _loc1_ = 35;
               for each(_loc2_ in _timers)
               {
                  if(_loc2_ && _loc2_.visible)
                  {
                     _loc2_.y = _loc1_;
                     _loc1_ += 30;
                  }
               }
               updateZoom();
            }
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD || GLOBAL.mode == GLOBAL.e_BASE_MODE.IBUILD)
            {
               UI_BOTTOM.Update();
               UI_BOTTOM.Resize();
               if(_scareAway)
               {
                  GLOBAL.RefreshScreen();
                  if(_scareAway.mcBG)
                  {
                     _scareAway.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - _scareAway.mcBG.width - 10;
                     _scareAway.y = GLOBAL._SCREENHUD.y - (_scareAway.mcBG.height + 10);
                  }
               }
            }
            else
            {
               UI_BOTTOM.Resize();
               if(_visitor)
               {
                  _visitor.Update();
               }
               if(UI_BOTTOM._missions)
               {
                  UI_BOTTOM._missions.Update();
               }
            }
            BUILDINGINFO.Update();
         }
      }
      
      public static function updateZoom() : void
      {
         var _loc1_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            _loc1_ = 6;
            if(_top.mcZoom)
            {
               _top.mcZoom.y = _loc1_;
            }
            if(_top.mcFullscreen)
            {
               _top.mcFullscreen.y = _loc1_;
            }
            if(_top.mcSound)
            {
               _top.mcSound.y = _loc1_ + 24;
            }
            if(_top.mcMusic)
            {
               _top.mcMusic.y = _loc1_ + 24;
            }
            if(_top.mcSave)
            {
               _top.mcSave.y = _loc1_ + 24 + 24;
            }
            if(UI2._top.mcFullscreen)
            {
               UI2._top.mcFullscreen.gotoAndStop(1 + 2);
            }
            if(UI2._top.mcZoom)
            {
               if(GLOBAL._ROOT.stage.displayState == StageDisplayState.NORMAL)
               {
                  UI2._top.mcZoom.gotoAndStop(1 + 3);
               }
               else
               {
                  UI2._top.mcZoom.gotoAndStop(3 + 3);
               }
               if(GLOBAL._ROOT.stage.displayState != StageDisplayState.FULL_SCREEN)
               {
                  if(GLOBAL._zoomed)
                  {
                     UI2._top.mcZoom.gotoAndStop(2 + 3);
                  }
               }
            }
         }
         else
         {
            if(_top.mcZoom)
            {
               _top.mcZoom.y = _loc1_;
            }
            if(_top.mcFullscreen)
            {
               _top.mcFullscreen.y = _loc1_;
            }
            if(_top.mcSound)
            {
               _top.mcSound.y = _loc1_;
            }
            if(_top.mcMusic)
            {
               _top.mcMusic.y = _loc1_;
            }
            if(_top.mcSave)
            {
               _top.mcSave.y = _loc1_;
            }
            if(UI2._top.mcFullscreen)
            {
               UI2._top.mcFullscreen.gotoAndStop(1);
            }
            if(UI2._top.mcZoom)
            {
               if(GLOBAL._ROOT.stage.displayState == StageDisplayState.NORMAL)
               {
                  UI2._top.mcZoom.gotoAndStop(1);
               }
               else
               {
                  UI2._top.mcZoom.gotoAndStop(3);
               }
               if(GLOBAL._ROOT.stage.displayState != StageDisplayState.FULL_SCREEN)
               {
                  if(GLOBAL._zoomed)
                  {
                     UI2._top.mcZoom.gotoAndStop(2);
                  }
               }
            }
         }
      }
      
      public static function ResizeHandler(param1:Event = null) : void
      {
         var _loc4_:Rectangle = null;
         var _loc2_:int = int(GLOBAL.GetGameWidth());
         var _loc3_:int = GLOBAL.GetGameHeight();
         var _loc5_:int = _wildMonsterBar != null ? 40 : 0;
         _loc4_ = new Rectangle(0 - (_loc2_ - GLOBAL._SCREENINIT.width) / 2,0 - (_loc3_ - (GLOBAL._SCREENINIT.height + _loc5_)) / 2,_loc2_,_loc3_);
         if(_wildMonsterBar)
         {
            if(_wildMonsterBar.back)
            {
               _wildMonsterBar.back.width = _loc4_.width;
            }
            _wildMonsterBar.x = _loc4_.x;
            _wildMonsterBar.y = _loc4_.y - 20;
            if(_wildMonsterBar.info)
            {
               _wildMonsterBar.info.x = _loc4_.width - 79;
            }
            if(_wildMonsterBar.eta_txt)
            {
               _wildMonsterBar.eta_txt.x = _loc4_.width - 190;
            }
         }
         if(_top)
         {
            // Inset the top bar + in-attack fling column off the Dynamic Island / notch.
            // Shift the left edge in and shrink the width so right-aligned buttons stay put.
            var _insL:Number = GLOBAL.GetSafeAreaInsetLeft();
            var _insR:Number = GLOBAL.GetSafeAreaInsetRight();
            // When the WMI "wild monster / next wave" bar is up it only clears the top bar
            // by 20px, so on iOS it overlaps the shiny/resources. Push the top bar down to
            // sit fully below the WMI bar while it's present.
            var _wmOffset:Number = (_wildMonsterBar != null && GLOBAL._iosViewport) ? 48 : 0;
            if(_insL != 0 || _insR != 0)
            {
               _top.resize(new Rectangle(_loc4_.x + _insL,_loc4_.y + _wmOffset,_loc4_.width - _insL - _insR,_loc4_.height));
            }
            else
            {
               _top.resize(new Rectangle(_loc4_.x,_loc4_.y + _wmOffset,_loc4_.width,_loc4_.height));
            }
         }
         if(_warning)
         {
            _warning.x = _loc4_.x + _loc4_.width / 2 - _warning.width / 2 + 50;
            _warning.y = _loc4_.y + 10;
         }
         if(_visitor)
         {
            _visitor.Update();
            if(_visitor.mc)
            {
               if(_visitor.mc.mcBG)
               {
                  _visitor.mc.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - _visitor.mc.mcBG.width - 10;
               }
               _visitor.mc.y = GLOBAL._SCREENHUD.y - (_visitor.mc.height + 10);
            }
         }
         if(_scareAway)
         {
            GLOBAL.RefreshScreen();
            if(_scareAway.mcBG)
            {
               _scareAway.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - _scareAway.mcBG.width - 10;
               _scareAway.y = GLOBAL._SCREENHUD.y - (_scareAway.mcBG.height + 10);
            }
         }
         if(Chat._bymChat)
         {
            Chat._bymChat.position();
         }
         if(_debugWarningTxt)
         {
            DebugWarning();
         }
         UI_BOTTOM.Resize();
         // iOS: the WMI "Siguiente oleada" bar (UI_NEXTWAVE) anchors to UI_BOTTOM._mc and
         // on the iOS viewport can land at the top over the shiny. Re-anchor it to the real
         // bottom-right of the visible screen so it never overlaps the top HUD.
         if(GLOBAL._iosViewport && UI_BOTTOM._nextwave && UI_BOTTOM._nextwave.visible && GLOBAL._SCREEN != null && GLOBAL._SCREENHUD != null)
         {
            UI_BOTTOM._nextwave.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - UI_BOTTOM._nextwave.width - 30;
            UI_BOTTOM._nextwave.y = GLOBAL._SCREENHUD.y - UI_BOTTOM._nextwave.height - 10;
         }
         UI_WORKERS.Resize();
      }
      
      public static function TimersVisible() : int
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         for each(_loc2_ in _timers)
         {
            if(_loc2_ && _loc2_.visible)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public static function DebugWarning() : void
      {
         var _loc1_:String = "DEBUG MODE";
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.font = "Verdana";
         _loc2_.bold = true;
         _loc2_.size = 72;
         _loc2_.align = TextFormatAlign.CENTER;
         _loc2_.color = 16711680;
         _loc2_.letterSpacing = -11;
         if(!_debugWarningTxt)
         {
            _debugWarningTxt = new TextField();
         }
         _debugWarningTxt.mouseEnabled = false;
         _debugWarningTxt.alpha = 0.8;
         _debugWarningTxt.width = 400;
         _debugWarningTxt.height = 100;
         _debugWarningTxt.autoSize = TextFieldAutoSize.LEFT;
         _debugWarningTxt.text = _loc1_;
         _debugWarningTxt.setTextFormat(_loc2_);
         _debugWarningTxt.x = GLOBAL._SCREEN.x + 15;
         _debugWarningTxt.y = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - _debugWarningTxt.height * 0.75;
         GLOBAL._layerUI.addChild(_debugWarningTxt);
      }
      
      public static function DebugWarningEdit(param1:String = null) : void
      {
         var _loc2_:String = "DEBUG MODE";
         if(param1)
         {
            _loc2_ = param1;
         }
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = "Verdana";
         _loc3_.bold = true;
         _loc3_.size = 36;
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.color = 16711680;
         _loc3_.letterSpacing = -2;
         if(_debugWarningTxt)
         {
            _debugWarningTxt.mouseEnabled = false;
            _debugWarningTxt.alpha = 0.8;
            _debugWarningTxt.width = 400;
            _debugWarningTxt.height = 100;
            _debugWarningTxt.autoSize = TextFieldAutoSize.LEFT;
            _debugWarningTxt.text = _loc2_;
            _debugWarningTxt.setTextFormat(_loc3_);
            _debugWarningTxt.x = GLOBAL._SCREEN.x + 15;
            _debugWarningTxt.y = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - _debugWarningTxt.height * 0.75;
         }
      }
   }
}
