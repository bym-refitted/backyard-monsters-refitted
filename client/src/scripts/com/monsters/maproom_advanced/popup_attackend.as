package com.monsters.maproom_advanced
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public dynamic class popup_attackend extends popup_attackend_CLIP
   {
       
      
      private var _success:Boolean;
      
      public function popup_attackend(param1:Boolean)
      {
         super();
         this._success = param1;
         if(this._success)
         {
            this.tTitle.htmlText = KEYS.Get("newmap_destroyed");
            if(MapRoomManager.instance.isInMapRoom2)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  this.tMessage.htmlText = KEYS.Get("newmap_des_wm2");
               }
               else
               {
                  this.tMessage.htmlText = KEYS.Get("newmap_des_pl1");
               }
            }
            else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  if(MAPROOM_DESCENT.InDescent)
                  {
                     this.tMessage.htmlText = KEYS.Get("descent_newmap_des_wm2");
                  }
                  else
                  {
                     this.tMessage.htmlText = KEYS.Get("inf_newmap_des_wm2");
                  }
               }
               else
               {
                  this.tMessage.htmlText = KEYS.Get("newmap_des_wm2");
               }
            }
            else
            {
               this.tMessage.htmlText = KEYS.Get("newmap_des_pl2");
            }
         }
         else
         {
            this.tTitle.htmlText = KEYS.Get("popup_attackended_title");
            if(MapRoomManager.instance.isInMapRoom2)
            {
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  this.tMessage.htmlText = KEYS.Get("popup_attackended_failedWMYard");
               }
               else if(BASE.isOutpost)
               {
                  this.tMessage.htmlText = KEYS.Get("popup_attackended_failedOutpost");
               }
               else
               {
                  this.tMessage.htmlText = "";
               }
            }
            else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               if(BASE.isInfernoMainYardOrOutpost)
               {
                  if(MAPROOM_DESCENT.InDescent)
                  {
                     this.tMessage.htmlText = KEYS.Get("descent_popup_attackended_failedWMTH");
                  }
                  else
                  {
                     this.tMessage.htmlText = KEYS.Get("inf_popup_attackended_failedWMTH");
                  }
               }
               else
               {
                  this.tMessage.htmlText = KEYS.Get("popup_attackended_failedWMTH");
               }
            }
            else
            {
               this.tMessage.htmlText = "";
            }
         }
         this.tProcessing.htmlText = KEYS.Get("please_wait");
         this.bAction.Enabled = false;
         if(!MapRoomManager.instance.isInMapRoom2 || BASE.isInfernoMainYardOrOutpost)
         {
            this.bAction.Setup(KEYS.Get("btn_returnhome"));
         }
         else
         {
            this.bAction.Setup(KEYS.Get("btn_openmap"));
         }
         this.addEventListener(Event.ENTER_FRAME,this.Tick);
      }
      
      private function Tick(param1:Event) : void
      {
         if(BASE._saveCounterA == BASE._saveCounterB)
         {
            this.bAction.Enabled = true;
            this.tProcessing.htmlText = "";
            this.bAction.addEventListener(MouseEvent.CLICK,this.End);
            this.removeEventListener(Event.ENTER_FRAME,this.Tick);
         }
      }
      
      private function End(param1:MouseEvent) : void
      {
         if(MapRoomManager.instance.isInMapRoom2)
         {
            MapRoom.showEnemyWait = true;
            if(this._success && Boolean(GLOBAL._currentCell))
            {
               (GLOBAL._currentCell as MapRoomCell).destroyed = 1;
            }
            MapRoomManager.instance.Show();
         }
         else if(GLOBAL._loadmode == GLOBAL.mode)
         {
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.MAIN_YARD);
         }
         else if(MAPROOM_DESCENT._inDescent)
         {
            MAPROOM_DESCENT.ExitDescent();
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,EnumYardType.MAIN_YARD);
         }
         else
         {
            BASE.LoadBase(GLOBAL._infBaseURL,0,0,"ibuild",false,EnumYardType.INFERNO_YARD);
         }
         POPUPS.Next();
      }
   }
}
