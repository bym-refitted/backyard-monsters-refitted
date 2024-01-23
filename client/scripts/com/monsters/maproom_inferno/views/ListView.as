package com.monsters.maproom_inferno.views
{
   import com.monsters.maproom.views.ListView_CLIP;
   import com.monsters.maproom_inferno.DescentMapRoom;
   import com.monsters.maproom_inferno.MapRoom;
   import com.monsters.maproom_inferno.PlayerLayer;
   import com.monsters.maproom_inferno.model.BaseObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   
   public class ListView extends ListView_CLIP
   {
       
      
      public var players:PlayerLayer;
      
      public var rows:Array;
      
      private var gotFirstData:Boolean = false;
      
      private var shell:Sprite;
      
      public var bNext:ListViewArrow;
      
      public var bPrevious:ListViewArrow;
      
      private var currentSort:String;
      
      private var sortedData:Array;
      
      private var reversed:Boolean = false;
      
      private var currentPage:uint = 0;
      
      private var pageLimit:uint = 0;
      
      private var currentSorter:MovieClip;
      
      private var rowsPerPage:uint = 7;
      
      private var btns:Array;
      
      private var _BRIDGE:Object;
      
      public function ListView()
      {
         var _loc1_:MovieClip = null;
         super();
         this.btns = [levelBtn,lastSeenBtn,nameBtn,winBtn,statusBtn];
         for each(_loc1_ in this.btns)
         {
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.sortHandler);
            _loc1_.mouseChildren = false;
            _loc1_.useHandCursor = true;
            _loc1_.buttonMode = true;
         }
         this.bPrevious = new ListViewArrow();
         this.bPrevious.rotation = 180;
         this.bPrevious.x = -20;
         this.bPrevious.y = 190;
         this.bPrevious.Trigger();
         addChild(this.bPrevious);
         this.bNext = new ListViewArrow();
         this.bNext.x = 720;
         this.bNext.y = 190;
         this.bNext.Trigger();
         addChild(this.bNext);
         this.bNext.visible = this.bPrevious.visible = false;
         this.bPrevious.buttonMode = this.bNext.buttonMode = true;
      }
      
      public function Setup() : void
      {
         var _loc2_:MovieClip = null;
         this.players.addEventListener(Event.COMPLETE,this.onPlayersLoad);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdd);
         this.rows = [].concat();
         this.shell = new Sprite();
         this.shell.mask = mask_mc;
         addChild(this.shell);
         var _loc1_:Array = [levelBtn,lastSeenBtn,statusBtn,nameBtn,winBtn];
         for each(_loc2_ in _loc1_)
         {
            _loc2_.sorter_mc.gotoAndStop(1);
         }
         this.setChildIndex(this.bPrevious,this.numChildren - 1);
         this.setChildIndex(this.bNext,this.numChildren - 1);
         if(MAPROOM_DESCENT._open)
         {
            if(DescentMapRoom.BRIDGE)
            {
               this._BRIDGE = DescentMapRoom.BRIDGE;
            }
         }
         else if(MAPROOM_INFERNO._open)
         {
            if(MapRoom.BRIDGE)
            {
               this._BRIDGE = MapRoom.BRIDGE;
            }
         }
      }
      
      public function Clear() : void
      {
         this.players = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.rows.length)
         {
            if(this.rows[_loc1_].parent)
            {
               this.rows[_loc1_].parent.removeChild(this.rows[_loc1_]);
            }
            _loc1_++;
         }
         if(Boolean(this.shell) && Boolean(this.shell.parent))
         {
            this.shell.parent.removeChild(this.shell);
         }
         this.shell = null;
         this.rows = null;
      }
      
      private function onAdd(param1:Event) : void
      {
      }
      
      private function onPlayersLoad(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:BaseObject = null;
         if(!this.gotFirstData)
         {
            for each(_loc3_ in this.players.baseData)
            {
               _loc2_ = _loc3_.wm.Get() == 1 ? new WMListViewItem() : new ListViewItem();
               _loc2_.Setup(_loc3_);
               this.rows.push(_loc2_);
            }
            this.gotFirstData = true;
            this.btns[this._BRIDGE._lastSort].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            if(this._BRIDGE._lastSortReversed == 1)
            {
               this.btns[this._BRIDGE._lastSort].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            if(this.players.baseData.length > 7)
            {
               this.bNext.addEventListener(MouseEvent.MOUSE_DOWN,this.nextDown);
               this.bPrevious.addEventListener(MouseEvent.MOUSE_DOWN,this.prevDown);
               this.pageLimit = Math.floor((this.players.baseData.length - 1) / 7);
               this.bNext.visible = true;
               this.bPrevious.visible = true;
            }
            this.displayArray(this.rows);
            this.scrollToPage(0);
         }
         else
         {
            this.displayArray(this.rows);
         }
      }
      
      private function nextDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(this.currentPage < this.pageLimit)
         {
            this.scrollToPage(this.currentPage + 1);
         }
      }
      
      private function prevDown(param1:MouseEvent) : void
      {
         SOUNDS.Play("click1");
         if(this.currentPage > 0)
         {
            this.scrollToPage(this.currentPage - 1);
         }
      }
      
      public function scrollToPage(param1:uint = 0) : void
      {
         this.currentPage = param1;
         TweenLite.to(this.shell,0.3,{"x":-param1 * mask_mc.width});
         if(this.currentPage > 0)
         {
            this.bPrevious.Trigger(true);
         }
         else
         {
            this.bPrevious.Trigger(false);
         }
         if(this.currentPage < this.pageLimit)
         {
            this.bNext.Trigger(true);
         }
         else
         {
            this.bNext.Trigger(false);
         }
         var _loc2_:uint = this.currentPage * this.rowsPerPage;
         var _loc3_:uint = (this.currentPage + 1) * this.rowsPerPage > this.rows.length ? this.rows.length : uint((this.currentPage + 1) * this.rowsPerPage);
         var _loc4_:uint = _loc2_;
         while(_loc4_ < _loc3_)
         {
            this.rows[_loc4_].Display();
            _loc4_++;
         }
      }
      
      private function displayArray(param1:Array) : void
      {
         var _loc3_:* = undefined;
         this.cleanup();
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            this.shell.addChild(_loc3_);
            _loc3_.x = 8 + mask_mc.width * Math.floor(_loc2_ / this.rowsPerPage);
            _loc3_.y = 26 + (_loc2_ * 50 - 50 * this.rowsPerPage * Math.floor(_loc2_ / this.rowsPerPage));
            _loc2_++;
         }
      }
      
      private function sortHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(this.currentSorter)
         {
            this.currentSorter.sorter_mc.gotoAndStop(1);
            this.currentSorter.gotoAndStop(1);
         }
         switch(param1.target)
         {
            case nameBtn:
               _loc2_ = "ownerName";
               break;
            case lastSeenBtn:
               _loc2_ = "online";
               break;
            case winBtn:
               _loc2_ = "attackStarPoints";
               break;
            case statusBtn:
               _loc2_ = "status";
               break;
            case levelBtn:
               _loc2_ = "level";
         }
         var _loc3_:Boolean = _loc2_ == "ownerName" || _loc2_ == "status" ? true : false;
         var _loc4_:uint = _loc3_ ? Array.CASEINSENSITIVE : Array.NUMERIC;
         if(this.currentSort == _loc2_)
         {
            this.reversed = !this.reversed;
            if(this.reversed == _loc3_)
            {
               _loc4_ |= Array.DESCENDING;
            }
         }
         else
         {
            if(_loc2_ != "ownerName" && _loc2_ != "status")
            {
               _loc4_ |= Array.DESCENDING;
            }
            this.reversed = false;
         }
         if(this.reversed)
         {
            param1.target.sorter_mc.gotoAndStop(3);
         }
         else
         {
            param1.target.sorter_mc.gotoAndStop(2);
         }
         this.sortedData = this.rows.sortOn([_loc2_,"status"],[_loc4_,Array.CASEINSENSITIVE]);
         this.currentSort = _loc2_;
         this.currentSorter = param1.target as MovieClip;
         this.currentSorter.gotoAndStop(2);
         this.displayArray(this.sortedData);
         this.scrollToPage(0);
         var _loc5_:int = 0;
         while(_loc5_ < this.btns.length)
         {
            if(param1.target == this.btns[_loc5_])
            {
               this._BRIDGE.setLastSort(_loc5_);
               break;
            }
            _loc5_++;
         }
         this._BRIDGE.setLastSortReversed(this.reversed ? 1 : 0);
      }
      
      private function cleanup() : void
      {
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.shell.numChildren)
         {
            _loc1_.push(this.shell.getChildAt(_loc2_));
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc1_[_loc2_].parent.removeChild(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
   }
}
