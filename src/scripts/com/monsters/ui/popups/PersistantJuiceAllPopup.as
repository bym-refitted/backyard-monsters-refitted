package com.monsters.ui.popups
{
   import flash.events.MouseEvent;
   
   public class PersistantJuiceAllPopup extends popup_juice_all
   {
       
      
      protected var m_fpAcceptCallback:Function;
      
      protected var m_fpCloseCallback:Function;
      
      protected var m_strCreepId:String;
      
      protected var m_nTotalCreeps:int;
      
      public function PersistantJuiceAllPopup()
      {
         super();
      }
      
      public function setup(param1:String, param2:Function, param3:Function) : void
      {
         this.m_fpAcceptCallback = param2;
         this.m_fpCloseCallback = param3;
         this.m_strCreepId = param1;
         this.m_nTotalCreeps = GLOBAL.player.monsterListByID(this.m_strCreepId).numHousedCreeps;
         var _loc4_:Number = 0.6;
         var _loc5_:int = 0;
         if(GLOBAL._bJuicer._lvl.Get() == 2)
         {
            _loc4_ = 0.8;
         }
         else if(GLOBAL._bJuicer._lvl.Get() == 3)
         {
            _loc4_ = 1;
         }
         _loc5_ += Math.ceil(CREATURES.GetProperty(this.m_strCreepId,"cResource") * _loc4_) * this.m_nTotalCreeps;
         mcFrame.Setup(true,this.cancelCallback);
         btnCancel.Setup(KEYS.Get("mh_cancel_btn"));
         btnCancel.addEventListener(MouseEvent.CLICK,this.cancelCallback,false,0,true);
         btnJuice.Setup(KEYS.Get("mh_juicemonstersX_btn",{
            "v1":this.m_nTotalCreeps,
            "v2":GLOBAL.FormatNumber(_loc5_)
         }));
         btnJuice.addEventListener(MouseEvent.CLICK,this.acceptCallback,false,0,true);
         btnJuice.Highlight = true;
         tfTitle.htmlText = KEYS.Get("pm_juiceall_popup_title");
         tfBody.htmlText = KEYS.Get("pm_juiceall_popup_body");
      }
      
      protected function acceptCallback(param1:MouseEvent = null) : void
      {
         if(this.m_fpAcceptCallback != null)
         {
            this.m_fpAcceptCallback(this.m_strCreepId);
         }
         POPUPS.Remove(this);
         this.clear();
      }
      
      protected function cancelCallback(param1:MouseEvent = null) : void
      {
         if(this.m_fpCloseCallback != null)
         {
            this.m_fpCloseCallback(param1);
         }
         POPUPS.Remove(this);
         this.clear();
      }
      
      protected function clear() : void
      {
         if(btnCancel.hasEventListener(MouseEvent.CLICK))
         {
            btnCancel.removeEventListener(MouseEvent.CLICK,this.cancelCallback);
         }
         if(btnJuice.hasEventListener(MouseEvent.CLICK))
         {
            btnJuice.removeEventListener(MouseEvent.CLICK,this.acceptCallback);
         }
         this.m_fpAcceptCallback = null;
         this.m_fpCloseCallback = null;
         mcFrame.Clear();
      }
   }
}
