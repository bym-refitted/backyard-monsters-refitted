package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.ScrollSetH;
   import com.monsters.monsters.champions.ChampionBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CHAMPIONSELECTPOPUP extends GUARDIANSELECTPOPUP_CLIP
   {
       
      
      private var _guardCage:CHAMPIONCAGE;
      
      public function CHAMPIONSELECTPOPUP()
      {
         super();
         this._guardCage = GLOBAL._bCage as CHAMPIONCAGE;
         tTitle.htmlText = KEYS.Get("popup_championselecttitle");
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
         var _loc1_:Sprite = null;
         var _loc3_:int = 0;
         var _loc5_:guardianselect_selectportrait_CLIP = null;
         var _loc6_:Object = null;
         var _loc7_:Button = null;
         _loc1_ = new Sprite();
         _loc1_.x = mcMask.x;
         _loc1_.y = mcMask.y;
         addChild(_loc1_);
         var _loc2_:int = 10;
         var _loc4_:int = int(CHAMPIONCAGE._guardians.length);
         while(_loc4_ > 0)
         {
            if(CHAMPIONCAGE.CanTrainGuardian(_loc4_))
            {
               _loc5_ = new guardianselect_selectportrait_CLIP();
               _loc6_ = CHAMPIONCAGE._guardians["G" + _loc4_];
               _loc5_.tGuard_label.htmlText = "<b>" + KEYS.Get(_loc6_.title) + "<b>";
               _loc5_.tGuard_desc.htmlText = "<b>" + KEYS.Get(_loc6_.description) + "<b>";
               _loc5_.name = _loc4_.toString();
               (_loc7_ = _loc5_.bAction).Setup(KEYS.Get("btn_raisechampion",{"v1":_loc6_.name}),false,0,0);
               ImageCache.GetImageWithCallBack(_loc6_.selectGraphic,this.onImageLoad,true,4,"",[_loc5_.mcImage]);
               _loc7_.addEventListener(MouseEvent.CLICK,this.clickedRaise);
               _loc5_.x = _loc3_;
               _loc1_.addChild(_loc5_);
               _loc3_ += _loc5_.width + _loc2_;
            }
            _loc4_--;
         }
         return _loc1_;
      }
      
      private function onImageLoad(param1:String, param2:BitmapData, param3:Array = null) : void
      {
         MovieClip(param3[0]).addChild(new Bitmap(param2));
      }
      
      private function clickedRaise(param1:MouseEvent) : void
      {
         var _loc2_:String = String(param1.currentTarget.parent.name);
         var _loc3_:int = int(_loc2_.substr(_loc2_.length - 1));
         this.RaiseGuard(_loc3_);
      }
      
      private function RaiseGuard(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            _loc2_ = "G" + param1;
            if(CHAMPIONCHAMBER.HasFrozen(param1))
            {
               GLOBAL.Message(KEYS.Get("championchamber_alreadyfrozen",{"v1":CHAMPIONCAGE._guardians[_loc2_].name}));
               return;
            }
            _loc3_ = BASE.getGuardianIndex(param1);
            if(_loc3_ >= 0)
            {
               BASE._guardianData[_loc3_].status = ChampionBase.k_CHAMPION_STATUS_NORMAL;
            }
            this._guardCage.SpawnGuardian(1,0,0,param1,CHAMPIONCAGE.GetGuardianProperty(_loc2_,1,"health").Get(),"",0,CHAMPIONCAGE._guardians[_loc2_].props.powerLevel);
            LOGGER.Stat([52,_loc2_,2]);
            BASE.Save(0,false,true);
            this.Hide();
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         CHAMPIONCAGE.Hide(param1);
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
