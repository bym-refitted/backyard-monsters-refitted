package
{
   import com.monsters.display.ImageCache;
   import com.monsters.kingOfTheHill.KOTHHandler;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.replayableEvents.ReplayableEventHandler;
   import com.monsters.utils.VideoUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.media.Video;
   import flash.net.NetStream;
   import flash.utils.Timer;
   import gs.*;
   import gs.easing.*;
   
   public class CHAMPIONCAGEPOPUP extends GUARDIANCAGEPOPUP_CLIP
   {
      
      public static var _page:int = 0;
      
      public static var _kothEnabled:Boolean = false;
      
      public static var page1Assets:Array;
      
      public static var page2Assets:Array;
      
      public static var page3Assets:Array;
      
      public static var pagesArr:Array;
      
      public static var statsArr:Array;
      
      public static var buffsArr:Array;
      
      public static var kothStatsArr:Array;
      
      public static var kothArr0:Array;
      
      public static var kothArr1:Array;
      
      public static var kothArr2:Array;
      
      public static var feedIcons:Array;
      
      private static var statsStringsArr:Array;
      
      private static var buffsStringsArr:Array;
      
      public static var _maxSpeed:Number = 4;
      
      public static var _maxHealth:Number = 250000;
      
      public static var _maxDamage:Number = 9600;
      
      public static var _maxBuff:Number = 100;
      
      public static var _maxLevel:Number = 6;
      
      public static var _isFeed:Boolean = false;
      
      public static var _useBonusIndicators:Boolean = false;
      
      public static var _bCage:CHAMPIONCAGE;
       
      
      private var guard:ChampionBase;
      
      private var guardType:int;
      
      private var guardLevel:int;
      
      private var guardID:String;
      
      private var foodBonus:int;
      
      private var totalFeeds:Number;
      
      private var currFeeds:Number;
      
      private var koth:ChampionBase;
      
      private var kothType:int;
      
      private var kothLevel:int;
      
      private var kothWins:int;
      
      private var kothPowerLevel:int;
      
      private var kothID:String;
      
      private var kothBonus:int;
      
      private var kothAbilities:int;
      
      public var kothTimeCurrent:Number;
      
      public var kothTimeLeft:Number;
      
      public var kothTimeStart:Number;
      
      public var kothTimeEnd:Number;
      
      public var kothTimeLength:Number = 604800;
      
      public var kothLootCurrent:Number;
      
      public var kothLootMax:Number;
      
      public var kothLootThresholds:Array;
      
      private var _timer:Timer;
      
      private var _videoStream:NetStream;
      
      private var _currentVideoURL:String;
      
      private var _currentPreviewUrl:String;
      
      private var _kothPreviewURL:String = "monsters/G5_L6-150.png";
      
      private var _kothVideoURL:String = "assets/koth/Krallen_200x200.flv";
      
      private var _kothToolTip1:DisplayObject;
      
      private var _kothToolTip2:DisplayObject;
      
      private var _kothToolTipAbility1:DisplayObject;
      
      private var _kothToolTipAbility2:DisplayObject;
      
      private const _PREVIEW_WIDTH:int = 200;
      
      private const _PREVIEW_HEIGHT:int = 200;
      
      private var _DOES_PLAY_VIDEO:Boolean = false;
      
      private const _KOTH_AWARD_GOAL:int = 1000000000;
      
      private const _KOTH_AWARD_ABILITY1:int = 1500000000;
      
      private const _KOTH_AWARD_ABILITY2:int = 2000000000;
      
      public function CHAMPIONCAGEPOPUP()
      {
         this._timer = new Timer(1000);
         super();
         tTitle.htmlText = KEYS.Get("gcage_title");
         _bCage = GLOBAL._bCage as CHAMPIONCAGE;
         page1Assets = [mcImage,tEvoStage,damage_txt,tDamage,bDamage,health_txt,tHealth,bHealth,speed_txt,tSpeed,bSpeed,buff_txt,tBuff,bBuff,tEvoDesc,tHP,barHP,bHeal];
         page2Assets = [barDNA,barDNA_bg,barDNA_mask,mcCurrGuardian,mcNextGuardian,tNextFeed,tFeedsFrom,mcInstant,mcFeed1,mcFeed2,gFeedBG,bEvolve,bFeedTimer,tNextFeedTitle];
         page3Assets = [p3_mcImage,p3_tDescription,p3_tDescription2,p3_tKothLevel,p3_gRankBG,p3_damage_txt,p3_health_txt,p3_speed_txt,p3_buff_txt,p3_abilities_txt,p3_tDamage,p3_tHealth,p3_tSpeed,p3_tBuff,p3_bDamage,p3_bHealth,p3_bSpeed,p3_bBuff,p3_mcAbility1,p3_bTimeleft,p3_tTimeleft,p3_tLootLeft,p3_bLootLeft,p3_bHP,p3_tHP,p3_bHeal,p3_mcLootMark1,p3_mcLootMark2,p3_timeleft_txt,p3_looted_txt];
         pagesArr = [page1Assets,page2Assets,page3Assets];
         statsArr = [damage_txt,tDamage,bDamage,health_txt,tHealth,bHealth,speed_txt,tSpeed,bSpeed,buff_txt,tBuff,bBuff];
         buffsArr = [damage_txt2,tDamage2,bDamage2,health_txt2,tHealth2,bHealth2,speed_txt2,tSpeed2,bSpeed2,buff_txt2,tBuff2,bBuff2,tBuffDesc,day1,day2,day3];
         kothArr0 = [p3_mcImage,p3_tDescription,p3_gRankBG,p3_bTimeleft,p3_tTimeleft,p3_tLootLeft,p3_bLootLeft,p3_mcLootMark1,p3_mcLootMark2,p3_timeleft_txt,p3_looted_txt];
         kothArr1 = [p3_tDescription2];
         kothArr2 = [p3_tKothLevel,p3_damage_txt,p3_health_txt,p3_speed_txt,p3_buff_txt,p3_abilities_txt,p3_tDamage,p3_tHealth,p3_tSpeed,p3_tBuff,p3_bDamage,p3_bHealth,p3_bSpeed,p3_bBuff,p3_mcAbility1,p3_bHP,p3_tHP,p3_bHeal];
         feedIcons = [mcFeed1,mcFeed2];
         kothStatsArr = [p3_damage_txt,p3_health_txt,p3_speed_txt,p3_buff_txt,p3_abilities_txt,p3_tDamage,p3_tHealth,p3_tSpeed,p3_tBuff,p3_bDamage,p3_bHealth,p3_bSpeed,p3_bBuff,p3_mcAbility1];
         this.Setup(0);
         mcCurrGuardian.stop();
         mcNextGuardian.stop();
         this.kothLootThresholds = [];
         this.kothLootThresholds.push(int(KOTHHandler.instance.lootThresholds[1]));
         this.kothLootThresholds.push(int(KOTHHandler.instance.lootThresholds[0]));
         this.kothLootCurrent = 0;
         this.kothLootMax = this.kothLootThresholds[this.kothLootThresholds.length - 1];
         this.kothTimeEnd = KOTHHandler.instance.timeToReset + ReplayableEventHandler.currentTime;
         this.kothTimeStart = this.kothTimeEnd - KOTHHandler.instance.timePerRound;
         this.kothTimeLeft = this.kothTimeEnd - ReplayableEventHandler.currentTime;
      }
      
      public static function FeedClick(param1:MouseEvent) : void
      {
         _bCage.FeedGuardian(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),false);
         CHAMPIONCAGE.Hide(param1);
      }
      
      public function Setup(param1:int = 0) : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(GLOBAL._bCage)
            {
               this.UpdateVars();
               b1.SetupKey("btn_champion",false,0,0);
               b1.addEventListener(MouseEvent.CLICK,this.SwitchClick(0));
               b2.SetupKey("btn_evolution",false,0,0);
               if(this.guardLevel == 6)
               {
                  b2.SetupKey("btn_dailyfeed",false,0,0);
               }
               b2.addEventListener(MouseEvent.CLICK,this.SwitchClick(1));
               if(_kothEnabled)
               {
                  b3.SetupKey("btn_krallen");
                  b3.addEventListener(MouseEvent.CLICK,this.SwitchClick(2));
               }
               else
               {
                  b3.visible = false;
                  b3.mouseEnabled = false;
               }
               tTitle.mouseEnabled = tEvoStage.mouseEnabled = false;
               this._timer.addEventListener(TimerEvent.TIMER,this.onTick);
               this._timer.start();
               this.Switch(param1);
            }
            else
            {
               GLOBAL.Message(KEYS.Get("cage_notbuilt"));
            }
         }
      }
      
      public function addKothListeners() : void
      {
         if(!p3_mcLootMark2.check.visible)
         {
            p3_mcLootMark2.addEventListener(MouseEvent.ROLL_OVER,this.onOverKothTooltip);
            p3_mcLootMark2.addEventListener(MouseEvent.ROLL_OUT,this.onOutKothTooltip);
         }
         p3_bHeal.addEventListener(MouseEvent.CLICK,this.kothHealClick);
         p3_mcAbility1.addEventListener(MouseEvent.ROLL_OVER,this.onKothAbilityOver);
         p3_mcAbility1.addEventListener(MouseEvent.ROLL_OUT,this.onKothAbilityOut);
      }
      
      public function removeKothListeners() : void
      {
         p3_mcLootMark1.removeEventListener(MouseEvent.ROLL_OVER,this.onOverKothTooltip);
         p3_mcLootMark2.removeEventListener(MouseEvent.ROLL_OVER,this.onOverKothTooltip);
         p3_mcLootMark1.removeEventListener(MouseEvent.ROLL_OUT,this.onOutKothTooltip);
         p3_mcLootMark2.removeEventListener(MouseEvent.ROLL_OUT,this.onOutKothTooltip);
         p3_bHeal.removeEventListener(MouseEvent.CLICK,this.kothHealClick);
         p3_mcAbility1.removeEventListener(MouseEvent.ROLL_OVER,this.onKothAbilityOver);
         p3_mcAbility1.removeEventListener(MouseEvent.ROLL_OUT,this.onKothAbilityOut);
      }
      
      public function onOverKothTooltip(param1:MouseEvent = null) : void
      {
         this.addKothTooltip(param1.target as MovieClip);
      }
      
      public function onOutKothTooltip(param1:MouseEvent = null) : void
      {
         this.removeKothTooltip(param1.target as MovieClip);
      }
      
      public function onKothAbilityOver(param1:MouseEvent = null) : void
      {
         this.addKothAbilityTooltip(param1.target as MovieClip);
      }
      
      public function onKothAbilityOut(param1:MouseEvent = null) : void
      {
         this.removeKothAbilityTooltip(param1.target as MovieClip);
      }
      
      public function addKothTooltip(param1:MovieClip) : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:bubblepopupDownBuff = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         switch(param1)
         {
            case p3_mcLootMark1:
               _loc2_ = KEYS.Get("krallenquota1_tooltip",{"v1":GLOBAL.FormatNumber(this.kothLootThresholds[0])});
               _loc4_ = p3_mcLootMark1;
               break;
            case p3_mcLootMark2:
               _loc2_ = KEYS.Get("krallenquota2_tooltip",{"v1":GLOBAL.FormatNumber(this.kothLootThresholds[1])});
               _loc4_ = p3_mcLootMark2;
               break;
            default:
               return;
         }
         if(Boolean(this._kothToolTip1) || Boolean(this._kothToolTip2))
         {
            this.removeKothTooltip(_loc4_);
         }
         _loc5_ = new bubblepopupDownBuff();
         if(_loc4_ == p3_mcLootMark1)
         {
            this._kothToolTip1 = addChild(_loc5_);
         }
         if(_loc4_ == p3_mcLootMark2)
         {
            this._kothToolTip2 = addChild(_loc5_);
         }
         _loc5_.Setup(_loc4_.x + _loc4_.width / 2,_loc4_.y + _loc4_.height + 4,_loc2_,_loc3_);
         _loc5_.x = 0 + (_loc4_.x + _loc4_.width / 2) - 2;
         _loc5_.y = 0 + (_loc4_.y - _loc4_.height + 4);
         _loc5_.Resize(60);
      }
      
      public function removeKothTooltip(param1:MovieClip = null) : void
      {
         if(param1 == p3_mcLootMark1 && Boolean(this._kothToolTip1))
         {
            removeChild(this._kothToolTip1);
            this._kothToolTip1 = null;
         }
         else if(param1 == p3_mcLootMark2 && Boolean(this._kothToolTip2))
         {
            removeChild(this._kothToolTip2);
            this._kothToolTip2 = null;
         }
         else if(param1 == null)
         {
            if(this._kothToolTip1)
            {
               removeChild(this._kothToolTip1);
               this._kothToolTip1 = null;
            }
            if(this._kothToolTip2)
            {
               removeChild(this._kothToolTip2);
               this._kothToolTip2 = null;
            }
         }
      }
      
      public function addKothAbilityTooltip(param1:MovieClip) : void
      {
         var _loc4_:MovieClip = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         switch(param1)
         {
            case p3_mcAbility1:
               if(this.kothPowerLevel >= 2)
               {
                  _loc2_ = KEYS.Get("krallen_lootbuffactive_tooltip");
               }
               else
               {
                  _loc2_ = KEYS.Get("krallen_lootbuff_tooltip",{"v1":GLOBAL.FormatNumber(this.kothLootThresholds[1])});
               }
               _loc4_ = p3_mcAbility1;
               if(Boolean(this._kothToolTipAbility1) || Boolean(this._kothToolTipAbility2))
               {
                  this.removeKothAbilityTooltip(_loc4_);
               }
               var _loc5_:bubblepopupDownBuff = new bubblepopupDownBuff();
               if(_loc4_ == p3_mcAbility1)
               {
                  this._kothToolTipAbility1 = addChild(_loc5_);
               }
               _loc5_.Setup(_loc4_.x + _loc4_.width / 2,_loc4_.y + _loc4_.height + 4,_loc2_,_loc3_);
               _loc5_.x = 0 + (_loc4_.x + _loc4_.width / 2) - 2;
               _loc5_.y = 0 + (_loc4_.y - _loc4_.height / 4);
               return;
            default:
               return;
         }
      }
      
      public function removeKothAbilityTooltip(param1:MovieClip = null) : void
      {
         if(param1 == p3_mcAbility1 && Boolean(this._kothToolTipAbility1))
         {
            removeChild(this._kothToolTipAbility1);
            this._kothToolTipAbility1 = null;
         }
         else if(param1 == null)
         {
            if(this._kothToolTipAbility1)
            {
               removeChild(this._kothToolTipAbility1);
               this._kothToolTipAbility1 = null;
            }
         }
      }
      
      public function onTick(param1:TimerEvent) : void
      {
         this.update();
      }
      
      public function UpdateVars() : void
      {
         if(CREATURES._guardian)
         {
            this.guard = CREATURES._guardian;
            this.guardType = CREATURES._guardian._type;
            this.guardLevel = CREATURES._guardian._level.Get();
            this.foodBonus = CREATURES._guardian._foodBonus.Get();
            this.guardID = CREATURES._guardian._creatureID;
            this.totalFeeds = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"feedCount");
            this.currFeeds = CREATURES._guardian._feeds.Get();
         }
         if(CREATURES._krallen)
         {
            this.koth = CREATURES._krallen;
            this.kothType = CREATURES._krallen._type;
            this.kothLevel = CREATURES._krallen._level.Get();
            this.kothWins = KOTHHandler.instance.wins;
            this.kothBonus = CREATURES._krallen._powerLevel.Get();
            this.kothPowerLevel = CREATURES._krallen._powerLevel.Get();
            this.kothID = CREATURES._krallen._creatureID;
         }
      }
      
      public function Switch(param1:int = 0) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         _page = param1;
         this.UpdateVars();
         mcInstant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantClick);
         mcInstant.bAction.removeEventListener(MouseEvent.CLICK,this.EvolveClick);
         bEvolve.removeEventListener(MouseEvent.CLICK,FeedClick);
         bHeal.removeEventListener(MouseEvent.CLICK,this.HealClick);
         var _loc2_:int = 0;
         while(_loc2_ < pagesArr.length)
         {
            if(_loc2_ == param1)
            {
               _loc4_ = 0;
               while(_loc4_ < pagesArr[_loc2_].length)
               {
                  pagesArr[_loc2_][_loc4_].visible = true;
                  if(pagesArr[_loc2_][_loc4_] is MovieClip)
                  {
                     pagesArr[_loc2_][_loc4_].enabled = true;
                  }
                  _loc4_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < pagesArr[_loc2_].length)
               {
                  pagesArr[_loc2_][_loc5_].visible = false;
                  if(pagesArr[_loc2_][_loc5_] is MovieClip)
                  {
                     pagesArr[_loc2_][_loc5_].enabled = false;
                  }
                  _loc5_++;
               }
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < buffsArr.length)
         {
            buffsArr[_loc3_].visible = false;
            if(buffsArr[_loc3_] is MovieClip)
            {
               buffsArr[_loc3_].enabled = true;
            }
            _loc3_++;
         }
         _loc2_ = 1;
         while(_loc2_ <= 3)
         {
            bDamage["mcBuff" + _loc2_].width = 0;
            bHealth["mcBuff" + _loc2_].width = 0;
            bSpeed["mcBuff" + _loc2_].width = 0;
            bBuff["mcBuff" + _loc2_].width = 0;
            bDamage2["mcBuff" + _loc2_].width = 0;
            bHealth2["mcBuff" + _loc2_].width = 0;
            bSpeed2["mcBuff" + _loc2_].width = 0;
            bBuff2["mcBuff" + _loc2_].width = 0;
            p3_bDamage["mcBuff" + _loc2_].width = 0;
            p3_bHealth["mcBuff" + _loc2_].width = 0;
            p3_bSpeed["mcBuff" + _loc2_].width = 0;
            p3_bBuff["mcBuff" + _loc2_].width = 0;
            _loc2_++;
         }
         if(CREATURES._guardian)
         {
            if(param1 == 0)
            {
               this.UpdatePortrait();
               this.UpdateStats();
               bHeal.SetupKey("btn_healchampion",false,0,0);
               if(CREATURES._guardian.health >= CREATURES._guardian.maxHealth)
               {
                  bHeal.Enabled = false;
                  bHeal.removeEventListener(MouseEvent.CLICK,this.HealClick);
               }
               else
               {
                  bHeal.Enabled = true;
                  bHeal.addEventListener(MouseEvent.CLICK,this.HealClick);
               }
            }
            else if(param1 == 1)
            {
               this.UpdateDNA();
               this.UpdateStats();
               _loc6_ = CREATURES._guardian._feedTime.Get() < GLOBAL.Timestamp();
               if(CREATURES._guardian._level.Get() < 6)
               {
                  tNextFeedTitle.x = -85;
                  tNextFeedTitle.width = 170;
                  tNextFeed.x = -80;
                  tNextFeed.width = 160;
                  bFeedTimer.x = -85;
                  bFeedTimer.width = 170;
                  if(_loc6_)
                  {
                     mcInstant.visible = true;
                     mcInstant.enabled = true;
                     mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("gcage_instantFeed") + "</b>";
                     mcInstant.bAction.Highlight = false;
                     _loc7_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedShiny");
                     mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_loc7_}),false,0,0);
                     mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.InstantClick);
                     bEvolve.SetupKey("btn_feednow",false,0,0);
                     bEvolve.visible = true;
                     bEvolve.Enabled = true;
                     bEvolve.Highlight = false;
                     bEvolve.removeEventListener(MouseEvent.CLICK,this.CantFeedClick);
                     bEvolve.addEventListener(MouseEvent.CLICK,FeedClick);
                  }
                  else
                  {
                     mcInstant.visible = true;
                     mcInstant.enabled = true;
                     mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("gcage_instantEvolve") + "</b>";
                     mcInstant.bAction.Highlight = false;
                     mcInstant.bAction.Enabled = true;
                     _loc8_ = (_loc8_ = (_loc8_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedShiny")) * 2) * (CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedCount") - CREATURES._guardian._feeds.Get());
                     mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_loc8_}),false,0,0);
                     mcInstant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantClick);
                     mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.EvolveClick);
                     bEvolve.SetupKey("btn_feednow",false,0,0);
                     bEvolve.visible = true;
                     bEvolve.Enabled = false;
                     bEvolve.Highlight = false;
                     bEvolve.removeEventListener(MouseEvent.CLICK,FeedClick);
                     bEvolve.addEventListener(MouseEvent.CLICK,this.CantFeedClick);
                  }
               }
               else if(this.guardLevel == _maxLevel)
               {
                  _loc4_ = 0;
                  while(_loc4_ < buffsArr.length)
                  {
                     buffsArr[_loc4_].visible = true;
                     if(buffsArr[_loc4_] is MovieClip)
                     {
                        buffsArr[_loc4_].enabled = true;
                     }
                     _loc4_++;
                  }
                  this.tFeedsFrom.visible = false;
                  this.tFeedsFrom.htmlText = "<b>" + KEYS.Get("gcage_fullyEvolved") + "</b>";
                  tNextFeedTitle.x = -75;
                  tNextFeedTitle.width = 315;
                  tNextFeed.x = -70;
                  tNextFeed.width = 305;
                  bFeedTimer.x = -75;
                  bFeedTimer.width = 315;
                  tBuffDesc.htmlText = KEYS.Get("gcage_feedBuffDesc");
                  if(_loc6_)
                  {
                     mcInstant.visible = true;
                     mcInstant.enabled = true;
                     mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("gcage_instantBuff") + "</b>";
                     mcInstant.bAction.Highlight = false;
                     mcInstant.bAction.Enabled = true;
                     _loc7_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusFeedShiny");
                     mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_loc7_}),false,0,0);
                     mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.InstantClick);
                     bEvolve.SetupKey("btn_feednow",false,0,0);
                     bEvolve.visible = true;
                     bEvolve.Enabled = true;
                     bEvolve.Highlight = false;
                     bEvolve.addEventListener(MouseEvent.CLICK,FeedClick);
                  }
                  else
                  {
                     mcInstant.visible = true;
                     mcInstant.enabled = true;
                     mcInstant.tDescription.htmlText = "<b>" + KEYS.Get("gcage_instantBuffAdd") + "</b>";
                     mcInstant.bAction.Highlight = false;
                     mcInstant.bAction.Enabled = true;
                     _loc8_ = (_loc8_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusFeedShiny")) * 2;
                     mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":_loc8_}),false,0,0);
                     mcInstant.bAction.removeEventListener(MouseEvent.CLICK,this.InstantClick);
                     if(CREATURES._guardian._foodBonus.Get() >= 3)
                     {
                        mcInstant.bAction.Enabled = false;
                        mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.CantInstantClick);
                     }
                     else
                     {
                        mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.InstantClick);
                     }
                     bEvolve.SetupKey("btn_feednow",false,0,0);
                     bEvolve.visible = true;
                     bEvolve.Enabled = false;
                     bEvolve.Highlight = false;
                     bEvolve.removeEventListener(MouseEvent.CLICK,FeedClick);
                     bEvolve.addEventListener(MouseEvent.CLICK,this.CantFeedClick);
                  }
                  mcNextGuardian.visible = false;
                  this.barDNA.visible = false;
                  this.barDNA_bg.visible = false;
               }
               else
               {
                  bEvolve.visible = false;
                  mcInstant.visible = false;
                  mcFeed1.visible = false;
                  mcFeed2.visible = false;
                  mcNextGuardian.visible = false;
                  this.tNextFeed.visible = false;
                  this.barDNA.visible = false;
                  this.barDNA_bg.visible = false;
                  this.tFeedsFrom.htmlText = "<b>" + KEYS.Get("gcage_fullyEvolved") + "</b>";
               }
            }
         }
         if(param1 == 2)
         {
            _loc9_ = this.getKothThreshold(1);
            _loc10_ = this.getKothThreshold(2);
            this.UpdatePortrait();
            this.UpdateStats();
            _loc11_ = 0;
            _loc11_ = 0;
            while(_loc11_ < page3Assets.length)
            {
               page3Assets[_loc11_].visible = false;
               _loc11_++;
            }
            _loc11_ = 0;
            while(_loc11_ < kothArr0.length)
            {
               kothArr0[_loc11_].visible = true;
               _loc11_++;
            }
            if(!this.hasKoth())
            {
               _loc11_ = 0;
               while(_loc11_ < kothArr1.length)
               {
                  kothArr1[_loc11_].visible = true;
                  _loc11_++;
               }
            }
            else
            {
               _loc11_ = 0;
               while(_loc11_ < kothArr2.length)
               {
                  kothArr2[_loc11_].visible = true;
                  _loc11_++;
               }
            }
            p3_looted_txt.htmlText = "<b>" + KEYS.Get("krallen_looted") + "</b>";
            p3_timeleft_txt.htmlText = "<b>" + KEYS.Get("krallen_remaining") + "</b>";
            p3_tDescription.htmlText = KEYS.Get("mon_krallendesc");
            p3_tDescription2.htmlText = KEYS.Get("krallen_desc");
            p3_mcLootMark1.visible = !KOTHHandler.instance.hasWonPermanantly;
            if(this.kothPowerLevel >= 2)
            {
               p3_mcAbility1.gotoAndStop("loot_on");
            }
            else
            {
               p3_mcAbility1.gotoAndStop("loot_off");
            }
            p3_tKothLevel.htmlText = "<b>" + KEYS.Get("mon_krallen_level",{"v1":this.kothLevel}) + "</b>";
            if(this.kothWins > 1)
            {
               p3_tKothLevel.htmlText += " " + KEYS.Get("mon_krallen_streak",{"v1":this.kothWins});
            }
            p3_bHeal.SetupKey("btn_healkrallen");
         }
         b1.Highlight = param1 == 0;
         b2.Highlight = param1 == 1;
         b3.Highlight = param1 == 2;
         window.gotoAndStop(param1 + 1);
         if(param1 == 2)
         {
            this.addKothListeners();
         }
         else
         {
            this.removeKothTooltip();
            this.removeKothAbilityTooltip();
            this.removeKothListeners();
         }
      }
      
      private function hasKoth() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < GLOBAL._playerGuardianData.length)
         {
            if(GLOBAL._playerGuardianData[_loc2_].t == 5)
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function getKothThreshold(param1:int = 1) : Number
      {
         return int(this.kothLootThresholds[Math.min(Math.max(param1 - 1,0),this.kothLootThresholds.length - 1)]);
      }
      
      private function addVideo() : void
      {
         var _loc1_:Video = new Video(this._PREVIEW_WIDTH,this._PREVIEW_HEIGHT);
         this._videoStream = VideoUtils.getVideoStream(_loc1_,this._kothVideoURL);
         VideoUtils.loopStream(this._videoStream);
         p3_mcImage.videoCanvas.addChild(_loc1_);
         _loc1_.x = 25;
         _loc1_.y = -20;
      }
      
      protected function update() : void
      {
         if(_page == 2 && _kothEnabled)
         {
            if(this._DOES_PLAY_VIDEO)
            {
               if(this._currentVideoURL != this._kothVideoURL)
               {
                  if(this._videoStream)
                  {
                     this._videoStream.close();
                  }
                  this._currentVideoURL = this._kothVideoURL;
                  this._videoStream.play(this._kothVideoURL);
                  p3_mcImage.videoCanvas.visible = true;
                  p3_mcImage.imageCanvas.visible = false;
               }
            }
            else if(this._currentPreviewUrl != this._kothPreviewURL)
            {
               this._currentPreviewUrl = this._kothPreviewURL;
               p3_mcImage.videoCanvas.visible = false;
               p3_mcImage.imageCanvas.visible = true;
               ImageCache.GetImageWithCallBack(this._kothPreviewURL,this.onPreviewImageLoaded,true,1,"",[p3_mcImage.imageCanvas]);
            }
            this.UpdateStats();
            this.UpdatePortrait();
         }
      }
      
      private function onPreviewImageLoaded(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         var _loc5_:Bitmap = null;
         if(param1 != this._currentPreviewUrl)
         {
            return;
         }
         var _loc4_:MovieClip;
         _loc4_ = param3[0];
         if(_loc4_)
         {
            while(_loc4_.numChildren > 0)
            {
               _loc4_.removeChildAt(0);
            }
            (_loc5_ = new Bitmap(param2)).x = 50;
            _loc4_.addChild(_loc5_);
            _loc4_.visible = true;
         }
      }
      
      protected function onErrorLoadingVideo(param1:*) : void
      {
      }
      
      private function onStreamNetStatus(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Stop")
         {
            this._videoStream.seek(0);
         }
      }
      
      private function UpdatePortrait() : void
      {
         var UpdatePortraitIcon:Function;
         if(CREATURES._guardian)
         {
            UpdatePortraitIcon = function(param1:String, param2:BitmapData):void
            {
               mcImage.addChild(new Bitmap(param2));
            };
            if(mcImage)
            {
               while(mcImage.numChildren)
               {
                  mcImage.removeChildAt(0);
               }
            }
            ImageCache.GetImageWithCallBack("monsters/" + "G" + CREATURES._guardian._type + "_L" + CREATURES._guardian._level.Get() + "-250.png",UpdatePortraitIcon);
         }
         if(_page == 2 && _kothEnabled)
         {
            if(this._DOES_PLAY_VIDEO)
            {
               if(this._videoStream)
               {
                  if(this._currentVideoURL != this._kothVideoURL)
                  {
                     if(this._videoStream)
                     {
                        this._videoStream.close();
                     }
                     this._currentVideoURL = this._kothVideoURL;
                     this._videoStream.play(this._kothVideoURL);
                  }
               }
               else if(!this._currentVideoURL)
               {
                  this.addVideo();
               }
               p3_mcImage.videoCanvas.visible = true;
               p3_mcImage.imageCanvas.visible = false;
            }
            else if(this._currentPreviewUrl != this._kothPreviewURL)
            {
               this._currentPreviewUrl = this._kothPreviewURL;
               p3_mcImage.videoCanvas.visible = false;
               p3_mcImage.imageCanvas.visible = true;
               ImageCache.GetImageWithCallBack(this._kothPreviewURL,this.onPreviewImageLoaded,true,1,"",[p3_mcImage.imageCanvas]);
            }
         }
      }
      
      private function FeedIconLoaded(param1:String, param2:BitmapData) : void
      {
         feedIcons[0].mcImage.addChild(new Bitmap(param2));
         feedIcons[0].mcImage.width = 30;
         feedIcons[0].mcImage.height = 27;
      }
      
      private function FeedIconLoaded2(param1:String, param2:BitmapData) : void
      {
         feedIcons[1].mcImage.addChild(new Bitmap(param2));
         feedIcons[1].mcImage.width = 30;
         feedIcons[1].mcImage.height = 27;
      }
      
      private function UpdateDNA() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:* = null;
         var _loc1_:int = 1;
         if(CREATURES._guardian)
         {
            if(mcCurrGuardian.numChildren == 0)
            {
               ImageCache.loadImageAndAddChild("monsters/" + "G" + CREATURES._guardian._type + "_L" + CREATURES._guardian._level.Get() + "-150.png",mcCurrGuardian);
               ImageCache.loadImageAndAddChild("monsters/" + "G" + CREATURES._guardian._type + "_L" + (CREATURES._guardian._level.Get() + 1) + "-150G.png",mcNextGuardian);
            }
            _loc2_ = -517;
            _loc3_ = 222;
            _loc4_ = this.currFeeds / this.totalFeeds;
            barDNA_mask.x = _loc2_ + _loc4_ * _loc3_;
            if((_loc5_ = CREATURES._guardian._feedTime.Get()) < GLOBAL.Timestamp())
            {
               tNextFeedTitle.htmlText = "<b>" + KEYS.Get("gcage_hungry") + "</b>";
               tNextFeed.htmlText = GLOBAL.ToTime(_loc5_ + CHAMPIONCAGE.STARVETIMER - GLOBAL.Timestamp());
            }
            else
            {
               tNextFeedTitle.htmlText = "<b>" + KEYS.Get("gcage_nextFeedIn") + "</b>";
               tNextFeed.htmlText = GLOBAL.ToTime(CREATURES._guardian._feedTime.Get() - GLOBAL.Timestamp());
            }
            tFeedsFrom.htmlText = Math.max(0,this.totalFeeds - this.currFeeds) + KEYS.Get("gcage_feedsFromEvo");
            feedIcons[0].visible = false;
            feedIcons[1].visible = false;
            _loc6_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"feeds");
            _loc7_ = 1;
            for(_loc8_ in _loc6_)
            {
               _loc9_ = int(_loc6_[_loc8_]);
               _loc10_ = KEYS.Get(CREATURELOCKER.getShortCreatureName(_loc8_));
               _loc11_ = "monsters/" + _loc8_ + "-small.png";
               if(GLOBAL.player.monsterListByID(_loc8_) == null || GLOBAL.player.monsterListByID(_loc8_) && GLOBAL.player.monsterListByID(_loc8_).numHealthyHousedCreeps < _loc9_)
               {
                  feedIcons[_loc7_ - 1].tName.htmlText = "<font color=\"#ff0000\"><b>" + _loc9_ + " " + _loc10_ + "</b></font>";
               }
               else
               {
                  feedIcons[_loc7_ - 1].tName.htmlText = "<font color=\"#000000\"><b>" + _loc9_ + " " + _loc10_ + "</b></font>";
               }
               if(_loc7_ == 1)
               {
                  ImageCache.GetImageWithCallBack(_loc11_,this.FeedIconLoaded);
               }
               else if(_loc7_ == 2)
               {
                  ImageCache.GetImageWithCallBack(_loc11_,this.FeedIconLoaded2);
               }
               feedIcons[_loc7_ - 1].visible = true;
               _loc7_++;
               if(_loc7_ >= 3)
               {
                  break;
               }
            }
         }
      }
      
      private function UpdateStats() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:Boolean = false;
         var _loc26_:int = 0;
         this.UpdateVars();
         if(CREATURES._guardian)
         {
            tEvoStage.htmlText = "<b>" + KEYS.Get("gcage_evo") + "</b>" + " Stage " + CREATURES._guardian._level.Get();
            damage_txt.htmlText = "<b>" + KEYS.Get("gcage_labelDamage") + "</b>";
            health_txt.htmlText = "<b>" + KEYS.Get("gcage_labelHealth") + "</b>";
            speed_txt.htmlText = "<b>" + KEYS.Get("gcage_labelSpeed") + "</b>";
            buff_txt.htmlText = "<b>" + KEYS.Get("gcage_labelBuff") + "</b>";
            damage_txt2.htmlText = "<b>" + KEYS.Get("gcage_labelDamage") + "</b>";
            health_txt2.htmlText = "<b>" + KEYS.Get("gcage_labelHealth") + "</b>";
            speed_txt2.htmlText = "<b>" + KEYS.Get("gcage_labelSpeed") + "</b>";
            buff_txt2.htmlText = "<b>" + KEYS.Get("gcage_labelBuff") + "</b>";
            tEvoDesc.htmlText = KEYS.Get(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].description);
            if(Boolean(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].powerLevel2Desc) && CREATURES._guardian._powerLevel.Get() > 1)
            {
               tEvoDesc.htmlText += "<br/><b>" + KEYS.Get("mon_specialability") + "</b>" + "<br/>* " + KEYS.Get(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].powerLevel2Desc);
               if(Boolean(KEYS.Get(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].powerLevel3Desc)) && CREATURES._guardian._powerLevel.Get() > 2)
               {
                  tEvoDesc.htmlText += "* " + KEYS.Get(CHAMPIONCAGE._guardians["G" + CREATURES._guardian._type].powerLevel3Desc);
               }
            }
            _loc1_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"damage");
            _loc2_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"health");
            _loc3_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"speed");
            _loc4_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"buffs") * 100;
            if(this.foodBonus > 0)
            {
               _loc1_ += CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.foodBonus,"bonusDamage");
               _loc2_ += CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.foodBonus,"bonusHealth");
               _loc3_ += CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.foodBonus,"bonusSpeed");
               _loc4_ += CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.foodBonus,"bonusBuffs") * 100;
            }
            _loc5_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"damage");
            _loc6_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"health");
            _loc7_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"speed");
            _loc8_ = CHAMPIONCAGE.GetGuardianProperty(this.guardID,this.guardLevel,"buffs") * 100;
            _loc9_ = int(_loc3_ * 10) / 10;
            tDamage.htmlText = "" + _loc1_;
            tHealth.htmlText = "" + _loc2_;
            tSpeed.htmlText = "" + _loc9_;
            tBuff.htmlText = "" + int(_loc4_) + "%";
            tHP.htmlText = Math.floor(this.guard.health) + " / " + Math.floor(this.guard.maxHealth);
            TweenLite.to(bDamage.mcBar,0.4,{
               "width":100 / _maxDamage * _loc1_,
               "ease":Circ.easeInOut,
               "delay":0
            });
            if(this.guardLevel == _maxLevel && _useBonusIndicators)
            {
               _loc10_ = this.foodBonus;
               while(_loc10_ <= 3)
               {
                  if(_loc10_ > 0)
                  {
                     (bDamage["mcBuff" + _loc10_] as MovieClip).gotoAndStop(_loc10_ + 1);
                     TweenLite.to(bDamage["mcBuff" + _loc10_],0,{
                        "width":100 / _maxDamage * (_loc5_ + CHAMPIONCAGE.GetGuardianProperty(this.guardID,_loc10_,"bonusDamage")) + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                  }
                  _loc10_++;
               }
            }
            TweenLite.to(bHealth.mcBar,0.4,{
               "width":100 / _maxHealth * _loc2_,
               "ease":Circ.easeInOut,
               "delay":0.05
            });
            if(this.guardLevel == _maxLevel && _useBonusIndicators)
            {
               _loc10_ = this.foodBonus;
               while(_loc10_ <= 3)
               {
                  if(_loc10_ > 0)
                  {
                     TweenLite.to(bHealth["mcBuff" + _loc10_],0,{
                        "width":100 / _maxHealth * (_loc6_ + CHAMPIONCAGE.GetGuardianProperty(this.guardID,_loc10_,"bonusHealth")) + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     bHealth["mcBuff" + _loc10_].gotoAndStop(1 + _loc10_);
                  }
                  _loc10_++;
               }
            }
            TweenLite.to(bSpeed.mcBar,0.4,{
               "width":100 / _maxSpeed * _loc3_,
               "ease":Circ.easeInOut,
               "delay":0.1
            });
            if(this.guardLevel == _maxLevel && _useBonusIndicators)
            {
               _loc10_ = this.foodBonus;
               while(_loc10_ <= 3)
               {
                  if(_loc10_ > 0)
                  {
                     TweenLite.to(bSpeed["mcBuff" + _loc10_],0,{
                        "width":100 / _maxSpeed * (_loc7_ + CHAMPIONCAGE.GetGuardianProperty(this.guardID,_loc10_,"bonusSpeed")) + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     bSpeed["mcBuff" + _loc10_].gotoAndStop(1 + _loc10_);
                  }
                  _loc10_++;
               }
            }
            TweenLite.to(bBuff.mcBar,0.4,{
               "width":100 / _maxBuff * _loc4_,
               "ease":Circ.easeInOut,
               "delay":0.15
            });
            if(this.guardLevel == _maxLevel && _useBonusIndicators)
            {
               _loc10_ = this.foodBonus;
               while(_loc10_ <= 3)
               {
                  if(_loc10_ > 0)
                  {
                     TweenLite.to(bBuff["mcBuff" + _loc10_],0,{
                        "width":100 / _maxBuff * (_loc8_ + CHAMPIONCAGE.GetGuardianProperty(this.guardID,_loc10_,"bonusBuffs")) + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     bBuff["mcBuff" + _loc10_].gotoAndStop(1 + _loc10_);
                  }
                  _loc10_++;
               }
            }
            if(this.guardLevel == _maxLevel)
            {
               day1.tDay.htmlText = KEYS.Get("gcage_day") + " 1";
               day1.bonusDamage.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusDamage") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusDamage")])) + "" : "";
               day1.bonusHealth.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusHealth") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusHealth")])) + "" : "";
               day1.bonusSpeed.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusSpeed") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusSpeed")]) + "" : "";
               day1.bonusBuff.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusBuffs") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusBuffs")]) * 100 + "%" + "" : "";
               day2.tDay.htmlText = KEYS.Get("gcage_day") + " 2";
               day2.bonusDamage.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusDamage") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusDamage") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusDamage")])) + "" : "";
               day2.bonusHealth.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusHealth") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusHealth") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusHealth")])) + "" : "";
               day2.bonusSpeed.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusSpeed") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusSpeed") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusSpeed")]) + "" : "";
               day2.bonusBuff.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusBuffs") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusBuffs") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,1,"bonusBuffs")]) * 100 + "%" + "" : "";
               day3.tDay.htmlText = KEYS.Get("gcage_day") + " 3";
               day3.bonusDamage.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusDamage") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusDamage") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusDamage")])) + "" : "";
               day3.bonusHealth.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusHealth") ? "+" + GLOBAL.FormatNumber(Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusHealth") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusHealth")])) + "" : "";
               day3.bonusSpeed.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusSpeed") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusSpeed") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusSpeed")]) + "" : "";
               day3.bonusBuff.htmlText = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusBuffs") ? "+" + Number([CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,3,"bonusBuffs") - CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,2,"bonusBuffs")]) * 100 + "%" + "" : "";
               _loc11_ = 1;
               while(_loc11_ <= 3)
               {
                  if(_loc11_ < this.foodBonus + 1)
                  {
                     this["day" + _loc11_].alpha = 1;
                     this["day" + _loc11_].mcDivider.alpha = 0;
                     if(_loc11_ <= this.foodBonus)
                     {
                        this["day" + _loc11_].bonusDamage.htmlText = "";
                        this["day" + _loc11_].bonusHealth.htmlText = "";
                        this["day" + _loc11_].bonusSpeed.htmlText = "";
                        this["day" + _loc11_].bonusBuff.htmlText = "";
                     }
                  }
                  else if(_loc11_ == this.foodBonus + 1)
                  {
                     this["day" + _loc11_].alpha = 1;
                     this["day" + _loc11_].mcDivider.alpha = 0.8;
                     this["day" + _loc11_].bonusDamage.htmlText = "<b>" + this["day" + _loc11_].bonusDamage.htmlText + "</b>";
                     this["day" + _loc11_].bonusHealth.htmlText = "<b>" + this["day" + _loc11_].bonusHealth.htmlText + "</b>";
                     this["day" + _loc11_].bonusSpeed.htmlText = "<b>" + this["day" + _loc11_].bonusSpeed.htmlText + "</b>";
                     this["day" + _loc11_].bonusBuff.htmlText = "<b>" + this["day" + _loc11_].bonusBuff.htmlText + "</b>";
                  }
                  else
                  {
                     this["day" + _loc11_].alpha = 0.5;
                     this["day" + _loc11_].mcDivider.alpha = 1;
                  }
                  _loc11_++;
               }
               tDamage2.htmlText = "" + _loc1_;
               tHealth2.htmlText = "" + _loc2_;
               tSpeed2.htmlText = "" + _loc9_;
               tBuff2.htmlText = "" + int(_loc4_) + "%";
               _loc12_ = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusDamage") ? 1 : 0;
               _loc13_ = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusHealth") ? 1 : 0;
               _loc14_ = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusSpeed") ? 1 : 0;
               _loc15_ = !!CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get() + 1,"bonusBuffs") ? 1 : 0;
               _loc16_ = 25.5;
               TweenLite.to(bDamage2.mcBar,0.4,{
                  "width":_loc16_ + this.foodBonus * 25,
                  "ease":Circ.easeInOut,
                  "delay":0
               });
               TweenLite.to(bHealth2.mcBar,0.4,{
                  "width":_loc16_ + this.foodBonus * 25,
                  "ease":Circ.easeInOut,
                  "delay":0.05
               });
               TweenLite.to(bSpeed2.mcBar,0.4,{
                  "width":_loc16_ + this.foodBonus * 25,
                  "ease":Circ.easeInOut,
                  "delay":0.1
               });
               TweenLite.to(bBuff2.mcBar,0.4,{
                  "width":_loc16_ * _loc15_ + this.foodBonus * 25 * _loc15_,
                  "ease":Circ.easeInOut,
                  "delay":0.15
               });
            }
            barHP.mcBar.width = 100 / this.guard.maxHealth * Math.max(1,this.guard.health);
            bFeedTimer.mcBar.width = 100 / CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedTime") * (CREATURES._guardian._feedTime.Get() - GLOBAL.Timestamp());
         }
         if(_page == 2 && _kothEnabled)
         {
            this.kothLootCurrent = KOTHHandler.instance.totalLoot;
            this.kothTimeCurrent = ReplayableEventHandler.currentTime - this.kothTimeStart;
            this.kothTimeLeft = this.kothTimeEnd - ReplayableEventHandler.currentTime;
            p3_bTimeleft.mcFill.width = 400 / KOTHHandler.instance.timePerRound * this.kothTimeCurrent;
            p3_bLootLeft.mcFill.width = 400 / this.kothLootMax * KOTHHandler.instance.totalLoot;
            _loc17_ = GLOBAL.ToTime(this.kothTimeLeft);
            _loc18_ = GLOBAL.FormatNumber(KOTHHandler.instance.totalLoot);
            p3_tTimeleft.htmlText = "<b>" + _loc17_ + " " + KEYS.Get("koth_bardesc_time") + "</b>";
            p3_tLootLeft.htmlText = "<b>" + _loc18_ + " " + KEYS.Get("koth_bardesc_loot") + "</b>";
            p3_mcLootMark1.visible = !KOTHHandler.instance.hasWonPermanantly;
            p3_mcLootMark1.check.visible = KOTHHandler.instance.totalLoot >= this.kothLootThresholds[0];
            p3_mcLootMark2.check.visible = KOTHHandler.instance.totalLoot >= this.kothLootThresholds[1];
            p3_mcLootMark1.x = p3_bLootLeft.x + p3_bLootLeft.mcBG.width / this.kothLootMax * this.kothLootThresholds[0] - p3_mcLootMark1.width / 2;
            p3_mcLootMark2.x = p3_bLootLeft.x + p3_bLootLeft.mcBG.width / this.kothLootMax * this.kothLootThresholds[1] - p3_mcLootMark2.width;
            if(p3_mcLootMark1.check.visible && !p3_mcLootMark2.check.visible)
            {
               this.addKothTooltip(p3_mcLootMark2);
            }
            else if(!p3_mcLootMark1.check.visible && !p3_mcLootMark2.check.visible)
            {
               if(p3_mcLootMark1.visible)
               {
                  this.addKothTooltip(p3_mcLootMark1);
               }
               else
               {
                  this.addKothTooltip(p3_mcLootMark2);
               }
            }
            if(CREATURES._krallen)
            {
               p3_damage_txt.htmlText = "<b>" + KEYS.Get("gcage_labelDamage") + "</b>";
               p3_health_txt.htmlText = "<b>" + KEYS.Get("gcage_labelHealth") + "</b>";
               p3_speed_txt.htmlText = "<b>" + KEYS.Get("gcage_labelSpeed") + "</b>";
               p3_buff_txt.htmlText = "<b>" + KEYS.Get("gcage_labelBuff") + "</b>";
               p3_abilities_txt.htmlText = "<b>" + KEYS.Get("gcage_labelAbilities") + "</b>";
               _loc19_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"damage");
               _loc20_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"health");
               _loc21_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"speed");
               _loc22_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"buffs") * 100;
               _loc5_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"damage");
               _loc6_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"health");
               _loc7_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"speed");
               _loc8_ = CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel,"buffs") * 100;
               _loc23_ = int(_loc21_ * 10) / 10;
               p3_tDamage.htmlText = "" + _loc19_;
               p3_tHealth.htmlText = "" + _loc20_;
               p3_tSpeed.htmlText = "" + _loc23_;
               p3_tBuff.htmlText = "" + int(_loc22_) + "%";
               p3_tHP.htmlText = Math.floor(this.koth.health) + " / " + Math.floor(this.koth.maxHealth);
               _loc24_ = 5;
               _loc25_ = true;
               TweenLite.to(p3_bDamage.mcBar,0.4,{
                  "width":100 / _maxDamage * _loc19_,
                  "ease":Circ.easeInOut,
                  "delay":0
               });
               if(this.kothLevel != _loc24_ && _loc25_)
               {
                  if(this.kothLevel + 1 <= _loc24_)
                  {
                     TweenLite.to(p3_bDamage["mcBuff" + 1],0,{
                        "width":100 / _maxDamage * CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel + 1,"damage") + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     p3_bDamage["mcBuff" + 1].gotoAndStop(2);
                  }
                  _loc26_ = 2;
                  while(_loc26_ <= 3)
                  {
                     p3_bDamage["mcBuff" + _loc26_].width = 0;
                     _loc26_++;
                  }
               }
               TweenLite.to(p3_bHealth.mcBar,0.4,{
                  "width":100 / _maxHealth * _loc20_,
                  "ease":Circ.easeInOut,
                  "delay":0.05
               });
               if(this.kothLevel != _loc24_ && _loc25_)
               {
                  if(this.kothLevel + 1 <= _loc24_)
                  {
                     TweenLite.to(p3_bHealth["mcBuff" + 1],0,{
                        "width":100 / _maxHealth * CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel + 1,"health") + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     p3_bHealth["mcBuff" + 1].gotoAndStop(2);
                  }
                  _loc26_ = 2;
                  while(_loc26_ <= 3)
                  {
                     p3_bHealth["mcBuff" + _loc26_].width = 0;
                     _loc26_++;
                  }
               }
               TweenLite.to(p3_bSpeed.mcBar,0.4,{
                  "width":100 / _maxSpeed * _loc21_,
                  "ease":Circ.easeInOut,
                  "delay":0.1
               });
               if(this.kothLevel != _loc24_ && _loc25_)
               {
                  if(this.kothLevel + 1 <= _loc24_)
                  {
                     TweenLite.to(p3_bSpeed["mcBuff" + 1],0,{
                        "width":100 / _maxSpeed * CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel + 1,"speed") + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     p3_bSpeed["mcBuff" + 1].gotoAndStop(2);
                  }
                  _loc26_ = 2;
                  while(_loc26_ <= 3)
                  {
                     p3_bSpeed["mcBuff" + _loc26_].width = 0;
                     _loc26_++;
                  }
               }
               TweenLite.to(p3_bBuff.mcBar,0.4,{
                  "width":100 / _maxBuff * _loc22_,
                  "ease":Circ.easeInOut,
                  "delay":0.15
               });
               if(this.kothLevel != _loc24_ && _loc25_)
               {
                  if(this.kothLevel + 1 <= _loc24_)
                  {
                     TweenLite.to(p3_bBuff["mcBuff" + 1],0,{
                        "width":100 / _maxBuff * CHAMPIONCAGE.GetGuardianProperty(this.kothID,this.kothLevel + 1,"buff") + 2,
                        "ease":Circ.easeInOut,
                        "delay":0
                     });
                     p3_bBuff["mcBuff" + 1].gotoAndStop(2);
                  }
                  _loc26_ = 2;
                  while(_loc26_ <= 3)
                  {
                     p3_bBuff["mcBuff" + _loc26_].width = 0;
                     _loc26_++;
                  }
               }
               p3_bHP.mcBar.width = 100 / this.koth.maxHealth * Math.max(1,this.koth.health);
            }
         }
      }
      
      public function Tick() : void
      {
         if(!CREATURES._guardian)
         {
            return;
         }
         var _loc1_:int = CREATURES._guardian._feedTime.Get();
         if(_loc1_ < GLOBAL.Timestamp())
         {
            if(_page == 1)
            {
               this.Switch(1);
            }
            tNextFeedTitle.htmlText = "<b>" + KEYS.Get("gcage_hungry") + "</b>";
            tNextFeed.htmlText = GLOBAL.ToTime(_loc1_ + CHAMPIONCAGE.STARVETIMER - GLOBAL.Timestamp());
            bFeedTimer.mcBar.width = 0;
         }
         else
         {
            tNextFeedTitle.htmlText = "<b>" + KEYS.Get("gcage_nextFeedIn") + "</b>";
            tNextFeed.htmlText = GLOBAL.ToTime(CREATURES._guardian._feedTime.Get() - GLOBAL.Timestamp());
            bFeedTimer.mcBar.width = Math.max(100,100 / CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedTime") * (CREATURES._guardian._feedTime.Get() - GLOBAL.Timestamp()));
         }
         this.UpdateStats();
         if(CREATURES._guardian.health >= CREATURES._guardian.maxHealth)
         {
            bHeal.removeEventListener(MouseEvent.CLICK,this.HealClick);
            bHeal.Enabled = false;
         }
      }
      
      public function SwitchClick(param1:int) : Function
      {
         var page:int = param1;
         return function(param1:MouseEvent = null):void
         {
            Switch(page);
         };
      }
      
      public function HealClick(param1:MouseEvent) : void
      {
         if(CREATURES._guardian.health < CREATURES._guardian.maxHealth)
         {
            CHAMPIONCAGE.HealGuardian();
            this.Switch(0);
         }
         else
         {
            this.Switch(0);
         }
      }
      
      public function kothHealClick(param1:MouseEvent = null) : void
      {
         if(Boolean(CREATURES._krallen) && CREATURES._krallen.health < CREATURES._krallen.maxHealth)
         {
            CHAMPIONCAGE.HealGuardian(5);
            this.Switch(2);
         }
         else
         {
            this.Switch(2);
         }
      }
      
      public function EvolveClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(CREATURES._guardian._level.Get() < 6)
         {
            _loc2_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedShiny");
            _loc2_ *= 2;
            _loc2_ *= CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedCount") - CREATURES._guardian._feeds.Get();
            this.EvolveClickB();
         }
         else if(CREATURES._guardian._level.Get() == 6)
         {
            _loc2_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._foodBonus.Get(),"bonusFeedShiny");
            _loc2_ *= 2;
            this.EvolveClickB();
         }
      }
      
      public function EvolveClickB() : void
      {
         var _loc1_:int = 0;
         if(CREATURES._guardian._level.Get() < 6)
         {
            _loc1_ = CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedShiny");
            _loc1_ *= 2;
            _loc1_ *= CHAMPIONCAGE.GetGuardianProperty(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),"feedCount") - CREATURES._guardian._feeds.Get();
            if(BASE._credits.Get() < _loc1_)
            {
               POPUPS.DisplayGetShiny();
               return;
            }
            CREATURES._guardian.levelSet(CREATURES._guardian._level.Get() + 1,_loc1_);
            BASE.Purchase("IEV",_loc1_,"cage");
            CHAMPIONCAGE.Hide();
            BASE.Save(0,false,true);
         }
      }
      
      public function InstantClick(param1:MouseEvent) : void
      {
         var _loc2_:* = CREATURES._guardian._feedTime.Get() < GLOBAL.Timestamp();
         if(CREATURES._guardian._level.Get() <= 6)
         {
            _bCage.FeedGuardian(CREATURES._guardian._creatureID,CREATURES._guardian._level.Get(),true,!_loc2_);
            CHAMPIONCAGE.Hide(param1);
         }
      }
      
      public function CantFeedClick(param1:MouseEvent) : void
      {
         if(CREATURES._guardian._level.Get() <= 6 && CREATURES._guardian._foodBonus.Get() < 3)
         {
            GLOBAL.Message(KEYS.Get("gcage_msgNotHungry"));
         }
         else if(CREATURES._guardian._level.Get() == 6 && CREATURES._guardian._foodBonus.Get() >= 3)
         {
            GLOBAL.Message(KEYS.Get("gcage_msgFullBuff"));
         }
      }
      
      public function CantInstantClick(param1:MouseEvent) : void
      {
         GLOBAL.Message(KEYS.Get("gcage_msgFullBuff"));
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         CHAMPIONCAGE.Hide(param1);
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
