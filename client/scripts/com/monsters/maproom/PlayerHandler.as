package com.monsters.maproom
{
   import com.monsters.ai.*;
   import com.monsters.enums.EnumYardType;
   import com.monsters.mailbox.model.Contact;
   import com.monsters.maproom.model.BaseObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PlayerHandler extends Sprite
   {
      
      public static var currentBase:BaseObject;
       
      
      private var player:*;
      
      private var data:BaseObject;
      
      public function PlayerHandler()
      {
         super();
      }
      
      public function configure(param1:*) : Object
      {
         this.player = param1;
         this.data = this.player.data;
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = true;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "#000000";
         var _loc7_:String = "Unknown";
         var _loc8_:String = "#000000";
         if(this.data.wm.Get() == 0)
         {
            if(this.data.saved.Get() >= MapRoom.BRIDGE.GLOBAL.Timestamp() - 62)
            {
               _loc2_ = false;
               _loc4_ = "<font color = \'#01BA01\'>" + KEYS.Get("player_online");
            }
            else
            {
               _loc4_ = "<font color = \'#666666\'>" + KEYS.Get("player_offline");
            }
            if(this.data.friend.Get() == 1)
            {
               _loc7_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_friends"));
               _loc8_ = "#0000FF";
            }
            if(this.data.attacksfrom.Get() > 1)
            {
               _loc7_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_hostile"));
               _loc8_ = "#990000";
            }
            if(Boolean(this.data.trucestate) && this.data.trucestate != "")
            {
               this.player.truceBtn.Enabled = false;
               this.player.truceBtn.removeEventListener(MouseEvent.CLICK,this.onTruce);
               if(this.data.trucestate == "accepted")
               {
                  _loc2_ = false;
                  _loc7_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_tactive"));
                  _loc8_ = "#00FF00";
               }
               else if(this.data.trucestate == "requested")
               {
                  _loc7_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_trequested"));
                  _loc8_ = "#0000FF";
               }
               else if(this.data.trucestate == "rejected")
               {
                  _loc7_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_trejected"));
                  _loc8_ = "#CC0000";
               }
               switch(this.data.attackpermitted.Get())
               {
                  case 5:
                     _loc2_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_dp"));
                     break;
                  case 6:
                     _loc2_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_sp"));
                     break;
                  case 7:
                     _loc2_ = false;
                     _loc3_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_underattack"));
                     _loc6_ = "#FF0000";
               }
            }
            else
            {
               this.player.truceBtn.Enabled = true;
               this.player.truceBtn.addEventListener(MouseEvent.CLICK,this.onTruce);
               switch(this.data.attackpermitted.Get())
               {
                  case 3:
                     _loc2_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_level"));
                     break;
                  case 4:
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_vengeance",{"v1":this.data.retaliatecount}));
                     _loc6_ = "#FF0000";
                     break;
                  case 5:
                     _loc2_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_dp"));
                     break;
                  case 6:
                     _loc2_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_sp"));
                     break;
                  case 7:
                     _loc2_ = false;
                     _loc3_ = false;
                     _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_underattack"));
                     _loc6_ = "#FF0000";
               }
            }
            if(this.data.truceexpire > 0)
            {
               _loc5_ = String(MapRoom.BRIDGE.KEYS.Get("map_status_timeremain",{"v1":MapRoom.BRIDGE.GLOBAL.ToTime(this.data.truceexpire,true,false)}));
               _loc6_ = "#000000";
            }
            this.player.helpBtn.removeEventListener(MouseEvent.CLICK,this.onHelp);
            this.player.helpBtn.removeEventListener(MouseEvent.CLICK,this.onView);
            this.player.attackBtn.removeEventListener(MouseEvent.CLICK,this.onAttack);
            this.player.msgBtn.addEventListener(MouseEvent.CLICK,this.onMessage);
            if(int(this.data.friend.Get()) == 1)
            {
               this.player.helpBtn.SetupKey("map_help_btn");
               this.player.helpBtn.addEventListener(MouseEvent.CLICK,this.onHelp);
            }
            else
            {
               this.player.helpBtn.SetupKey("map_view_btn");
               this.player.helpBtn.addEventListener(MouseEvent.CLICK,this.onView);
            }
            if(!_loc3_)
            {
               this.player.helpBtn.Enabled = false;
            }
            this.player.attackBtn.SetupKey("map_attack_btn");
            this.player.attackBtn.addEventListener(MouseEvent.CLICK,this.onAttack);
            if(!_loc3_ || !_loc2_)
            {
               this.player.attackBtn.Enabled = false;
            }
            else
            {
               this.player.attackBtn.Enabled = true;
            }
         }
         else
         {
            this.player.helpBtn.SetupKey("map_view_btn");
            if(TUTORIAL._stage < 110)
            {
               this.player.helpBtn.Enabled = false;
            }
            else
            {
               this.player.helpBtn.addEventListener(MouseEvent.CLICK,this.onView);
            }
            this.player.attackBtn.SetupKey("map_attack_btn");
            this.player.attackBtn.addEventListener(MouseEvent.CLICK,this.onAttack);
            this.player.attackBtn.Enabled = true;
            if(TUTORIAL._stage > 110)
            {
               this.player.helpBtn.Enabled = true;
            }
         }
         return {
            "OKattack":_loc2_,
            "OKview":_loc3_,
            "status":_loc4_,
            "extraStatus":_loc5_,
            "relation":_loc7_,
            "relationColor":_loc8_,
            "extraStatusColor":_loc6_
         };
      }
      
      private function onMessage(param1:MouseEvent) : void
      {
         MapRoom.BRIDGE.SOUNDS.Play("click1");
         // Important Comment: This does not exist - fix.
         // var _loc2_:* = new MapRoom.BRIDGE.MessageUI();
         var _loc3_:Contact = new Contact(String(this.player.data.userid.Get()),{
            "first_name":this.player.data.ownerName,
            "last_name":"",
            "pic_square":this.player.data.pic
         });
         _loc2_.picker.preloadSelection(_loc3_);
         _loc2_.requestType = "message";
         _loc2_.body_txt.text = "";
         GLOBAL.BlockerAdd();
         GLOBAL._layerWindows.addChild(_loc2_);
      }
      
      private function onHelp(param1:MouseEvent) : void
      {
         MapRoom.BRIDGE.SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         if(_loc2_.friend.Get())
         {
            MapRoom.BRIDGE.setVisitingFriend(true);
         }
         else
         {
            MapRoom.BRIDGE.setVisitingFriend(false);
         }
         MapRoom.BRIDGE.LoadBase(null,null,this.player.data.baseid.Get(),"help");
         if(MAPROOM._mc)
         {
            MAPROOM._mc.Hide();
         }
      }
      
      private function onView(param1:MouseEvent) : void
      {
         MapRoom.BRIDGE.SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         if(_loc2_.friend.Get())
         {
            MapRoom.BRIDGE.setVisitingFriend(true);
         }
         else
         {
            MapRoom.BRIDGE.setVisitingFriend(false);
         }
         var _loc3_:String = _loc2_.wm.Get() == 1 ? "wmview" : "view";
         MapRoom.BRIDGE.LoadBase(null,null,this.player.data.baseid.Get(),_loc3_,false,EnumYardType.MAIN_YARD);
         if(Boolean(MAPROOM) && Boolean(MAPROOM._mc))
         {
            MAPROOM._mc.Hide();
         }
      }
      
      private function onTruce(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Contact = null;
         MapRoom.BRIDGE.SOUNDS.Play("click1");
         if(!this.data.trucestate || this.data.trucestate == "")
         {
            if(MapRoom._useMailBoxForTruces)
            {
                // Important Comment: This does not exist - fix.
               // _loc2_ = new MapRoom.BRIDGE.MessageUI();
               _loc3_ = new Contact(String(this.player.data.userid.Get()),{
                  "first_name":this.player.data.ownerName,
                  "last_name":"",
                  "pic_square":this.player.data.pic
               });
               _loc2_.picker.preloadSelection(_loc3_);
               _loc2_.subject_txt.htmlText = "<b>" + MapRoom.BRIDGE.KEYS.Get("map_trucesubject");
               _loc2_.body_txt.htmlText = MapRoom.BRIDGE.KEYS.Get("map_trucemessage");
               _loc2_.requestType = "trucerequest";
               _loc2_.truceShareHandler = MapRoom.BRIDGE.truceShareHandler;
               GLOBAL.BlockerAdd();
               GLOBAL._layerWindows.addChild(_loc2_);
            }
            else
            {
               MapRoom.BRIDGE.RequestTruce(this.data.ownerName,this.data.baseid.Get());
            }
         }
         else
         {
            MapRoom.BRIDGE.GLOBAL.Message(MapRoom.BRIDGE.KEYS.Get("msg_trucealreadyrequested"));
         }
      }
      
      private function onAttack(param1:MouseEvent) : void
      {
         var _loc6_:String = null;
         MapRoom.BRIDGE.SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         var _loc3_:Boolean = false;
         var _loc4_:String = "";
         var _loc5_:String = String(MapRoom.BRIDGE.KEYS.Get("map_attack_btn2"));
         var _loc7_:Boolean = MapRoom.BRIDGE.HOUSING._housingUsed.Get() > 0 || MapRoom.BRIDGE.GLOBAL._playerGuardianData != null;
         if(MapRoom.BRIDGE.GLOBAL._bFlinger != null && MapRoom.BRIDGE.GLOBAL._bFlinger._canFunction && MapRoom.BRIDGE.GLOBAL._bFlinger._countdownUpgrade.Get() == 0)
         {
            if(_loc2_.wm.Get() == 0)
            {
               if(_loc2_.saved.Get() >= MapRoom.BRIDGE.GLOBAL.Timestamp() - 62)
               {
                  _loc3_ = false;
                  _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_ownerinyard",{"v1":_loc2_.ownerName}));
               }
               else if(MapRoom.BRIDGE.GLOBAL._flags.attacking == 0)
               {
                  _loc3_ = false;
                  _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_attackingdisabled"));
               }
               else
               {
                  switch(_loc2_.attackpermitted.Get())
                  {
                     case 1:
                        _loc3_ = true;
                        if(MapRoom.BRIDGE.BASE._isProtected > GLOBAL.Timestamp())
                        {
                           _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_protection",{"v1":MapRoom.BRIDGE.GLOBAL.ToTime(MapRoom.BRIDGE.BASE._isProtected - MapRoom.BRIDGE.GLOBAL.Timestamp(),false,false)}));
                        }
                        else if(_loc2_.friend.Get())
                        {
                           _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_attackfriend",{"v1":_loc2_.ownerName}));
                        }
                        else
                        {
                           _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_attackconfirm",{"v1":_loc2_.ownerName}));
                        }
                        break;
                     case 2:
                        _loc3_ = true;
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_higherlevelconfirm",{"v1":_loc2_.ownerName}));
                        break;
                     case 3:
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_leveltoolow"));
                        break;
                     case 4:
                        _loc3_ = true;
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_vengeance"));
                        break;
                     case 5:
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_dp",{"v1":_loc2_.ownerName}));
                        break;
                     case 6:
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_sp",{"v1":_loc2_.ownerName}));
                        break;
                     case 7:
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_inprogress",{
                           "v1":_loc2_.ownerName,
                           "v2":_loc2_.attacker
                        }));
                        break;
                     case 9:
                        _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_truceactive",{"v1":_loc2_.ownerName}));
                  }
               }
            }
            else
            {
               _loc3_ = true;
               if(_loc2_.wm.Get() == 0)
               {
                  _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_atatckconfirm",{"v1":_loc2_.ownerName}));
                  if(_loc2_.level.Get() > MapRoom.BRIDGE.BASE.BaseLevel().level)
                  {
                     _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_higherlevelconfirm",{"v1":_loc2_.ownerName}));
                  }
               }
               else
               {
                  _loc6_ = _loc2_.wm.Get() == 1 ? "wmattack" : GLOBAL.e_BASE_MODE.ATTACK;
                  if(_loc7_)
                  {
                     this.onAttackB(_loc2_.baseid.Get(),_loc6_);
                     return;
                  }
               }
            }
         }
         else
         {
            _loc3_ = false;
            if(MapRoom.BRIDGE.GLOBAL._bFlinger == null)
            {
               _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_needflinger"));
            }
            else if(MapRoom.BRIDGE.GLOBAL._bFlinger._countdownUpgrade.Get() > 0)
            {
               _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_flingerupgrading"));
            }
            else
            {
               _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_flingerdamaged"));
            }
         }
         if(_loc3_)
         {
            MapRoom.BRIDGE.HOUSING.HousingSpace();
            _loc6_ = _loc2_.wm.Get() == 1 ? "wmattack" : GLOBAL.e_BASE_MODE.ATTACK;
            if(_loc7_)
            {
               MapRoom.BRIDGE.GLOBAL.Message(_loc4_,_loc5_,this.onAttackB,[_loc2_.baseid.Get(),_loc6_]);
            }
            else
            {
               _loc4_ = String(MapRoom.BRIDGE.KEYS.Get("map_msg_nomonsters"));
               MapRoom.BRIDGE.GLOBAL.Message(_loc4_);
            }
         }
         else
         {
            MapRoom.BRIDGE.GLOBAL.Message(_loc4_);
         }
      }
      
      public function onAttackB(param1:Number, param2:String) : void
      {
         var _loc3_:BaseObject = this.player.data;
         if(_loc3_.wm.Get() == 1)
         {
            MapRoom.BRIDGE.WMBASE._type = _loc3_.type;
         }
         if(_loc3_.friend.Get())
         {
            MapRoom.BRIDGE.setVisitingFriend(true);
         }
         else
         {
            MapRoom.BRIDGE.setVisitingFriend(false);
         }
         MapRoom.BRIDGE.BASE.LoadBase(null,null,param1,param2,false,EnumYardType.MAIN_YARD);
         if(MapRoom.BRIDGE && MapRoom.BRIDGE.MAPROOM && Boolean(MapRoom.BRIDGE.MAPROOM._mc))
         {
            MapRoom.BRIDGE.MAPROOM._mc.Hide();
         }
      }
   }
}
