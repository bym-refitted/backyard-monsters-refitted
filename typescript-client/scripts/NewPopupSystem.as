package
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_advanced.PopupMigrate;
   import com.monsters.maproom_manager.MapRoomManager;
   
   public class NewPopupSystem
   {
      
      public static const instance:NewPopupSystem = new NewPopupSystem();
       
      
      private var _popupStates:Object;
      
      private var _actualIds:Object;
      
      private var _timeOfLastDialog:int = 0;
      
      private var _dialogShownInSession:Boolean = false;
      
      private var _dialogShowing:Boolean;
      
      private var _requirements:Vector.<RequireData>;
      
      public function NewPopupSystem()
      {
         super();
      }
      
      public static function get dialogShowing() : Boolean
      {
         return instance._dialogShowing;
      }
      
      public function createPopupData() : Array
      {
         return [{
            "id":"mr2_reminder2",
            "displayFn":function(param1:String):void
            {
               var id:String = param1;
               PopupMigrate.Show(function():void
               {
                  NewPopupSystem.instance.ConfirmDialog(id);
               });
            },
            "requirements":[{
               "yardType":EnumYardType.MAIN_YARD,
               "minTownHallLevel":6,
               "maxMapRoomLevel":1,
               "minTimeBetweenDisplays":5 * 24 * 60 * 60,
               "requirementsFn":function(param1:String):Boolean
               {
                  return Boolean(GLOBAL._bMap);
               }
            }]
         }];
      }
      
      public function ConfirmDialog(param1:String) : void
      {
         if(!this._popupStates[param1])
         {
            this._popupStates[param1] = {"count":0};
         }
         ++this._popupStates[param1].count;
         this._dialogShowing = false;
         POPUPS.Next();
      }
      
      public function IgnoreDialog(param1:String) : void
      {
         this._dialogShowing = false;
         POPUPS.Next();
      }
      
      public function Setup(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:RequireData = null;
         var _loc7_:String = null;
         this._popupStates = !!param1 ? param1.popupStates || {} : {};
         this._timeOfLastDialog = !!param1 ? int(param1.lastDialog) || 0 : 0;
         this._requirements = new Vector.<RequireData>();
         this._dialogShowing = false;
         this._actualIds = {};
         var _loc2_:Array = this.createPopupData();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            this._actualIds[_loc4_.id] = true;
            if(!(Boolean(this._popupStates[_loc4_.id]) && this._popupStates[_loc4_.id].count > 0))
            {
               for each(_loc5_ in _loc4_.requirements)
               {
                  (_loc6_ = new RequireData()).id = _loc4_.id;
                  _loc6_.displayFn = _loc4_.displayFn;
                  _loc6_.requireFn = this.coreRequirements;
                  if(_loc4_.startupOnly != null)
                  {
                     _loc6_.startupOnly = _loc4_.startupOnly;
                     delete _loc4_.startupOnly;
                  }
                  for(_loc7_ in _loc5_)
                  {
                     _loc6_.requireFn = this.getRequirementsFn(_loc7_,_loc5_[_loc7_],_loc6_.requireFn);
                  }
                  this._requirements.push(_loc6_);
               }
            }
            _loc3_++;
         }
         this._requirements.fixed = true;
      }
      
      public function getRequirementsFn(param1:String, param2:Object, param3:Function) : Function
      {
         var requireId:String = param1;
         var value:Object = param2;
         var nextFn:Function = param3;
         switch(requireId)
         {
            case "minTimeBetweenDialogs":
               return function(param1:String):Boolean
               {
                  return value as Number <= GLOBAL.Timestamp() - _timeOfLastDialog && Boolean(nextFn(param1));
               };
            case "minSessionTimeBetweenDialogs":
               return function(param1:String):Boolean
               {
                  return value as Number <= GLOBAL.Timestamp() - _timeOfLastDialog && _dialogShownInSession && Boolean(nextFn(param1));
               };
            case "yardType":
               return function(param1:String):Boolean
               {
                  return BASE.yardType == value && Boolean(nextFn(param1));
               };
            case "maxMapRoomLevel":
               return function(param1:String):Boolean
               {
                  return (value as Number < 2 ? !MapRoomManager.instance.isInMapRoom2 : true) && Boolean(nextFn(param1));
               };
            case "minTownHallLevel":
               return function(param1:String):Boolean
               {
                  return Boolean(GLOBAL.townHall) && GLOBAL.townHall._lvl.Get() >= (value as Number) && Boolean(nextFn(param1));
               };
            case "minTimeBetweenDisplays":
               return function(param1:String):Boolean
               {
                  return Boolean(_popupStates[param1]) && value as Number > GLOBAL.Timestamp() - _popupStates[param1].shown && Boolean(nextFn(param1));
               };
            case "never":
               return function(param1:String):Boolean
               {
                  return false;
               };
            case "requirementsFn":
               return function(param1:String):Boolean
               {
                  return (value as Function)(param1) && Boolean(nextFn(param1));
               };
            default:
               throw new Error("Requirement id \"" + requireId + "\" not found");
         }
      }
      
      private function coreRequirements(param1:String) : Boolean
      {
         if(POPUPS._open || GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(Boolean(this._popupStates[param1]) && this._popupStates[param1].count > 0)
         {
            return false;
         }
         return true;
      }
      
      public function Export() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {};
         for(_loc2_ in this._actualIds)
         {
            if(this._popupStates[_loc2_])
            {
               _loc1_[_loc2_] = {
                  "count":this._popupStates[_loc2_].count || 0,
                  "shown":this._popupStates[_loc2_].shown || null
               };
            }
         }
         return {
            "popupStates":_loc1_,
            "lastDialog":this._timeOfLastDialog
         };
      }
      
      public function CheckAll(param1:Boolean = false) : Boolean
      {
         var _loc4_:RequireData = null;
         var _loc2_:Vector.<RequireData> = new Vector.<RequireData>();
         var _loc3_:int = 0;
         while(_loc3_ < this._requirements.length)
         {
            if((_loc4_ = this._requirements[_loc3_]).requireFn(_loc3_) && (!param1 || !_loc4_.startupOnly))
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            this._dialogShownInSession = true;
            this._dialogShowing = false;
            if(!this._popupStates[_loc2_[0].id])
            {
               this._popupStates[_loc2_[0].id] = {};
            }
            this._popupStates[_loc2_[0].id].shown = GLOBAL.Timestamp();
            _loc2_[0].displayFn(_loc2_[0].id);
            return true;
         }
         return false;
      }
   }
}

final class RequireData
{
    
   
   public var id:String;
   
   public var displayFn:Function;
   
   public var requireFn:Function;
   
   public var startupOnly:Boolean = false;
   
   public function RequireData()
   {
      super();
   }
}
