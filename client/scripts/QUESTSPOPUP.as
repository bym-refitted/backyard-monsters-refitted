package
{
   import com.monsters.display.ImageCache;
   import com.monsters.maproom_advanced.PopupInfoMonster;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.SiegeWeapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   
   public class QUESTSPOPUP extends QUESTSPOPUP_CLIP
   {
       
      
      public var _groupsMC:MovieClip;
      
      public var _questsMC:MovieClip;
      
      public var _infoMC:QUESTINFO;
      
      public var _monsterRewardMC:PopupInfoMonster;
      
      public var _specialReward:SpecialRewardInfo;
      
      public var _groupID:int;
      
      public var _questID:String;
      
      public function QUESTSPOPUP()
      {
         var _loc2_:Object = null;
         super();
         this._groupID = -1;
         this._questID = "";
         this.ListGroups();
         title_txt.htmlText = KEYS.Get("quests_title");
         var _loc1_:int = 0;
         while(_loc1_ < QUESTS._quests.length)
         {
            _loc2_ = QUESTS._quests[_loc1_];
            if(Boolean(QUESTS._completed) && QUESTS._completed[_loc2_.id] == 1)
            {
               this.ListQuestsB(_loc2_.group);
               this.ShowQuestB(_loc2_.id);
               break;
            }
            _loc1_++;
         }
      }
      
      public function ListGroups() : void
      {
         var _loc2_:Object = null;
         var _loc3_:QUESTGROUP = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         if(this._groupsMC)
         {
            this.removeChild(this._groupsMC);
            this._groupsMC = null;
         }
         this._groupsMC = this.addChild(new MovieClip()) as MovieClip;
         this._groupsMC.x = -337;
         this._groupsMC.y = -195;
         var _loc1_:int = 0;
         while(_loc1_ < QUESTS._questGroups.length)
         {
            _loc2_ = QUESTS._questGroups[_loc1_];
            _loc3_ = this._groupsMC.addChild(new QUESTGROUP()) as QUESTGROUP;
            _loc3_.tLabel.htmlText = KEYS.Get(_loc2_.name);
            _loc3_.name = _loc1_.toString();
            _loc3_.x = 10;
            _loc3_.y = 10 + 30 * _loc1_;
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            _loc3_.addEventListener(MouseEvent.CLICK,this.ListQuests);
            _loc3_.gotoAndStop(1);
            _loc4_ = 0;
            while(_loc4_ < QUESTS._quests.length)
            {
               _loc5_ = QUESTS._quests[_loc4_];
               if(QUESTS._completed && _loc5_.group == _loc1_ && QUESTS._completed[_loc5_.id] == 1)
               {
                  _loc3_.gotoAndStop(3);
               }
               if(this._groupID == _loc1_)
               {
                  _loc3_.gotoAndStop(2);
               }
               _loc4_++;
            }
            _loc1_++;
         }
      }
      
      public function ListQuests(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         SOUNDS.Play("click1");
         if(param1)
         {
            this._groupID = int(param1.target.name);
            _loc2_ = 0;
            while(_loc2_ < QUESTS._quests.length)
            {
               _loc3_ = QUESTS._quests[_loc2_];
               _loc4_ = true;
               if(_loc4_ && _loc3_.group == this._groupID && QUESTS._completed && QUESTS._completed[_loc3_.id] == 1)
               {
                  this.ShowQuestB(_loc3_.id);
                  break;
               }
               _loc2_++;
            }
            this.ListQuestsB(this._groupID);
         }
         else
         {
            this.ListQuestsB(this._groupID);
         }
      }
      
      public function ListQuestsB(param1:int) : void
      {
         var c:int;
         var i:int = 0;
         var q:Object = null;
         var show:Boolean = false;
         var groupID:int = param1;
         var AddItem:Function = function(param1:Object, param2:int):int
         {
            var _loc3_:QUESTITEM = null;
            if(!param1.block)
            {
               if(param1.id == "BOOKMARK" && !GLOBAL._flags.fanfriendbookmarkquests)
               {
                  return 0;
               }
               if(param1.id.substr(0,6) == "INVITE" && !GLOBAL._flags.fanfriendbookmarkquests)
               {
                  return 0;
               }
               if(param1.id == "FAN" && !GLOBAL._flags.fanfriendbookmarkquests)
               {
                  return 0;
               }
               _loc3_ = _questsMC.addChild(new QUESTITEM()) as QUESTITEM;
               _loc3_.tLabel.htmlText = KEYS.Get(param1.name,param1.keyvars);
               _loc3_.y = 10 + 30 * param2;
               _loc3_.x = 10;
               _loc3_.mouseChildren = false;
               _loc3_.buttonMode = true;
               _loc3_.addEventListener(MouseEvent.CLICK,ShowQuest(param1.id));
               _loc3_.gotoAndStop(1);
               if(Boolean(QUESTS._completed) && QUESTS._completed[param1.id] == 1)
               {
                  _loc3_.gotoAndStop(3);
               }
               else
               {
                  _loc3_.mcTick.visible = false;
               }
               if(_questID == param1.id)
               {
                  _loc3_.gotoAndStop(2);
               }
               return 1;
            }
            return 0;
         };
         this._groupID = groupID;
         this.ListGroups();
         if(this._questsMC)
         {
            this.removeChild(this._questsMC);
            this._questsMC = null;
         }
         if(this._infoMC)
         {
            this.removeChild(this._infoMC);
            this._infoMC = null;
         }
         this._questsMC = this.addChild(new MovieClip()) as MovieClip;
         this._questsMC.x = -188;
         this._questsMC.y = -195;
         c = 0;
         if(QUESTS._completed)
         {
            i = 0;
            while(i < QUESTS._quests.length)
            {
               q = QUESTS._quests[i];
               if(q.group == this._groupID && c < 13)
               {
                  if(Boolean(QUESTS._completed[q.id]) && QUESTS._completed[q.id] == 1)
                  {
                     c += AddItem(q,c);
                  }
               }
               i++;
            }
         }
         i = 0;
         while(i < QUESTS._quests.length)
         {
            q = QUESTS._quests[i];
            if(q.group == this._groupID && c < 13)
            {
               show = true;
               if(show && !QUESTS._completed[q.id])
               {
                  c += AddItem(q,c);
               }
            }
            i++;
         }
      }
      
      public function ShowQuest(param1:String) : Function
      {
         var questID:String = param1;
         return function(param1:MouseEvent):void
         {
            ShowQuestB(questID);
         };
      }
      
      public function ShowQuestB(param1:String) : void
      {
         var i:int;
         var ImageLoaded:Function;
         var q:Object = null;
         var description:String = null;
         var hintStr:String = null;
         var qq:int = 0;
         var n:int = 0;
         var weapon:SiegeWeapon = null;
         var c:int = 0;
         var questID:String = param1;
         this._questID = questID;
         if(this._infoMC)
         {
            this.removeChild(this._infoMC);
            this._infoMC = null;
         }
         this.ListQuestsB(this._groupID);
         this._infoMC = this.addChild(new QUESTINFO()) as QUESTINFO;
         this._infoMC.x = 8;
         this._infoMC.y = -195;
         this._infoMC.tReward.htmlText = "<b>" + KEYS.Get("popup_label_reward") + "</b>";
         QUESTS._displayedInstructions = true;
         i = 0;
         while(i < QUESTS._quests.length)
         {
            q = QUESTS._quests[i];
            if(q.id == questID)
            {
               description = KEYS.Get(q.description,q.keyvars);
               description = description.replace("#installsgenerated#",BASE._installsGenerated);
               description = description.replace("#mushroomspicked#",QUESTS._global.mushroomspicked);
               description = description.replace("#goldmushroomspicked#",QUESTS._global.goldmushroomspicked);
               description = description.replace("#monstersblended#",QUESTS._global.monstersblended);
               description = description.replace("#giftssent#",QUESTS._global.bonus_gifts);
               description = description.replace("#sentgiftsaccepted#",QUESTS._global.gift_accept);
               if(Boolean(QUESTS._completed) && QUESTS._completed[questID] == 1)
               {
                  this._infoMC.tDescription.htmlText = "<b>" + KEYS.Get("q_ui_completed") + "</b><br>" + description;
               }
               else
               {
                  this._infoMC.tDescription.htmlText = description;
               }
               if(QUESTS._completed && QUESTS._completed[q.id] == 1 || q.hint == "")
               {
                  this._infoMC.tHint.htmlText = "";
               }
               else
               {
                  hintStr = KEYS.Get(q.hint,q.keyvars);
                  this._infoMC.tHint.htmlText = "<b>" + KEYS.Get("q_ui_hint") + "</b> <i>" + hintStr + "</i>";
               }
               if(q.questimage)
               {
                  ImageLoaded = function(param1:String, param2:BitmapData):void
                  {
                     try
                     {
                        _infoMC.mcImage.addChild(new Bitmap(param2));
                     }
                     catch(e:Error)
                     {
                     }
                  };
                  ImageCache.GetImageWithCallBack("popups/" + q.questimage,ImageLoaded);
               }
               if(q.monster_reward != undefined)
               {
                  qq = 0;
                  while(qq < 5)
                  {
                     if(GLOBAL.mode == GLOBAL._loadmode)
                     {
                        this._infoMC["R" + (qq + 1)].gotoAndStop(qq + 1);
                     }
                     else
                     {
                        this._infoMC["R" + (qq + 1)].gotoAndStop(qq + 7);
                     }
                     this._infoMC["R" + (qq + 1)].visible = false;
                     qq++;
                  }
                  this._monsterRewardMC = new PopupInfoMonster();
                  this._monsterRewardMC.Setup(this._infoMC.R1.x,this._infoMC.R1.y,q.reward_creatureid,q.monster_reward);
                  this._infoMC.addChild(this._monsterRewardMC);
               }
               else if(q.siegeweapon_reward)
               {
                  n = 1;
                  while(n <= 5)
                  {
                     this._infoMC["R" + n].visible = false;
                     n++;
                  }
                  weapon = SiegeWeapons.getWeapon(q.siegeweapon_reward);
                  this._specialReward = new SpecialRewardInfo();
                  this._specialReward.x = this._infoMC.R1.x;
                  this._specialReward.y = this._infoMC.R1.y;
                  this._specialReward.Setup(weapon.name,q.siegeweapon_rewardcount,weapon.rewardImage);
                  this._infoMC.addChild(this._specialReward);
               }
               else
               {
                  c = 0;
                  while(c < 5)
                  {
                     if(GLOBAL.mode == GLOBAL._loadmode)
                     {
                        this._infoMC["R" + (c + 1)].gotoAndStop(c + 1);
                     }
                     else
                     {
                        this._infoMC["R" + (c + 1)].gotoAndStop(c + 7);
                     }
                     this._infoMC["R" + (c + 1)].tTitle.htmlText = KEYS.Get(GLOBAL._resourceNames[c]);
                     this._infoMC["R" + (c + 1)].tValue.htmlText = "<b>" + GLOBAL.FormatNumber(q.reward[c]) + "</b>";
                     this._infoMC["R" + (c + 1)].visible = true;
                     c++;
                  }
               }
               this._infoMC.bCollect.SetupKey("btn_collect");
               if(BASE._pendingPurchase.length == 0)
               {
                  this._infoMC.bCollect.addEventListener(MouseEvent.CLICK,this.Collect(questID));
                  if(!QUESTS._completed || QUESTS._completed[questID] != 1)
                  {
                     (this._infoMC.bCollect as Button).Enabled = false;
                     this._infoMC.mcArrow.visible = false;
                  }
                  else
                  {
                     (this._infoMC.bCollect as Button).Highlight = true;
                     this._infoMC.mcArrow.visible = true;
                  }
               }
               else
               {
                  (this._infoMC.bCollect as Button).Enabled = false;
               }
               break;
            }
            i++;
         }
      }
      
      public function Collect(param1:String) : Function
      {
         var questID:String = param1;
         return function(param1:MouseEvent = null):void
         {
            var _loc3_:* = undefined;
            _infoMC.bCollect.enabled = false;
            QUESTS.CollectB(questID);
            var _loc2_:* = 0;
            while(_loc2_ < QUESTS._quests.length)
            {
               _loc3_ = QUESTS._quests[_loc2_];
               if(Boolean(QUESTS._completed) && QUESTS._completed[_loc3_.id] == 1)
               {
                  ListQuestsB(_loc3_.group);
                  ShowQuestB(_loc3_.id);
                  return;
               }
               _loc2_++;
            }
            if(QUESTS._mc)
            {
               QUESTS.Hide();
            }
         };
      }
      
      public function Hide() : void
      {
         QUESTS.Hide();
      }
      
      public function Center() : void
      {
         POPUPSETTINGS.AlignToCenter(this);
      }
      
      public function ScaleUp() : void
      {
         POPUPSETTINGS.ScaleUp(this);
      }
   }
}
