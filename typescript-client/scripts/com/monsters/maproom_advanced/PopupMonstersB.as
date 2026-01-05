package com.monsters.maproom_advanced
{
   import com.monsters.display.ScrollSet;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   internal class PopupMonstersB extends PopupMonstersB_CLIP
   {
       
      
      private var _cell:MapRoomCell;
      
      private var _transfer:Object;
      
      private var _mcMonsters:MovieClip;
      
      private var _scroller:ScrollSet;
      
      public function PopupMonstersB()
      {
         super();
         x = 760 / 2 + 75;
         y = 520 / 2 - 10;
         mMonsters.mask = mMonstersMask;
         this._scroller = new ScrollSet();
         this._scroller.isHiddenWhileUnnecessary = true;
         this._scroller.AutoHideEnabled = false;
         this._scroller.width = scroll.width;
         this._scroller.x = scroll.x;
         this._scroller.y = scroll.y;
         addChild(this._scroller);
         this._scroller.Init(mMonsters,mMonstersMask,0,scroll.y,scroll.height);
         this.bTransfer.SetupKey("bunker_btn_transfer");
         this.bTransfer.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            MapRoom.TransferMonstersC(_cell);
         });
         this.bCancel.SetupKey("btn_cancel");
         this.bCancel.addEventListener(MouseEvent.CLICK,this.Hide);
      }
      
      public function Setup(param1:Object, param2:MapRoomCell) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:PopupInfoMonster = null;
         tDesc.htmlText = KEYS.Get("popup_desc_monstertransferb");
         if(this._mcMonsters)
         {
            while(this._mcMonsters.numChildren > 0)
            {
               this._mcMonsters.removeChildAt(0);
            }
            this._mcMonsters = null;
         }
         this._cell = param2;
         this._transfer = param1;
         if(this._transfer)
         {
            this._mcMonsters = new MovieClip();
            this._mcMonsters.x = -190;
            this._mcMonsters.y = -115;
            _loc3_ = 0;
            _loc4_ = 0;
            for(_loc5_ in this._transfer)
            {
               if(this._transfer[_loc5_].Get() > 0)
               {
                  (_loc6_ = new PopupInfoMonster()).Setup(_loc3_ * 130,_loc4_ * 35,_loc5_,this._transfer[_loc5_].Get());
                  _loc3_ += 1;
                  if(_loc3_ == 3)
                  {
                     _loc3_ = 0;
                     _loc4_ += 1;
                  }
                  this._mcMonsters.addChild(_loc6_);
               }
            }
            this.addChild(this._mcMonsters);
         }
         this._scroller.Update();
      }
      
      public function Cleanup() : void
      {
         this.bTransfer.removeEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            MapRoom.TransferMonstersC(_cell);
         });
         this.bCancel.removeEventListener(MouseEvent.CLICK,this.Hide);
         if(this._mcMonsters)
         {
            while(this._mcMonsters.numChildren > 0)
            {
               this._mcMonsters.removeChildAt(0);
            }
            this._mcMonsters = null;
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         if(MapRoom._mc)
         {
            MapRoom._mc.HideMonstersB();
         }
      }
   }
}
