package com.monsters.maproom3.popups
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom3.MapRoom3Tutorial;
   import flash.events.MouseEvent;
   
   public class MapRoom3OutpostSecured extends popup_outpost_secured
   {
       
      
      protected var m_nCellType:int;
      
      public function MapRoom3OutpostSecured(param1:int, param2:Object)
      {
         super();
         this.setup(param1,param2);
      }
      
      public function setup(param1:int, param2:Object) : void
      {
         this.m_nCellType = param1;
         switch(this.m_nCellType)
         {
            case EnumYardType.RESOURCE:
               tfTitle.htmlText = KEYS.Get("ro_taken_title");
               tfBody.htmlText = KEYS.Get("ro_taken_desc",{
                  "v1":param2.level,
                  "v2":GLOBAL.FormatNumber(param2[2] * 60),
                  "v3":GLOBAL.FormatNumber(param2[10]),
                  "v4":param2[7]
               });
               break;
            case EnumYardType.STRONGHOLD:
               tfTitle.htmlText = KEYS.Get("sh_taken_title");
               tfBody.htmlText = KEYS.Get("sh_taken_desc",{
                  "v1":param2.level,
                  "v2":param2[5],
                  "v3":param2[6],
                  "v4":param2[7]
               });
               break;
            case EnumYardType.PLAYER:
               break;
            case EnumYardType.FORTIFICATION:
               if(param2.fortified)
               {
                  tfTitle.htmlText = KEYS.Get("opd_controlled_taken_title");
                  tfBody.htmlText = KEYS.Get("opd_controled_taken_desc",{"v1":this.getAdjacentCellCopy(param2.fortified)});
               }
               else
               {
                  tfTitle.htmlText = KEYS.Get("opd_notcontrolled_taken_title");
                  tfBody.htmlText = KEYS.Get("opd_notcontroled_taken_desc",{"v1":this.getAdjacentCellCopy(param2.weakened)});
               }
         }
         if(TUTORIAL._stage < 120)
         {
            TUTORIAL._stage = 120;
         }
         if(TUTORIAL._stage > 120)
         {
            mcEnter.addEventListener(MouseEvent.CLICK,this.enterOutpost,false,0,true);
         }
         mcMap.addEventListener(MouseEvent.CLICK,this.openMap,false,0,true);
         if(TUTORIAL._stage > 120)
         {
            mcEnter.SetupKey("btn_enteroutpost");
         }
         else
         {
            mcEnter.visible = mcEnter.enabled = mcEnter.Enabled = false;
         }
         if(TUTORIAL._stage > 120)
         {
            mcMap.SetupKey("btn_openmap");
         }
         else
         {
            mcMap.SetupKey("btn_returnhome");
         }
         mcFrame.Setup(false);
      }
      
      private function openMap(param1:MouseEvent) : void
      {
         if(TUTORIAL._stage > 120)
         {
            GLOBAL.ShowMap();
         }
         else
         {
            MapRoom3Tutorial.instance.advance();
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.MAIN_YARD);
         }
      }
      
      private function enterOutpost(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         BASE.LoadBase(null,0,BASE._baseID,GLOBAL.e_BASE_MODE.BUILD,false,this.m_nCellType,_loc2_);
      }
      
      private function getAdjacentCellCopy(param1:int) : String
      {
         switch(param1)
         {
            case EnumYardType.RESOURCE:
               return KEYS.Get("nwm_resource");
            case EnumYardType.STRONGHOLD:
               return KEYS.Get("nwm_stronghold");
            case EnumYardType.PLAYER:
               return KEYS.Get("nwm_mainyard");
            default:
               return "cell";
         }
      }
   }
}
