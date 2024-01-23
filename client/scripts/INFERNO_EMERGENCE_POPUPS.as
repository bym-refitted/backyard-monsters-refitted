package
{
   import com.monsters.ai.INFERNO_EMERGENCE_ATTACKPOPUP;
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class INFERNO_EMERGENCE_POPUPS
   {
      
      public static var _warningPopup:INFERNO_EMERGENCE_ATTACKPOPUP;
      
      public static var _lvl:int;
      
      public static var EVENT_DIALOGUE_START:String = "emerge_dialogue_started";
      
      public static var EVENT_DIALOGUE_1:String = "emerge_start_1";
      
      public static var EVENT_DIALOGUE_2:String = "emerge_start_2";
      
      public static var EVENT_DIALOGUE_3:String = "emerge_start_3";
      
      public static var EVENT_DIALOGUE_4:String = "emerge_start_4";
      
      public static var EVENT_DIALOGUE_5:String = "emerge_start_5";
      
      public static var EVENT_DIALOGUE_DEFAULT:String = "emerge_dialogue_default";
      
      public static var INFERNO_UPGRADE_SHOWN:String = "infernoUpgradeShown";
       
      
      public function INFERNO_EMERGENCE_POPUPS()
      {
         super();
      }
      
      public static function ShowUpgrade() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = new popup_infernoemerge_upgrade();
         _loc1_.tTitle.htmlText = KEYS.Get("emerge_upgrade_title");
         _loc1_.tBody.htmlText = KEYS.Get("emerge_upgrade_body");
         _loc1_.bAction.buttonMode = true;
         _loc1_.bAction.useHandCursor = true;
         _loc1_.bAction.mouseChildren = false;
         _loc1_.bAction.Setup(KEYS.Get("emerge_upgrade_btnaction"));
         if(GLOBAL.townHall._lvl.Get() >= INFERNO_EMERGENCE_EVENT.TOWN_HALL_LEVEL_REQUIREMENT)
         {
            _loc1_.bAction.visible = false;
         }
         _loc1_.bAction.addEventListener(MouseEvent.CLICK,EmergeUpgradeCB);
         POPUPS.Push(_loc1_,INFERNO_EMERGENCE_POPUPS.ShownUpgradeCB);
      }
      
      private static function EmergeUpgradeCB(param1:MouseEvent) : void
      {
         GLOBAL._selectedBuilding = GLOBAL.townHall;
         BUILDINGOPTIONS.Show(GLOBAL.townHall,"upgrade");
         POPUPS.Next();
      }
      
      public static function ShowStart() : void
      {
         ShowDialogue(0);
      }
      
      public static function ShownUpgradeCB() : void
      {
      }
      
      public static function ShowDialogue(param1:int) : MovieClip
      {
         var _loc2_:String = null;
         var _loc3_:Point = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Function = null;
         _lvl = param1;
         switch(param1)
         {
            case 0:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_intro");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 1:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt1");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 2:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt2");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 3:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt3");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 4:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt4");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 5:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt5");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
         }
         var _loc8_:MovieClip;
         (_loc8_ = POPUPS.DisplayDialogue(_loc4_,_loc5_,_loc6_,_loc2_,_loc3_,_loc7_)).addEventListener(Event.REMOVED_FROM_STAGE,DialogueCB,false,0,true);
         return _loc8_;
      }
      
      public static function DialogueCB(param1:Event) : void
      {
         var _loc2_:String = EVENT_DIALOGUE_DEFAULT;
         param1.target.dispatchEvent(new Event(_loc2_));
         param1.target.removeEventListener(Event.REMOVED_FROM_STAGE,DialogueCB);
      }
      
      public static function ShowRSVP(param1:int) : void
      {
         var showRSVP:MovieClip;
         var isEventOver:Boolean;
         var portrait:String = null;
         var imgOffset:Point = null;
         var title:String = null;
         var line:String = null;
         var btnLabel:String = null;
         var action:Function = null;
         var RSVPLink:Function = null;
         var lvl:int = param1;
         RSVPLink = function(param1:MouseEvent):void
         {
            GLOBAL.gotoURL("http://www.facebook.com/events/242085715856757/",null,true,null);
            POPUPS.Next();
         };
         _lvl = lvl;
         switch(lvl)
         {
            case 0:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("cavern_pop1");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
               break;
            case 1:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("cavern_pop1");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
               break;
            case 2:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("cavern_pop2");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
               break;
            case 3:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("cavern_pop3");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
               break;
            case 4:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("cavern_pop4");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
               break;
            case 5:
               portrait = "portrait_moloch.png";
               imgOffset = new Point(-75,50);
               title = "";
               line = KEYS.Get("entercavernfail_popup");
               btnLabel = KEYS.Get("emerge_RSVP");
               action = POPUPS.Next;
         }
         showRSVP = new popup_infernoemerge_dialog();
         showRSVP.tBody.htmlText = line;
         showRSVP.bAction.buttonMode = true;
         showRSVP.bAction.useHandCursor = true;
         showRSVP.bAction.mouseChildren = false;
         isEventOver = INFERNO_EMERGENCE_EVENT.isLastDay() || INFERNO_EMERGENCE_EVENT.IsPostEvent();
         if(!isEventOver)
         {
            showRSVP.bAction.Setup(btnLabel);
            showRSVP.bAction.addEventListener(MouseEvent.CLICK,RSVPLink);
         }
         else if(GLOBAL.townHall._lvl.Get() < INFERNO_EMERGENCE_EVENT.TOWN_HALL_LEVEL_REQUIREMENT)
         {
            showRSVP.bAction.Setup(KEYS.Get("emerge_upgrade_btnaction"));
            showRSVP.bAction.addEventListener(MouseEvent.CLICK,EmergeUpgradeCB);
         }
         else
         {
            showRSVP.bAction.visible = false;
         }
         POPUPS.Push(showRSVP,null,null,"");
      }
      
      public static function ShowStagePassed(param1:int) : void
      {
         var completeRound:MovieClip = null;
         var imageCompleteRoundDialogue:Function = null;
         var EmergeBragCB:Function = null;
         var lvl:int = param1;
         imageCompleteRoundDialogue = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            _loc3_.y = -_loc3_.height + 80;
            _loc3_.x = -100;
            completeRound.mcImage.addChild(_loc3_);
         };
         EmergeBragCB = function(param1:MouseEvent):void
         {
            GLOBAL.CallJS("sendFeed",["emerge-defense",KEYS.Get("ai_caverndefense_streamtitle"),KEYS.Get("ai_caverndefense_streambody"),"emergence_streampost01A.png"]);
            POPUPS.Next();
         };
         completeRound = new popup_infernoemerge_roundover();
         completeRound.tBody.htmlText = KEYS.Get("ai_caverndefense");
         completeRound.bAction.buttonMode = true;
         completeRound.bAction.useHandCursor = true;
         completeRound.bAction.mouseChildren = false;
         completeRound.bAction.Setup(KEYS.Get("btn_brag"));
         completeRound.bAction.Highlight = true;
         completeRound.bAction.addEventListener(MouseEvent.CLICK,EmergeBragCB);
         ImageCache.GetImageWithCallBack("popups/" + "portrait_moloch.png",imageCompleteRoundDialogue);
         POPUPS.Push(completeRound,null,null,"");
         _lvl = lvl;
         switch(lvl)
         {
            case 0:
               ShowDialogue(0);
               break;
            case 1:
               ShowDialogue(1);
               break;
            case 2:
               ShowDialogue(2);
               break;
            case 3:
               ShowDialogue(3);
               break;
            case 4:
               ShowDialogue(4);
               break;
            case 5:
               ShowDialogue(5);
         }
         INFERNO_EMERGENCE_EVENT.EndRound();
         if(lvl == INFERNOPORTAL.GetMaxLevel())
         {
            ShowComplete();
         }
      }
      
      public static function ShowComplete() : void
      {
         var completeEmerge:MovieClip = null;
         var imageCompleteEmerge:Function = null;
         imageCompleteEmerge = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            completeEmerge.mcImage.addChild(_loc3_);
         };
         var portrait:String = "portrait_moloch.png";
         var imgOffset:Point = new Point(-75,50);
         var title:String = "";
         var line:String = KEYS.Get("ai_moloch_intro");
         var btnLabel:String = "Next";
         var action:Function = POPUPS.Next;
         completeEmerge = new popup_infernoemerge_complete();
         completeEmerge.tBody.htmlText = KEYS.Get("entercavern_popup");
         if(GLOBAL.townHall._lvl.Get() >= INFERNO_EMERGENCE_EVENT.TOWN_HALL_LEVEL_REQUIREMENT)
         {
            completeEmerge.bAction.buttonMode = true;
            completeEmerge.bAction.useHandCursor = true;
            completeEmerge.bAction.mouseChildren = false;
            completeEmerge.bAction.Highlight = true;
            completeEmerge.bAction.Setup(BASE.isInfernoMainYardOrOutpost ? KEYS.Get(INFERNOPORTAL.EXIT_BUTTON) : KEYS.Get(INFERNOPORTAL.ENTER_BUTTON));
            completeEmerge.bAction.addEventListener(MouseEvent.CLICK,INFERNOPORTAL.EnterPortal);
         }
         else
         {
            completeEmerge.bAction.visible = false;
            completeEmerge.bAction.mouseEnabled = false;
         }
         ImageCache.GetImageWithCallBack("popups/" + "popup_emergecomplete.v2.jpg",imageCompleteEmerge);
         POPUPS.Push(completeEmerge,null,null,"");
      }
      
      public static function ShowWarning(param1:int) : void
      {
         var _loc2_:String = "portrait_moloch.png";
         var _loc3_:Point = new Point(-75,50);
         var _loc4_:String = "";
         var _loc5_:String = KEYS.Get("ai_moloch_intro");
         var _loc6_:String = "Next";
         var _loc7_:Function = POPUPS.Next;
         switch(param1)
         {
            case 0:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_intro");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 1:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt1");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 2:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt2");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 3:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt3");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 4:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt4");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
               break;
            case 5:
               _loc2_ = "portrait_moloch.png";
               _loc3_ = new Point(-75,50);
               _loc4_ = "";
               _loc5_ = KEYS.Get("ai_moloch_taunt5");
               _loc6_ = "Next";
               _loc7_ = POPUPS.Next;
         }
         var _loc8_:Array = INFERNO_PORTAL_ATTACK.GetVariableCreeps();
         if(!_warningPopup)
         {
            _warningPopup = new INFERNO_EMERGENCE_ATTACKPOPUP(_loc8_);
            GLOBAL._layerWindows.addChild(_warningPopup);
            BASE.Save();
         }
      }
      
      public static function HideWarning() : void
      {
         if(_warningPopup)
         {
            if(_warningPopup.parent)
            {
               _warningPopup.parent.removeChild(_warningPopup);
            }
            _warningPopup = null;
         }
      }
      
      public static function DefenseBragCB() : void
      {
      }
   }
}
