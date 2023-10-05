package
{
   import com.monsters.ai.WMBASE;
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class INFERNO_DESCENT_POPUPS
   {
      
      private static const _MOLOCH_PORTRAIT_GLOAT:String = "portrait_muloch_gloat.png";
      
      private static const _MOLOCH_PORTRAIT_WHIMPER:String = "portrait_muloch_whimper.png";
      
      private static const _MOLOCH_PORTRAIT_NEUTRAL:String = "portrait_moloch.png";
      
      private static const _TOTAL_LOOT_LABEL:String = "descentTotalLoot";
      
      private static const _PORTRAIT_IMAGE_OFFSET:Point = new Point(-75,50);
      
      private static var _level:uint;
       
      
      public function INFERNO_DESCENT_POPUPS()
      {
         super();
      }
      
      public static function ShowTauntDialog(param1:uint) : void
      {
         var _loc2_:popup_dialogue = POPUPS.DisplayDialogue("",KEYS.Get("descent_moloch_taunt" + param1),KEYS.Get("taunt_player_response" + param1),_MOLOCH_PORTRAIT_NEUTRAL,_PORTRAIT_IMAGE_OFFSET,POPUPS.Next) as popup_dialogue;
         FormatTextFieldForDialog(_loc2_.tBody);
      }
      
      public static function ShowPostAttackPopup(param1:uint, param2:Boolean, param3:Vector.<uint>, param4:Vector.<uint>) : void
      {
         var _loc5_:MovieClip = null;
         _level = param1;
         var _loc6_:Vector.<uint> = UpdateTotalLoot(param3,param4);
         if(param2)
         {
            _loc5_ = ShowWhimperDialog(param1);
            ShowBattleReport(param1,param3,_loc6_);
            if(param1 >= MAPROOM_DESCENT._descentLvlMax - 1)
            {
               ShowCapturePopup();
            }
            LOGGER.Stat([87,param1,"Victory"]);
         }
         else
         {
            _loc5_ = ShowGloatDialog(param1);
            LOGGER.Stat([87,param1,"Defeat"]);
         }
      }
      
      public static function ShowEnticePopup() : void
      {
         var CloseAndEnter:Function = null;
         CloseAndEnter = function(param1:MouseEvent):void
         {
            POPUPS.Next();
            GLOBAL.StatSet("p_id",1);
            INFERNOPORTAL.EnterPortal();
         };
         var entice:MovieClip = new popup_infernoentice_CLIP();
         entice.tDesc.htmlText = KEYS.Get("entercavern_direct_popup");
         entice.tButton.htmlText = KEYS.Get(INFERNOPORTAL.ENTER_BUTTON);
         entice.tButton.mouseEnabled = false;
         entice.bEnter.Setup(" ");
         entice.bEnter.addEventListener(MouseEvent.CLICK,CloseAndEnter);
         POPUPS.Push(entice);
      }
      
      public static function ShowGloatDialog(param1:uint) : MovieClip
      {
         return ShowAttackEndDialog(_MOLOCH_PORTRAIT_GLOAT,KEYS.Get("descent_moloch_gloat" + param1),KEYS.Get("gloat_player_response" + param1));
      }
      
      public static function ShowWhimperDialog(param1:uint) : MovieClip
      {
         return ShowAttackEndDialog(_MOLOCH_PORTRAIT_WHIMPER,KEYS.Get("descent_moloch_whimper" + param1),KEYS.Get("whimper_player_response" + param1));
      }
      
      public static function ShowBattleReport(param1:uint, param2:Vector.<uint>, param3:Vector.<uint>) : void
      {
         var _loc4_:String = KEYS.Get("descent_battlereport",{
            "v1":param2[0],
            "v2":param2[1],
            "v3":param2[2],
            "v4":param2[3]
         });
         var _loc5_:InfernoBattleReportPopup = new InfernoBattleReportPopup("<b>" + KEYS.Get("pop_youlooted_title") + "</b>",_loc4_,param3);
         if(isBragable(param1))
         {
            _loc5_.bButton.SetupKey("btn_brag");
            _loc5_.bButton.Highlight = true;
            _loc5_.bButton.addEventListener(MouseEvent.CLICK,BragBattleReport,false,0,true);
         }
         else
         {
            _loc5_.bButton.SetupKey("btn_close");
            _loc5_.bButton.addEventListener(MouseEvent.CLICK,CloseBattleReport,false,0,true);
         }
         POPUPS.Push(_loc5_,null,null,null,"portrait_moloch.png");
      }
      
      private static function UpdateTotalLoot(param1:Vector.<uint>, param2:Vector.<uint>) : Vector.<uint>
      {
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_[_loc4_] = param1[_loc4_] + param2[_loc4_];
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function CloseBattleReport(param1:MouseEvent) : void
      {
         MovieClip(param1.target).removeEventListener(Event.REMOVED_FROM_STAGE,CloseBattleReport);
         POPUPS.Next();
      }
      
      private static function isBragable(param1:uint) : Boolean
      {
         return param1 == 1 || param1 == 4 || param1 == 7;
      }
      
      private static function BragBattleReport(param1:MouseEvent) : void
      {
         GLOBAL.CallJS("sendFeed",["loot",KEYS.Get("pop_cavernwin" + _level + "_streamtitle"),KEYS.Get("pop_cavernwin" + _level + "_streambody"),"pop_cavernwin" + _level + ".png"]);
         POPUPS.Next();
      }
      
      public static function ShowCapturePopup() : void
      {
         var _loc1_:MovieClip = new popup_infernoemerge_dialog();
         _loc1_.tBody.htmlText = "<b>" + KEYS.Get("descent_pop_victory_title") + "</b><br><br>";
         _loc1_.tBody.htmlText += KEYS.Get("descent_pop_victory_body");
         _loc1_.bAction.Setup(KEYS.Get("descent_pop_victory_button"));
         _loc1_.bAction.addEventListener(MouseEvent.CLICK,ClosedCapturePopup);
         POPUPS.Push(_loc1_,null,null,"");
         GLOBAL.StatSet("descentLvl",MAPROOM_DESCENT._descentLvlMax);
         MAPROOM_DESCENT._descentLvl = MAPROOM_DESCENT._descentLvlMax;
         MAPROOM_DESCENT.DescentPassed;
         WMBASE.DestroyAllDescent();
      }
      
      private static function ClosedCapturePopup(param1:MouseEvent) : void
      {
         MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
         BASE.LoadBase(GLOBAL._infBaseURL,0,0,"ibuild",false,EnumYardType.INFERNO_YARD);
      }
      
      private static function ShowAttackEndDialog(param1:String, param2:String, param3:String) : MovieClip
      {
         var _loc4_:popup_dialogue = POPUPS.DisplayDialogue("",param2,param3,param1,_PORTRAIT_IMAGE_OFFSET,POPUPS.Next) as popup_dialogue;
         FormatTextFieldForDialog(_loc4_.tBody);
         return _loc4_;
      }
      
      private static function FormatTextFieldForDialog(param1:TextField) : TextField
      {
         param1.htmlText = "<i>" + param1.htmlText + "</i>";
         return param1;
      }
      
      public static function isInDescent() : Boolean
      {
         return BASE.isInfernoMainYardOrOutpost && !MAPROOM_DESCENT.DescentPassed && GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK;
      }
   }
}

import flash.display.MovieClip;

class InfernoBattleReportPopup extends popup_infernodescent_battle_report
{
    
   
   public function InfernoBattleReportPopup(param1:String, param2:String, param3:Vector.<uint>)
   {
      var _loc5_:String = null;
      var _loc6_:MovieClip = null;
      super();
      tTitle.htmlText = param1;
      tBody.htmlText = param2;
      var _loc4_:int = 0;
      while(_loc4_ < param3.length)
      {
         _loc5_ = "mcResource" + (_loc4_ + 1);
         _loc6_ = MovieClip(getChildByName(_loc5_));
         switch(_loc4_)
         {
            case 0:
               _loc6_.tTitle.htmlText = "<b>" + KEYS.Get("#r_bone#") + "</b>";
               break;
            case 1:
               _loc6_.tTitle.htmlText = "<b>" + KEYS.Get("#r_coal#") + "</b>";
               break;
            case 2:
               _loc6_.tTitle.htmlText = "<b>" + KEYS.Get("#r_sulfur#") + "</b>";
               break;
            case 3:
               _loc6_.tTitle.htmlText = "<b>" + KEYS.Get("#r_magma#") + "</b>";
               break;
            case 4:
               _loc6_.tTitle.htmlText = "<b>" + KEYS.Get("#r_shiny#") + "</b>";
               break;
         }
         _loc6_.tValue.htmlText = "<b>" + int(param3[_loc4_]).toString() + "</b>";
         _loc6_.stop();
         _loc4_++;
      }
   }
}
