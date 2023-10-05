package
{
   import com.monsters.chat.Chat;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class UI_WORKERS
   {
      
      private static var _do:DisplayObject;
      
      private static var _mc:MovieClip;
      
      private static var _workers:Array;
      
      private static var _popupdo:DisplayObject;
      
      private static var _popupID:int;
      
      private static var _popupmc:bubblepopupRight;
      
      private static var _popupmc2:bubblepopup;
      
      private static var _maxWorkers:int;
      
      private static var _workerMCOffset:int = 45;
      
      private static var _canUseHorizontal:Boolean = false;
       
      
      public function UI_WORKERS()
      {
         super();
      }
      
      public static function Setup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         if(Boolean(_do) && Boolean(_do.parent))
         {
            _do.parent.removeChild(_do);
            _do = null;
         }
         _mc = new MovieClip();
         _workers = [];
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            _maxWorkers = 5;
            if(!BASE.isMainYard)
            {
               _maxWorkers = 1;
            }
            _loc1_ = 0;
            while(_loc1_ < _maxWorkers)
            {
               if(GLOBAL.InfernoMode())
               {
                  _loc2_ = new icon_worker_inferno();
               }
               else
               {
                  _loc2_ = new icon_worker();
               }
               _loc2_.y = 20 + _loc1_ * _workerMCOffset;
               _loc2_.mouseChildren = false;
               _loc2_.addEventListener(MouseEvent.CLICK,MouseClicked(_loc1_));
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,MouseOver(_loc1_));
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
               _loc2_.buttonMode = true;
               _mc.addChild(_loc2_);
               _workers.push({
                  "purchased":false,
                  "active":false,
                  "id":0,
                  "message":"",
                  "mc":_loc2_
               });
               _loc1_++;
            }
            _do = GLOBAL._layerUI.addChild(_mc);
         }
         Update();
         if(!UI2._showBottom)
         {
            Hide();
         }
      }
      
      private static function MouseOver(param1:int) : Function
      {
         var i:int = param1;
         return function(param1:MouseEvent = null):void
         {
            var _loc3_:* = undefined;
            var _loc2_:* = _workers[i];
            if(_loc2_.purchased)
            {
               if(_loc2_.active)
               {
                  _loc3_ = _loc2_.message;
               }
               else
               {
                  _loc3_ = KEYS.Get("ui_worker_idle");
               }
            }
            else
            {
               _loc3_ = KEYS.Get("ui_worker_hire");
            }
            PopupShow(_mc.x - 5,_mc.y + _workerMCOffset / 2 + i * _workerMCOffset + _workerMCOffset * 0.5,_loc3_,i);
         };
      }
      
      private static function MouseOut(param1:MouseEvent) : void
      {
         PopupHide();
      }
      
      private static function MouseClicked(param1:int) : Function
      {
         var i:int = param1;
         return function(param1:MouseEvent = null):void
         {
            if(_workers[i])
            {
               if(_workers[i].purchased)
               {
                  QUEUE.JumpToWorker(i);
               }
               else
               {
                  STORE.ShowB(1,0,["BEW"]);
               }
            }
         };
      }
      
      public static function Update() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         while(_loc2_ < _workers.length)
         {
            _loc3_ = _workers[_loc2_];
            if(Boolean(QUEUE._stack) && Boolean(QUEUE._stack[_loc2_]))
            {
               _loc4_ = QUEUE._stack[_loc2_];
               if(_loc3_.id != _loc4_.id)
               {
                  _loc3_.id = _loc4_.id;
               }
               _loc3_.message = "<b>" + _loc4_.title + "</b> " + _loc4_.message;
               if(!_loc3_.purchased)
               {
                  _loc3_.purchased = true;
                  _loc1_ = true;
               }
               if(_loc3_.active != _loc4_.active)
               {
                  _loc3_.active = _loc4_.active;
                  _loc1_ = true;
               }
               if(Boolean(_loc3_.active) && _popupID == _loc2_)
               {
                  PopupUpdate(_loc3_.message);
               }
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            Render();
         }
         Resize();
      }
      
      public static function Resize() : void
      {
         var _loc1_:int = 0;
         if(!Chat.flagsShouldChatDisplay() && _canUseHorizontal)
         {
            if(_mc)
            {
               _mc.x = GLOBAL._SCREEN.x;
               _mc.y = GLOBAL._SCREEN.bottom - 52;
            }
         }
         else if(_mc)
         {
            _mc.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - _workerMCOffset;
            _loc1_ = !!UI2._wildMonsterBar ? 20 : 0;
            _mc.y = GLOBAL._SCREEN.top + 50 + _loc1_ + 30 * UI2.TimersVisible();
         }
      }
      
      private static function Render() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < _maxWorkers)
         {
            _loc2_ = _workers[_loc1_];
            if(_loc2_.purchased)
            {
               if(_loc2_.active)
               {
                  _loc2_.mc.gotoAndStop(2);
               }
               else
               {
                  _loc2_.mc.gotoAndStop(1);
               }
               if(STORE._storeData.BST)
               {
                  _loc2_.mc.mcIcon.gotoAndStop(2);
               }
               else
               {
                  _loc2_.mc.mcIcon.gotoAndStop(1);
               }
            }
            else
            {
               _loc2_.mc.gotoAndStop(3);
               _loc2_.mc.label_txt.htmlText = "<b>" + KEYS.Get("ui_worker_hireicon") + "</b>";
            }
            _loc1_++;
         }
      }
      
      public static function PopupShow(param1:int, param2:int, param3:String, param4:int) : void
      {
         PopupHide();
         _popupID = param4;
         _popupmc = new bubblepopupRight();
         _popupmc.Setup(param1,param2,param3);
         _popupmc.Nudge("left");
         _popupdo = GLOBAL._layerUI.addChild(_popupmc);
      }
      
      public static function PopupUpdate(param1:String) : void
      {
         if(_popupmc)
         {
            _popupmc.Update(param1);
         }
         else if(_popupmc2)
         {
            _popupmc2.Update(param1);
         }
      }
      
      public static function PopupHide() : void
      {
         if(_popupdo)
         {
            if(_popupdo.parent == GLOBAL._layerUI)
            {
               GLOBAL._layerUI.removeChild(_popupdo);
            }
            _popupdo = null;
         }
      }
      
      public static function Show() : void
      {
         if(TUTORIAL._stage < 192)
         {
            _mc.visible = false;
         }
         else
         {
            _mc.visible = true;
         }
      }
      
      public static function Hide() : void
      {
         _mc.visible = false;
      }
   }
}
