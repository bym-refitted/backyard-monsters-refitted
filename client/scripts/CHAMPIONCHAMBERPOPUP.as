package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetH;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import gs.easing.*;
   
   public class CHAMPIONCHAMBERPOPUP extends GUARDIANCHAMBERPOPUP_CLIP
   {
       
      
      private var _guardChamber:CHAMPIONCHAMBER;
      
      private var _selectGuard:Object;
      
      private var _slots:Vector.<ChampionChamberFrozen>;
      
      private var _activeSlot:ChampionChamberFrozen;
      
      private var _cubeContainer:Sprite;
      
      public function CHAMPIONCHAMBERPOPUP()
      {
         super();
         this._guardChamber = GLOBAL._bChamber as CHAMPIONCHAMBER;
         this._slots = new Vector.<ChampionChamberFrozen>();
         tTitle.htmlText = KEYS.Get("chamber_title");
         this.createScrollBar(this.createSlots());
      }
      
      private function createScrollBar(param1:Sprite) : void
      {
         var _loc2_:ScrollSetH = null;
         param1.mask = mcMask;
         _loc2_ = new ScrollSetH(param1,mcMask);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y + param1.height;
         addChild(_loc2_);
      }
      
      private function createSlots() : Sprite
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:ChampionChamberFrozen = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc1_:Sprite = new Sprite();
         _loc1_.x = mcMask.x;
         _loc1_.y = mcMask.y;
         addChild(_loc1_);
         var _loc2_:int = 0;
         for each(_loc4_ in CHAMPIONCAGE.GetAllGuardianData())
         {
            _loc5_ = new ChampionChamberFrozen();
            _loc6_ = int(_loc4_.l.Get());
            _loc7_ = "G" + _loc4_.t;
            _loc8_ = CHAMPIONCAGE._guardians[_loc7_];
            _loc5_.name = _loc4_.t.toString();
            _loc5_.tName.htmlText = "<b>" + KEYS.Get(_loc8_.title) + "</b><br>" + KEYS.Get("chamber_level",{"v1":_loc6_});
            ImageCache.GetImageWithCallBack("monsters/" + _loc7_ + "_L" + _loc6_ + "-150.png",this.onImageLoad,true,4,"",[_loc5_.mcImage]);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,this.rollOverChampion);
            _loc5_.x = _loc3_;
            _loc1_.addChild(_loc5_);
            if(_loc3_ == 0)
            {
               this.SelectGuard(_loc4_.t);
            }
            _loc3_ += _loc5_.width + _loc2_;
            this._slots.push(_loc5_);
            this.updateSlot(_loc5_,_loc4_.t);
         }
         return _loc1_;
      }
      
      private function updateSlot(param1:ChampionChamberFrozen, param2:int) : void
      {
         var _loc3_:Boolean = CHAMPIONCHAMBER.HasFrozen(param2);
         var _loc4_:String = String(CHAMPIONCAGE._guardians["G" + param2].name);
         if(_loc3_)
         {
            param1.gotoAndStop("frozen");
            param1.bFreeze.removeEventListener(MouseEvent.CLICK,this.clickedFreeze);
            param1.bFreeze.Setup(KEYS.Get("btn_thawname",{"v1":_loc4_}),false,0,0);
            param1.bFreeze.addEventListener(MouseEvent.CLICK,this.clickedThaw);
         }
         else
         {
            param1.gotoAndStop("thaw");
            param1.bFreeze.removeEventListener(MouseEvent.CLICK,this.clickedThaw);
            param1.bFreeze.Setup(KEYS.Get("btn_freezename",{"v1":_loc4_}),false,0,0);
            param1.bFreeze.addEventListener(MouseEvent.CLICK,this.clickedFreeze);
         }
      }
      
      private function onImageLoad(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         MovieClip(param3[0]).addChild(new Bitmap(param2));
      }
      
      private function clickedFreeze(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.parent.name);
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1));
         this.FreezeGuard(_loc3_);
      }
      
      private function clickedThaw(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.parent.name);
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1));
         this.ThawGuard(_loc3_);
      }
      
      private function rollOverChampion(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.name);
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1));
         this.SelectGuard(_loc3_);
      }
      
      public function FreezeGuard(param1:int = 0) : void
      {
         this._guardChamber.FreezeGuardian();
         this.Hide();
      }
      
      private function ThawGuard(param1:int = 0) : void
      {
         this._guardChamber.ThawGuardian(param1);
         this.Hide();
      }
      
      public function SelectGuard(param1:int = 1) : void
      {
         this.UpdateStats(CHAMPIONCAGE.GetGuardianData(param1));
      }
      
      private function UpdateStats(param1:Object = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1)
         {
            _loc2_ = int(param1.t);
            _loc3_ = int(param1.l.Get());
            _loc4_ = int(param1.fb.Get());
            _loc5_ = "G" + _loc2_;
            if(_loc6_ = "monsters/" + "G" + _loc2_ + "_L" + _loc3_ + "-150.png")
            {
               ImageCache.GetImageWithCallBack(_loc6_,this.UpdateSelectImage);
            }
            damage_txt.htmlText = "<b>" + KEYS.Get("gcage_labelDamage") + "</b>";
            health_txt.htmlText = "<b>" + KEYS.Get("gcage_labelHealth") + "</b>";
            speed_txt.htmlText = "<b>" + KEYS.Get("gcage_labelSpeed") + "</b>";
            buff_txt.htmlText = "<b>" + KEYS.Get("gcage_labelBuff") + "</b>";
            tEvoStage.htmlText = "<b>" + CHAMPIONCAGE._guardians["G" + _loc2_].name + "</b> " + KEYS.Get("chamber_level",{"v1":_loc3_});
            tEvoDesc.htmlText = KEYS.Get(CHAMPIONCAGE._guardians["G" + _loc2_].description);
            _loc7_ = CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc3_,"damage").Get();
            _loc8_ = CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc3_,"health").Get();
            _loc9_ = CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc3_,"speed");
            _loc10_ = CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc3_,"buffs") * 100;
            if(_loc4_ > 0)
            {
               _loc7_ += CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc4_,"bonusDamage");
               _loc8_ += CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc4_,"bonusHealth");
               _loc9_ += CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc4_,"bonusSpeed");
               _loc10_ += CHAMPIONCAGE.GetGuardianProperty(_loc5_,_loc4_,"bonusBuffs") * 100;
            }
            _loc11_ = int(_loc9_ * 10) / 10;
            tDamage.htmlText = _loc7_.toString();
            tHealth.htmlText = _loc8_.toString();
            tSpeed.htmlText = _loc11_.toString();
            tBuff.htmlText = int(_loc10_) + "%";
            TweenLite.to(bDamage.mcBar,0.4,{
               "width":100 / CHAMPIONCAGEPOPUP._maxDamage * _loc7_,
               "ease":Circ.easeInOut
            });
            TweenLite.to(bHealth.mcBar,0.4,{
               "width":100 / CHAMPIONCAGEPOPUP._maxHealth * _loc8_,
               "ease":Circ.easeInOut
            });
            TweenLite.to(bSpeed.mcBar,0.4,{
               "width":100 / CHAMPIONCAGEPOPUP._maxSpeed * _loc9_,
               "ease":Circ.easeInOut
            });
            TweenLite.to(bBuff.mcBar,0.4,{
               "width":100 / CHAMPIONCAGEPOPUP._maxBuff * _loc10_,
               "ease":Circ.easeInOut
            });
         }
      }
      
      private function UpdateSelectImage(param1:String, param2:BitmapData) : void
      {
         var _loc3_:int = selectedImage.numChildren;
         while(_loc3_--)
         {
            selectedImage.removeChildAt(_loc3_);
         }
         var _loc4_:Bitmap = new Bitmap(param2);
         selectedImage.addChild(_loc4_);
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         CHAMPIONCHAMBER.Hide();
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

class ChampionSlot
{
    
   
   public var graphic:ChampionChamberFrozen;
   
   public var championProperties:Object;
   
   public var championObject:Object;
   
   public var type:int;
   
   public function ChampionSlot()
   {
      super();
   }
}
