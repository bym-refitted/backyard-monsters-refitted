package
{
   import com.cc.utils.SecNum;
   import com.monsters.ai.WMBASE;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.utils.getTimer;
   
   public class INFERNOAPI extends EventDispatcher
   {
      
      public static var _baseID:int;
      
      public static var _wmID:int;
      
      public static var _saving:Boolean;
      
      public static var _loading:Boolean;
      
      public static var _initialized:Boolean = false;
      
      private static var _loadedSomething:Boolean = false;
      
      private static var _loadType:String;
      
      private static var _prevMode:String;
      
      public static var _infernoLoadData:Object = {};
      
      public static var _descentLoadData:Object = {};
      
      public static var _wmBasesDescent:Array;
      
      public static var _wmBasesInferno:Array;
      
      public static var _wmBases:Array;
      
      public static var _descentLootData:Object;
      
      private static var _infernoapi:INFERNOAPI;
      
      private static var eventDispatcher:EventDispatcher;
      
      public static const EVENT_DESCENTLOADED:String = "descentDataProcessed";
       
      
      public function INFERNOAPI(param1:InternalClass)
      {
         super();
         _infernoapi = this;
      }
      
      public static function getInstance() : INFERNOAPI
      {
         if(_infernoapi == null)
         {
            _infernoapi = new INFERNOAPI(new InternalClass());
         }
         return _infernoapi;
      }
      
      public static function Cleanup() : void
      {
         _infernoLoadData = {};
         _descentLoadData = {};
      }
      
      public static function LoadInfernoData(param1:String = null, param2:int = 0, param3:int = 0, param4:String = "idescent", param5:Boolean = false) : void
      {
         var tmpMode:String;
         var loadVars:Array;
         var handleLoadSuccessful:Function = null;
         var handleLoadError:Function = null;
         var url:String = param1;
         var userid:int = param2;
         var baseid:int = param3;
         var mode:String = param4;
         var createinfernobase:Boolean = param5;
         handleLoadSuccessful = function(param1:Object):void
         {
            if(param1.error == 0)
            {
               if(!_loadedSomething && ExternalInterface.available)
               {
                  ExternalInterface.call("cc.recordStats","baseend");
                  _loadedSomething = true;
               }
               if(_loadType == "idescent")
               {
                  _descentLoadData = param1;
                  if(param1.wmstatus)
                  {
                     _wmBasesDescent = param1.wmstatus;
                     ProcessWmBases(_wmBasesDescent);
                     DescentDataReady();
                  }
                  if(param1.resources)
                  {
                     _descentLootData = param1.resources;
                     if(_descentLootData.r1)
                     {
                        MAPROOM_DESCENT._loot.r1 = new SecNum(int(_descentLootData.r1));
                     }
                     else
                     {
                        MAPROOM_DESCENT._loot.r1 = new SecNum(int(0));
                     }
                     if(_descentLootData.r2)
                     {
                        MAPROOM_DESCENT._loot.r2 = new SecNum(int(_descentLootData.r2));
                     }
                     else
                     {
                        MAPROOM_DESCENT._loot.r2 = new SecNum(int(0));
                     }
                     if(_descentLootData.r3)
                     {
                        MAPROOM_DESCENT._loot.r3 = new SecNum(int(_descentLootData.r3));
                     }
                     else
                     {
                        MAPROOM_DESCENT._loot.r3 = new SecNum(int(0));
                     }
                     if(_descentLootData.r4)
                     {
                        MAPROOM_DESCENT._loot.r4 = new SecNum(int(_descentLootData.r4));
                     }
                     else
                     {
                        MAPROOM_DESCENT._loot.r4 = new SecNum(int(0));
                     }
                  }
                  else
                  {
                     _descentLootData = {};
                     MAPROOM_DESCENT._loot.r1 = new SecNum(int(0));
                     MAPROOM_DESCENT._loot.r2 = new SecNum(int(0));
                     MAPROOM_DESCENT._loot.r3 = new SecNum(int(0));
                     MAPROOM_DESCENT._loot.r4 = new SecNum(int(0));
                  }
               }
               else if(BASE.isInfernoMainYardOrOutpost)
               {
                  _infernoLoadData = param1;
               }
               GLOBAL.WaitHide();
            }
            _loading = false;
         };
         handleLoadError = function(param1:IOErrorEvent):void
         {
            if(GLOBAL._reloadonerror)
            {
               GLOBAL.CallJS("reloadPage");
            }
            else
            {
               LOGGER.Log("err","INFERNOAPI.Load HTTP");
               PLEASEWAIT.Hide();
               GLOBAL.ErrorMessage("INFERNO.Load HTTP");
            }
            _loading = false;
         };
         var t:int = getTimer();
         _loading = true;
         _baseID = baseid;
         PLEASEWAIT.Hide();
         Cleanup();
         PLEASEWAIT.Show(KEYS.Get("msg_loading"));
         tmpMode = GLOBAL.mode;
         _loadType = mode;
         loadVars = [["userid",userid > 0 ? userid : ""],["baseid",_baseID],["type",_loadType]];
         if(url)
         {
            new URLLoaderApi().load(url + "load",loadVars,handleLoadSuccessful,handleLoadError);
         }
         else if(BASE.isInfernoMainYardOrOutpost)
         {
            new URLLoaderApi().load(GLOBAL._infBaseURL + "load",loadVars,handleLoadSuccessful,handleLoadError);
         }
         else
         {
            new URLLoaderApi().load(GLOBAL._baseURL + "load",loadVars,handleLoadSuccessful,handleLoadError);
         }
      }
      
      public static function ProcessWmBases(param1:Array) : void
      {
         if(WMBASE._bases)
         {
            _wmBases = WMBASE._bases;
         }
         WMBASE.DescentData(param1);
      }
      
      public static function RevertWmBases() : Boolean
      {
         if(_wmBases)
         {
            WMBASE._bases = _wmBases;
            return true;
         }
         return false;
      }
      
      public static function DescentDataReady() : void
      {
         dispatchEvent(new Event(EVENT_DESCENTLOADED));
      }
      
      public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         getInstance().addEventListener(param1,param2,param3,param4,param5);
      }
      
      public static function dispatchEvent(param1:Event) : Boolean
      {
         return getInstance().dispatchEvent(param1);
      }
      
      public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         getInstance().removeEventListener(param1,param2,param3);
      }
      
      public static function hasEventListener(param1:String) : Boolean
      {
         return getInstance().hasEventListener(param1);
      }
      
      public static function willTrigger(param1:String) : Boolean
      {
         return getInstance().willTrigger(param1);
      }
   }
}

class InternalClass
{
    
   
   public function InternalClass()
   {
      super();
   }
}
