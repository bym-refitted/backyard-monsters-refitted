package com.monsters.radio
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RADIOSETTINGSPOPUP extends RADIOSETTINGSPOPUP_CLIP
   {
       
      
      public var _changed:Boolean = false;
      
      private var _notifyNews:Boolean = false;
      
      private var _notifyAttack:Boolean = false;
      
      private var _emailAddress:String;
      
      private var _emailSettings:Object;
      
      private var _isSaving:Boolean = false;
      
      public function RADIOSETTINGSPOPUP()
      {
         this._emailAddress = KEYS.Get("radio_insertemail");
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         if(RADIO._settings)
         {
            this._emailSettings = RADIO._settings;
         }
         else
         {
            this._emailSettings = {};
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         removeEventListener(param1.type,this.onAdded);
         cbNews = Checkbox.Replace(cbNews);
         cbAttack = Checkbox.Replace(cbAttack);
         bSave.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         bSave.SetupKey("radio_bSave");
         tTitle.htmlText = KEYS.Get("radio_tTitle");
         tNews.htmlText = KEYS.Get("radio_cbNews");
         tAttack.htmlText = KEYS.Get("radio_cbAttack");
         tEmail.htmlText = KEYS.Get("radio_tEmail");
         tEmailInput.htmlText = "<font color=\"#444444\">" + KEYS.Get("radio_tfEmail") + "</font>";
         tDesc.htmlText = KEYS.Get("radio_desc");
         tEmailInput.addEventListener(Event.CHANGE,this.onEmailChange);
         tEmailInput.addEventListener(MouseEvent.CLICK,this.onEmailClear);
         cbProxy.visible = false;
         tProxy.visible = false;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:Object = RADIO.getProp("o1");
         if(_loc1_)
         {
            cbNews.fromInt(_loc1_[RADIO.NEWS_KEY]);
            cbAttack.fromInt(_loc1_[RADIO.ATTACK_KEY]);
            if(_loc1_[RADIO.ADDRESS_KEY])
            {
               tEmailInput.htmlText = String(_loc1_[RADIO.ADDRESS_KEY]);
            }
            else if(Boolean(LOGIN._email) && LOGIN._email != LOGIN._proxymail)
            {
               tEmailInput.htmlText = LOGIN._email;
            }
            else
            {
               tEmailInput.htmlText = "<font color=\"#444444\">" + KEYS.Get("radio_tfEmail") + "</font>";
            }
         }
         else
         {
            Checkbox(cbNews).deselect();
            Checkbox(cbAttack).deselect();
            if(Boolean(LOGIN._email) && LOGIN._email != LOGIN._proxymail)
            {
               tEmailInput.htmlText = LOGIN._email;
            }
            else
            {
               tEmailInput.htmlText = "<font color=\"#444444\">" + KEYS.Get("radio_tfEmail") + "</font>";
            }
         }
         Checkbox(cbNews).removeEventListener(MouseEvent.MOUSE_UP,Checkbox(cbNews).onUp);
         Checkbox(cbNews).addEventListener(MouseEvent.MOUSE_UP,this.onCBUp);
         Checkbox(cbAttack).removeEventListener(MouseEvent.MOUSE_UP,Checkbox(cbAttack).onUp);
         Checkbox(cbAttack).addEventListener(MouseEvent.MOUSE_UP,this.onCBUp);
         Checkbox(cbNews).Update();
         Checkbox(cbAttack).Update();
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Checkbox = null;
         var _loc5_:Checkbox = null;
         var _loc6_:Object = null;
         var _loc2_:String = String(param1.currentTarget.name);
         switch(_loc2_)
         {
            case "bSave":
               _loc3_ = true;
               _loc4_ = cbNews as Checkbox;
               _loc5_ = cbAttack as Checkbox;
               if(_loc4_.selected || _loc5_.selected)
               {
                  _loc3_ &&= tEmailInput.text.lastIndexOf("@") != -1;
                  _loc3_ &&= tEmailInput.text.lastIndexOf(".") != -1;
               }
               if(_loc3_)
               {
                  (_loc6_ = {})[RADIO.ATTACK_KEY] = Checkbox(cbAttack).toInt();
                  if(_loc6_[RADIO.ATTACK_KEY] == 1)
                  {
                  }
                  _loc6_[RADIO.NEWS_KEY] = Checkbox(cbNews).toInt();
                  if(_loc6_[RADIO.NEWS_KEY] == 1)
                  {
                  }
                  _loc6_[RADIO.ADDRESS_KEY] = tEmailInput.text;
                  if(!_loc4_.selected && !_loc5_.selected)
                  {
                     GLOBAL.Message(KEYS.Get("radio_noSubscribe"),KEYS.Get("radio_noSubscribeY"),this.SaveConfirmCB,["o1",_loc6_],KEYS.Get("radio_noSubscribeN"),null,null);
                  }
                  else if(!RADIO._isSaving)
                  {
                     RADIO.setProp("o1",_loc6_);
                     this._changed = false;
                  }
               }
               else
               {
                  GLOBAL.Message(KEYS.Get("radio_enterValidEmail"));
               }
         }
      }
      
      private function SaveConfirmCB(param1:String, param2:Object) : void
      {
         if(!RADIO._isSaving)
         {
            RADIO.setProp(param1,param2);
            this._changed = false;
         }
      }
      
      public function bSaveToggle(param1:Boolean = false) : void
      {
         if(param1)
         {
            RADIO._isSaving = false;
         }
         if(!RADIO._isSaving)
         {
            bSave.SetupKey("radio_bSave");
            bSave.enabled = true;
            bSave.mouseEnabled = true;
         }
         else
         {
            bSave.SetupKey("radio_bSaving");
            bSave.enabled = false;
            bSave.mouseEnabled = false;
         }
      }
      
      private function onCBClick(param1:MouseEvent) : void
      {
         (param1.currentTarget as Checkbox).onClick(param1);
         stage.focus = null;
         this._changed = true;
      }
      
      private function onCBUp(param1:MouseEvent) : void
      {
         (param1.currentTarget as Checkbox).onUp(param1);
         stage.focus = null;
         this._changed = true;
      }
      
      private function onEmailChange(param1:Event) : void
      {
         this._changed = true;
      }
      
      private function onEmailClear(param1:Event) : void
      {
         tEmailInput.htmlText = "";
         stage.focus = tEmailInput;
         tEmailInput.removeEventListener(MouseEvent.CLICK,this.onEmailClear);
      }
      
      public function Hide() : void
      {
         var _loc1_:Checkbox = cbNews as Checkbox;
         var _loc2_:Checkbox = cbAttack as Checkbox;
         if(this._changed)
         {
            GLOBAL.Message(KEYS.Get("radio_unsavedChanges"),KEYS.Get("radio_abandonChanges"),RADIO.Hide);
         }
         else if(!_loc1_.selected && !_loc2_.selected)
         {
            GLOBAL.Message(KEYS.Get("radio_noSubscribe"),KEYS.Get("radio_noSubscribeY"),RADIO.Hide,null,KEYS.Get("radio_noSubscribeN"),null,null);
         }
         else
         {
            RADIO.Hide();
         }
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
