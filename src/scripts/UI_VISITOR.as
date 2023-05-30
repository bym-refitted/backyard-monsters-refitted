package
{
   import com.monsters.enums.EnumYardType;
   import com.monsters.managers.InstanceManager;
   import com.monsters.maproom3.MapRoom3Cell;
   import com.monsters.maproom3.popups.Maproom3AttackCostPopup;
   import com.monsters.maproom_advanced.MapRoom;
   import com.monsters.maproom_advanced.MapRoomCell;
   import com.monsters.maproom_manager.MapRoomManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class UI_VISITOR extends UI_VISITOR_CLIP
   {
      
      public static var _helpButtons:MovieClip;
      
      private static var s_mc:MovieClip;
       
      
      protected var m_resourceBar1:ResourceBar1;
      
      protected var m_resourceBar2:ResourceBar2;
      
      protected var m_resourceBar3:ResourceBar3;
      
      protected var m_resourceBar4:ResourceBar4;
      
      protected var m_oldScreen:Rectangle;
      
      private var attackCostPopup:Maproom3AttackCostPopup;
      
      public function UI_VISITOR()
      {
         super();
         s_mc = mc;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            mc.mcBG.width = 100;
            mc.bReturn.SetupKey("btn_endattack");
            mc.bAttack.visible = false;
         }
         else if(MapRoomManager.instance.isInMapRoom2or3 && !BASE.isInfernoMainYardOrOutpost)
         {
            mc.bReturn.SetupKey("btn_openmap");
            if((GLOBAL.mode != GLOBAL.e_BASE_MODE.HELP || MapRoomManager.instance.isInMapRoom3) && !MapRoomManager.instance.viewOnly && GLOBAL._currentCell && MapRoomManager.instance.flingerInRange)
            {
               if(GLOBAL._currentCell.isDestroyed)
               {
                  mc.bAttack.SetupKey("newmap_take_btn");
               }
               else
               {
                  mc.bAttack.SetupKey("map_attack_btn");
               }
               mc.bAttack.visible = true;
               if(MapRoomManager.instance.isInMapRoom3)
               {
                  mc.bAttack.addEventListener(MouseEvent.CLICK,this.AttackMR3);
               }
               else
               {
                  mc.bAttack.addEventListener(MouseEvent.CLICK,this.Attack);
               }
               if(GLOBAL._currentCell.isLocked || this.isLevelLimited || !ATTACK.hasCreaturesToAttackWith)
               {
                  mc.bAttack.Enabled = false;
               }
               else
               {
                  mc.bAttack.Enabled = true;
               }
            }
            else
            {
               mc.bAttack.visible = false;
               if(GLOBAL.mode != GLOBAL.e_BASE_MODE.HELP || MapRoomManager.instance.isInMapRoom3)
               {
                  mc.mcBG.width = 100;
               }
            }
         }
         else
         {
            if(GLOBAL.mode != GLOBAL.e_BASE_MODE.HELP || MapRoomManager.instance.isInMapRoom3)
            {
               mc.mcBG.width = 100;
            }
            mc.bReturn.SetupKey("btn_returnhome");
            mc.bAttack.visible = false;
         }
         if(MapRoomManager.instance.isInMapRoom3 && mc.bAttack.visible && Boolean(mc.bAttack.Enabled))
         {
         }
         mc.bReturn.addEventListener(MouseEvent.CLICK,this.ReturnCB);
         mc.gotoAndStop(1);
         this.Update();
      }
      
      public static function get mc() : MovieClip
      {
         return s_mc;
      }
      
      public static function Focus(param1:BFOUNDATION) : Function
      {
         var building:BFOUNDATION = param1;
         return function(param1:MouseEvent = null):void
         {
            MAP.FocusTo(building._mc.x,building._mc.y,0.6);
            BASE.BuildingSelect(building,true);
         };
      }
      
      public function get isLevelLimited() : Boolean
      {
         return BASE.loadObject["canattack"] == false;
      }
      
      public function Taunt(param1:MouseEvent = null) : void
      {
         BUILDINGS.Show();
      }
      
      public function Gift(param1:MouseEvent = null) : void
      {
         BUILDINGS.Show();
      }
      
      public function ReturnCB(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(GLOBAL._newBuilding)
         {
            GLOBAL._newBuilding.Cancel();
         }
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            ATTACK.End();
         }
         else if(MapRoomManager.instance.isInMapRoom2or3 && GLOBAL._loadmode == GLOBAL.mode)
         {
            MapRoomManager.instance.SetupAndShow();
         }
         else if(BASE.isInfernoMainYardOrOutpost)
         {
            _loc2_ = MapRoomManager.instance.isInMapRoom3 ? int(EnumYardType.PLAYER) : int(EnumYardType.MAIN_YARD);
            if(MAPROOM_DESCENT.InDescent)
            {
               BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,_loc2_);
            }
            else
            {
               BASE.LoadBase(GLOBAL._infBaseURL,0,0,GLOBAL.e_BASE_MODE.IBUILD,false,EnumYardType.INFERNO_YARD);
            }
         }
         else
         {
            BASE.LoadBase(null,0,0,GLOBAL.e_BASE_MODE.BUILD,false,_loc2_);
         }
      }
      
      public function AttackMR3(param1:MouseEvent) : void
      {
         var _loc2_:MapRoom3Cell = GLOBAL._currentCell as MapRoom3Cell;
         if(!_loc2_)
         {
            return;
         }
         if(!ATTACK.hasCreaturesToAttackWith)
         {
            GLOBAL.Message(KEYS.Get("msg_nocreaturesattack"));
            return;
         }
         if(_loc2_.isLocked)
         {
            GLOBAL.Message(KEYS.Get("mr3_base_locked_cannot_attack"));
            return;
         }
         if(this.isLevelLimited)
         {
            GLOBAL.Message(KEYS.Get("map_msg_leveltoolow"));
            return;
         }
         if(_loc2_.hasTruce)
         {
            GLOBAL.Message(KEYS.Get("newmap_truce"));
            return;
         }
         if(_loc2_.hasDamageProtection)
         {
            GLOBAL.Message(KEYS.Get("newmap_dp"));
            return;
         }
         if(_loc2_.isInAttackRange)
         {
            this.loadAttack();
         }
         else
         {
            if(!this.attackCostPopup)
            {
               this.attackCostPopup = new Maproom3AttackCostPopup(_loc2_);
               this.attackCostPopup.addEventListener(Maproom3AttackCostPopup.k_LOAD_ATTACK,this.clickedLoadAttack);
            }
            POPUPS.Push(this.attackCostPopup.graphic);
         }
      }
      
      protected function clickedLoadAttack(param1:Event) : void
      {
         this.attackCostPopup.removeEventListener(Maproom3AttackCostPopup.k_LOAD_ATTACK,this.clickedLoadAttack);
         POPUPS.Next();
         this.loadAttack(this.attackCostPopup.addtionalLoadParameters);
         this.attackCostPopup = null;
      }
      
      private function loadAttack(param1:Object = null) : void
      {
         var _loc2_:MapRoom3Cell = null;
         _loc2_ = GLOBAL._currentCell as MapRoom3Cell;
         var _loc3_:int = MapRoomManager.instance.CalculateCellId(_loc2_.cellX,_loc2_.cellY);
         BASE.LoadBase(null,0,_loc2_.baseID,!_loc2_.userID ? GLOBAL.e_BASE_MODE.WMATTACK : GLOBAL.e_BASE_MODE.ATTACK,false,_loc2_.cellType,_loc3_,!!param1 ? ["attackcost",JSON.encode(param1)] : null);
      }
      
      public function Attack(param1:MouseEvent) : void
      {
         var _loc2_:MapRoomCell = GLOBAL._currentCell as MapRoomCell;
         if(_loc2_)
         {
         }
         if(Boolean(_loc2_) && _loc2_.isLocked)
         {
            if(_loc2_.online)
            {
               GLOBAL.Message(KEYS.Get("msg_cantattackoccupied"));
            }
            else
            {
               GLOBAL.Message(KEYS.Get("msg_cantattackbeingattacked"));
            }
         }
         else if(_loc2_)
         {
            if(_loc2_.isDestroyed)
            {
               MapRoom.showEnemyWait = true;
               MapRoomManager.instance.Show();
            }
            else if(!_loc2_.isProtected && !(_loc2_.truce && _loc2_.truce > GLOBAL.Timestamp()))
            {
               MapRoom.showAttackWait = true;
               MapRoomManager.instance.Show();
            }
            else if(_loc2_.isProtected)
            {
               GLOBAL.Message(KEYS.Get("newmap_dp"));
            }
            else if(Boolean(_loc2_.truce) && _loc2_.truce > GLOBAL.Timestamp())
            {
               GLOBAL.Message(KEYS.Get("newmap_truce"));
            }
         }
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:BFOUNDATION = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:MovieClip = null;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
         {
            if(ATTACK._countdown < 0)
            {
               mc.bReturn.Highlight = true;
            }
         }
         else if(GLOBAL.mode == GLOBAL.e_BASE_MODE.HELP)
         {
            if(Boolean(_helpButtons) && mc.contains(_helpButtons))
            {
               mc.removeChild(_helpButtons);
            }
            _helpButtons = mc.addChild(new MovieClip()) as MovieClip;
            _helpButtons.x = MapRoomManager.instance.isInMapRoom3 ? 310 : 210;
            _helpButtons.y = 5;
            _loc1_ = 0;
            _loc2_ = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_._countdownBuild.Get() + _loc3_._countdownUpgrade.Get() + _loc3_._countdownFortify.Get() > 0)
               {
                  _loc4_ = false;
                  for each(_loc5_ in _loc3_._helpList)
                  {
                     if(_loc5_ == LOGIN._playerID)
                     {
                        _loc4_ = true;
                        break;
                     }
                  }
                  mc.gotoAndStop(2);
                  if(MapRoomManager.instance.isInMapRoom3)
                  {
                     mc.getChildAt(2).x = 200;
                  }
                  (_loc6_ = new button_buildings()).gotoAndStop(_loc3_._type);
                  _loc6_.x = _loc1_ * 45;
                  if(!_loc4_)
                  {
                     _loc6_.buttonMode = true;
                     _loc6_.addEventListener(MouseEvent.CLICK,Focus(_loc3_));
                     _loc6_.mcTick.visible = false;
                  }
                  _helpButtons.addChild(_loc6_);
                  _loc1_++;
               }
            }
            if(_loc1_ > 0)
            {
               mc.mcBG.width = (MapRoomManager.instance.isInMapRoom3 ? 320 : 220) + _loc1_ * 45;
            }
            else
            {
               mc.mcBG.width = MapRoomManager.instance.isInMapRoom3 ? 210 : 100;
               mc.gotoAndStop(1);
            }
         }
         this.Resize();
      }
      
      public function Resize() : void
      {
         if(!this.m_oldScreen || !GLOBAL._SCREEN.equals(this.m_oldScreen))
         {
            GLOBAL.RefreshScreen();
            this.m_oldScreen = GLOBAL._SCREEN.clone();
         }
         mc.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - mc.mcBG.width - 10;
         if(GLOBAL._flags.viximo)
         {
            mc.y = GLOBAL._SCREEN.y + GLOBAL._SCREEN.height - (mc.height + 10);
         }
         else
         {
            mc.y = GLOBAL._SCREENHUD.y - (mc.mcBG.height + 10);
         }
         var _loc1_:int = 4;
         while(_loc1_ > 0)
         {
            if(this["m_resourceBar" + _loc1_])
            {
               this["m_resourceBar" + _loc1_].x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - 10 - this["m_resourceBar" + _loc1_].width * 0.5;
               this["m_resourceBar" + _loc1_].y = GLOBAL._SCREEN.y + _loc1_ * 40;
            }
            _loc1_--;
         }
      }
      
      public function checkMapRoomHealth() : void
      {
         var _loc1_:BUILDING11 = null;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BUILDING11);
         if(_loc2_.length === 0)
         {
            return;
         }
         _loc1_ = _loc2_[0] as BUILDING11;
         if(_loc1_.health < _loc1_.maxHealth / 2)
         {
            mc.bReturn.SetupKey("btn_returnhome");
         }
      }
   }
}
