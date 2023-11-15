package com.monsters.radio
{
   import com.brokenfunction.json.decodeJson;
   import com.brokenfunction.json.encodeJson;
   import flash.display.StageDisplayState;
   
   public class RADIO
   {
      
      public static var _init:Boolean = false;
      
      public static var _open:Boolean = false;
      
      public static var _twitterAccount:String;
      
      private static var _requestedName:Boolean = false;
      
      private static var _mc:RADIOSETTINGSPOPUP;
      
      public static var _proxymode:Boolean = false;
      
      public static var _settings:Object;
      
      public static var _isSaving:Boolean = false;
      
      public static const ATTACK_KEY:String = "att";
      
      public static const NEWS_KEY:String = "news";
      
      public static const ADDRESS_KEY:String = "address";
      
      public static const PROXY_KEY:String = "proxy";
       
      
      public function RADIO()
      {
         super();
      }
      
      public static function Setup(param1:Object = null) : void
      {
         if(param1)
         {
            _settings = param1;
         }
         else if(LOGIN._settings)
         {
            _settings = LOGIN._settings;
         }
         else
         {
            _settings = {};
         }
      }
      
      public static function SubmitEmail() : void
      {
      }
      
      public static function getProp(param1:String) : *
      {
         if(Boolean(_settings) && _settings.hasOwnProperty(param1))
         {
            return _settings[param1];
         }
         return null;
      }
      
      public static function setProp(param1:String, param2:*) : void
      {
         _settings[param1] = param2;
         var _loc3_:String = encodeJson(_settings);
         new URLLoaderApi().load(GLOBAL._apiURL + "player/updateemail",[["settings",_loc3_]],handleSettingsSaveSucc,handleSettingsSaveFail);
         _isSaving = true;
         _mc.bSaveToggle();
      }
      
      private static function handleSettingsSaveSucc(param1:Object) : void
      {
         _isSaving = false;
         _mc.bSaveToggle();
         if(param1.error == 0)
         {
            GLOBAL.Message(KEYS.Get("radio_saveSucc"),null,null,null);
            Hide();
         }
         else
         {
            LOGGER.Log("err","|RADIO| - handleSettingsSaveSucc - Fail" + encodeJson(param1));
            GLOBAL.Message(KEYS.Get("radio_saveFail"),null,null,null);
         }
      }
      
      private static function handleSettingsSaveFail(param1:Object) : void
      {
         _isSaving = false;
         GLOBAL.Message(KEYS.Get("radio_saveFail"),null,null,null);
      }
      
      public static function TwitterCallback(param1:String) : void
      {
         var _loc2_:Object = decodeJson(param1);
         if(_loc2_.error)
         {
            if(_loc2_.error != "noname")
            {
               LOGGER.Log("err","radio: " + _loc2_.error);
               GLOBAL.Message(KEYS.Get("msg_err_radio") + _loc2_.error + "<br><br>" + KEYS.Get("msg_tryagain"));
            }
         }
         else if(_loc2_.name)
         {
            _twitterAccount = _loc2_.name;
         }
      }
      
      public static function TwitterSetName(param1:String) : void
      {
         GLOBAL.CallJS("twitterInterface.setName",["" + param1,"twitteraccount"],false);
         _twitterAccount = param1;
      }
      
      public static function TwitterRemoveName() : void
      {
         GLOBAL.CallJS("twitterInterface.deleteName",["twitteraccount"],false);
      }
      
      public static function RemoveName() : void
      {
         var handleRemoveSucc:Function = null;
         var handleRemoveFail:Function = null;
         var removeEmail:Function = function(param1:String, param2:*):void
         {
            _settings[param1] = param2;
            var _loc3_:String = encodeJson(_settings);
            new URLLoaderApi().load(GLOBAL._apiURL + "player/updateemail",[["settings",_loc3_]],handleRemoveSucc,handleRemoveFail);
            _isSaving = true;
         };
         handleRemoveSucc = function(param1:Object):void
         {
            _isSaving = false;
            if(param1.error == 0)
            {
               GLOBAL.Message(KEYS.Get("radio_recycleConfirm"),null,null,null);
               Hide();
            }
            else
            {
               LOGGER.Log("err","|RADIO| - handleSettingsSaveSucc - Fail" + encodeJson(param1));
               GLOBAL.Message(KEYS.Get("radio_recycleConfirm"),null,null,null);
            }
         };
         handleRemoveFail = function(param1:Object):void
         {
            _isSaving = false;
            GLOBAL.Message(KEYS.Get("radio_saveFail"),null,null,null);
         };
         var obj:Object = {};
         obj[RADIO.ATTACK_KEY] = 0;
         if(obj[RADIO.ATTACK_KEY] == 1)
         {
            QUESTS._global.email_att = 1;
         }
         obj[RADIO.NEWS_KEY] = 0;
         if(obj[RADIO.NEWS_KEY] == 1)
         {
            QUESTS._global.email_news = 1;
         }
         obj[RADIO.ADDRESS_KEY] = LOGIN._email;
         removeEmail("o1",obj);
      }
      
      public static function TwitterFollow() : void
      {
         GLOBAL.CallJS("openUrl",["http://twitter.com/#!/BackyardMonster"],true);
      }
      
      public static function TwitterBrag() : void
      {
         GLOBAL.CallJS("sendFeed",["build-radio",KEYS.Get("radiobuilt_streamtitle"),KEYS.Get("radiobuilt_streambody"),"build-radio.v2.png"]);
      }
      
      public static function Export() : Object
      {
         return _settings;
      }
      
      public static function Show() : void
      {
         if(!_open)
         {
            if(GLOBAL._ROOT.stage.displayState == StageDisplayState.FULL_SCREEN)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcZoom.gotoAndStop(1 + 3);
               }
               else
               {
                  UI2._top.mcZoom.gotoAndStop(1);
               }
               GLOBAL._ROOT.stage.displayState = StageDisplayState.NORMAL;
               GLOBAL._zoomed = false;
               MAP._GROUND.scaleX = MAP._GROUND.scaleY = 1;
               MAP.Focus(0,0);
            }
            GLOBAL.BlockerAdd();
            _mc = new RADIOSETTINGSPOPUP();
            _mc.Center();
            _mc.ScaleUp();
            GLOBAL._layerWindows.addChild(_mc);
            _open = true;
         }
      }
      
      public static function Hide() : void
      {
         if(_open)
         {
            GLOBAL.BlockerRemove();
            if(Boolean(_mc) && Boolean(_mc.parent))
            {
               _mc.parent.removeChild(_mc);
            }
            _open = false;
         }
      }
   }
}
