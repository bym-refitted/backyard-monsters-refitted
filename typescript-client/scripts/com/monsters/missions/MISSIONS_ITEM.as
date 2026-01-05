package com.monsters.missions
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class MISSIONS_ITEM extends UI_MISSIONS_ITEM_CLIP
   {
       
      
      public var _Width:Number = 340;
      
      public var _Height:Number = 32;
      
      public var _missionObject:Object;
      
      public var _missionID:String;
      
      public var _missionKey:String;
      
      public var _isComplete:Boolean = false;
      
      public var _isDisable:Boolean = false;
      
      private var _skinTag:int;
      
      public function MISSIONS_ITEM(param1:String)
      {
         var ImageLoaded:Function;
         var nametxt:String = null;
         var description:String = null;
         var shortenStr:String = null;
         var missionID:String = param1;
         super();
         this._missionObject = QUESTS._quests[missionID];
         this._missionID = missionID;
         this._missionKey = this._missionObject.id;
         nametxt = KEYS.Get(this._missionObject.name,this._missionObject.keyvars);
         description = KEYS.Get(this._missionObject.description,this._missionObject.keyvars);
         description = description.replace("#installsgenerated#",BASE._installsGenerated);
         description = description.replace("#mushroomspicked#",QUESTS._global.mushroomspicked);
         description = description.replace("#goldmushroomspicked#",QUESTS._global.goldmushroomspicked);
         description = description.replace("#monstersblended#",QUESTS._global.monstersblended);
         description = description.replace("#giftssent#",QUESTS._global.bonus_gifts);
         description = description.replace("#sentgiftsaccepted#",QUESTS._global.gift_accept);
         tName.htmlText = "<b>" + nametxt + "</b>";
         if(description.length > 50)
         {
            shortenStr = description;
            description = shortenStr.substr(0,46) + "...";
         }
         tDesc.htmlText = description;
         mouseChildren = false;
         if(this._missionObject.questicon)
         {
            ImageLoaded = function(param1:String, param2:BitmapData):void
            {
               try
               {
                  mcImage.addChild(new Bitmap(param2));
               }
               catch(e:Error)
               {
               }
            };
            ImageCache.GetImageWithCallBack("missionicon/" + this._missionObject.questicon,ImageLoaded);
         }
         if(Boolean(QUESTS._completed) && QUESTS._completed[this._missionKey] == 1)
         {
            this._isComplete = true;
         }
         else
         {
            this._isComplete = false;
         }
         this.Init();
      }
      
      public function Init(param1:Boolean = false) : void
      {
         this._isDisable = param1;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !param1)
         {
            this.buttonMode = true;
            this.useHandCursor = true;
            if(!hasEventListener(MouseEvent.CLICK))
            {
               addEventListener(MouseEvent.CLICK,this.ShowMission(this._missionID));
               addEventListener(MouseEvent.ROLL_OVER,this.MissionRollOver(this._missionID));
            }
            if(this._isComplete)
            {
               gotoAndStop(2);
            }
            else
            {
               gotoAndStop(1);
            }
         }
         else
         {
            this.buttonMode = false;
            this.useHandCursor = false;
            removeEventListener(MouseEvent.CLICK,this.ShowMission(this._missionID));
            removeEventListener(MouseEvent.ROLL_OVER,this.MissionRollOver(this._missionID));
            if(this._isComplete)
            {
               gotoAndStop(3);
            }
            else
            {
               gotoAndStop(4);
            }
         }
      }
      
      public function ShowMission(param1:String) : Function
      {
         var missionID:String = param1;
         return function(param1:MouseEvent = null):void
         {
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !_isDisable)
            {
               _loc2_ = _missionObject.id;
               if(TUTORIAL.hasFinished || QUESTS._completed && QUESTS._completed[_loc2_] == 1 && TUTORIAL._stage >= 26)
               {
                  _loc3_ = new MISSIONS_INFO(missionID);
                  POPUPS.Push(_loc3_);
                  SOUNDS.Play("click1");
                  QUESTS._open = true;
               }
            }
         };
      }
      
      public function MissionRollOver(param1:String) : Function
      {
         var missionID:String = param1;
         return function(param1:MouseEvent = null):void
         {
         };
      }
   }
}
