package com.monsters.missions
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom_advanced.PopupInfoMonster;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MISSIONS_INFO extends MISSIONS_INFO_CLIP
   {
       
      
      private var _text:String;
      
      private var _textCur:int = 0;
      
      private var _monsterRewardMC:PopupInfoMonster;
      
      private var _specialReward:SpecialRewardInfo;
      
      private var _missionID:String;
      
      private var _missionObject:Object;
      
      private var _missionKey:String;
      
      private var _mcImage:MovieClip;
      
      public function MISSIONS_INFO(param1:String)
      {
         var description:String;
         var ImageLoaded:Function;
         var hintStr:String = null;
         var qq:int = 0;
         var n:int = 0;
         var weapon:SiegeWeapon = null;
         var c:int = 0;
         var missionID:String = param1;
         super();
         tReward.htmlText = "<b>" + KEYS.Get("popup_label_reward") + "</b>";
         this._missionObject = QUESTS._quests[missionID];
         this._missionID = missionID;
         this._missionKey = QUESTS._quests[missionID].id;
         this._mcImage = this.mcImage;
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y;
         description = "<b>" + KEYS.Get(this._missionObject.description,this._missionObject.keyvars) + "</b><br>";
         description = description.replace("#installsgenerated#",BASE._installsGenerated);
         description = description.replace("#mushroomspicked#",QUESTS._global.mushroomspicked);
         description = description.replace("#goldmushroomspicked#",QUESTS._global.goldmushroomspicked);
         description = description.replace("#monstersblended#",QUESTS._global.monstersblended);
         description = description.replace("#giftssent#",QUESTS._global.bonus_gifts);
         description = description.replace("#sentgiftsaccepted#",QUESTS._global.gift_accept);
         if(Boolean(QUESTS._completed) && QUESTS._completed[this._missionKey] == 1)
         {
            tDescription.htmlText = "<b>" + KEYS.Get("q_ui_completed") + "</b><br>" + description;
         }
         else
         {
            tDescription.htmlText = description;
         }
         if(QUESTS._completed && QUESTS._completed[this._missionObject.id] == 1 || this._missionObject.hint == "")
         {
            tHint.htmlText = "";
         }
         else
         {
            hintStr = KEYS.Get(this._missionObject.hint,this._missionObject.keyvars);
            tHint.htmlText = "<b>" + KEYS.Get("q_ui_hint") + "</b> <i>" + hintStr + "</i>";
         }
         if(this._missionObject.questimage)
         {
            ImageLoaded = function(param1:String, param2:BitmapData):void
            {
               var k:int = 0;
               var bmp:Bitmap = null;
               var key:String = param1;
               var bmd:BitmapData = param2;
               try
               {
                  k = _mcImage.numChildren;
                  while(k--)
                  {
                     _mcImage.removeChildAt(k);
                  }
                  bmp = new Bitmap(bmd);
                  _mcImage.addChild(bmp);
               }
               catch(e:Error)
               {
               }
            };
            ImageCache.GetImageWithCallBack("popups/" + this._missionObject.questimage,ImageLoaded);
         }
         if(this._missionObject.monster_reward != undefined)
         {
            qq = 0;
            while(qq < 5)
            {
               if(GLOBAL.mode == GLOBAL._loadmode)
               {
                  this["R" + (qq + 1)].gotoAndStop(c + 1);
               }
               else
               {
                  this["R" + (qq + 1)].gotoAndStop(c + 7);
               }
               this["R" + (qq + 1)].tTitle.htmlText = KEYS.Get(GLOBAL._resourceNames[c]);
               this["R" + (qq + 1)].tValue.htmlText = "<b>" + GLOBAL.FormatNumber(this._missionObject.reward[c]) + "</b>";
               this["R" + (qq + 1)].visible = false;
               qq++;
            }
            this._monsterRewardMC = new PopupInfoMonster();
            this._monsterRewardMC.Setup(R1.x,R1.y,this._missionObject.reward_creatureid,this._missionObject.monster_reward);
            this.addChild(this._monsterRewardMC);
         }
         else if(this._missionObject.siegeweapon_reward)
         {
            n = 1;
            while(n <= 5)
            {
               this["R" + n].visible = false;
               n++;
            }
            weapon = SiegeWeapons.getWeapon(this._missionObject.siegeweapon_reward);
            this._specialReward = new SpecialRewardInfo();
            this._specialReward.x = R1.x;
            this._specialReward.y = R1.y;
            this._specialReward.Setup(weapon.name,this._missionObject.siegeweapon_rewardcount,weapon.rewardImage);
            addChild(this._specialReward);
         }
         else
         {
            c = 0;
            while(c < 5)
            {
               if(GLOBAL.mode == GLOBAL._loadmode)
               {
                  this["R" + (c + 1)].gotoAndStop(c + 1);
               }
               else
               {
                  this["R" + (c + 1)].gotoAndStop(c + 7);
               }
               this["R" + (c + 1)].tTitle.htmlText = KEYS.Get(GLOBAL._resourceNames[c]);
               this["R" + (c + 1)].tValue.htmlText = "<b>" + GLOBAL.FormatNumber(this._missionObject.reward[c]) + "</b>";
               this["R" + (c + 1)].visible = true;
               c++;
            }
         }
         bCollect.SetupKey("btn_collect");
         if(BASE._pendingPurchase.length == 0)
         {
            bCollect.addEventListener(MouseEvent.CLICK,this.Collect(this._missionKey));
            if(!QUESTS._completed || QUESTS._completed[this._missionKey] != 1)
            {
               (bCollect as Button).Enabled = false;
               mcArrow.visible = false;
            }
            else
            {
               (bCollect as Button).Highlight = true;
               mcArrow.visible = true;
            }
         }
         else
         {
            (bCollect as Button).Enabled = false;
         }
         if(Boolean(QUESTS._completed) && QUESTS._completed[this._missionObject.id] == 1)
         {
            this.gotoAndStop(2);
         }
         else
         {
            this.gotoAndStop(1);
         }
      }
      
      public function Collect(param1:String) : Function
      {
         var questID:String = param1;
         return function(param1:MouseEvent = null):void
         {
            bCollect.enabled = false;
            var _loc2_:* = QUESTS.CollectB(questID);
            if(_loc2_)
            {
               QUESTS.Hide();
               return;
            }
         };
      }
      
      public function Hide() : void
      {
         QUESTS.Hide();
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREENCENTER.x;
         this.y = GLOBAL._SCREENCENTER.y;
      }
   }
}
