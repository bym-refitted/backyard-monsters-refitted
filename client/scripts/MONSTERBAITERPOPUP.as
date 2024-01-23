package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MONSTERBAITERPOPUP extends MONSTERBAITERPOPUP_CLIP
   {
      
      private static const BAITER_BAR_WIDTH:int = 535;
       
      
      public var monsters:Array;
      
      public var _arrows:Array;
      
      public var _attackPt:Point;
      
      public var _attackIndex:int;
      
      private var attackArrow:MovieClip;
      
      private var attackStrings:Array;
      
      private var items:Array;
      
      private var _guidePage:int = 1;
      
      public function MONSTERBAITERPOPUP()
      {
         super();
         title_txt.htmlText = KEYS.Get("bait_title");
      }
      
      public function Setup(param1:Object, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MonsterBaiterItem = null;
         clearBtn.SetupKey("bait_clear_btn");
         clearBtn.addEventListener(MouseEvent.CLICK,this.clearDown);
         tSize.htmlText = "<b>" + KEYS.Get("size_of_attack") + "</b>";
         tUpgrade.htmlText = KEYS.Get("upgrade_monster_baiter");
         sendBtn.SetupKey("bait_start_btn");
         sendBtn.addEventListener(MouseEvent.CLICK,this.onSendDown);
         this.attackStrings = ["tl","tr","br","bl","t","r","b","l"];
         this.monsters = [m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14];
         var _loc3_:Array = ["C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C17"];
         sendBtn.Highlight = true;
         this.items = [];
         _loc4_ = 1;
         while(_loc4_ < 15)
         {
            _loc8_ = new MonsterBaiterItem();
            this["m" + _loc4_].addChild(_loc8_);
            _loc8_.Setup("C" + _loc4_);
            _loc8_._count = param1["C" + _loc4_];
            _loc8_.Update();
            _loc8_.addEventListener(Event.CHANGE,this.onChange);
            _loc8_.addEventListener("increment",this.onIncrementAttempt);
            this.items.push(_loc8_);
            _loc4_++;
         }
         var _loc5_:Array = [tl_mc,tr_mc,br_mc,bl_mc,t_mc,r_mc,b_mc,l_mc];
         this._arrows = GLOBAL._bBaiter._lvl.Get() >= 3 ? _loc5_.splice(0,8) : _loc5_.splice(0,4);
         if(param2 >= this._arrows.length)
         {
            param2 = 0;
         }
         for each(_loc6_ in _loc5_)
         {
            _loc6_.visible = false;
         }
         for each(_loc7_ in this._arrows)
         {
            _loc7_.gotoAndStop(2);
            _loc7_.addEventListener(MouseEvent.CLICK,this.handleArrowDown);
            _loc7_.buttonMode = true;
         }
         this._attackIndex = param2;
         this.setAttackDirection(this._arrows[param2]);
         this.Update();
      }
      
      private function handleArrowDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_ != this.attackArrow)
         {
            this.setAttackDirection(_loc2_);
         }
      }
      
      private function onBuyDown(param1:MouseEvent) : void
      {
         STORE.ShowB(2,1,["MUSK"]);
      }
      
      private function onIncrementAttempt(param1:Event) : void
      {
         var _loc4_:MonsterBaiterItem = null;
         var _loc2_:int = MONSTERBAITER._musk / MONSTERBAITER._muskLimit * 100;
         var _loc3_:int = 0;
         for each(_loc4_ in this.items)
         {
            _loc3_ += _loc4_.getCost();
         }
      }
      
      private function clearDown(param1:MouseEvent) : void
      {
         var _loc3_:MonsterBaiterItem = null;
         var _loc2_:Object = {};
         for each(_loc3_ in this.items)
         {
            _loc3_._count = 0;
            _loc2_[_loc3_._key] = _loc3_._count;
            _loc3_.Update();
         }
         MONSTERBAITER._queue = _loc2_;
         this.Update();
         SOUNDS.Play("click1");
      }
      
      public function setAttackDirection(param1:MovieClip) : void
      {
         var _loc2_:Array = null;
         _loc2_ = [new Point(400,180),new Point(400,270),new Point(400,0),new Point(400,90),new Point(400,225),new Point(400,315),new Point(400,45),new Point(400,135)];
         if(this.attackArrow)
         {
            this.attackArrow.gotoAndStop(2);
         }
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this._arrows.length)
         {
            if(this._arrows[_loc3_] == param1)
            {
               param1.gotoAndStop(1);
               this._attackPt = _loc2_[_loc3_];
               this._attackIndex = _loc3_;
               this.attackArrow = param1;
               this._arrows[_loc3_].removeEventListener(MouseEvent.CLICK,this.handleArrowDown);
            }
            else
            {
               this._arrows[_loc3_].addEventListener(MouseEvent.CLICK,this.handleArrowDown);
            }
            _loc3_++;
         }
         MONSTERBAITER._attackDir = this._attackIndex;
         MONSTERBAITER._attackPt = _loc2_[this._attackIndex];
      }
      
      private function onChange(param1:Event = null) : void
      {
         var _loc3_:MonsterBaiterItem = null;
         var _loc2_:Object = {};
         for each(_loc3_ in this.items)
         {
            _loc2_[_loc3_._key] = _loc3_._count;
         }
         MONSTERBAITER._queue = _loc2_;
      }
      
      public function Tick() : void
      {
      }
      
      public function Update() : void
      {
         var _loc2_:MonsterBaiterItem = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         for each(_loc2_ in this.items)
         {
            _loc1_ += _loc2_.getCost();
         }
         clearBtn.Enabled = _loc1_ > 0;
         _loc3_ = MONSTERBAITER._musk / MONSTERBAITER._muskLimit * 100;
         if((_loc4_ = MONSTERBAITER._musk - _loc1_) < 0)
         {
            _loc4_ = 0;
         }
         mcStorage.mcBar.width = (1 - _loc4_ / MONSTERBAITER._muskLimit) * BAITER_BAR_WIDTH;
         mcStorage.mcBarB.width = 0;
         var _loc5_:int = MONSTERBAITER._musk - _loc1_;
         for each(_loc2_ in this.items)
         {
            _loc2_.Enable(_loc2_._cost <= _loc5_);
            _loc2_.Update();
         }
         if(_loc1_ > MONSTERBAITER._musk || _loc1_ == 0)
         {
            sendBtn.Enabled = false;
            sendBtn.removeEventListener(MouseEvent.CLICK,this.onSendDown);
         }
         else
         {
            sendBtn.Enabled = true;
            sendBtn.addEventListener(MouseEvent.CLICK,this.onSendDown);
         }
      }
      
      private function onSendDown(param1:MouseEvent) : void
      {
         var _loc3_:MonsterBaiterItem = null;
         MONSTERBAITER.Hide();
         var _loc2_:int = 0;
         for each(_loc3_ in this.items)
         {
            _loc2_ += _loc3_.getCost();
         }
         MONSTERBAITER._musk -= _loc2_;
         MONSTERBAITER.PrepAttack();
      }
      
      public function Help(param1:MouseEvent = null) : void
      {
         var _loc2_:int = 7;
         this._guidePage += 1;
         if(this._guidePage > _loc2_)
         {
            this._guidePage = 1;
         }
         this.gotoAndStop(this._guidePage);
         if(this._guidePage > 1)
         {
            this.txtGuide.htmlText = KEYS.Get("bait_tut_" + (this._guidePage - 1));
            if(this._guidePage == 2)
            {
               this.bContinue.addEventListener(MouseEvent.CLICK,this.Help);
               this.bContinue.SetupKey("btn_continue");
            }
         }
      }
      
      public function Hide() : void
      {
         MONSTERBAITER.Hide();
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
