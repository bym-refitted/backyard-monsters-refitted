package
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   
   public class plannerBuilding extends plannerBuilding_CLIP
   {
       
      
      public var _building:BFOUNDATION;
      
      public var _dragging:Boolean;
      
      public var _dragPoint:Point;
      
      public var _oldPoint:Point;
      
      public var _rangeCircle:plannerRange;
      
      public var _clickAge:int;
      
      public function plannerBuilding(param1:BFOUNDATION, param2:*)
      {
         var _loc3_:Point = null;
         super();
         mouseEnabled = false;
         this._building = param1;
         mcSquare.width = this._building._footprint[0].width;
         mcSquare.height = this._building._footprint[0].height;
         _loc3_ = GRID.FromISO(this._building._mc.x,this._building._mc.y);
         x = _loc3_.x;
         y = _loc3_.y;
         mcSquare.mcBlocked.visible = false;
         mcLocked.visible = false;
         mcLocked.x = mcSquare.width / 2;
         mcLocked.y = mcSquare.height / 2;
         mcLocked.mouseEnabled = false;
         mcSquare.mcOver.visible = false;
         if(this._building._class != "mushroom" && this._building._class != "immovable")
         {
            if(this._building._countdownBuild.Get() + this._building._countdownUpgrade.Get() + this._building._countdownFortify.Get() == 0)
            {
               mcSquare.addEventListener(MouseEvent.CLICK,this.Click);
               mcSquare.buttonMode = true;
            }
            else
            {
               mcLocked.visible = true;
            }
         }
         mcSquare.addEventListener(MouseEvent.ROLL_OVER,this.InfoShow);
         mcSquare.addEventListener(MouseEvent.ROLL_OUT,this.InfoHide);
         if(this._building._type == 17)
         {
            mcSquare.gotoAndStop(200 + this._building._lvl.Get());
         }
         else
         {
            mcSquare.gotoAndStop(this._building._type);
         }
         if(this._building._class == "tower")
         {
            this._rangeCircle = param2.addChild(new plannerRange()) as plannerRange;
            this._rangeCircle.x = x + mcSquare.width / 2;
            this._rangeCircle.y = y + mcSquare.height / 2;
            this._rangeCircle.width = this._rangeCircle.height = this._building._range * 2;
            this._rangeCircle.mouseEnabled = false;
         }
      }
      
      public function Remove() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.Drag);
         mcSquare.removeEventListener(MouseEvent.CLICK,this.Click);
         mcSquare.removeEventListener(MouseEvent.ROLL_OVER,this.InfoShow);
         mcSquare.removeEventListener(MouseEvent.ROLL_OUT,this.InfoHide);
      }
      
      public function Click(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!PLANNER._mc._dragged)
         {
            if(!PLANNER._selected)
            {
               PLANNER._selected = true;
               this._dragging = true;
               mcSquare.mcOver.visible = false;
               this._dragPoint = new Point(x - (PLANNER._mc.mouseX - PLANNER._mc.mcMap.x) / PLANNER._mc.mcMap.scaleX,y - (PLANNER._mc.mouseY - PLANNER._mc.mcMap.y) / PLANNER._mc.mcMap.scaleY);
               this._oldPoint = new Point(x,y);
               this._clickAge = 0;
               mcSquare.removeEventListener(MouseEvent.CLICK,this.Click);
               PLANNER._mc.addEventListener(MouseEvent.CLICK,this.ClickB);
               this.addEventListener(Event.ENTER_FRAME,this.Drag);
               _loc2_ = 0;
               _loc3_ = 0;
               while(_loc3_ < PLANNER._mc._buildings.numChildren)
               {
                  if(PLANNER._mc._buildings.getChildAt(_loc3_) != this)
                  {
                     PLANNER._mc._buildings.setChildIndex(PLANNER._mc._buildings.getChildAt(_loc3_),_loc2_);
                     _loc2_++;
                  }
                  _loc3_++;
               }
               PLANNER._mc._buildings.setChildIndex(this,_loc2_);
               this.ShadowAdd();
               this._building.StartMove();
            }
         }
      }
      
      public function ClickB(param1:MouseEvent = null) : void
      {
         var _loc2_:Point = null;
         if(!PLANNER._mc._dragged && this._clickAge > 0)
         {
            PLANNER._selected = false;
            this._dragging = false;
            removeEventListener(Event.ENTER_FRAME,this.Drag);
            PLANNER._mc.removeEventListener(MouseEvent.CLICK,this.ClickB);
            mcSquare.addEventListener(MouseEvent.CLICK,this.Click);
            mcSquare.mcBlocked.visible = false;
            this._building.StopMoveB();
            _loc2_ = GRID.FromISO(this._building._mc.x,this._building._mc.y);
            x = _loc2_.x;
            y = _loc2_.y;
            this.ShadowRemove();
         }
      }
      
      public function Drag(param1:Event) : void
      {
         var _loc2_:Point = null;
         if(PLANNER._open)
         {
            if(!this._building._moving)
            {
               PLANNER._selected = false;
               this._dragging = false;
               removeEventListener(Event.ENTER_FRAME,this.Drag);
               PLANNER._mc.removeEventListener(MouseEvent.CLICK,this.ClickB);
               mcSquare.addEventListener(MouseEvent.CLICK,this.Click);
               mcSquare.mcBlocked.visible = false;
               this._building.StopMoveB();
               _loc2_ = GRID.FromISO(this._building._mc.x,this._building._mc.y);
               x = _loc2_.x;
               y = _loc2_.y;
               this.ShadowRemove();
            }
            else
            {
               ++this._clickAge;
               x = int(((PLANNER._mc.mouseX - PLANNER._mc.mcMap.x) / PLANNER._mc.mcMap.scaleX + this._dragPoint.x) / 5) * 5;
               y = int(((PLANNER._mc.mouseY - PLANNER._mc.mcMap.y) / PLANNER._mc.mcMap.scaleY + this._dragPoint.y) / 5) * 5;
               _loc2_ = GRID.ToISO(x,y,0);
               this._building._mc.x = _loc2_.x;
               this._building._mc.y = _loc2_.y;
               this._building._mcBase.x = this._building._mc.x;
               this._building._mcBase.y = this._building._mc.y;
               if(this._building._mcFootprint)
               {
                  this._building._mcFootprint.x = this._building._mc.x;
                  this._building._mcFootprint.y = this._building._mc.y;
               }
               if(this._building._class == "tower")
               {
                  this._rangeCircle.x = x + mcSquare.width / 2;
                  this._rangeCircle.y = y + mcSquare.height / 2;
               }
               if(BASE.BuildBlockers(this._building) != "")
               {
                  mcSquare.mcBlocked.visible = true;
               }
               else
               {
                  mcSquare.mcBlocked.visible = false;
               }
            }
         }
      }
      
      public function InfoShow(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(this._building._class == "decoration" || this._building._class == "mushroom" || this._building._class == "immovable")
         {
            _loc2_ = "<b>" + KEYS.Get(this._building._buildingProps.name) + "</b>";
         }
         else
         {
            mcSquare.mcOver.visible = true;
            _loc2_ = "<b>";
            if(this._building._lvl.Get() > 0 && this._building._class != "mushroom" && this._building._class != "immovable")
            {
               _loc2_ += KEYS.Get("planner_bdglevel",{
                  "v1":this._building._lvl.Get(),
                  "v2":KEYS.Get(this._building._buildingProps.name)
               }) + "</b>";
            }
            if(this._building._countdownBuild.Get() > 0)
            {
               _loc2_ += " " + KEYS.Get("planner_bdgbuilding");
            }
            if(this._building._countdownUpgrade.Get() > 0)
            {
               _loc2_ += " " + KEYS.Get("planner_bdgupgrading");
            }
            if(this._building._countdownFortify.Get() > 0)
            {
               _loc2_ += " " + KEYS.Get("planner_bdgfortifying");
            }
         }
         PLANNER._mc.tName.htmlText = _loc2_;
         PLANNER._mc.mcNameBG.width = PLANNER._mc.tName.width + 10;
         PLANNER._mc.tName.visible = true;
         PLANNER._mc.mcNameBG.visible = true;
      }
      
      public function InfoHide(param1:MouseEvent) : void
      {
         mcSquare.mcOver.visible = false;
         PLANNER._mc.tName.visible = false;
         PLANNER._mc.mcNameBG.visible = false;
      }
      
      public function ShadowAdd() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.distance = 5;
         _loc1_.angle = 45;
         _loc1_.color = 0;
         _loc1_.alpha = 0.5;
         _loc1_.blurX = 3;
         _loc1_.blurY = 3;
         _loc1_.strength = 1;
         _loc1_.quality = 15;
         mcSquare.filters = new Array(_loc1_);
      }
      
      public function ShadowRemove() : void
      {
         mcSquare.filters = [];
      }
   }
}
