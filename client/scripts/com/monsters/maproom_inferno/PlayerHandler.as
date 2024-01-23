package com.monsters.maproom_inferno
{
   import com.monsters.ai.WMBASE;
   import com.monsters.enums.EnumYardType;
   import com.monsters.mailbox.Message;
   import com.monsters.mailbox.model.Contact;
   import com.monsters.maproom_inferno.model.BaseObject;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PlayerHandler extends Sprite
   {
      
      public static var currentBase:BaseObject;
      
      private static const MODE_IATTACK:String = "iattack";
      
      private static const MODE_IWMATTACK:String = "iwmattack";
      
      private static const MODE_IDESCENT:String = "idescent";
      
      private static const MODE_IHELP:String = "ihelp";
      
      private static const MODE_IVIEW:String = "iview";
       
      
      private var player;
      
      private var data:BaseObject;
      
      private var _BRIDGE:Object;
      
      private var _isDescent:Boolean = false;
      
      public function PlayerHandler()
      {
         super();
         if(MAPROOM_DESCENT._open)
         {
            if(DescentMapRoom.BRIDGE)
            {
               this._BRIDGE = DescentMapRoom.BRIDGE;
               this._isDescent = true;
            }
         }
         else if(MAPROOM_INFERNO._open)
         {
            if(MapRoom.BRIDGE)
            {
               this._BRIDGE = MapRoom.BRIDGE;
               this._isDescent = false;
            }
         }
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
            if(this.data.saved.Get() >= GLOBAL.Timestamp() - 62)
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
               _loc7_ = KEYS.Get("map_status_friends");
               _loc8_ = "#0000FF";
            }
            if(this.data.attacksfrom.Get() > 1)
            {
               _loc7_ = KEYS.Get("map_status_hostile");
               _loc8_ = "#990000";
            }
            if(Boolean(this.data.trucestate) && this.data.trucestate != "")
            {
               this.player.truceBtn.Enabled = false;
               this.player.truceBtn.removeEventListener(MouseEvent.CLICK,this.onTruce);
               if(this.data.trucestate == "accepted")
               {
                  _loc2_ = false;
                  _loc7_ = KEYS.Get("map_status_tactive");
                  _loc8_ = "#00FF00";
               }
               else if(this.data.trucestate == "requested")
               {
                  _loc7_ = KEYS.Get("map_status_trequested");
                  _loc8_ = "#0000FF";
               }
               else if(this.data.trucestate == "rejected")
               {
                  _loc7_ = KEYS.Get("map_status_trejected");
                  _loc8_ = "#CC0000";
               }
               switch(this.data.attackpermitted.Get())
               {
                  case 5:
                     _loc2_ = false;
                     _loc5_ = KEYS.Get("map_status_dp");
                     break;
                  case 6:
                     _loc2_ = false;
                     _loc5_ = KEYS.Get("map_status_sp");
                     break;
                  case 7:
                     _loc2_ = false;
                     _loc3_ = false;
                     _loc5_ = KEYS.Get("map_status_underattack");
                     _loc6_ = "#FF0000";
               }
            }
            else
            {
               this.player.truceBtn.Enabled = false;
               this.player.truceBtn.addEventListener(MouseEvent.CLICK,this.onTruce);
               switch(this.data.attackpermitted.Get())
               {
                  case 3:
                     _loc2_ = false;
                     _loc5_ = KEYS.Get("map_status_level");
                     break;
                  case 4:
                     _loc5_ = KEYS.Get("map_status_vengeance",{"v1":this.data.retaliatecount});
                     _loc6_ = "#FF0000";
                     break;
                  case 5:
                     _loc2_ = false;
                     _loc5_ = KEYS.Get("map_status_dp");
                     break;
                  case 6:
                     _loc2_ = false;
                     _loc5_ = KEYS.Get("map_status_sp");
                     break;
                  case 7:
                     _loc2_ = false;
                     _loc3_ = false;
                     _loc5_ = KEYS.Get("map_status_underattack");
                     _loc6_ = "#FF0000";
               }
            }
            if(this.data.truceexpire > 0)
            {
               _loc5_ = KEYS.Get("map_status_timeremain",{"v1":GLOBAL.ToTime(this.data.truceexpire,true,false)});
               _loc6_ = "#000000";
            }
            this.player.helpBtn.removeEventListener(MouseEvent.CLICK,this.onHelp);
            this.player.helpBtn.removeEventListener(MouseEvent.CLICK,this.onView);
            this.player.attackBtn.removeEventListener(MouseEvent.CLICK,this.onAttack);
            this.player.msgBtn.addEventListener(MouseEvent.CLICK,this.onMessage);
            this.player.helpBtn.SetupKey("map_view_btn");
            this.player.helpBtn.addEventListener(MouseEvent.CLICK,this.onView);
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
            this.player.helpBtn.addEventListener(MouseEvent.CLICK,this.onView);
            this.player.attackBtn.SetupKey("map_attack_btn");
            this.player.attackBtn.addEventListener(MouseEvent.CLICK,this.onAttack);
            this.player.attackBtn.Enabled = true;
            this.player.helpBtn.Enabled = true;
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
         SOUNDS.Play("click1");
         var _loc2_:* = new Message();
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
         SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         if(_loc2_.friend.Get())
         {
            this._BRIDGE.setVisitingFriend(true);
         }
         else
         {
            this._BRIDGE.setVisitingFriend(false);
         }
         this._BRIDGE.LoadBase(null,null,this.player.data.baseid.Get(),"ihelp",false,EnumYardType.INFERNO_YARD);
         this._BRIDGE.MAPROOM._mc.Hide();
      }
      
      private function onView(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         if(_loc2_.friend.Get())
         {
            this._BRIDGE.setVisitingFriend(true);
         }
         else
         {
            this._BRIDGE.setVisitingFriend(false);
         }
         _loc3_ = _loc2_.wm.Get() == 1 ? "iwmview" : "iview";
         this._BRIDGE.LoadBase(null,null,this.player.data.baseid.Get(),_loc3_,false,EnumYardType.INFERNO_YARD);
         if(this._BRIDGE && this._BRIDGE.MAPROOM && Boolean(this._BRIDGE.MAPROOM._mc))
         {
            this._BRIDGE.MAPROOM._mc.Hide();
         }
      }
      
      private function onTruce(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         GLOBAL.Message(KEYS.Get("msg_infernotruce"));
      }
      
      private function onAttack(param1:MouseEvent) : void
      {
         var _loc6_:String = null;
         SOUNDS.Play("click1");
         var _loc2_:BaseObject = this.player.data;
         var _loc3_:Boolean = false;
         var _loc4_:String = "";
         var _loc5_:String = KEYS.Get("map_attack_btn2");
         var _loc7_:Boolean = Boolean(this._BRIDGE.HOUSING) && this._BRIDGE.HOUSING._housingUsed.Get() > 0 || GLOBAL._playerGuardianData != null && !MAPROOM_DESCENT.DescentPassed;
         if(_loc2_.wm.Get() == 0)
         {
            if(_loc2_.saved.Get() >= GLOBAL.Timestamp() - 62)
            {
               _loc3_ = false;
               _loc4_ = KEYS.Get("map_msg_ownerinyard",{"v1":_loc2_.ownerName});
            }
            else if(GLOBAL._flags.attacking == 0)
            {
               _loc3_ = false;
               _loc4_ = KEYS.Get("map_msg_attackingdisabled");
            }
            else
            {
               switch(_loc2_.attackpermitted.Get())
               {
                  case 1:
                     _loc3_ = true;
                     if(BASE._isProtected > GLOBAL.Timestamp())
                     {
                        _loc4_ = KEYS.Get("map_msg_protection",{"v1":GLOBAL.ToTime(BASE._isProtected - GLOBAL.Timestamp(),false,false)});
                     }
                     else if(_loc2_.friend.Get())
                     {
                        _loc4_ = KEYS.Get("map_msg_attackfriend",{"v1":_loc2_.ownerName});
                     }
                     else
                     {
                        _loc4_ = KEYS.Get("map_msg_attackconfirm",{"v1":_loc2_.ownerName});
                     }
                     break;
                  case 2:
                     _loc3_ = true;
                     _loc4_ = KEYS.Get("map_msg_higherlevelconfirm",{"v1":_loc2_.ownerName});
                     break;
                  case 3:
                     _loc4_ = KEYS.Get("map_msg_leveltoolow");
                     break;
                  case 4:
                     _loc3_ = true;
                     _loc4_ = KEYS.Get("map_msg_vengeance");
                     break;
                  case 5:
                     _loc4_ = KEYS.Get("map_msg_dp",{"v1":_loc2_.ownerName});
                     break;
                  case 6:
                     _loc4_ = KEYS.Get("map_msg_sp",{"v1":_loc2_.ownerName});
                     break;
                  case 7:
                     _loc4_ = KEYS.Get("map_msg_inprogress",{
                        "v1":_loc2_.ownerName,
                        "v2":_loc2_.attacker
                     });
                     break;
                  case 9:
                     _loc4_ = KEYS.Get("map_msg_truceactive",{"v1":_loc2_.ownerName});
               }
            }
         }
         else
         {
            _loc3_ = true;
            if(_loc2_.wm.Get() == 0)
            {
               _loc4_ = KEYS.Get("map_msg_atatckconfirm",{"v1":_loc2_.ownerName});
               if(_loc2_.level.Get() > BASE.BaseLevel().level)
               {
                  _loc4_ = KEYS.Get("map_msg_higherlevelconfirm",{"v1":_loc2_.ownerName});
               }
            }
            else
            {
               _loc6_ = _loc2_.wm.Get() == 1 ? "iwmattack" : "iattack";
               if(_loc7_)
               {
                  this.onAttackB(_loc2_.baseid.Get(),_loc6_);
                  return;
               }
            }
         }
         if(_loc3_)
         {
            this._BRIDGE.HOUSING.HousingSpace();
            _loc6_ = _loc2_.wm.Get() == 1 ? "iwmattack" : "iattack";
            if(_loc7_)
            {
               GLOBAL.Message(_loc4_,_loc5_,this.onAttackB,[Number(_loc2_.baseid.Get()),_loc6_]);
            }
            else
            {
               if(MAPROOM_DESCENT.DescentPassed)
               {
                  _loc4_ = KEYS.Get("infmap_msg_nomonsters");
               }
               else
               {
                  _loc4_ = KEYS.Get("map_msg_nomonsters");
               }
               GLOBAL.Message(_loc4_);
            }
         }
         else
         {
            GLOBAL.Message(_loc4_);
         }
      }
      
      public function onAttackB(param1:Number, param2:String) : void
      {
         var _loc3_:BaseObject = this.player.data;
         if(_loc3_.wm.Get() == 1)
         {
            WMBASE._type = _loc3_.type;
         }
         if(_loc3_.friend.Get())
         {
            this._BRIDGE.setVisitingFriend(true);
         }
         else
         {
            this._BRIDGE.setVisitingFriend(false);
         }
         MapRoomManager.instance.mapRoomVersion = MapRoomManager.MAP_ROOM_VERSION_1;
         BASE.LoadBase(null,0,Number(param1),param2,false,EnumYardType.INFERNO_YARD);
         if(!MAPROOM_DESCENT.DescentPassed && param2 == "iwmattack")
         {
            LOGGER.Stat([87,_loc3_.level.Get(),"Attacked"]);
         }
         if(this._BRIDGE.MAPROOM._mc)
         {
            this._BRIDGE.MAPROOM._mc.Hide();
         }
      }
   }
}
